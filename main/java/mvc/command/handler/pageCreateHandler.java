// mvc/command/handler/pageCreateHandler.java
package mvc.command.handler;

import java.sql.Connection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.domain.vo.PageVO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.PageDAO;
import mvc.persistence.daoImpl.PageDAOImpl;
import com.util.ConnectionProvider;

/** 새 페이지 생성 처리 */
public class pageCreateHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 세션에서 ac_idx 가져오기
        UserVO user = (UserVO) request.getSession().getAttribute("userInfo");
        int acIdx = user.getAc_idx();

        // 요청이 multipart/form-data이므로 subject는 Part로 읽어옵니다
        String subject = request.getParameter("subject");
        System.out.println(subject);
        System.out.println(acIdx);

        // VO 빌드 (userpg_idx는 시퀀스/트리거로 생성)
        PageVO page = PageVO.builder()
                            .subject(subject)
                            .thumbnail(null)
                            .ac_idx(acIdx)
                            .re_userpg_idx(0)
                            .build();

        Connection conn = ConnectionProvider.getConnection();
        PageDAO dao = new PageDAOImpl(conn);
        dao.createPage(page);
        conn.close();

        // JSON 응답
        response.setContentType("application/json; charset=UTF-8");

        try (java.io.PrintWriter out = response.getWriter()) {
            out.write("{\"success\":true}");
        }
        
        return null;
    }
}
