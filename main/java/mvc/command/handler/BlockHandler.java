package mvc.command.handler;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.util.BlockAction;

import mvc.command.service.NoteService;
import mvc.command.service.WatchPartyService;
import mvc.domain.vo.UserVO;

public class BlockHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("BlockHandler.process()...");
		
		response.setContentType("application/json; charset=UTF-8");
	    PrintWriter out = response.getWriter();
	    Gson gson = new Gson();

	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("userInfo") == null) {
	        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        out.print(gson.toJson(Map.of("success", false, "message", "로그인 필요")));
	        return null;
	    }
	    UserVO userInfo = (UserVO) session.getAttribute("userInfo");
	    int ac_idx = userInfo.getAc_idx();

	    String method = request.getMethod();
        String actionParam = request.getParameter("action").trim();
        
		BlockAction action = null;
        try {
        	action = BlockAction.valueOf(actionParam.trim());
        } catch (IllegalArgumentException e) {
        	response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
        	return null;
        }

	    if ("POST".equalsIgnoreCase(method)) {
	        // POST 요청
	        return null;
	        
	    } else if ("GET".equalsIgnoreCase(method)) {
	        // GET 요청 : 블록 추가
	    	
	    	Object result;
	    	
	        switch (action) {

	            case CategoryPosts:
	            	NoteService postServiceForBlock = new NoteService();
	                int category_idx = Integer.parseInt(request.getParameter("category_idx"));
	                String sortType = request.getParameter("sortType");
	                result = postServiceForBlock.getPostsByCategory(category_idx, sortType);
	                break;
	            
	            case WatchParties:
	            	System.out.println("===== 1. BlockHandler 진입 =====");
	                System.out.println("현재 로그인한 사용자 ID(ac_idx): " + ac_idx); // 로그인 ID 확인

	                WatchPartyService watchPartyService = new WatchPartyService();
	                result = watchPartyService.getFollowingWatchPartyList(ac_idx);

	                System.out.println("서비스 실행 후 받은 결과: " + new Gson().toJson(result)); // 서비스 결과 확인
	                System.out.println("================================");
	                break;
	
	            case UserStats:
	            	NoteService postServiceForStats = new NoteService();
	                result = postServiceForStats.getUserNoteStats(ac_idx);
	                break;
	
	            default:
	                // 잘못된 action 값에 대한 처리
	                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
	                return null;
	                
	        }
	        
	        out.print(gson.toJson(result));
	        return null;
	        
	    }
	    
	    response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
	    out.print(gson.toJson(Map.of("success", false, "message", "허용되지 않은 요청")));
	    return null;
	}

}
