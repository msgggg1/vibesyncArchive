package mvc.command.service;

import java.sql.Connection;
import java.util.List;
import com.util.ConnectionProvider;
import mvc.domain.vo.CommentVO;
import mvc.persistence.dao.CommentDAO;
import mvc.persistence.daoImpl.CommentDAOImpl;

public class CommentService {

    public List<CommentVO> getComments(int note_idx) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            CommentDAO dao = new CommentDAOImpl(conn);
            return dao.getCommentsByNoteId(note_idx);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public CommentVO getComment(int comment_idx) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            CommentDAO dao = new CommentDAOImpl(conn);
            return dao.getCommentById(comment_idx);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void addComment(CommentVO comment) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            CommentDAO dao = new CommentDAOImpl(conn);
            dao.addComment(comment);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void updateComment(int comment_idx, String text) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            CommentDAO dao = new CommentDAOImpl(conn);
            dao.updateComment(comment_idx, text);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void deleteComment(int comment_idx) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            CommentDAO dao = new CommentDAOImpl(conn);
            dao.deleteComment(comment_idx);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}