package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException; // SQLException import 추가
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import mvc.command.service.LikeService;
import mvc.domain.vo.UserVO;

public class LikeHandler implements CommandHandler {

    private LikeService likeService;

    public LikeHandler() {
        this.likeService = new LikeService();
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

            HttpSession session = request.getSession(false); // 기존 세션 가져오기, 없으면 null
            Integer userAcIdxFromSession = null; // Integer로 선언하여 null 가능성 처리

            if (session != null) {
                Object attr = session.getAttribute("userInfo"); // "userInfo" 키로 조회
                UserVO userInfo = null;
                if (attr != null) {
                	userInfo = (UserVO) session.getAttribute("userInfo");
                }
                
                if (userInfo != null) {
                    userAcIdxFromSession = (Integer) userInfo.getAc_idx();
                }
            }

            if (userAcIdxFromSession == null) { // 세션이 없거나, ac_idx 속성이 없거나, Integer 타입이 아닌 경우
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print(gson.toJson(Map.of("success", false, "message", "로그인이 필요합니다.")));
                return null;
            }
            int acIdx = userAcIdxFromSession.intValue(); // 실제 사용할 ac_idx 값

            String noteIdxParam = request.getParameter("noteId");
            if (noteIdxParam == null || noteIdxParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(Map.of("success", false, "message", "게시글 ID가 필요합니다.")));
                return null;
            }
            int noteIdx = Integer.parseInt(noteIdxParam);

            serviceResult = likeService.toggleLike(acIdx, noteIdx);

            out.print(gson.toJson(serviceResult));

        } catch (NumberFormatException e) {
            if (out == null) out = response.getWriter();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(Map.of("success", false, "message", "유효하지 않은 게시글 ID 형식입니다.")));
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
        return null;
    }
}