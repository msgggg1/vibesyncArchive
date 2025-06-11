package mvc.command.handler; 

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import mvc.command.service.FollowService;
import mvc.domain.vo.UserVO;

public class FollowHandler implements CommandHandler {

    private FollowService followService;

    public FollowHandler() {
        this.followService = new FollowService();
    }

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = null;
        Gson gson = new Gson();
        Map<String, Object> serviceResult = null;

        try {
            out = response.getWriter();

            HttpSession session = request.getSession(false);
            Integer followerAcIdx = null; // 현재 로그인한 사용자 ID

            if (session != null) {
                Object userObj = session.getAttribute("userInfo"); // login.jsp에서 설정한 세션 속성 이름
                if (userObj != null && userObj instanceof UserVO) { // 타입 확인
                	UserVO loggedInUser = (UserVO) userObj;
                    followerAcIdx = loggedInUser.getAc_idx();
                }
            }

            if (followerAcIdx == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print(gson.toJson(Map.of("success", false, "message", "로그인이 필요합니다.")));
                return null;
            }

            String targetUserIdParam = request.getParameter("authorId"); // AJAX 요청 시 전달될 파라미터 이름
            if (targetUserIdParam == null || targetUserIdParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(Map.of("success", false, "message", "팔로우할 대상의 ID가 필요합니다.")));
                return null;
            }
            int targetUserAcIdx = Integer.parseInt(targetUserIdParam);

            // 자기 자신을 팔로우하는 것 방지 (선택 사항)
            if (followerAcIdx.intValue() == targetUserAcIdx) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(Map.of("success", false, "message", "자기 자신을 팔로우할 수 없습니다.")));
                return null;
            }

            serviceResult = followService.toggleFollow(followerAcIdx, targetUserAcIdx);
            out.print(gson.toJson(serviceResult));

        } catch (NumberFormatException e) {
            if (out == null) out = response.getWriter();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(Map.of("success", false, "message", "유효하지 않은 사용자 ID 형식입니다.")));
            e.printStackTrace();
        } catch (SQLException e) {
            if (out == null) out = response.getWriter();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("success", false, "message", "데이터베이스 처리 중 오류: " + e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) {
            if (out == null) out = response.getWriter();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("success", false, "message", "서버 내부 오류: " + e.getMessage())));
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.flush();
            }
        }
        return null; // JSON 응답을 직접 처리했으므로 null 반환
    }
}