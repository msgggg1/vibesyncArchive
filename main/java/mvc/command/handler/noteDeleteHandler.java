package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.util.ConnectionProvider;

import mvc.persistence.daoImpl.UserNoteDAOImpl;

import java.sql.Connection;

public class noteDeleteHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        String noteIdxStr = request.getParameter("noteidx");
        int noteIdx = Integer.parseInt(noteIdxStr);

        Connection conn = null;
        
        conn = ConnectionProvider.getConnection();
        UserNoteDAOImpl dao = new UserNoteDAOImpl(conn);
        dao.deleteNote(noteIdx);


        response.sendRedirect("page.do");
        return null;
    }
}
