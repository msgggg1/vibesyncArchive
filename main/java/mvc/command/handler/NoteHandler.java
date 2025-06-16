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
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        HttpSession session = request.getSession(false);
        UserVO loginUser = (UserVO) session.getAttribute("userInfo");
        int acIdx = loginUser.getAc_idx();

        String action = request.getParameter("action");

        try {
            // --- 2. action 값에 따라 다른 서비스 메소드 호출 ---
        	if ("getMyPostsPreview".equals(action)) {
        	    List<NoteSummaryDTO> posts = noteService.getMyPostsPreview(acIdx);
        	    out.print(gson.toJson(posts));
        	} else if ("getAllMyPosts".equals(action)) {
                List<NoteSummaryDTO> posts = noteService.getAllMyPosts(acIdx);
                out.print(gson.toJson(posts));

            } else if ("getLikedPostsPreview".equals(action)) {
                List<NoteSummaryDTO> posts = noteService.getLikedPostsPreview(acIdx);
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

        return null; 
    }
}