package mvc.svl;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import mvc.domain.vo.WaSyncVO;
import mvc.domain.vo.WatchPartyVO;
import mvc.persistence.dao.WaSyncDAO;
import mvc.persistence.daoImpl.WatchPartyDAOImpl;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;



import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet("/AddWatchPartyServlet")
public class AddWatchPartyServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private WatchPartyDAOImpl dao = new WatchPartyDAOImpl();
	private WaSyncDAO   wsDao = new WaSyncDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {

        // 요청 JSON 파싱
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        JsonObject jsonReq = gson.fromJson(sb.toString(), JsonObject.class);

        String title = jsonReq.get("title").getAsString();
        String videoId = jsonReq.get("video_id").getAsString();
        int host = jsonReq.get("host").getAsInt();

        System.out.printf("title : %s / videoId : %s / host : %d", title, videoId, host);
        
        // 모델에 담아 DAO.insert 호출
        WatchPartyVO wp = new WatchPartyVO();
        wp.setTitle(title);
        wp.setVideoId(videoId);
        wp.setHost(host);

        int inserted = dao.insert(wp);
        
        if (inserted > 0) {
        	// 1) 방금 insert 한 watchParty_idx를 조회
        	//    (WatchPartyDAO.insert 메서드 자체에서 시퀀스를 사용하기 때문에, 
        	//     selectOne 혹은 별도 DAO 메서드로 마지막 idx를 조회)
        	// ▶ 간단하게, title + host + videoId 조합으로 최신 행 조회 (예시)
        	WatchPartyVO insertedWp = dao.selectLatestByUniqueFields(title, videoId, host);
        	if (insertedWp != null) {
        	WaSyncVO initialSync = new WaSyncVO();
        	initialSync.setWatchPartyIdx(insertedWp.getWatchPartyIdx());
        	initialSync.setTimeline(0.0);       // 초기 타임라인 0
        	initialSync.setPlay("PAUSE");       // 초기 상태는 PAUSE
        	try {
				wsDao.insert(initialSync);
			} catch (NamingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}          // wa_sync 테이블에 저장
        	}
        }
        
        response.setContentType("application/json; charset=UTF-8");
        JsonObject jsonResp = new JsonObject();
        if (inserted > 0) {
            jsonResp.addProperty("success", true);
        } else {
            jsonResp.addProperty("success", false);
            jsonResp.addProperty("error", "DB 삽입 실패");
        }
        response.getWriter().write(gson.toJson(jsonResp));
    }
}
