package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

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
		response.setContentType("text/html; charset=UTF-8");
		
		// AJAX 처리: action 파라미터 확인
		String action = request.getParameter("action");
		if ("toggleFollow".equals(action)) {
			System.out.println(">>> postViewHandler.process(): toggleFollow 호출됨");
			handleToggleFollow(request, response);
			return null; // AJAX 응답을 이미 보냈으므로 forward 하지 않음
		} else if ("toggleLike".equals(action)) {
			System.out.println(">>> postViewHandler.process(): toggleLike 호출됨");
			handleToggleLike(request, response);
			return null; // AJAX 응답을 이미 보냈으므로 forward 하지 않음
		}

		// 일반적인 페이지 요청: postView.jsp 렌더링
		System.out.println("> postViewHandler.process() - 일반 페이지 요청");

		String note_idx_str = request.getParameter("nidx");
		int note_idx = 0;
		
		if (note_idx_str != null && !note_idx_str.isEmpty()) {
			note_idx = Integer.parseInt(note_idx_str);
		}
		System.out.println("noteidx : " + note_idx_str);
		
		UserNoteVO note = postviews.getUserNoteInfo(note_idx);
		System.out.println(">>> PostView 데이터: " + note);
		
        HttpSession session = request.getSession(false);
        UserVO user = null;
        if (session != null && session.getAttribute("userInfo") != null) {
        	user = (UserVO) session.getAttribute("userInfo");
        } else {
        	System.out.println(">>> 경고: 세션에 userInfo가 없습니다.");
        	response.sendRedirect(request.getContextPath() + "/vibesync/user.do"); // 로그인 페이지로 리디렉션
        }
		
		UserNoteDTO followLike = postviews.getFollowLike(user.getAc_idx(), note_idx, note.getUpac_idx());
		System.out.println(">>> followLike DTO: " + followLike);
		
		request.setAttribute("note", note);
		request.setAttribute("followLike", followLike);
		
		// forward할 때는 쿼리 스트링 없이 JSP 경로만 넘긴다
		return "postView.jsp";
	}

	private void handleToggleFollow(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json; charset=UTF-8");
		PrintWriter out = response.getWriter();
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection(); // *******************수정정
			FollowDAO dao = new FollowDAOImpl(conn);

			int userIdx = Integer.parseInt(request.getParameter("userIdx"));
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
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			LikeDAO dao = new LikeDAOImpl(conn);

			int userIdx = Integer.parseInt(request.getParameter("userIdx"));
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
