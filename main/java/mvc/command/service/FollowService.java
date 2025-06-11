package mvc.command.service; 

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.persistence.dao.FollowDAO;
import mvc.persistence.dao.UserDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;
import mvc.persistence.daoImpl.UserDAOImpl;

public class FollowService {
	
	 Connection conn = null;

    public FollowService() {
    }


    //팔로우 상태를 토글.
    public Map<String, Object> toggleFollow(int followerAcIdx, int targetUserAcIdx) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        boolean originallyFollowing = false;
        boolean autoCommitOriginalState = true;
        int newFollowerCount = 0; // 새로운 팔로워 수를 담을 변수 

        try {
            conn = ConnectionProvider.getConnection();
            FollowDAO followDAO = new FollowDAOImpl(conn);
            autoCommitOriginalState = conn.getAutoCommit();
            conn.setAutoCommit(false); // 트랜잭션 시작

            originallyFollowing = followDAO.isFollowing(followerAcIdx, targetUserAcIdx);

            if (originallyFollowing) {
                followDAO.removeFollow(followerAcIdx, targetUserAcIdx);
                result.put("following", false); // 이제 팔로우 안함
            } else {
                followDAO.addFollow(followerAcIdx, targetUserAcIdx);
                result.put("following", true);  // 이제 팔로우 함
            }
            
         // 팔로우/언팔로우 작업 후, 대상 사용자의 최신 팔로워 수 조회
            newFollowerCount = followDAO.getFollowerCount( targetUserAcIdx);
            result.put("newFollowerCount", newFollowerCount); // 결과 맵에 추가

            conn.commit(); // 트랜잭션 커밋
            result.put("success", true);

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                    System.err.println("Transaction rolled back in FollowService due to: " + e.getMessage());
                } catch (SQLException ex) {
                    System.err.println("Rollback failed in FollowService: " + ex.getMessage());
                }
            }
            result.put("success", false);
            // 핸들러에서 오류 메시지를 포함하여 최종 JSON 응답을 생성하도록 예외를 다시 던짐
            throw e;
        } catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
            if (conn != null) {
                try {
                    if (!conn.isClosed()) {
                        conn.setAutoCommit(autoCommitOriginalState);
                    }
                } catch (SQLException e) {
                    System.err.println("Failed to reset auto-commit in FollowService: " + e.getMessage());
                } finally {
                    conn.close();
                }
            }
        }
        return result;
    }

    // 특정 사용자가 다른 사용자를 팔로우하고 있는지 상태를 조회합니다. (페이지 로딩 시 NoteDetailDTO 채우기용)
    public boolean getFollowStatus(int followerAcIdx, int targetUserAcIdx) throws SQLException {
        boolean isUserFollowing = false; // 결과를 담을 변수, 기본값은 false
        try {
        	conn = ConnectionProvider.getConnection();
        	FollowDAO followDAO = new FollowDAOImpl(conn);
            isUserFollowing = followDAO.isFollowing(followerAcIdx, targetUserAcIdx);
        } catch (SQLException e) {
            throw e;
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            if (conn != null) {
            	conn.close();
            }
        }
		return isUserFollowing;
    }
}