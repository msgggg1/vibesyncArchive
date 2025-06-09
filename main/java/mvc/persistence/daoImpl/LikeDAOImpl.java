package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
// import your.project.db.DBConnectionManager; // 직접 사용하지 않고 Connection을 매개변수로 받음

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
        String sql = "SELECT COUNT(*) FROM likes WHERE note_idx = ?";
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
}
