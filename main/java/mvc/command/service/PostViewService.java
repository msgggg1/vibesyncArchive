package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.UserNoteDTO;
import mvc.domain.vo.UserNoteVO;
import mvc.persistence.dao.FollowDAO;
import mvc.persistence.dao.LikeDAO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.dao.UserNoteDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;
import mvc.persistence.daoImpl.LikeDAOImpl;
import mvc.persistence.daoImpl.NoteDAOImpl;
import mvc.persistence.daoImpl.UserNoteDAOImpl;

public class PostViewService {
	
	public UserNoteVO getUserNoteInfo(int note_idx) {
		Connection conn = null;
		try {
            conn = ConnectionProvider.getConnection(); 
            UserNoteDAO dao = new UserNoteDAOImpl(conn);
            UserNoteVO noteInfo = dao.getUserNoteById(note_idx);
            return noteInfo;

        } catch (SQLException e) {
            e.printStackTrace(); 
            JdbcUtil.rollback(conn);
            throw new RuntimeException("노트 정보 오류", e);
        } catch (NamingException e) {
			e.printStackTrace();
			JdbcUtil.rollback(conn);
			throw new RuntimeException("DB 커넥션 설정(JNDI) 오류 발생: " + e.getMessage(), e);
		} finally {
            if (conn != null) {
                try {
                    conn.close(); 
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

	}

	public void updateViewCount(int noteidx) {
		Connection conn = null;
		try {
            conn = ConnectionProvider.getConnection(); 
            UserNoteDAO dao = new UserNoteDAOImpl(conn);
            dao.updateViewCount(noteidx);
        } catch (SQLException e) {
            e.printStackTrace(); 
            throw new RuntimeException("노트 조회수 오류", e); 
        } catch (NamingException e) {
			e.printStackTrace();
			throw new RuntimeException("DB 커넥션 설정(JNDI) 오류 발생: " + e.getMessage(), e);
		} finally {
            if (conn != null) {
                try {
                    conn.close(); 
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
	}
	
	public UserNoteDTO getFollowLike(int user_idx, int note_idx, int writerIdx) {
		Connection conn = null;
		try {
            conn = ConnectionProvider.getConnection(); 

            FollowDAO followDAO = new FollowDAOImpl(conn);
            LikeDAO likeDAO = new LikeDAOImpl(conn);
            
            boolean following = followDAO.isFollowing(user_idx, writerIdx);
            boolean liking = likeDAO.isLiked(user_idx, note_idx);
            

            return UserNoteDTO.builder()
                    .following(following)
                    .liking(liking)
                    .build();

        } catch (SQLException e) {
            e.printStackTrace(); 
            throw new RuntimeException("노트 정보 오류", e); 
        } catch (NamingException e) {
			e.printStackTrace();
			throw new RuntimeException("DB 커넥션 설정(JNDI) 오류 발생: " + e.getMessage(), e);
		} finally {
            if (conn != null) {
                try {
                    conn.close(); 
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
	}
}
