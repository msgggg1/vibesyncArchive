package com.listener;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import mvc.command.service.CategoryService;
import mvc.domain.vo.CategoryVO;

/**
 * 웹 애플리케이션의 시작과 종료 이벤트를 감지하는 리스너입니다.
 * 서버 시작 시, 모든 사용자가 공유할 카테고리 목록을 DB에서 불러와
 * Application Scope에 저장하는 역할을 합니다.
 */
@WebListener // 이 클래스가 리스너임을 서블릿 컨테이너에게 알리는 어노테이션
public class CategoryLoaderListener implements ServletContextListener {

    /**
     * 서버가 종료되거나 웹 애플리케이션이 언로드될 때 호출됩니다.
     * 보통 자원 해제 코드를 작성합니다.
     */
    public void contextDestroyed(ServletContextEvent sce)  { 
         System.out.println("[CategoryLoaderListener] contextDestroyed() - 애플리케이션 종료.");
         // 여기서는 특별히 해제할 자원이 없으므로 비워둡니다.
    }

    /**
     * 서버가 시작되어 웹 애플리케이션이 메모리에 로드될 때 단 한 번 호출됩니다.
     * 애플리케이션 초기화 작업을 하기에 가장 좋은 장소입니다.
     */
    public void contextInitialized(ServletContextEvent sce)  { 
    	System.out.println("[CategoryLoaderListener] contextInitialized() - 애플리케이션 시작, 카테고리 로드를 시작합니다.");
    	
    	try {
    		// 1. 카테고리 목록을 가져오기 위한 서비스 객체 생성
			CategoryService categoryService = new CategoryService();
			List<CategoryVO> categoryVOList = categoryService.allCategories();
			
			// 2. Application Scope 객체를 얻어옴
			//    ServletContext가 바로 Application Scope의 실체입니다.
			ServletContext application = sce.getServletContext();
			
			// 3. 가져온 카테고리 목록을 Application Scope에 저장
			application.setAttribute("categoryVOList", categoryVOList);
			
			System.out.println("[CategoryLoaderListener] 카테고리 " + categoryVOList.size() + "개를 Application Scope에 성공적으로 로드했습니다.");
			
		} catch (Exception e) {
			System.out.println("[CategoryLoaderListener] 카테고리 로드 중 심각한 오류 발생!");
			e.printStackTrace();
		}
    }
}