package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.util.JdbcUtil;

import mvc.domain.dto.DailyStatsDTO;
import mvc.persistence.dao.LikeDAO;

public class LikeDAOImpl implements LikeDAO {
    private Connection conn = null;

	// 생성자
	public LikeDAOImpl(Connection conn) {
	    	this.conn = conn;
	    }

    // 좋아요 추가
    public int addLike(int acIdx, int noteIdx) throws SQLException {
        String sql = "INSERT INTO likes (likes_idx, note_idx, ac_idx, created_at) VALUES (likes_seq.NEXTVAL, ?, ?, SYSDATE)";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noteIdx);
            pstmt.setInt(2, acIdx);
            return pstmt.executeUpdate();
        } finally {
            if (pstmt != null) pstmt.close();
            // Connection은 Service나 Controller에서 관리하므로 여기서 닫지 않음
        }
    }

    // 좋아요 제거
    public int removeLike(int acIdx, int noteIdx) throws SQLException {
        String sql = "DELETE FROM likes WHERE ac_idx = ? AND note_idx = ?";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, acIdx);
            pstmt.setInt(2, noteIdx);
            return pstmt.executeUpdate();
        } finally {
            if (pstmt != null) pstmt.close();
        }
    }

    // 특정 사용자가 특정 게시글을 좋아했는지 확인
    public boolean isLiked(int acIdx, int noteIdx) throws SQLException {
        String sql = "SELECT COUNT(*) FROM likes WHERE ac_idx = ? AND note_idx = ?";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, acIdx);
            pstmt.setInt(2, noteIdx);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
    }

    // 특정 게시글의 총 좋아요 수 계산
    public int getLikesCountForNote(int noteIdx) throws SQLException {
        String sql = "SELECT COUNT(*) FROM likes WHERE note_idx = ? ";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noteIdx);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
    }

    // 여러 게시글의 좋아요 수 합산
	@Override
	public int getLikesCountForMultipleNotes(List<Integer> noteIdxList) throws SQLException {
        int likeCnt = 0;
		
		StringBuffer sql = new StringBuffer(" SELECT COUNT(likes_idx) FROM likes WHERE note_idx IN ( ");
		
		for (int i = 0; i < noteIdxList.size(); i++) {
			sql.append(noteIdxList.get(i));
			if (i != noteIdxList.size() - 1) {
				sql.append(", ");
			} else {
				sql.append(" ) ");
			}
		}
		
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        pstmt = conn.prepareStatement(sql.toString());
		rs = pstmt.executeQuery();
		
        if (rs.next()) {
        	likeCnt = rs.getInt(1);
        }
        
        JdbcUtil.close(rs);
        JdbcUtil.close(pstmt);        
		
		return likeCnt;
	}

	// 특정 사용자의 최근 N일간의 일별 게시글 좋아요 수 (일별 통계)
	@Override
	public List<DailyStatsDTO> getDailyLikeCountsForUserPosts(int acIdx, int days) throws SQLException {
		List<DailyStatsDTO> dailyStats = new ArrayList<DailyStatsDTO>();

		PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = " SELECT "
	    		   + " TO_CHAR(TRUNC(l.created_at), 'YYYY-M-d (E)') AS stat_date, "
	    		   + " COUNT(likes_idx) AS like_count "
	               + " FROM likes l "
	               + " JOIN note n "
	               + " ON l.note_idx = n.note_idx "
	    		   + " JOIN userPage u "
	    		   + " ON u.userPg_idx = n.userPg_idx "
                   + " WHERE u.ac_idx = ? "
                   + " AND l.created_at >= TRUNC(SYSDATE) - ? "
	               + " GROUP BY TRUNC(l.created_at) "
	               + " ORDER BY stat_date ";
	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, acIdx);
	        pstmt.setInt(2, days - 1);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            dailyStats.add(new DailyStatsDTO(rs.getString("stat_date"), rs.getLong("like_count")));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        JdbcUtil.close(rs);
	        JdbcUtil.close(pstmt);
	    }
	    
	    return dailyStats;
	    
	}
	
	// 특정 사용자의 최근 N주간의 주별 게시글 좋아요 수 (주별 통계)
	@Override
	public List<DailyStatsDTO> getWeeklyLikeCountsForUserPosts(int acIdx, int weeks) throws SQLException {
		List<DailyStatsDTO> weeklyStats = new ArrayList<>();
		
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    String sql = " SELECT "
	    		   + " TO_CHAR(TRUNC(l.created_at, 'IW'), 'YYYY-MM-DD') AS stat_date, "
	    		   + " COUNT(likes_idx) AS like_count "
	    		   + " FROM likes l "
	               + " JOIN note n ON l.note_idx = n.note_idx "
	               + " JOIN userPage u ON u.userPg_idx = n.userPg_idx "
	               + " WHERE u.ac_idx = ? AND l.created_at >= TRUNC(SYSDATE, 'IW') - (? * 7) "
	               + " GROUP BY TRUNC(l.created_at, 'IW') "
	               + " ORDER BY stat_date ";
	    
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setInt(1, acIdx);
	    pstmt.setInt(2, weeks - 1);
	    rs = pstmt.executeQuery();
	    while (rs.next()) {
         weeklyStats.add(new DailyStatsDTO(rs.getString("stat_date"), rs.getLong("like_count")));
	    }
	    JdbcUtil.close(rs);
	    JdbcUtil.close(pstmt);
		
		return weeklyStats;
	}

	// 특정 사용자의 최근 N달간의 월별 게시글 좋아요 수 (월별 통계)
	@Override
	public List<DailyStatsDTO> getMonthlyLikeCountsForUserPosts(int acIdx, int months) throws SQLException {
        List<DailyStatsDTO> monthlyStats = new ArrayList<>();
        
		PreparedStatement pstmt = null;
	    ResultSet rs = null;
        
        // months가 -1이면 전체 기간 조회
        String sql = " SELECT TO_CHAR(l.created_at, 'YYYY-MM') AS stat_date, COUNT(l.likes_idx) AS like_count "
                   + " FROM likes l "
                   + " JOIN note n ON l.note_idx = n.note_idx "
                   + " JOIN userPage u ON u.userPg_idx = n.userPg_idx "
                   + " WHERE u.ac_idx = ? "
                   + "AND l.created_at >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -?) "
                   + " GROUP BY TO_CHAR(l.created_at, 'YYYY-MM') "
                   + " ORDER BY stat_date ";

        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, acIdx);
        pstmt.setInt(2, months - 1);
        
        rs = pstmt.executeQuery();
        while (rs.next()) {
            monthlyStats.add(new DailyStatsDTO(rs.getString("stat_date"), rs.getLong("like_count")));
        }
        
        JdbcUtil.close(rs);
        JdbcUtil.close(pstmt);
        
        return monthlyStats;
	}
	
	// 특정 사용자의 최근 N년간의 연도별 게시글 좋아요 수 (연도별 통계)
	@Override
	public List<DailyStatsDTO> getYearlyLikeCountsForUserPosts(int acIdx, int years) throws SQLException {
	    List<DailyStatsDTO> yearlyStats = new ArrayList<>();
	    
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    String sql = " SELECT TO_CHAR(l.created_at, 'YYYY') AS stat_date, COUNT(l.likes_idx) AS like_count "
		 		   + " FROM likes l "
		           + " JOIN note n ON l.note_idx = n.note_idx "
		           + " JOIN userPage u ON u.userPg_idx = n.userPg_idx "
		           + " WHERE u.ac_idx = ? AND l.created_at >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), -((?-1)*12)) "
		           + " GROUP BY TO_CHAR(l.created_at, 'YYYY') "
		           + " ORDER BY stat_date ";
	    
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setInt(1, acIdx);
	    pstmt.setInt(2, years);
	    rs = pstmt.executeQuery();
	    while (rs.next()) {
            yearlyStats.add(new DailyStatsDTO(rs.getString("stat_date"), rs.getLong("like_count")));
        }
	    
        JdbcUtil.close(rs);
        JdbcUtil.close(pstmt);
	    
	    return yearlyStats;
	}
	
}
