package main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mvc.domain.NoteVO;
import mvc.domain.UserVO;
import mvc.persistence.NoteDAO;
import mvc.persistence.NoteDAOImpl;
import mvc.persistence.UserDAO;
import mvc.persistence.UserDAOImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/mainPageWithDao") // URL 매핑 변경 또는 기존것 사용
public class MainPageData extends HttpServlet {

    private NoteDAO noteDao;
    private UserDAO userDao;

    @Override
    public void init() throws ServletException {
        // 서블릿 초기화 시 DAO 인스턴스 생성 (또는 의존성 주입 사용)
        super.init();
        noteDao = new NoteDAOImpl();
        userDao = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer loggedInUserAcIdx = null;

        if (session != null && session.getAttribute("loggedInUserAcIdx") != null) {
            loggedInUserAcIdx = (Integer) session.getAttribute("loggedInUserAcIdx");
        } else {
            System.err.println("User not logged in or session expired for DAO example.");
            // 비로그인 시 처리 (예: 기본 데이터 로드 또는 로그인 페이지로 리디렉션)
        }

        List<NoteVO> recentPostsList = new ArrayList<>();
        List<NoteVO> popularPostsList = new ArrayList<>();
        List<UserVO> popularUsersList = new ArrayList<>();
        int preferredCategoryIdx = -1;

        try {
            if (loggedInUserAcIdx != null) {
                preferredCategoryIdx = userDao.findPreferredCategoryIdxByAcIdx(loggedInUserAcIdx);
            }

            if (preferredCategoryIdx != -1) {
                recentPostsList = noteDao.findRecentByPreferredCategory(preferredCategoryIdx, 5);
                popularPostsList = noteDao.findPopularByPreferredCategory(preferredCategoryIdx, 5);
            } else {
                // 선호 카테고리가 없는 사용자 또는 비로그인 사용자를 위한 처리
                // 예: 기본 카테고리 ID로 조회하거나, 목록을 비워둠
                System.out.println("선호 카테고리 없음 또는 비로그인. 관련 목록은 비어있을 수 있습니다.");
            }

            // 인기 유저는 선호 카테고리와 무관하게 조회
            popularUsersList = userDao.findPopularUsers(5);

        } catch (SQLException e) {
            System.err.println("DAO 작업 중 데이터베이스 오류 발생: " + e.getMessage());
            // 사용자에게 오류 페이지를 보여주거나, 더 상세한 로깅 필요
            throw new ServletException("데이터베이스 오류", e);
        }

        request.setAttribute("recentPostsList", recentPostsList);
        request.setAttribute("popularPostsList", popularPostsList);
        request.setAttribute("popularUsersList", popularUsersList);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/main.jsp"); // 실제 JSP 파일 경로
        dispatcher.forward(request, response);
    }
}
