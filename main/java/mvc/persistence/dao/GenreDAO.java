package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mvc.domain.vo.GenreVO;

public interface GenreDAO {
	
	// 모든 카테고리 정보 조회
	List<GenreVO> GenreAll() throws SQLException;
	
}
