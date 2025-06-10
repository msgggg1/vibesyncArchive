package mvc.command.service;

import java.sql.Connection;
import java.util.List;

import com.util.ConnectionProvider; 
import mvc.domain.dto.NoteSummaryDTO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.NoteDAOImpl;

public class NoteService {

    // --- Workspace [내가 작성한 글] 관련 서비스 메소드 ---
    /**
     * 특정 사용자가 작성한 글을 인기순으로 7개 가져옵니다. (위젯 미리보기용)
     * @param acIdx 사용자 계정 ID
     * @return NoteSummaryDTO 리스트
     */
	public List<NoteSummaryDTO> getMyPostsPreview(int acIdx, int limit) throws Exception {
	    Connection conn = null;
	    try {
	        conn = ConnectionProvider.getConnection();
	        NoteDAO noteDAO = new NoteDAOImpl(conn);
	        List<NoteSummaryDTO> posts = noteDAO.findMyPostsByPopularity(acIdx, limit);
	        return posts;
	    } finally {
	        if (conn != null) conn.close();
	    }
	}

    /**
     * 특정 사용자가 작성한 글 전체를 인기순으로 가져옵니다. (모달용)
     * @param acIdx 사용자 계정 ID
     * @return NoteSummaryDTO 리스트
     */
    public List<NoteSummaryDTO> getAllMyPosts(int acIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            return noteDAO.findAllMyPostsByPopularity(acIdx);
        } finally {
            if (conn != null) conn.close();
        }
    }
    
    // --- [좋아요한 글] 관련 서비스 메소드 ---
    /**
     * 특정 사용자가 좋아요한 글을 최신순으로 7개 가져옵니다. (위젯 미리보기용)
     * @param acIdx 사용자 계정 ID
     * @return NoteSummaryDTO 리스트
     */
    public List<NoteSummaryDTO> getLikedPostsPreview(int acIdx, int limit) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            // DAO에 구현할 findLikedPostsByRecent 메소드 호출 (limit: 7)
            return noteDAO.findLikedPostsByRecent(acIdx, limit);
        } finally {
            if (conn != null) conn.close();
        }
    }

    /**
     * 특정 사용자가 좋아요한 글 전체를 최신순으로 가져옵니다. (모달용)
     * @param acIdx 사용자 계정 ID
     * @return NoteSummaryDTO 리스트
     */
    
    public List<NoteSummaryDTO> getAllLikedPosts(int acIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            // DAO에 구현할 findAllLikedPostsByRecent 메소드 호출
            return noteDAO.findAllLikedPostsByRecent(acIdx);
        } finally {
            if (conn != null) conn.close();
        }
    }
    
}