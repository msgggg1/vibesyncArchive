package mvc.command.handler;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import mvc.command.service.ScheduleService;
import mvc.domain.dto.CalendarEventDTO;

public class WorkspaceHandler implements CommandHandler{
	

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String action = request.getParameter("action");
		
		// 각 기능에 필요한 서비스들을 멤버 변수로 선언
	    // 앞으로 추가될 서비스들 추가

        // action 파라미터가 존재하고, AJAX 요청을 처리해야 할 경우
        if (action != null) {

            

                // AJAX 요청은 응답을 직접 작성했으므로, 뷰로 포워딩하지 않도록 null을 반환합.
                return null; 
            
            } 
          


        return "/vibesync/workspace.jsp"; // 워크스페이스 JSP 페이지 경로 (예시)
	}

}
