package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Set;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.util.ConnectionProvider;
import mvc.command.service.PostViewService;
import mvc.domain.dto.UserNoteDTO;
import mvc.domain.vo.UserNoteVO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.FollowDAO;
import mvc.persistence.dao.LikeDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;
import mvc.persistence.daoImpl.LikeDAOImpl;

public class postViewHandler implements CommandHandler {
	
	private PostViewService postviews = new PostViewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
		String method = request.getMethod(); // 요청 메소드 확인 (GET 또는 POST)

        // POST 요청은 AJAX (팔로우/좋아요) 처리
        if ("POST".equalsIgnoreCase(method)) {
            response.setContentType("application/json; charset=UTF-8");
            String action = request.getParameter("action");

            if ("toggleFollow".equals(action)) {
                System.out.println(">>> postViewHandler.process(): toggleFollow 호출됨");
                handleToggleFollow(request, response);
            } else if ("toggleLike".equals(action)) {
                System.out.println(">>> postViewHandler.process(): toggleLike 호출됨");
                handleToggleLike(request, response);
            } else {
                // 정의되지 않은 action에 대한 오류 처리
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                try (PrintWriter out = response.getWriter()) {
                    out.write("{\"error\":\"Invalid action\"}");
                    out.flush();
                }
            }
            return null; // AJAX 처리 후 forward 방지

        // GET 요청은 페이지 렌더링 처리
        } else if ("GET".equalsIgnoreCase(method)) {
            System.out.println("> postViewHandler.process() - 일반 페이지 요청 (GET)");
            response.setContentType("text/html; charset=UTF-8");

            String note_idx_str = request.getParameter("nidx");
            if (note_idx_str == null || note_idx_str.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Note index is required.");
                return null;
            }
            int note_idx = Integer.parseInt(note_idx_str);
            
         // --- '손님' 상태를 처리하도록 로직 수정 ---
            HttpSession session = request.getSession(false); // 없으면 null 반환
            UserVO loggedInUser = null;
            
            // 1. 기본 게시물 정보는 항상 조회
            UserNoteVO note = postviews.getUserNoteInfo(note_idx);
            request.setAttribute("note", note);

            // 2. 로그인 여부 확인
            if (session != null && session.getAttribute("userInfo") != null) {
            	// 3. 로그인 사용자일 경우에만, 추가 정보(좋아요/팔로우)를 조회하여 request에 저장
                loggedInUser = (UserVO) session.getAttribute("userInfo");
                
                int writerIdx = note.getAc_idx(); // 게시물 작성자의 ID
                UserNoteDTO followLike = postviews.getFollowLike(loggedInUser.getAc_idx(), note_idx, writerIdx);
                request.setAttribute("followLike", followLike);
            }
            // loggedInUser가 null이면 손님, 아니면 로그인 사용자

            // --- 조회수 처리 로직 ---
            HttpSession viewSession = request.getSession();
            @SuppressWarnings("unchecked")
            Set<Integer> accessPage = (Set<Integer>) viewSession.getAttribute("accessPage");
            if (accessPage == null) {
                accessPage = new HashSet<>();
                viewSession.setAttribute("accessPage", accessPage);
            }

            if (!accessPage.contains(note_idx)) {
                postviews.updateViewCount(note_idx);
                accessPage.add(note_idx);
            }

            return "postView.jsp"; // JSP 페이지로 forward
        }

        // GET/POST가 아닌 다른 메소드는 에러 처리
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return null;
    }

	private void handleToggleFollow(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userInfo") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized 에러
            out.write("{\"error\":\"login_required\"}");
            out.flush();
            return;
        }
        UserVO loggedInUser = (UserVO) session.getAttribute("userInfo");
        
        Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			FollowDAO dao = new FollowDAOImpl(conn);

			int userIdx = loggedInUser.getAc_idx();
			int writerIdx = Integer.parseInt(request.getParameter("writerIdx"));
			int noteIdx = Integer.parseInt(request.getParameter("nidx"));

			// 로그로 파라미터 값 확인
			System.out.println(">>> handleToggleFollow - userIdx: " + userIdx + ", writerIdx: " + writerIdx + ", noteIdx: " + noteIdx);

			boolean following = dao.isFollowing(userIdx, writerIdx);
			if (following) {
				dao.removeFollow(userIdx, writerIdx);
				following = false;
			} else {
				dao.addFollow(userIdx, writerIdx);
				following = true;
			}

			out.write("{\"following\":" + following + "}");
			
		} catch (NamingException | java.sql.SQLException e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.write("{\"error\":\"Unable to toggle follow\"}");
			e.printStackTrace();
		} finally {
			if (conn != null) try { conn.close(); } catch (Exception ignored) {}
			out.flush();
			out.close();
		}
	}

	private void handleToggleLike(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userInfo") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized 에러
            out.write("{\"error\":\"login_required\"}");
            out.flush();
            return;
        }
        UserVO loggedInUser = (UserVO) session.getAttribute("userInfo");
		
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			LikeDAO dao = new LikeDAOImpl(conn);

			int userIdx = loggedInUser.getAc_idx();
			int noteIdx = Integer.parseInt(request.getParameter("noteIdx"));

			// 로그로 파라미터 값 확인
			System.out.println(">>> handleToggleLike - userIdx: " + userIdx + ", noteIdx: " + noteIdx);

			boolean liked = dao.isLiked(userIdx, noteIdx);
			if (liked) {
				dao.removeLike(userIdx, noteIdx);
				liked = false;
			} else {
				dao.addLike(userIdx, noteIdx);
				liked = true;
			}

			out.write("{\"liked\":" + liked + "}");
		} catch (NamingException | java.sql.SQLException e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.write("{\"error\":\"Unable to toggle like\"}");
			e.printStackTrace();
		} finally {
			if (conn != null) try { conn.close(); } catch (Exception ignored) {}
			out.flush();
			out.close();
		}
	}
}
