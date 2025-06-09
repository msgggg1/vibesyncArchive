package mvc.command.service;

import java.util.ArrayList;
import java.util.List;

import mvc.domain.vo.CategoryVO;
import mvc.persistence.dao.CategoryDAO;

public class CategoryService_KYJ {
	private CategoryDAO categoryDAO;

	public CategoryService_KYJ(CategoryDAO categoryDAO) {
		this.categoryDAO = categoryDAO;
	}
	
	// 전체 카테고리 조회
	public List<CategoryVO> allCategories() {
		List<CategoryVO> list = new ArrayList<CategoryVO>();
		list = categoryDAO.CategoryAll();
		
		return list;
	}
	
	
	
}
