package mvc.command.handler;

import java.io.PrintWriter;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import mvc.command.service.CommentService;
import mvc.domain.vo.CommentVO;
import mvc.domain.vo.UserVO;

public class CommentHandler implements CommandHandler {

    private CommentService commentService = new CommentService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json; charset=UTF-8");

        String action = request.getParameter("action");
        
        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
        PrintWriter out = response.getWriter();

        try {
            if ("list".equals(action)) {
            	// 'list' 기능은 로그인 정보가 필요 없으므로 바로 실행합니다.
                int noteIdx = Integer.parseInt(request.getParameter("noteIdx"));
                List<CommentVO> comments = commentService.getComments(noteIdx);
                
                // [로그 추가] DB에서 가져온 댓글 목록의 depth 값을 서버 콘솔에서 확인
                System.out.println("--- [CommentHandler] 'list' action 결과 ---");
                if (comments != null && !comments.isEmpty()) {
                    System.out.println("조회된 댓글 수: " + comments.size());
                    for (CommentVO comment : comments) {
                        // Lombok의 @ToString이 모든 필드를 출력하므로 depth 값도 함께 보입니다.
                        System.out.println(comment.toString());
                    }
                } else {
                    System.out.println("조회된 댓글이 없습니다.");
                }
                System.out.println("------------------------------------------");

                out.print(gson.toJson(comments));

            } else if ("add".equals(action)) {
            	HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("userInfo") == null) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.print("{\"error\":\"login_required\"}");
                    return null; // 여기서 실행 종료
                }
                UserVO user = (UserVO) session.getAttribute("userInfo");
                
                int noteIdx = Integer.parseInt(request.getParameter("noteIdx"));
                String text = request.getParameter("text");
                String reCommentIdxParam = request.getParameter("reCommentIdx");
                
                int depth = 1;

                CommentVO newComment = CommentVO.builder()
                        .note_idx(noteIdx)
                        .text(text)
                        .ac_idx(user.getAc_idx())
                        .build();

                if (reCommentIdxParam != null && !reCommentIdxParam.isEmpty()) {
                    int parentId = Integer.parseInt(reCommentIdxParam);
                    CommentVO parentComment = commentService.getComment(parentId);
                    if (parentComment != null) {
                        depth = parentComment.getDepth() + 1;
                    }
                    newComment.setRe_commentlist_idx(parentId);
                }

                newComment.setDepth(depth);
                commentService.addComment(newComment);
                
                out.print("{\"status\":\"success\"}");

            } else if ("update".equals(action)) {
            	HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("userInfo") == null) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.print("{\"error\":\"login_required\"}");
                    return null; // 여기서 실행 종료
                }
                UserVO user = (UserVO) session.getAttribute("userInfo");
                
                int commentIdx = Integer.parseInt(request.getParameter("commentIdx"));
                String text = request.getParameter("text");
                commentService.updateComment(commentIdx, text);
                out.print("{\"status\":\"success\"}");

            } else if ("delete".equals(action)) {
            	HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("userInfo") == null) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.print("{\"error\":\"login_required\"}");
                    return null; // 여기서 실행 종료
                }
                UserVO user = (UserVO) session.getAttribute("userInfo");
                
                int commentIdx = Integer.parseInt(request.getParameter("commentIdx"));
                commentService.deleteComment(commentIdx);
                out.print("{\"status\":\"success\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
            e.printStackTrace();
        } finally {
            out.flush();
        }
        
        return null;
    }
}