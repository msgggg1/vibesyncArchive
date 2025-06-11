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

@WebServlet("/WatchPartyListServlet")
public class WatchPartyListServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private WatchPartyDAOImpl dao = new WatchPartyDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");
        List<WatchPartyVO> list = dao.selectAll();

        // GSON 으로 List<WatchParty> → JSON으로 변환
        String json = new Gson().toJson(list);

        PrintWriter out = resp.getWriter();
        out.print(json);
        out.flush();
    }
}
