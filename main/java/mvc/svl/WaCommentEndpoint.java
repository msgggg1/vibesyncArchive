package mvc.svl;

import javax.naming.NamingException;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

import java.sql.SQLException;
import java.util.*;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import mvc.domain.vo.WaCommentVO;
import mvc.persistence.dao.WaCommentDAO;

/**
 * 클라이언트 간 채팅(댓글) 기능을 담당하는 Endpoint
 * URL: ws://[HOST]/[CONTEXT]/waCommentEndpoint
 */
@ServerEndpoint("/waCommentEndpoint")
public class WaCommentEndpoint {

    // watchPartyIdx 별 세션들
    private static Map<Integer, Set<Session>> partySessions = Collections.synchronizedMap(new HashMap<>());

    private WaCommentDAO commentDao = new WaCommentDAO();
    private Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session) {
        // 대기, 메시지에서 watchPartyIdx를 받아 등록
    }

    @OnMessage
    public void onMessage(String message, Session session) throws NamingException, SQLException {
        JsonObject json = gson.fromJson(message, JsonObject.class);
        String type = json.get("type").getAsString();
        int wpIdx = json.get("watchPartyIdx").getAsInt();

        // 1) initComment: 최초 접속 시 과거 채팅들을 DB에서 꺼내서 클라이언트에게 전송
        if ("initComment".equals(type)) {
            List<WaCommentVO> oldComments = commentDao.selectByWatchParty(wpIdx);
            JsonArray arr = new JsonArray();
            for (WaCommentVO c : oldComments) {
                JsonObject obj = new JsonObject();
                obj.addProperty("nickname", c.getNickname());
                obj.addProperty("chatting", c.getChatting());
                obj.addProperty("timeline", c.getTimeline());
                obj.addProperty("createdAt", c.getCreatedAt().toString());
                arr.add(obj);
            }
            JsonObject resp = new JsonObject();
            resp.addProperty("type", "initCommentList");
            resp.add("comments", arr);
            session.getAsyncRemote().sendText(gson.toJson(resp));

            // 세션 등록
            addSession(wpIdx, session);
        }
        // 2) comment: 신규 채팅이 들어오면 DB에 저장하고 브로드캐스트
        else if ("comment".equals(type)) {
            String nickname = json.get("nickname").getAsString();
            String chatText = json.get("chatting").getAsString();
            double timeline = json.get("timeline").getAsDouble();

            System.out.println("nickname : " + nickname + "/ commentText : " + chatText + " / timeline : " + timeline + "/ wpIdx : " + wpIdx);
           
            // DB 저장
            WaCommentVO wc = new WaCommentVO();
            wc.setWatchPartyIdx(wpIdx);
            wc.setNickname(nickname);
            wc.setChatting(chatText);
            wc.setTimeline(timeline);
            commentDao.insert(wc);

            // 모든 참가자에게 브로드캐스트
            JsonObject broadcastMsg = new JsonObject();
            broadcastMsg.addProperty("type", "comment");
            broadcastMsg.addProperty("nickname", nickname);
            broadcastMsg.addProperty("chatting", chatText);
            broadcastMsg.addProperty("timeline", timeline);
            broadcastMsg.addProperty("timestamp", new Date().toString());

            broadcastToParty(wpIdx, gson.toJson(broadcastMsg));
        }
    }

    @OnClose
    public void onClose(Session session, CloseReason reason) {
        
    }

    @OnError
    public void onError(Session session, Throwable thr) {
        thr.printStackTrace();
        removeSession(session);
    }

    private void addSession(int wpIdx, Session session) {
        partySessions.computeIfAbsent(wpIdx, k -> Collections.synchronizedSet(new HashSet<>())).add(session);
        session.getUserProperties().put("watchPartyIdx", wpIdx);
    }

    private void removeSession(Session session) {
        Integer wpIdx = (Integer) session.getUserProperties().get("watchPartyIdx");
        if (wpIdx != null && partySessions.containsKey(wpIdx)) {
            partySessions.get(wpIdx).remove(session);
            if (partySessions.get(wpIdx).isEmpty()) {
                partySessions.remove(wpIdx);
            }
        }
    }

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
