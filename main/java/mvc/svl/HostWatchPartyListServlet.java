package mvc.svl;

import com.google.gson.Gson;

import mvc.domain.vo.WatchPartyVO;
import mvc.persistence.daoImpl.WatchPartyDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;



import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/HostWatchPartyListServlet")
public class HostWatchPartyListServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private WatchPartyDAOImpl dao = new WatchPartyDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        Cookie[] cookies = req.getCookies();
        String useridx_str = null;
        int useridx = 0;
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("login_user_idx".equals(c.getName())) {
                	useridx_str = c.getValue();
                	useridx = Integer.parseInt(useridx_str);
                }
            }
        }
        

        resp.setContentType("application/json; charset=UTF-8");

        if (useridx == 0) {
            // 로그인 안 된 상태라면 빈 목록 리턴
            PrintWriter out = resp.getWriter();
            out.print("[]");
            out.flush();
            return;
        }
        System.out.println(useridx);

        List<WatchPartyVO> list = dao.selectByHost(useridx);
        String json = new Gson().toJson(list);

        PrintWriter out = resp.getWriter();
        out.print(json);
        out.flush();
    }
}

