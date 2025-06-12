package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.util.ConnectionProvider;

import mvc.domain.vo.CategoryVO;
import mvc.domain.vo.ContentsVO;
import mvc.persistence.dao.CategoryDAO;
import mvc.persistence.dao.ContentsDAO;

public class ContentsDAOImpl implements ContentsDAO {
    private Connection conn = null;

    // 생성자
    public ContentsDAOImpl(Connection conn) {
    	this.conn = conn;
    }
    
    @Override
    // 모든 카테고리 정보 조회
    public List<ContentsVO> ContentsAll() throws SQLException {
    	List<ContentsVO> list = new ArrayList<ContentsVO>();

        PreparedStatement pstmt = null;
        ResultSet rs = null;
    	
    	String sql = " SELECT * FROM contents ";
    	
        try {
        	pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int content_idx = rs.getInt("content_idx");
                String title = rs.getString("title");
                String img = rs.getString("img");
                String dsc = rs.getString("dsc");
                int category_idx = rs.getInt("category_idx");
            	
                ContentsVO vo = ContentsVO.builder()
            							  .content_idx(content_idx)
            							  .title(title)
            							  .img(img)
            							  .dsc(dsc)
            							  .category_idx(category_idx)
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
