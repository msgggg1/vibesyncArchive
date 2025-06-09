package mvc.persistence.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.DBConn_vibesync;

import mvc.domain.vo.WatchPartyVO;

public class WatchPartyDAO {

    // 1) 전체 WatchParty 목록 조회 (비로그인 / 비호스트 시)
    public List<WatchPartyVO> selectAll() {
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        List<WatchPartyVO> list = new ArrayList<>();
        String sql = "SELECT watchParty_idx, title, video_id, created_at, host FROM watchParty ORDER BY created_at DESC";

        try {

			conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
            	WatchPartyVO wp = new WatchPartyVO();
                wp.setWatchPartyIdx(rs.getInt("watchParty_idx"));
                wp.setTitle(rs.getString("title"));
                wp.setVideoId(rs.getString("video_id"));
                wp.setCreatedAt(rs.getTimestamp("created_at"));
                wp.setHost(rs.getInt("host"));
                list.add(wp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
			e.printStackTrace();
		}
        finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            try {
            	conn.close();
            } catch (Exception e) {
            	e.printStackTrace();
            }
        }

        return list;
    }

    // 2) 특정 호스트의 WatchParty 목록 조회
    public List<WatchPartyVO> selectByHost(int hostIdx) {
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        List<WatchPartyVO> list = new ArrayList<>();
        String sql = "SELECT watchParty_idx, title, video_id, created_at, host " +
                     "FROM watchParty WHERE host = ? ORDER BY created_at DESC";

        try {
        	conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, hostIdx);
            rs = pstmt.executeQuery();
            while (rs.next()) {
            	WatchPartyVO wp = new WatchPartyVO();
                wp.setWatchPartyIdx(rs.getInt("watchParty_idx"));
                wp.setTitle(rs.getString("title"));
                wp.setVideoId(rs.getString("video_id"));
                wp.setCreatedAt(rs.getTimestamp("created_at"));
                wp.setHost(rs.getInt("host"));
                list.add(wp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
			e.printStackTrace();
		} finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            try {
            	conn.close();
            } catch (Exception e) {
            	e.printStackTrace();
            }
        }

        return list;
    }

    // 3) 새로운 WatchParty 삽입
    public int insert(WatchPartyVO wp) {
    	Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = "INSERT INTO watchParty (title, video_id, host) VALUES (?, ?, ?)";
        int result = 0;

        try {
        	
        	conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, wp.getTitle());
            pstmt.setString(2, wp.getVideoId());
            pstmt.setInt(3, wp.getHost());
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
			e.printStackTrace();
		} finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            try {
            	conn.close();
            } catch (Exception e) {
            	e.printStackTrace();
            }
        }
        return result;
    }

    // 4) 단일 WatchParty 조회 (watch.jsp에서 영상 재생 시)
    public WatchPartyVO selectOne(int watchPartyIdx) {
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
    	WatchPartyVO wp = null;
        String sql = "SELECT watchParty_idx, title, video_id, created_at, host " +
                     "FROM watchParty WHERE watchParty_idx = ?";

        try {
        	
			conn = ConnectionProvider.getConnection();

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, watchPartyIdx);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                wp = new WatchPartyVO();
                wp.setWatchPartyIdx(rs.getInt("watchParty_idx"));
                wp.setTitle(rs.getString("title"));
                wp.setVideoId(rs.getString("video_id"));
                wp.setCreatedAt(rs.getTimestamp("created_at"));
                wp.setHost(rs.getInt("host"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
			e.printStackTrace();
		} finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            try {
            	conn.close();
            } catch (Exception e) {
            	e.printStackTrace();
            }
        }
        return wp;
    }

	public WatchPartyVO selectLatestByUniqueFields(String title, String videoId, int host) {
		Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
		WatchPartyVO wp = null;
	    String sql = "SELECT watchParty_idx, title, video_id, created_at, host "
	               + "FROM watchParty "
	               + "WHERE title = ? AND video_id = ? AND host = ? "
	               + "ORDER BY created_at DESC";
	    try {

			conn = ConnectionProvider.getConnection();

            pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, title);
	        pstmt.setString(2, videoId);
	        pstmt.setInt(3, host);
	        rs = pstmt.executeQuery();

            if (rs.next()) {
                wp = new WatchPartyVO();
                wp.setWatchPartyIdx(rs.getInt("watchParty_idx"));
                wp.setTitle(rs.getString("title"));
                wp.setVideoId(rs.getString("video_id"));
                wp.setCreatedAt(rs.getTimestamp("created_at"));
                wp.setHost(rs.getInt("host"));
            }
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } catch (Exception e) {
			e.printStackTrace();
		} finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            try {
            	conn.close();
            } catch (Exception e) {
            	e.printStackTrace();
            }
        }
	    return wp;
	}
}

