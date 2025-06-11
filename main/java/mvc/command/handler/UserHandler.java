package mvc.command.handler;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mvc.command.service.CategoryService;
import mvc.command.service.LoginService;
import mvc.command.service.SignUpService;
import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.vo.CategoryVO;
import mvc.domain.vo.UserVO;

public class UserHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        System.out.println("> UserHandler.process()...");
        
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // accessType : 사용자가 필요로 하는 것이 로그인 처리인지 회원가입 처리인지 구분하기 위한 변수
        // login.jsp에서 input으로 값을 받아옴. type=hidden 으로 지정되어 있어 화면에는 나타나지 않음
        String accessType = request.getParameter("accessType");
        
        // 현재 링크 위치 : 이후 페이지 리디렉션에 활용
        String contextPath = request.getContextPath();
        // 예) http://localhost/vibeSyncTest/vibesync/user.do
        
        // 요청방식 : GET 또는 POST
        String requestMethod = request.getMethod();
        
        // 기존 쿠키 확인 : 자동로그인 / 이메일 기억하기 기능 적용 목적
        String autoLoginUserEmail = null; // autoLoginUserEmail 쿠키 값 (자동로그인용)
        String rememberedEmail = ""; // rememberEmail 쿠키 값 (이메일 기억하기용 : 폼의 email 부분 기본 value값으로 들어감)
        							 // rememberEmail 쿠키 기본값 빈 문자열 처리 (폼에 email 정보 채워둘 때 오류 방지 목적)
        
        // 로그아웃
        if (requestMethod.equals("POST") && accessType.equals("logout")) {
            return "logout.jsp";
        }
        
        // 쿠키 값 불러오기
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
        	for (Cookie c : cookies) {
        		if ("autoLoginUserEmail".equals(c.getName())) {
        			autoLoginUserEmail = c.getValue();
        			
        		} else if ("rememberedEmail".equals(c.getName())) {
        			rememberedEmail = c.getValue();
        		}
        	}
        }
        
        // login.jsp에서 기억된 이메일을 표시할 수 있도록 attribute에 저장
        request.setAttribute("rememberedEmail", rememberedEmail);
        
        // 로그인된 유저인지 확인하는 session Attribute : userInfo
        // UserSessionVO 객체인 userInfo는 로그인된 사용자의 email, nickname, img, category_idx 정보를 담고 있음
        UserVO userInfo = null;
        
        
        /* 로그인 및 회원가입 기능 */
        
    	// 이후 Listener(서버 시작 시 실행)로 보낼 부분 : application 객체 사용 예정
    	CategoryService categoryService = new CategoryService();
    	List<CategoryVO> categoryVOList = (ArrayList<CategoryVO>) categoryService.allCategories();
    	session.setAttribute("categoryVOList", categoryVOList);
    	
    	// UserHandler에서 로그인 관련 기능들을 담당하는 서비스 클래스 : LoginService
    	LoginService loginService = new LoginService();
    	
    	// UserHandler에서 회원가입 관련 기능들을 담당하는 서비스 클래스 : SignUpService
    	SignUpService signUpService = new SignUpService();
    	
    	// 최초 페이지 로딩 (로그인/회원가입 기능 진입 이전)
    	if (!"POST".equalsIgnoreCase(requestMethod)) { // 요청방식이 POST가 아닌 경우 (GET 방식)
    		if(session.getAttribute("userInfo") != null) { // 로그인 되어 있는 상태
    			// 이미 세션에 로그인 정보가 있고, POST 요청이 아닌 상태
    			response.sendRedirect(contextPath + "/vibesync/main.do"); // main.jsp로 리디렉션
    			// (로그인된 사용자가 login.jsp에 접근하는 것을 막음)
    			
    		} else { // 로그인 되어있지 않은 상태
    			if (autoLoginUserEmail != null && !autoLoginUserEmail.isEmpty()) {
    				// 현재 세션에 로그인 정보가 없고, autoLoginUserEmail 쿠키(자동 로그인용)가 있는 상태
    				// -> 자동 로그인 처리
            		userInfo = loginService.autoLogin(autoLoginUserEmail); // 이메일 정보로 자동로그인
            		session.setAttribute("userInfo", userInfo); // 로그인 처리 + 세션에 로그인된 사용자 정보 저장
            		
            		if (userInfo == null) { // 자동 로그인으로 로그인 실패 시
            			return "logout.jsp";
					} else {
						response.sendRedirect(contextPath + "/vibesync/main.do"); // main.jsp로 리디렉션
						return null;
					}
            		
				} else { // 현재 세션에 로그인 정보가 없고, 자동 로그인용 쿠키도 존재하지 않는 상태
					return "login.jsp"; // login.jsp로 포워딩
				}
    		}
    	
    	// 로그인/회원가입 기능 진입 (요청방식 : POST)
    	} else {
            if (accessType.equals("login")) { // 로그인
            	// 로그인 폼에서 입력받은 값 변수에 담기
            	String emailParam = request.getParameter("userId"); // 이메일
			    String pwParam = request.getParameter("userPw"); // 비밀번호 (평문)
			    
			    // 사용자가 입력한 로그인 정보는 LoginDTO에 담아서 LoginService 객체에 전달
			    LoginDTO loginDTO = new LoginDTO(emailParam, pwParam);
			    userInfo = loginService.login(loginDTO); // 로그인된 사용자의 정보를 userInfo에 저장
            	
                if (userInfo != null) { // 로그인 성공
                    // 이메일 기억하기 기능 처리
                    String RememEmail = request.getParameter("RememEmail"); // 체크박스 값 가져오기
                    if ("on".equals(RememEmail)) { // 체크박스가 선택되었다면 (HTML에서 checkbox가 check되면 "on" 값을 가짐)
                        Cookie emailCookie = new Cookie("rememberedEmail", emailParam); // rememberedEmail 쿠키 생성
                        emailCookie.setMaxAge(60 * 60 * 24 * 30); // 쿠키 유효 기간: 30일 (초 단위)
                        emailCookie.setPath("/"); // 웹 애플리케이션 전체 경로에서 사용 가능하도록 설정
                        response.addCookie(emailCookie); // rememberedEmail 쿠키 저장
                        
                    } else { // 체크박스가 선택되지 않았다면 기존 쿠키 삭제
                        Cookie emailCookie = new Cookie("rememberedEmail", "");
                        emailCookie.setMaxAge(0); // 쿠키 즉시 만료
                        emailCookie.setPath("/");
                        response.addCookie(emailCookie); // rememberedEmail 쿠키 삭제
                    }
                    
                    // 자동 로그인 기능 처리
                    String autoLogin = request.getParameter("autoLogin"); // 체크박스 값 가져오기
                    if ("on".equals(autoLogin)) {
                    	Cookie autoLoginCookie = new Cookie("autoLoginUserEmail", emailParam);
                    	autoLoginCookie.setMaxAge(60 * 60 * 24 * 30); // 쿠키 유효 기간: 30일 (초 단위)
                    	autoLoginCookie.setPath("/"); // 웹 애플리케이션 전체 경로에서 사용 가능하도록 설정
                    	
                    	// 자동 로그인 쿠키 저장 시, 보안 설정 추가
                    	autoLoginCookie.setHttpOnly(true);
                    	autoLoginCookie.setSecure(true); // HTTPS에서만 작동하도록
                    	
                        response.addCookie(autoLoginCookie);
                    }
                    // 자동로그인의 경우 로그아웃 실행 시에만 autoLoginUserEmail 쿠키 삭제가 가능
                	
                    // 로그인 성공에 따른 사용자 정보 저장 및 메인 페이지 리디렉션
                    session.setAttribute("userInfo", userInfo); // 세션에 로그인된 사용자 정보 저장
                    response.sendRedirect(contextPath + "/vibesync/main.do"); // 메인 페이지로 리디렉션
                    
                } else { // 로그인 실패 (userInfo == null)
                	request.setAttribute("loginErrorForDisplay", "로그인 중 오류가 발생했습니다."); // 로그인 에러 메세지
                	return "login.jsp"; // 로그인 페이지로 오류메시지 가지고 포워딩
                }
            
            } else if (accessType.equals("signUp")) { // 회원가입
            	// 회원가입 성공여부
            	boolean isRegistered = false;
            	
            	// 회원가입 폼에서 입력받은 값 변수에 담기
                String name = request.getParameter("signupName"); // 이름
                String nickname = request.getParameter("signupNickname"); // 닉네임
                String email = request.getParameter("signupEmail"); // 이메일
                String pw = request.getParameter("signupPw"); // 비밀번호 (평문)
                String cpw = request.getParameter("confirmPw"); // 비밀번호 재입력 (평문)
                int category_idx = Integer.parseInt(request.getParameter("category")); // 선호 카테고리
                
                // 사용자가 입력한 회원가입 정보는 SignUpDTO에 담아서 SignUpService 객체에 전달
                SignUpDTO signUpDTO = new SignUpDTO().builder()
                									 .name(name)
                									 .nickname(nickname)
                									 .email(email)
                									 .password(pw)
                									 .confirmPassword(cpw)
                									 .category_idx(category_idx)
                									 .build();
                
                try {
                	// 회원가입
                	isRegistered = signUpService.register(signUpDTO);
                	if (isRegistered) {
                		// 회원가입 성공 메세지
                    	request.setAttribute("signupSuccessForDisplay", "회원가입이 성공적으로 완료되었습니다.");
                	}
					
                } catch (Exception e) { // 회원가입 실패
                    // 회원가입 에러 발생 시 이전에 입력한 값 다시 표시되도록 만들기
                    request.setAttribute("prevSignupName", name);
                    request.setAttribute("prevSignupNickname", nickname);
                    request.setAttribute("prevSignupEmail", email);
                	
                    // 회원가입 실패시 다시 회원가입 폼이 열린 페이지로 돌아가기
                	request.setAttribute("formToShow", "signUp");
                	
                	// 회원가입 실패 메시지
                	request.setAttribute("signupErrorForDisplay", e.getMessage());
				}
                
                return "login.jsp"; // 회원가입 성공/실패 여부 관계 없이 로그인 페이지로 포워딩
            }
    	}
		return null;
    	
	}

}
