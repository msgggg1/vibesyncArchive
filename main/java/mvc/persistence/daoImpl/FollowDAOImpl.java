package mvc.persistence.daoImpl; 

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import mvc.persistence.dao.FollowDAO;

public class FollowDAOImpl implements FollowDAO {

    @Override
    public int addFollow(Connection conn, int followerAcIdx, int followingAcIdx) throws SQLException {
        String sql = "INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (follows_seq.NEXTVAL, ?, ?)";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, followerAcIdx);
            pstmt.setInt(2, followingAcIdx);
            return pstmt.executeUpdate();
        } finally {
            if (pstmt != null) pstmt.close();
        }
    }

    @Override
    public int removeFollow(Connection conn, int followerAcIdx, int followingAcIdx) throws SQLException {
        String sql = "DELETE FROM follows WHERE ac_follow = ? AND ac_following = ?";
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, followerAcIdx);
            pstmt.setInt(2, followingAcIdx);
            return pstmt.executeUpdate();
        } finally {
            if (pstmt != null) pstmt.close();
        }
    }

    @Override
    public boolean isFollowing(Connection conn, int followerAcIdx, int followingAcIdx) throws SQLException {
        String sql = "SELECT COUNT(*) FROM follows WHERE ac_follow = ? AND ac_following = ?";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, followerAcIdx);
            pstmt.setInt(2, followingAcIdx);
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
}