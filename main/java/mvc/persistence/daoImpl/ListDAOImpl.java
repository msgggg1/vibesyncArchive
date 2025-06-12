package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mvc.domain.vo.PageVO;
import mvc.domain.vo.NoteVO;  // 추가
import mvc.persistence.dao.ListDAO;

public class ListDAOImpl implements ListDAO {
    private Connection conn;

    public ListDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public int selectCount(String searchType, String keyword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM userPage";
        if (keyword != null && !keyword.isEmpty()) {
            if ("subject".equals(searchType)) {
                sql += " WHERE subject LIKE ?";
            } else if ("content".equals(searchType)) {
                sql += " WHERE content LIKE ?";
            } else if ("subject_content".equals(searchType)) {
                sql += " WHERE subject LIKE ? OR content LIKE ?";
            }
        }
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                if ("subject_content".equals(searchType)) {
                    pstmt.setString(1, kw);
                    pstmt.setString(2, kw);
                } else {
                    pstmt.setString(1, kw);
                }
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    @Override
    public List<PageVO> selectAll(String searchType, String keyword) throws SQLException {
        String sql = "SELECT userpg_idx, subject, thumbnail, created_at, ac_idx, re_userpg_idx FROM userPage";
        if (keyword != null && !keyword.isEmpty()) {
            if ("subject".equals(searchType)) {
                sql += " WHERE subject LIKE ?";
            } else if ("content".equals(searchType)) {
                sql += " WHERE content LIKE ?";
            } else if ("subject_content".equals(searchType)) {
                sql += " WHERE subject LIKE ? OR content LIKE ?";
            }
        }
        sql += " ORDER BY userpg_idx DESC";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                if ("subject_content".equals(searchType)) {
                    pstmt.setString(1, kw);
                    pstmt.setString(2, kw);
                } else {
                    pstmt.setString(1, kw);
                }
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                List<PageVO> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(PageVO.builder()
                        .userpg_idx(rs.getInt("userpg_idx"))
                        .subject(rs.getString("subject"))
                        .thumbnail(rs.getString("thumbnail"))
                        .created_at(rs.getTimestamp("created_at"))
                        .ac_idx(rs.getInt("ac_idx"))
                        .re_userpg_idx(rs.getInt("re_userpg_idx"))
                        .build());
                }
                return list;
            }
        }
    }

    @Override
    public List<NoteVO> selectNotesByPage(int userPgIdx) throws SQLException {
        String sql = "SELECT note_idx, title, text, img, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx "
                   + "FROM note WHERE userPg_idx = ? ORDER BY create_at DESC";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userPgIdx);
            try (ResultSet rs = pstmt.executeQuery()) {
                List<NoteVO> notes = new ArrayList<>();
                while (rs.next()) {
                    notes.add(NoteVO.builder()
                        .note_idx(rs.getInt("note_idx"))
                        .title(rs.getString("title"))
                        .text(rs.getString("text"))
                        .img(rs.getString("img"))
                        .create_at(rs.getTimestamp("create_at"))
                        .edit_at(rs.getTimestamp("edit_at"))
                        .view_count(rs.getInt("view_count"))
                        .content_idx(rs.getInt("content_idx"))
                        .genre_idx(rs.getInt("genre_idx"))
                        .category_idx(rs.getInt("category_idx"))
                        .userPg_idx(rs.getInt("userPg_idx"))
                        .build());
                }
                return notes;
            }
        }
    }
}
