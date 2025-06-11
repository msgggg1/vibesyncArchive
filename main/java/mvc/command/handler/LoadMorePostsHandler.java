package mvc.command.handler;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

import mvc.command.service.UserPageService; // 또는 NoteService 사용
import mvc.domain.dto.NoteSummaryDTO;

public class LoadMorePostsHandler implements CommandHandler {
    private UserPageService userPageService; // 또는 NoteService

    public LoadMorePostsHandler() {
        this.userPageService = new UserPageService();
    }

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        try {
            int profileUserAcIdx = Integer.parseInt(request.getParameter("userId"));
            int pageNumber = Integer.parseInt(request.getParameter("page"));

            List<NoteSummaryDTO> morePosts = userPageService.getMorePosts(profileUserAcIdx, pageNumber);
            
            // 더 로드할 게시물이 있는지 판단 (간단한 예시)
            // UserPageService에서 전체 게시물 수를 알아야 정확한 판단 가능
            // 여기서는 PAGE_SIZE(예:9)만큼 가져왔다면 더 있다고 가정. 실제로는 전체 카운트 비교 필요.
            boolean hasMore = (morePosts != null && morePosts.size() == 9); // 9는 UserPageService의 PAGE_SIZE와 일치해야 함

            Map<String, Object> result = new HashMap<>();
            result.put("posts", morePosts);
            result.put("hasMore", hasMore);
            result.put("nextPage", pageNumber + 1);

            out.print(gson.toJson(result));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("error", e.getMessage())));
            e.printStackTrace();
        } finally {
            if (out != null) out.flush();
        }
        return null; // JSON 직접 응답
    }
}