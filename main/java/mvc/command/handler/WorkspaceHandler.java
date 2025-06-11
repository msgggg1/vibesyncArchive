package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.util.BlockAction;

import mvc.command.service.MessageService;
import mvc.command.service.NoteService;
import mvc.command.service.PostViewService;
import mvc.command.service.UserPageService;
import mvc.command.service.WatchPartyService;
import mvc.command.service.WorkspaceService;
import mvc.domain.dto.UserPageDataDTO;
import mvc.domain.dto.WorkspaceDTO;
import mvc.domain.vo.UserVO;

public class WorkspaceHandler implements CommandHandler {
	private WorkspaceService workspaceService;
    
    public WorkspaceHandler() {
        this.workspaceService = new WorkspaceService(); // 생성자에서 초기화
    }

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        
        // 현재 링크 위치 : 이후 페이지 리디렉션에 활용
        String contextPath = request.getContextPath();
        
        UserVO userInfo = null; // 로그인된 사용자 정보
        int ac_idx = 0; // 로그인된 사용자 idx
    	
        if(session.getAttribute("userInfo") != null) {
        	userInfo = (UserVO) session.getAttribute("userInfo");
        	ac_idx = userInfo.getAc_idx();
        } else { // 로그인 안되어 있으면 로그인 페이지로
        	response.sendRedirect(contextPath + "/vibesync/user.do"); // 로그인 페이지로 리디렉션
        	return null;
        }
        
    	WorkspaceDTO initialData = workspaceService.getInitialData(ac_idx);
        request.setAttribute("initialData", initialData);
        return "workspace.jsp";
    }
}
