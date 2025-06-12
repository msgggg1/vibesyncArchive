package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.util.ConnectionProvider;

import mvc.domain.vo.CategoryVO;
import mvc.domain.vo.GenreVO;
import mvc.persistence.dao.CategoryDAO;
import mvc.persistence.dao.GenreDAO;

public class GenreDAOImpl implements GenreDAO {
    private Connection conn = null;

    // 생성자
    public GenreDAOImpl(Connection conn) {
    	this.conn = conn;
    }
    
    @Override
    // 모든 카테고리 정보 조회
    public List<GenreVO> GenreAll() throws SQLException {
    	List<GenreVO> list = new ArrayList<GenreVO>();

        PreparedStatement pstmt = null;
        ResultSet rs = null;
    	
    	String sql = " SELECT * FROM genre ";
    	
        try {
        	pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int genre_idx = rs.getInt("genre_idx");
                String gen_name = rs.getString("gen_name");
            	
                GenreVO vo = GenreVO.builder()
    							  .genre_idx(genre_idx)
    							  .gen_name(gen_name)
    							  .build();
                list.add(vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
        }

        return list;
    }
}
