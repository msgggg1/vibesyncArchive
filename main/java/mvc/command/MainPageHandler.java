package mvc.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mvc.domain.NoteVO; 
import mvc.domain.UserVO; 
import mvc.persistence.NoteDAO;
import mvc.persistence.NoteDAOImpl;
import mvc.persistence.UserDAO;
import mvc.persistence.UserDAOImpl; 

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MainPageHandler implements CommandHandler {

    private NoteDAO noteDao;
    private UserDAO userDao; 

    public MainPageHandler() {
        this.noteDao = new NoteDAOImpl();
        this.userDao = new UserDAOImpl();
    }

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);
        Integer loggedInUserAcIdx = null;

        if (session != null && session.getAttribute("loggedInUserAcIdx") != null) {
            loggedInUserAcIdx = (Integer) session.getAttribute("loggedInUserAcIdx");
        } else {
            System.err.println("MainPageHandler: User not logged in or session expired.");
        }

        List<NoteVO> recentPostsList = new ArrayList<>();
        List<NoteVO> popularPostsList = new ArrayList<>();
        List<UserVO> popularUsersList = new ArrayList<>(); 
        int preferredCategoryIdx = -1;

        try {
            if (loggedInUserAcIdx != null) {
                preferredCategoryIdx = userDao.preferredCategoryIdx(loggedInUserAcIdx);
            }

            if (preferredCategoryIdx != -1) {
                recentPostsList = noteDao.recentNoteByMyCategory(preferredCategoryIdx, 5);
                popularPostsList = noteDao.popularNoteByMyCategory(preferredCategoryIdx, 5);
                
            } else {
            	System.out.println("MainPageHandler: 선호 카테고리 없음 또는 비로그인. 전체 게시글 목록을 조회합니다.");
                // 선호 카테고리가 없을 때, 전체 글 중에서 인기글(좋아요+조회수, 최신순)을 가져옴
                recentPostsList = noteDao.recentAllNotes(5);
                popularPostsList = noteDao.recentAllNotes(5); 
                
            }

            // 인기 유저 목록 조회
            popularUsersList = userDao.findPopularUsers(5);
           

        } catch (SQLException e) {
            System.err.println("MainPageHandler: DAO 작업 중 데이터베이스 오류 발생 - " + e.getMessage());
            e.printStackTrace();
            // 공통 에러 페이지로 포워딩.
            request.setAttribute("errorMessage", "데이터를 불러오는 중 오류가 발생했습니다.");
            return "/WEB-INF/error.jsp"; // 예시 에러 페이지 경로
        }

        // 뷰(JSP)로 전달할 데이터를 request attribute에 저장
        request.setAttribute("recentPostsList", recentPostsList);
        request.setAttribute("popularPostsList", popularPostsList);
        request.setAttribute("popularUsersList", popularUsersList);
        
 
        // 포워딩할 뷰 페이지 경로
        return "/vibesync/main.jsp";  
    }
}