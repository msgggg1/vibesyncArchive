package mvc.command.handler;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mvc.command.service.UserPageService;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.dto.UserPageDataDTO;
import mvc.domain.vo.UserVO;

public class UserPageHandler implements CommandHandler {
    private UserPageService userPageService;
    
    public UserPageHandler() {
        this.userPageService = new UserPageService(); // 생성자에서 초기화
    }

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 요청 파라미터에서 프로필 사용자 ID 가져오기 (예: user.do?acIdx=123)
        String profileUserAcIdxParam = request.getParameter("acIdx");
        if (profileUserAcIdxParam == null || profileUserAcIdxParam.isEmpty()) {
            // ID가 없으면 에러 처리 또는 기본 페이지로 리디렉션
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "사용자 ID가 필요합니다.");
            return null;
        }
        int profileUserAcIdx = Integer.parseInt(profileUserAcIdxParam);

        // 2. 세션에서 현재 로그인한 사용자 ID 가져오기
        HttpSession session = request.getSession(false);
        UserVO userInfo = (UserVO) session.getAttribute("userInfo");
        int loggedInUserAcIdx = userInfo.getAc_idx();
        
        // 3. 초기 페이지 번호 (무한 스크롤용)
        int pageNumber = 1; // 항상 첫 페이지 로드

        // 4. 서비스 호출하여 사용자 페이지 데이터 가져오기
        UserPageDataDTO userPageData = userPageService.getUserPageData(profileUserAcIdx, loggedInUserAcIdx, pageNumber);

        List<NoteSummaryDTO> temp = userPageData.getPosts();
        for (NoteSummaryDTO note : temp) {
            System.out.println("note img : " + note.getThumbnail_img()); // This will call note.toString()
        }
        
        System.out.println("getPosts : " + userPageData.getPosts());
        if (userPageData == null || userPageData.getUserProfile() == null) {
            // 해당 사용자가 없거나 데이터를 가져올 수 없는 경우
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "사용자 정보를 찾을 수 없습니다.");
            return null;
        }

        // 5. request에 데이터 저장
        request.setAttribute("userPageData", userPageData);

        // 6. 뷰 경로 반환
        return "userPage.jsp"; // 실제 JSP 경로로 수정
    }
}