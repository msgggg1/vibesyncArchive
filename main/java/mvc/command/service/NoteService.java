package mvc.command.service;

import java.sql.Connection;
import java.util.List;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.NoteStatsDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.persistence.dao.LikeDAO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.LikeDAOImpl;
import mvc.persistence.daoImpl.NoteDAOImpl;

public class NoteService {
	 // --- Workspace [내가 작성한 글] 관련 서비스 메소드 ---
    //사용자가 작성한 글 인기순. (위젯 미리보기용)
	public List<NoteSummaryDTO> getMyPostsPreview(int acIdx) throws Exception {
	    Connection conn = null;
	    try {
	        conn = ConnectionProvider.getConnection();
	        NoteDAO noteDAO = new NoteDAOImpl(conn);
	        List<NoteSummaryDTO> posts = noteDAO.findMyPostsByPopularity(acIdx);
	        return posts;
	    } finally {
	        if (conn != null) conn.close();
	    }
	}

    
    //사용자가 작성한 글 전체를 인기순 (모달용)
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
    // 좋아요한 글 최신순 7개 (위젯 미리보기용)
    public List<NoteSummaryDTO> getLikedPostsPreview(int acIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            // DAO에 구현할 findLikedPostsByRecent 메소드 호출 (limit: 7)
            return noteDAO.findLikedPostsByRecent(acIdx);
        } finally {
            if (conn != null) conn.close();
        }
    }

    //좋아요한 글 전체를 최신순
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
	
	public List<NoteSummaryDTO> getPostsByCategory(int categoryIdx, String sortType) {
		List<NoteSummaryDTO> postsByCategory = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			NoteDAO noteDAO = new NoteDAOImpl(conn);
			
			if (sortType.equals("popular")) {
				postsByCategory = noteDAO.popularNoteByMyCategory(categoryIdx, 5);
				
			} else if (sortType.equals("latest")) {
				postsByCategory = noteDAO.recentNoteByMyCategory(categoryIdx, 5);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return postsByCategory;
	}

	public NoteStatsDTO getUserNoteStats(int acIdx) {
		NoteStatsDTO userNoteStats = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			// 유저가 작성한 전체 게시글 note_idx
			NoteDAO noteDAO = new NoteDAOImpl(conn);
			List<Integer> noteIdList = noteDAO.getNoteIdxListByUser(acIdx);
			
			// 전체 게시글의 총 좋아요 수
			LikeDAO likeDAO = new LikeDAOImpl(conn);
			int likeCnt = likeDAO.getLikesCountForMultipleNotes(noteIdList);
			
			// 전체 게시글의 조회수
			int viewCnt = noteDAO.getViewCountsForNotesAllByUser(acIdx);
			
			userNoteStats = NoteStatsDTO.builder()
										.totalLikes(likeCnt)
										.totalViews(viewCnt)
										.totalPosts(noteIdList.size())
										.build();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return userNoteStats;
	}

}
