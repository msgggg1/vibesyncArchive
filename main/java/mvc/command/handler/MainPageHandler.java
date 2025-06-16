package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mvc.command.service.MainPageService;
import mvc.command.service.SidebarService;
import mvc.domain.dto.MainPageDTO;
import mvc.domain.dto.SidebarDTO;
import mvc.domain.vo.UserVO;

public class MainPageHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		
		System.out.println("> MainPageHandler.process()...");
		
		// 로그인 되어 있지 않고, 게스트 계정으로 메인 페이지 오픈하려는 경우
		// HttpSession session = request.getSession();
		
		HttpSession session = request.getSession(false);
		UserVO userInfo = (UserVO) session.getAttribute("userInfo");
		
        	// 로그인 되어 있지 않고, 게스트 계정으로 메인 페이지 오픈하려는 경우
        	/*
            userInfo = new UserSessionVO().builder()
            							  .email("")
            							  .nickname("GUEST")
            							  .img(null)
            							  .category_idx(1) // 입력 받기?
            							  .build();
        	 */
        	
        	// 사이드바 로딩
        	SidebarService sidebarService = new SidebarService();
        	SidebarDTO sidebarDTO = sidebarService.loadSidebar(userInfo.getAc_idx());
        	System.out.println(sidebarDTO);
        	request.setAttribute("sidebarDTO", sidebarDTO);
        	
        	// 메인 페이지 로딩
        	MainPageService service = new MainPageService();
        	MainPageDTO mainPageDTO = service.loadMainPage(userInfo.getCategory_idx());
        	request.setAttribute("mainPageDTO", mainPageDTO);
        	
        	return "main.jsp";
        }
        
}
