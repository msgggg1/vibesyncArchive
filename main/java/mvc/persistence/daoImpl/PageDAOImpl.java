package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mvc.domain.vo.PageVO;
import mvc.persistence.dao.PageDAO;

public class PageDAOImpl implements PageDAO {
    private Connection conn;

    public PageDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<PageVO> pageAll(int useridx) throws SQLException {
        List<PageVO> list = new ArrayList<>();
        String sql = "SELECT userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx FROM userPage where ac_idx = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        	pstmt.setInt(1, useridx);
        	ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				PageVO vo = PageVO.builder()
						.userpg_idx(rs.getInt("userPg_idx"))
						.subject(rs.getString("subject"))
						.thumbnail(rs.getString("thumbnail"))
						.created_at(rs.getTimestamp("created_at"))
						.ac_idx(rs.getInt("ac_idx"))
						// re_userPg_idx가 null인 경우 0으로 반환, 필요한 경우 확인
						.re_userpg_idx(rs.getInt("re_userPg_idx"))
						.build();
				list.add(vo);
			}
        }

        return list;
    }

    @Override
    public void createPage(PageVO page) throws SQLException {
        String sql = "INSERT INTO userPage (subject, thumbnail, ac_idx, re_userPg_idx) VALUES ( ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, page.getSubject());
            pstmt.setString(2, page.getThumbnail());
            pstmt.setInt(3, page.getAc_idx());
            if (page.getRe_userpg_idx() > 0) {
                pstmt.setInt(4, page.getRe_userpg_idx());
            } else {
                pstmt.setNull(4, java.sql.Types.INTEGER);
            }
            pstmt.executeUpdate();
        }
    }

    @Override
    public void updatePage(PageVO page) throws SQLException {
        String sql = "UPDATE userPage SET subject = ?, thumbnail = ?, ac_idx = ?, re_userPg_idx = ? WHERE userPg_idx = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, page.getSubject());
            pstmt.setString(2, page.getThumbnail());
            pstmt.setInt(3, page.getAc_idx());
            if (page.getRe_userpg_idx() > 0) {
                pstmt.setInt(4, page.getRe_userpg_idx());
            } else {
                pstmt.setNull(4, java.sql.Types.INTEGER);
            }
            pstmt.setInt(5, page.getUserpg_idx());
            pstmt.executeUpdate();
        }
    }

    @Override
    public void deletePage(int userPg_idx) throws SQLException {
        String sql = "DELETE FROM userPage WHERE userPg_idx = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userPg_idx);
            pstmt.executeUpdate();
        }
    }
}
