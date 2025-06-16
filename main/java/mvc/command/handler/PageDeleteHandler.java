package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.util.ConnectionProvider; // ConnectionProvider는 프로젝트에 맞게 import 해야 합니다.

import mvc.persistence.dao.PageDAO;
import mvc.persistence.daoImpl.PageDAOImpl;
import java.sql.Connection;

public class PageDeleteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. GET 파라미터로 삭제할 페이지의 ID를 받습니다.
        String pageIdxParam = request.getParameter("userPgIdx");
        
        // 파라미터가 없거나 비어있으면 에러 처리
        if (pageIdxParam == null || pageIdxParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "삭제할 페이지 ID가 필요합니다.");
            return null;
        }
        
        int userPgIdx = Integer.parseInt(pageIdxParam);
        
        Connection conn = null;
        try {
            // 2. DB 커넥션을 얻고 DAO 객체를 생성합니다.
            conn = ConnectionProvider.getConnection();
            PageDAO pageDAO = new PageDAOImpl(conn);
            
            // 3. DAO의 삭제 메서드를 호출합니다.
            // 참고: 페이지에 속한 노트들이 있다면, 노트부터 삭제하거나
            // DB에서 ON DELETE CASCADE 제약조건이 설정되어 있어야 합니다.
            pageDAO.deletePage(userPgIdx);
            
        } catch (Exception e) {
            // DB 처리 중 예외 발생 시 로그를 남기고 예외를 다시 던져서 에러 페이지로 이동시킵니다.
            e.printStackTrace();
            throw e; 
        } finally {
            // 4. DB 커넥션을 닫습니다.
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        
        response.sendRedirect("page.do");
        return null;
    }
}