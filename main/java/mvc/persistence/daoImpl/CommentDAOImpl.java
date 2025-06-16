package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import mvc.domain.vo.CommentVO;
import mvc.persistence.dao.CommentDAO;

public class CommentDAOImpl implements CommentDAO {
    private Connection conn;

    public CommentDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<CommentVO> getCommentsByNoteId(int note_idx) throws SQLException {
        List<CommentVO> list = new ArrayList<>();
        
        // [수정] c.* 대신 모든 컬럼명을 명시적으로 나열하여 안정성 향상
        String sql = "SELECT " +
                     "    c.commentlist_idx, c.text, c.like_count, c.create_at, " +
                     "    c.re_commentlist_idx, c.note_idx, c.ac_idx, c.depth, u.nickname " +
                     "FROM commentlist c " +
                     "JOIN userAccount u ON c.ac_idx = u.ac_idx " +
                     "WHERE c.note_idx = ? " +
                     "START WITH c.re_commentlist_idx IS NULL " +
                     "CONNECT BY PRIOR c.commentlist_idx = c.re_commentlist_idx " +
                     "ORDER SIBLINGS BY c.create_at ASC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, note_idx);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CommentVO vo = CommentVO.builder()
                        .commentlist_idx(rs.getInt("commentlist_idx"))
                        .text(rs.getString("text"))
                        .like_count(rs.getInt("like_count"))
                        .create_at(rs.getTimestamp("create_at"))
                        .re_commentlist_idx(rs.getInt("re_commentlist_idx"))
                        .note_idx(rs.getInt("note_idx"))
                        .ac_idx(rs.getInt("ac_idx"))
                        .nickname(rs.getString("nickname"))
                        .depth(rs.getInt("depth"))
                        .build();
                    list.add(vo);
                }
            }
        }
        return list;
    }

    @Override
    public CommentVO getCommentById(int commentlist_idx) throws SQLException {
        String sql = "SELECT * FROM commentlist WHERE commentlist_idx = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentlist_idx);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return CommentVO.builder()
                        .commentlist_idx(rs.getInt("commentlist_idx"))
                        .text(rs.getString("text"))
                        .like_count(rs.getInt("like_count"))
                        .create_at(rs.getTimestamp("create_at"))
                        .re_commentlist_idx(rs.getInt("re_commentlist_idx"))
                        .note_idx(rs.getInt("note_idx"))
                        .ac_idx(rs.getInt("ac_idx"))
                        .depth(rs.getInt("depth"))
                        .build();
                }
            }
        }
        return null;
    }

    @Override
    public void addComment(CommentVO comment) throws SQLException {
        String sql = "INSERT INTO commentlist (commentlist_idx, text, note_idx, ac_idx, re_commentlist_idx, depth) " + 
                     "VALUES ( (SELECT NVL(MAX(commentlist_idx), 0) + 1 FROM commentlist), ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, comment.getText());
            pstmt.setInt(2, comment.getNote_idx());
            pstmt.setInt(3, comment.getAc_idx());
            
            if (comment.getRe_commentlist_idx() > 0) {
                pstmt.setInt(4, comment.getRe_commentlist_idx());
            } else {
                pstmt.setNull(4, Types.INTEGER);
            }
            pstmt.setInt(5, comment.getDepth());
            
            pstmt.executeUpdate();
        }
    }

    @Override
    public void updateComment(int commentlist_idx, String text) throws SQLException {
        String sql = "UPDATE commentlist SET text = ? WHERE commentlist_idx = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, text);
            pstmt.setInt(2, commentlist_idx);
            pstmt.executeUpdate();
        }
    }

    @Override
    public void deleteComment(int commentlist_idx) throws SQLException {
        String sql = "DELETE FROM commentlist WHERE commentlist_idx = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentlist_idx);
            pstmt.executeUpdate();
        }
    }
}