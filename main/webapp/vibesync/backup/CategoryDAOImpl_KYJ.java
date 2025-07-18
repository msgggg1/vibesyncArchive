package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.util.ConnectionProvider;

import mvc.domain.vo.CategoryVO;
import mvc.persistence.dao.CategoryDAO;

public class CategoryDAOImpl_KYJ implements CategoryDAO {
    private Connection conn = null;
    private PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 생성자
    public CategoryDAOImpl_KYJ(Connection conn) {
    	this.conn = conn;
    }
    
    @Override
    // 모든 카테고리 정보 조회
    public List<CategoryVO> CategoryAll() throws SQLException {
    	List<CategoryVO> list = new ArrayList<CategoryVO>();

    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
    	
    	String sql = " SELECT category_idx, c_name, img FROM category ";
    	
        try {
            conn = ConnectionProvider.getConnection();
        	pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int category_idx = rs.getInt("category_idx");
                String c_name = rs.getString("c_name");
                String img = rs.getString("img");
            	
            	CategoryVO vo = CategoryVO.builder()
            							  .category_idx(category_idx)
            							  .c_name(c_name)
            							  .img(img)
            							  .build();
                list.add(vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
        }

        return list;
    }
}
