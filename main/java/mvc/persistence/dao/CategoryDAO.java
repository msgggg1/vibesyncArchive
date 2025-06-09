package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mvc.domain.vo.CategoryVO;

public interface CategoryDAO {
	
	// 모든 카테고리 정보 조회
	List<CategoryVO> CategoryAll() throws SQLException;
	
}
