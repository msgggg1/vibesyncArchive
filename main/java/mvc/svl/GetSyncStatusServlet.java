package mvc.svl;


import com.google.gson.Gson;

import mvc.domain.vo.WaSyncVO;
import mvc.persistence.dao.WaSyncDAO;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/GetSyncStatusServlet")
public class GetSyncStatusServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private WaSyncDAO wsDao = new WaSyncDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {

        int wpIdx = Integer.parseInt(request.getParameter("watchPartyIdx"));
        WaSyncVO lastSync = null;
		try {
			lastSync = wsDao.selectLatestByWatchParty(wpIdx);
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        response.setContentType("application/json; charset=UTF-8");
        if (lastSync != null) {
            // JSON으로 play와 timeline 반환
            response.getWriter().write(gson.toJson(lastSync));
        } else {
            // 레코드가 없으면 기본값 반환
            response.getWriter().write("{\"play\":\"PAUSE\",\"timeline\":0.0}");
        }
    }
}

