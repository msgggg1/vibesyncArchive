package mvc.svl;

import javax.naming.NamingException;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;


import java.sql.SQLException;
import java.util.*;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import mvc.domain.vo.WaSyncVO;
import mvc.persistence.dao.WaSyncDAO;

/**
 * 클라이언트 간 재생 동기화를 담당하는 Endpoint
 * URL: ws://[HOST]/[CONTEXT]/waSyncEndpoint
 */
@ServerEndpoint("/waSyncEndpoint")
public class WaSyncEndpoint {

    // 접속된 세션들을 관리 (watchPartyIdx 별로 분류)
    private static Map<Integer, Set<Session>> partySessions = Collections.synchronizedMap(new HashMap<>());

    private WaSyncDAO syncDao = new WaSyncDAO();
    private Gson gson = new Gson();

    // 클라이언트가 연결됐을 때 호출
    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        // 세션에는 watchPartyIdx가 아직 없으므로, 메시지를 통해 받도록 처리
    }

    // 메시지 수신 시 (initSync, sync)
    @OnMessage
    public void onMessage(String message, Session session) throws NamingException, SQLException {
        JsonObject json = gson.fromJson(message, JsonObject.class);
        String type = json.get("type").getAsString();
        int wpIdx = json.get("watchPartyIdx").getAsInt();

        // 1) initSync: 최초 접속 시, DB의 마지막 sync 정보 조회해서 클라이언트에 전달
        if ("initSync".equals(type)) {
            WaSyncVO lastSync = syncDao.selectLatestByWatchParty(wpIdx);
            if (lastSync != null) {
                Map<String, Object> resp = new HashMap<>();
                resp.put("type", "sync");
                resp.put("timeline", lastSync.getTimeline());
                resp.put("play", lastSync.getPlay());
                session.getAsyncRemote().sendText(gson.toJson(resp));
            }
            // 세션을 파티에 등록
            addSession(wpIdx, session);
        }
        // 2) sync: 클라이언트가 재생/일시정지 시, timeline + play 상태를 브로드캐스트
        else if ("sync".equals(type)) {
            double timeline = json.get("timeline").getAsDouble();
            String playState = json.get("play").getAsString();

            // 2-1) DB에 현재 상태 저장
            WaSyncVO newSync = new WaSyncVO();
            newSync.setWatchPartyIdx(wpIdx);
            newSync.setTimeline(timeline);
            newSync.setPlay(playState);
            syncDao.upsertByWatchParty(newSync);

            // 2-2) 같은 watchPartyIdx에 연결된 모든 클라이언트에 브로드캐스트
            Map<String, Object> broadcastMsg = new HashMap<>();
            broadcastMsg.put("type", "sync");
            broadcastMsg.put("watchPartyIdx", wpIdx);
            broadcastMsg.put("timeline", timeline);
            broadcastMsg.put("play", playState);
            String jsonStr = gson.toJson(broadcastMsg);

            broadcastToParty(wpIdx, jsonStr);
        }
    }

    // 연결이 종료됐을 때 호출
    @OnClose
    public void onClose(Session session, CloseReason reason) {
        removeSession(session);
    }

    // 에러 발생 시 호출
    @OnError
    public void onError(Session session, Throwable thr) {
        thr.printStackTrace();
        removeSession(session);
    }

    // 세션 추가
    private void addSession(int wpIdx, Session session) {
        partySessions.computeIfAbsent(wpIdx, k -> Collections.synchronizedSet(new HashSet<>())).add(session);
        // 세션 속성에 watchPartyIdx 저장
        session.getUserProperties().put("watchPartyIdx", wpIdx);
    }

    // 세션 제거
    private void removeSession(Session session) {
        Integer wpIdx = (Integer) session.getUserProperties().get("watchPartyIdx");
        if (wpIdx != null && partySessions.containsKey(wpIdx)) {
            partySessions.get(wpIdx).remove(session);
            if (partySessions.get(wpIdx).isEmpty()) {
                partySessions.remove(wpIdx);
            }
        }
    }

    // 해당 파티(wpIdx)에 있는 모든 세션에 메시지 전송
    private void broadcastToParty(int wpIdx, String message) {
        if (partySessions.containsKey(wpIdx)) {
            for (Session s : partySessions.get(wpIdx)) {
                if (s.isOpen()) {
                    s.getAsyncRemote().sendText(message);
                }
            }
        }
    }
}
