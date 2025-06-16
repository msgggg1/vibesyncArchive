package mvc.command.handler;

import java.io.IOException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.listener.DuplicateLoginPreventer; 

import mvc.command.service.LoginService;
import mvc.command.service.SignUpService;
import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.vo.UserVO;

public class UserHandler implements CommandHandler {

    private final LoginService loginService = new LoginService();
    private final SignUpService signUpService = new SignUpService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 공통 캐시 제어 헤더 설정
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String method = request.getMethod();
        if ("GET".equalsIgnoreCase(method)) {
            return handleGet(request, response);
        } else if ("POST".equalsIgnoreCase(method)) {
            return handlePost(request, response);
        }
        
        // GET/POST가 아닌 다른 요청은 허용하지 않음
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return null;
    }

    /**
     * GET 요청을 처리하는 메소드
     */
    private String handleGet(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();

        // 이미 로그인된 사용자가 user.do에 접근 시 메인으로 리다이렉트
        if (session.getAttribute("userInfo") != null) {
            response.sendRedirect(request.getContextPath() + "/vibesync/main.do");
            return null;
        }

        // JavaScript를 통해 직접 로그인 페이지로 이동된 경우, 이전 페이지 주소 저장
        if (session.getAttribute("referer") == null) {
            String httpReferer = request.getHeader("Referer");
            if (httpReferer != null && !httpReferer.contains("/user.do")) {
                session.setAttribute("referer", httpReferer);
            }
        }
        
        // 자동 로그인 쿠키 확인
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("autoLoginUserEmail".equals(c.getName())) {
                    UserVO userInfo = loginService.autoLogin(c.getValue());
                    if (userInfo != null) {
                        // 자동 로그인 성공 시, 공통 로그인 처리 메소드 호출
                        return processSuccessfulLogin(request, response, userInfo);
                    }
                } else if ("rememberedEmail".equals(c.getName())) {
                	request.setAttribute("rememberedEmail", c.getValue());
                }
            }
        }

        // 모든 조건에 해당하지 않으면 로그인 페이지 표시
        return "login.jsp";
    }

    /**
     * POST 요청을 처리하는 메소드
     */
    private String handlePost(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String accessType = request.getParameter("accessType");
        if (accessType == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "AccessType is required.");
            return null;
        }

        switch (accessType) {
            case "login":
                return processManualLogin(request, response);
            case "signUp":
                return processSignUp(request, response);
            case "logout":
                return processLogout(request, response);
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid AccessType.");
                return null;
        }
    }

    /**
     * 수동 로그인을 처리하는 메소드
     */
    private String processManualLogin(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String emailParam = request.getParameter("userId");
        String pwParam = request.getParameter("userPw");
        LoginDTO loginDTO = new LoginDTO(emailParam, pwParam);
        UserVO userInfo = loginService.login(loginDTO);

        if (userInfo != null) {
            // 로그인 성공 시, 공통 로그인 처리 메소드 호출
            return processSuccessfulLogin(request, response, userInfo);
        } else {
            // 로그인 실패
            request.setAttribute("loginErrorForDisplay", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "login.jsp";
        }
    }
    
    /**
     * ★★★ 로그인 성공 시 모든 공통 작업을 처리하는 핵심 메소드 ★★★
     */
    private String processSuccessfulLogin(HttpServletRequest request, HttpServletResponse response, UserVO userInfo) throws IOException {
        HttpSession session = request.getSession();
        String userEmail = userInfo.getEmail();

        // 1. 중복 로그인 방지 로직
        if (DuplicateLoginPreventer.loginUsers.containsKey(userEmail)) {
            HttpSession oldSession = DuplicateLoginPreventer.loginUsers.get(userEmail);
            if (oldSession != null && !oldSession.getId().equals(session.getId())) {
                System.out.println("[UserHandler] 중복 로그인 감지! 기존 세션 강제 종료: " + userEmail);
                oldSession.invalidate(); // 기존 세션을 무효화 -> Listener가 맵에서 자동으로 제거
            }
        }
        // 현재 로그인한 사용자 정보를 전역 목록에 추가
        DuplicateLoginPreventer.loginUsers.put(userEmail, session);

        // 2. '이메일 기억하기', '자동 로그인' 쿠키 처리
        handleLoginCookies(request, response, userEmail);

        // 3. 사용자 정보를 세션에 저장
        session.setAttribute("userInfo", userInfo);
        
        Cookie userIdxCookie = new Cookie("login_user_idx", userInfo.getAc_idx() + "");
	                    userIdxCookie.setMaxAge(60 * 60 * 24 * 7);
	                    userIdxCookie.setPath("/");
	                    response.addCookie(userIdxCookie);

        // 4. 이전 페이지 또는 메인 페이지로 리다이렉트
        redirectToPreviousOrMainPage(session, request, response);

        return null;
    }

    /**
     * 로그인 관련 쿠키를 처리하는 헬퍼 메소드
     */
    private void handleLoginCookies(HttpServletRequest request, HttpServletResponse response, String userEmail) {
        // '이메일 기억하기' 처리
        String rememEmail = request.getParameter("RememEmail");
        Cookie emailCookie = new Cookie("rememberedEmail", "on".equals(rememEmail) ? userEmail : "");
        emailCookie.setPath("/");
        emailCookie.setMaxAge("on".equals(rememEmail) ? 60 * 60 * 24 * 30 : 0);
        response.addCookie(emailCookie);

        // '자동 로그인' 처리
        String autoLogin = request.getParameter("autoLogin");
        if ("on".equals(autoLogin)) {
            Cookie autoLoginCookie = new Cookie("autoLoginUserEmail", userEmail);
            autoLoginCookie.setPath("/");
            autoLoginCookie.setMaxAge(60 * 60 * 24 * 30);
            autoLoginCookie.setHttpOnly(true); // JavaScript 접근 방지
            // autoLoginCookie.setSecure(true); // HTTPS 환경에서만 사용
            response.addCookie(autoLoginCookie);
        }
    }

    /**
     * 로그아웃을 처리하는 메소드
     */
    private String processLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false); // 현재 세션을 가져오되 없으면 새로 만들지 않음
        
        boolean wasAutoLoginActive = false; // 자동 로그인이 활성화되어 있었는지 여부를 판단하는 플래그
        Cookie rememberEmailCookieInstance = null; // rememberEmail 쿠키 객체를 저장할 변수

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("autoLoginUserEmail".equals(cookie.getName())) { // 자동 로그인용 쿠키
                    wasAutoLoginActive = true; // 자동 로그인이 활성화 되어 있었음을 표시
                    
                    cookie.setValue("");
                    cookie.setMaxAge(0);
                    cookie.setPath("/"); 
                    response.addCookie(cookie); // 자동 로그인 쿠키 삭제
                    
                } else if ("rememberedEmail".equals(cookie.getName())) {
                    // rememberEmail 쿠키를 바로 삭제하지 않고, 인스턴스만 저장
                    rememberEmailCookieInstance = cookie;
                } else if ("login_user_idx".equals(cookie.getName())) {
                	cookie.setValue("");
                    cookie.setMaxAge(0);
                    cookie.setPath("/"); 
                    response.addCookie(cookie);
				}
            }
        }

        // 자동 로그인이 활성화되어 있었고, 이메일 기억하기 쿠키도 존재했다면 함께 삭제
        if (wasAutoLoginActive && rememberEmailCookieInstance != null) {
            rememberEmailCookieInstance.setValue("");
            rememberEmailCookieInstance.setMaxAge(0);
            rememberEmailCookieInstance.setPath("/"); 
            response.addCookie(rememberEmailCookieInstance); // 이메일 기억하기 쿠키 삭제
        }

        // 세션 초기화
        session.invalidate();

        // 로그아웃 후 login.jsp로 리디렉션
        response.sendRedirect(request.getContextPath() + "/vibesync/user.do");
        return null;
    }

    /**
     * 회원가입을 처리하는 메소드
     */
    private String processSignUp(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String name = request.getParameter("signupName");
        String nickname = request.getParameter("signupNickname");
        String email = request.getParameter("signupEmail");
        String pw = request.getParameter("signupPw");
        
        SignUpDTO signUpDTO = new SignUpDTO().builder()
                .name(name).nickname(nickname).email(email).password(pw)
                .confirmPassword(request.getParameter("confirmPw"))
                .category_idx(Integer.parseInt(request.getParameter("category")))
                .build();
        try {
            signUpService.register(signUpDTO);
            request.setAttribute("signupSuccessForDisplay", "회원가입이 성공적으로 완료되었습니다.");
        } catch (Exception e) {
            request.setAttribute("prevSignupName", name);
            request.setAttribute("prevSignupNickname", nickname);
            request.setAttribute("prevSignupEmail", email);
            request.setAttribute("formToShow", "signUp");
            request.setAttribute("signupErrorForDisplay", e.getMessage());
        }
        return "login.jsp";
    }
    
    /**
     * 이전 페이지 또는 메인 페이지로 리다이렉트하는 헬퍼 메소드
     */
    private void redirectToPreviousOrMainPage(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String referer = (String) session.getAttribute("referer");
        if (referer != null && !referer.isEmpty()) {
            session.removeAttribute("referer");
            response.sendRedirect(referer);
        } else {
            String mainPage = request.getContextPath() + "/vibesync/main.do";
            response.sendRedirect(mainPage);
        }
    }
}
