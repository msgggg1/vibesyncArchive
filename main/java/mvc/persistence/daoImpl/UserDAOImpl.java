package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.domain.UserVO;
import mvc.domain.dto.UserDTO;
import mvc.persistence.dao.UserDAO;

public class UserDAOImpl implements UserDAO {

	@Override
	public int preferredCategoryIdx(int acIdx) throws SQLException {
		int preferredCategoryIdx = -1;
        String sql = "SELECT category_idx FROM userAccount WHERE ac_idx = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, acIdx);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                preferredCategoryIdx = rs.getInt("category_idx");
            }
        } catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
        	conn.close();
        }
        return preferredCategoryIdx;
    }

	@Override
	public List<UserVO> findPopularUsers(int limit) throws SQLException {
		 List<UserVO> users = new ArrayList<>();
	        // 인기 유저: (받은 좋아요 수 + 팔로워 수) 합산 기준, Oracle TOP-N 쿼리
	        String sql = "SELECT ac_idx, nickname, img, popularity_score " +
	                "FROM ( " +
	                "    SELECT " +
	                "        ua.ac_idx, " +
	                "        ua.nickname, " +
	                "        ua.img, " +
	                "        COALESCE(follower_counts.total_followers, 0) AS popularity_score, " + // 인기도 점수를 팔로워 수로만 계산
	                "        ROW_NUMBER() OVER (ORDER BY COALESCE(follower_counts.total_followers, 0) DESC, ua.created_at DESC) as rn " +
	                "    FROM " +
	                "        userAccount ua " +
	                "    LEFT JOIN " +
	                "        (SELECT ac_following, COUNT(follows_idx) AS total_followers " +
	                "         FROM follows " +
	                "         GROUP BY ac_following) follower_counts ON ua.ac_idx = follower_counts.ac_following " +
	                ") " +
	                "WHERE rn <= ?";
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            conn = ConnectionProvider.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, limit);
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	                UserVO user = new UserVO();
	                user.setAc_idx(rs.getInt("ac_idx"));
	                user.setNickname(rs.getString("nickname"));
	                user.setImg(rs.getString("img"));
	                user.setPopularityScore(rs.getInt("popularity_score")); // UserDTO에 필드가 있다면 설정
	                users.add(user);
	            }
	        } catch (NamingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
	        	conn.close();
	        }
	        return users;
	    }

	 @Override
	    public UserDTO getBasicUserInfoById(Connection conn, int acIdx) throws SQLException {
	        String sql = "SELECT ac_idx, nickname, img, name FROM userAccount WHERE ac_idx = ?";
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        UserDTO user = null;
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, acIdx);
	            rs = pstmt.executeQuery();
	            if (rs.next()) {
	                user = UserDTO.builder() 
	                        .ac_idx(rs.getInt("ac_idx"))
	                        .nickname(rs.getString("nickname"))
	                        .img(rs.getString("img"))
	                        .name(rs.getString("name")) // 필요하다면 다른 필드도 추가
	                        .build();
	            }
	        } finally {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	        }
	        return user;
	    }

	    @Override
	    public int getPostCount(Connection conn, int userAcIdx) throws SQLException {
	        // note 테이블과 userPage 테이블을 조인하여 해당 ac_idx를 가진 사용자의 게시글 수를 계산
	        String sql = "SELECT COUNT(n.note_idx) " +
	                     "FROM note n " +
	                     "JOIN userPage up ON n.userPg_idx = up.userPg_idx " +
	                     "WHERE up.ac_idx = ?";
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        int count = 0;
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, userAcIdx);
	            rs = pstmt.executeQuery();
	            if (rs.next()) {
	                count = rs.getInt(1);
	            }
	        } finally {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	        }
	        return count;
	    }

	    @Override
	    public int getFollowerCount(Connection conn, int userAcIdx) throws SQLException {
	        String sql = "SELECT COUNT(*) FROM follows WHERE ac_following = ?"; // userAcIdx를 팔로우하는 사람들의 수
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        int count = 0;
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, userAcIdx);
	            rs = pstmt.executeQuery();
	            if (rs.next()) {
	                count = rs.getInt(1);
	            }
	        } finally {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	        }
	        return count;
	    }

	    @Override
	    public int getFollowingCount(Connection conn, int userAcIdx) throws SQLException {
	        String sql = "SELECT COUNT(*) FROM follows WHERE ac_follow = ?"; // userAcIdx가 팔로우하는 사람들의 수
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        int count = 0;
	        try {
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, userAcIdx);
	            rs = pstmt.executeQuery();
	            if (rs.next()) {
	                count = rs.getInt(1);
	            }
	        } finally {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	        }
	        return count;
	    }

}
