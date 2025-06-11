package mvc.persistence.daoImpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.util.ConnectionProvider;

import mvc.domain.dto.WatchPartyDTO;
import mvc.domain.vo.UserSummaryVO;
import mvc.domain.vo.WatchPartyVO;
import mvc.persistence.dao.WatchPartyDAO;

public class WatchPartyDAOImpl implements WatchPartyDAO {

	Connection conn = null;
	
	public WatchPartyDAOImpl() {}
	
    public WatchPartyDAOImpl(Connection conn) {
		this.conn = conn;
	}

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

    // 5) ???
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

	
	// 6) 여러 명의 호스트의 WatchParty 목록 조회
	@Override
	public List<WatchPartyDTO> selectWatchPartyListByHostId(List<Integer> hostList) throws SQLException {
		
		// 1. hostList가 비어있는 경우, DB에 접근할 필요 없이 즉시 빈 리스트를 반환합니다. (오류 방지)
	    if (hostList == null || hostList.isEmpty()) {
	        return new ArrayList<>();
	    }
	    
		List<WatchPartyDTO> watchPartyListByHost = new ArrayList<WatchPartyDTO>();
		
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuffer sql = new StringBuffer(" SELECT "
        								  + " watchparty_idx, title, video_id, w.created_at, host, nickname, img AS profile_img, category_idx "
        								  + " FROM watchparty w "
        								  + " JOIN userAccount u ON w.host = u.ac_idx "
        								  + " WHERE w.host IN ( ");
		
        for (int i = 0; i < hostList.size(); i++) {
			sql.append(hostList.get(i));
			if (i != hostList.size() - 1) {
				sql.append(", ");
			} else {
				sql.append(" ) ");
			}
		}
        
        pstmt = conn.prepareStatement(sql.toString());
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
    		WatchPartyVO watchPartyVO = WatchPartyVO.builder()
													.watchPartyIdx(rs.getInt("watchparty_idx"))
													.title(rs.getString("title"))
													.videoId(rs.getString("video_id"))
													.createdAt(rs.getTimestamp("created_at"))
													.build();
			
			UserSummaryVO host = UserSummaryVO.builder()
										 	  .ac_idx(rs.getInt("host"))
										 	  .nickname(rs.getString("nickname"))
										 	  .profile_img(rs.getString("profile_img"))
										 	  .category_idx(rs.getInt("category_idx"))
										 	  .build();
			
			WatchPartyDTO watchPartDTO = WatchPartyDTO.builder()
													  .watchparty(watchPartyVO)
													  .host(host)
													  .build();
			
			watchPartyListByHost.add(watchPartDTO);
		}
		
		return watchPartyListByHost;
	}
	
}

