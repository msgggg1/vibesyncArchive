package mvc.command.service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.vo.CategoryVO;
import mvc.persistence.dao.CategoryDAO;
import mvc.persistence.daoImpl.CategoryDAOImpl;

public class CategoryService {
	
	// 전체 카테고리 조회
	public List<CategoryVO> allCategories() {
		List<CategoryVO> list = new ArrayList<CategoryVO>();
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			CategoryDAO categoryDAO = new CategoryDAOImpl(conn);
			
			// 카테고리 조회
			list = categoryDAO.CategoryAll();
			System.out.println(list.toString());
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return list;
	}
	
	
	
}
