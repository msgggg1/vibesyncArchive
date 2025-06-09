package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.persistence.dao.LikeDAO;
import mvc.persistence.daoImpl.LikeDAOImpl;

public class LikeService {

	Connection conn = null;

    public LikeService() {
    }

    public Map<String, Object> toggleLike(int acIdx, int noteIdx) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        boolean originallyLiked = false;
        int newLikeCount = 0;
        boolean autoCommitOriginalState = true; // 원래 autoCommit 상태 저장용

        try {
            conn = ConnectionProvider.getConnection(); 
            LikeDAO likeDAO = new LikeDAOImpl(conn);
            autoCommitOriginalState = conn.getAutoCommit(); // 기존 autoCommit 상태 저장
            conn.setAutoCommit(false); // 트랜잭션 시작

            originallyLiked = likeDAO.isLiked(acIdx, noteIdx);

            if (originallyLiked) {
                likeDAO.removeLike(acIdx, noteIdx);
                result.put("liked", false);
            } else {
                likeDAO.addLike(acIdx, noteIdx);
                result.put("liked", true);
            }

            newLikeCount = likeDAO.getLikesCountForNote(noteIdx);
            result.put("newLikeCount", newLikeCount);

            conn.commit(); // 트랜잭션 커밋
            result.put("success", true);

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // 오류 발생 시 롤백
                    System.err.println("Transaction rolled back in LikeService due to: " + e.getMessage());
                } catch (SQLException ex) {
                    System.err.println("Rollback failed in LikeService: " + ex.getMessage());
                }
            }
            result.put("success", false);
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            if (conn != null) {
                try {
                    if (!conn.isClosed()) { 
                         conn.setAutoCommit(autoCommitOriginalState);
                    }
                } catch (SQLException e) {
                    System.err.println("Failed to reset auto-commit in LikeService: " + e.getMessage());
                } finally {
                    conn.close();
                }
            }
        }
        return result;
    }

    public Map<String, Object> getLikeStatusAndCount(int ac_idx, int note_idx) throws SQLException {
        Map<String, Object> status = new HashMap<>();
        try {
            conn = ConnectionProvider.getConnection(); 
            LikeDAO likeDAO = new LikeDAOImpl(conn);
            status.put("isLiked", likeDAO.isLiked(ac_idx, note_idx));
            status.put("likeCount", likeDAO.getLikesCountForNote(note_idx));
        } catch (SQLException e) {
            // SQLException을 핸들러로 다시 던짐
            throw e;
        } catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
            if (conn != null) {
            	conn.close(); 
            }
        }
        return status;
    }
}