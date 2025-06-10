package mvc.command.handler;

import java.io.PrintWriter;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import mvc.command.service.NoteService;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.vo.UserVO;

public class NoteHandler implements CommandHandler {

    private NoteService noteService = new NoteService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	System.out.println("> NoteHandler.process()");
        
        // --- 1. 공통 로직: JSON 응답 설정 및 로그인 사용자 정보 확인 ---
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userInfo") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }
        UserVO loginUser = (UserVO) session.getAttribute("userInfo");
        int acIdx = loginUser.getAc_idx();

        String action = request.getParameter("action");

        try {
            // --- 2. action 값에 따라 다른 서비스 메소드 호출 ---
        	if ("getMyPostsPreview".equals(action)) {
        	    System.out.println("---- [HANDLER] getMyPostsPreview 실행 ----");
        	    int limit = Integer.parseInt(request.getParameter("limit"));
        	    List<NoteSummaryDTO> posts = noteService.getMyPostsPreview(acIdx, limit);
        	    // ★★★ 핸들러가 JSON으로 응답하기 직전의 목록 크기를 출력합니다. ★★★
        	    System.out.println("[HANDLER] Service로부터 받은 목록 크기: " + posts.size());
        	    out.print(gson.toJson(posts));
        	} else if ("getAllMyPosts".equals(action)) {
                List<NoteSummaryDTO> posts = noteService.getAllMyPosts(acIdx);
                out.print(gson.toJson(posts));

            } else if ("getLikedPostsPreview".equals(action)) {
            	int limit = Integer.parseInt(request.getParameter("limit"));
                List<NoteSummaryDTO> posts = noteService.getLikedPostsPreview(acIdx, limit);
                out.print(gson.toJson(posts));

            } else if ("getAllLikedPosts".equals(action)) {
                List<NoteSummaryDTO> posts = noteService.getAllLikedPosts(acIdx);
                out.print(gson.toJson(posts));

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "알 수 없는 action입니다.");
            }
            

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "요청 처리 중 오류 발생");
        } finally {
            if (out != null) out.flush();
        }

        return null; // AJAX 요청이므로 null 반환
    }
}