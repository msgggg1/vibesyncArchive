package mvc.command.Service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.persistence.dao.LikeDAO;
import mvc.persistence.daoImpl.LikeDAOImpl;

public class LikeService {
    private LikeDAO likeDAO;

    public LikeService() {
        this.likeDAO = new LikeDAOImpl();
    }

    // 테스트 등을 위해 외부에서 DAO 구현체를 주입받는 생성자 (선택 사항)
    public LikeService(LikeDAO likeDAO) {
        this.likeDAO = likeDAO;
    }

    public Map<String, Object> toggleLike(int acIdx, int noteIdx) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection conn = null;
        boolean originallyLiked = false;
        int newLikeCount = 0;
        boolean autoCommitOriginalState = true; // 원래 autoCommit 상태 저장용

        try {
            conn = ConnectionProvider.getConnection(); 
            autoCommitOriginalState = conn.getAutoCommit(); // 기존 autoCommit 상태 저장
            conn.setAutoCommit(false); // 트랜잭션 시작

            originallyLiked = likeDAO.isLiked(conn, acIdx, noteIdx);

            if (originallyLiked) {
                likeDAO.removeLike(conn, acIdx, noteIdx);
                result.put("liked", false);
            } else {
                likeDAO.addLike(conn, acIdx, noteIdx);
                result.put("liked", true);
            }

            newLikeCount = likeDAO.getLikesCountForNote(conn, noteIdx);
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
                    // Connection Pool 사용을 대비하여 원래 autoCommit 상태로 복원
                    if (!conn.isClosed()) { // 이미 닫히지 않은 경우에만 시도
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
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection(); // 서비스에서 Connection 획득
            status.put("isLiked", likeDAO.isLiked(conn, ac_idx, note_idx));
            status.put("likeCount", likeDAO.getLikesCountForNote(conn, note_idx));
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