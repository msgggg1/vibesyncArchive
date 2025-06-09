package mvc.persistence.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.domain.vo.WaCommentVO;


public class WaCommentDAO {

    // 특정 WatchParty의 전체 댓글 목록 조회 (타임라인 오름차순)
    public List<WaCommentVO> selectByWatchParty(int watchPartyIdx) throws NamingException, SQLException {
    	 Connection conn = null;
		 PreparedStatement pstmt = null;
		 ResultSet rs = null;
    	
        List<WaCommentVO> list = new ArrayList<>();
        String sql = "SELECT wac_idx, nickname, chatting, timeline, create_at, watchParty_idx " +
                     "FROM wa_comment WHERE watchParty_idx = ? ORDER BY timeline ASC, create_at ASC";

        try {
        	conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, watchPartyIdx);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                WaCommentVO wc = new WaCommentVO();
                wc.setWacIdx(rs.getInt("wac_idx"));
                wc.setNickname(rs.getString("nickname"));
                wc.setChatting(rs.getString("chatting"));
                wc.setTimeline(rs.getDouble("timeline"));
                wc.setCreatedAt(rs.getTimestamp("create_at"));
                wc.setWatchPartyIdx(rs.getInt("watchParty_idx"));
                list.add(wc);
                
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            conn.close();
        }
        return list;
    }

    // 실시간 채팅(댓글) 삽입 (WebSocket에서 호출)
    public int insert(WaCommentVO wc) throws NamingException, SQLException {
    	Connection conn = null;
		PreparedStatement pstmt = null;
		 
        String sql = "INSERT INTO wa_comment (nickname, chatting, timeline, watchParty_idx) VALUES (?, ?, ?, ?)";
        int result = 0;

        try {
        	conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, wc.getNickname());
            pstmt.setString(2, wc.getChatting());
            pstmt.setDouble(3, wc.getTimeline());
            pstmt.setInt(4, wc.getWatchPartyIdx());
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            conn.close();
        }
        return result;
    }
}
