package mvc.persistence.dao;

import java.sql.*;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.DBConn_vibesync;

import mvc.domain.vo.WaSyncVO;

public class WaSyncDAO {

    // 특정 WatchParty의 최근 sync 정보 가져오기 (마지막 재생 상태)
    public WaSyncVO selectLatestByWatchParty(int watchPartyIdx) throws NamingException, SQLException {
		 Connection conn = null;
		 PreparedStatement pstmt = null;
		 ResultSet rs = null;
		 
    	WaSyncVO sync = null;
        String sql = "SELECT sync_idx, timeline, play, watchParty_idx " +
                     "FROM wa_sync WHERE watchParty_idx = ? ORDER BY sync_idx DESC";

        try {
        	conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, watchPartyIdx);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                sync = new WaSyncVO();
                sync.setSyncIdx(rs.getInt("sync_idx"));
                sync.setTimeline(rs.getDouble("timeline"));
                sync.setPlay(rs.getString("play"));
                sync.setWatchPartyIdx(rs.getInt("watchParty_idx"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            conn.close();
        }
        return sync;
    }

    // 실시간 재생 정보 삽입 (WebSocket에서 호출)
    public int insert(WaSyncVO sync) throws NamingException, SQLException {
    	 Connection conn = null;
		 PreparedStatement pstmt = null;
		 
        String sql = "INSERT INTO wa_sync (timeline, play, watchParty_idx) VALUES (?, ?, ?)";
        int result = 0;

        try {
        	conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setDouble(1, sync.getTimeline());
            pstmt.setString(2, sync.getPlay());
            pstmt.setInt(3, sync.getWatchPartyIdx());
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            conn.close();
        }
        return result;
    }

    public int upsertByWatchParty(WaSyncVO vo) throws NamingException, SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = ConnectionProvider.getConnection();

            // 1) 먼저, 해당 watchParty_idx 레코드가 있는지 확인
            String selectSql = "SELECT sync_idx FROM wa_sync WHERE watchParty_idx = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, vo.getWatchPartyIdx());
            rs = pstmt.executeQuery();
            if (rs.next()) {
                // 기존 레코드가 있으면 UPDATE
                int syncIdx = rs.getInt("sync_idx");
                rs.close();
                pstmt.close();

                String updateSql = "UPDATE wa_sync SET timeline = ?, play = ? WHERE sync_idx = ?";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setDouble(1, vo.getTimeline());
                pstmt.setString(2, vo.getPlay());
                pstmt.setInt(3, syncIdx);
                return pstmt.executeUpdate();
            } else {
                // 없으면 INSERT
                rs.close();
                pstmt.close();

                String insertSql = "INSERT INTO wa_sync (timeline, play, watchParty_idx) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(insertSql);
                pstmt.setDouble(1, vo.getTimeline());
                pstmt.setString(2, vo.getPlay());
                pstmt.setInt(3, vo.getWatchPartyIdx());
                return pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignore) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception ignore) {}
            conn.close();
        }
    }
}
