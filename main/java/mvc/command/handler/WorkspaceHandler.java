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
import mvc.domain.dto.BlockDTO;
import mvc.domain.dto.UserPageDataDTO;
import mvc.domain.dto.UserStatsBlockDTO;
import mvc.domain.dto.WorkspaceDTO;
import mvc.domain.vo.UserVO;

public class WorkspaceHandler implements CommandHandler {
	private WorkspaceService workspaceService;
    
    public WorkspaceHandler() {
        this.workspaceService = new WorkspaceService(); // 생성자에서 초기화
    }

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
       
        // 현재 링크 위치 : 이후 페이지 리디렉션에 활용
        String contextPath = request.getContextPath();
        
        HttpSession session = request.getSession(false);
        UserVO userInfo = (UserVO) session.getAttribute("userInfo");
        int ac_idx = userInfo.getAc_idx();
        
    	WorkspaceDTO initialData = workspaceService.getInitialData(ac_idx);
    	
    	Gson gson = new Gson();
    	for (BlockDTO block : initialData.getBlocks()) {
    	    if (block instanceof UserStatsBlockDTO) {
    	        String json = gson.toJson(((UserStatsBlockDTO) block).getChartData());
    	        ((UserStatsBlockDTO) block).setChartDataJson(json);
    	    }
    	}
    	
        request.setAttribute("workspaceData", initialData);
        request.setAttribute("initialData", initialData);
        return "workspace.jsp";
    }
}
