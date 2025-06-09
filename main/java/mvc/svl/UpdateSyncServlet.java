package mvc.svl;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import mvc.domain.vo.WaSyncVO;
import mvc.persistence.dao.WaSyncDAO;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;



import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/UpdateSyncServlet")
public class UpdateSyncServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private WaSyncDAO wsDao = new WaSyncDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {

        // 1) 요청 JSON 파싱
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        JsonObject jsonReq = gson.fromJson(sb.toString(), JsonObject.class);

        int watchPartyIdx = jsonReq.get("watchPartyIdx").getAsInt();
        String play       = jsonReq.get("play").getAsString();      // "PLAY" (혹은 "PAUSE")
        double timeline   = jsonReq.get("timeline").getAsDouble();  // 예: 0.0

        // 2) WaSync 모델에 담아서 DAO.insert 호출
        WaSyncVO sync = new WaSyncVO();
        sync.setWatchPartyIdx(watchPartyIdx);
        sync.setPlay(play);
        sync.setTimeline(timeline);

        int inserted = 0;
		try {
			inserted = wsDao.insert(sync);
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // 성공 시 > 0

        response.setContentType("application/json; charset=UTF-8");
        JsonObject jsonResp = new JsonObject();
        if (inserted > 0) {
            jsonResp.addProperty("success", true);
        } else {
            jsonResp.addProperty("success", false);
            jsonResp.addProperty("error", "wa_sync INSERT 실패");
        }
        response.getWriter().write(gson.toJson(jsonResp));
    }
}
