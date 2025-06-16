// mvc/command/handler/pageListModalHandler.java
package mvc.command.handler;

import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.util.ConnectionProvider;

import mvc.domain.vo.PageVO;
import mvc.persistence.dao.PageDAO;
import mvc.persistence.daoImpl.PageDAOImpl;

public class pageListModalHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int acIdx = Integer.parseInt(request.getParameter("ac_idx"));
        System.out.println(acIdx);
        Connection conn = ConnectionProvider.getConnection();
        PageDAO dao = new PageDAOImpl(conn);
        List<PageVO> pages = dao.pageAll(acIdx);
        conn.close();

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        // 간단한 JSP fragment 형태로 <select>와 버튼 렌더링
        out.println("<div class=\"modal-content\">");
        out.println("  <h3>내 페이지 선택</h3>");
        out.println("  <select id=\"pageSelect\">");
        for (PageVO p : pages) {
            if (p.getAc_idx() == acIdx) {
                out.printf("    <option value=\"%d\">%s</option>%n",
                           p.getUserpg_idx(), p.getSubject());
            }
        }
        out.println("  </select>");
   
        out.println("  <div id=\"btn_wrapper\"><button id=\"newPageBtn\" class=\"btn_deco\">＋ 새 페이지</button>");
        out.println("  <a id=\"newNoteLink\" href=\"notecreate.do?pageidx=\">\r\n"
        		+ "  <button id=\"newNoteBtn\" class=\"btn_deco\" >새 글쓰기</button>\r\n"
        		+ "</a></di>\r\n"
        		+ "");
        out.println("</div>");
        return null;
    }
}
