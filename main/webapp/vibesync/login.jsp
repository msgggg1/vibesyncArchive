<%@page import="com.util.ConnectionProvider"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.util.PasswordMigrator"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%
    //──  기존 쿠키 확인 ──
    String autoLoginUserEmail = null; // userEmail 쿠키에서 읽어온 값 (자동 로그인용)
    String rememberedEmail = null; // rememberEmail 쿠키에서 읽어온 값 (폼 채우기용)
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("userEmail".equals(c.getName())) {
                autoLoginUserEmail = c.getValue();
            } else if ("rememberEmail".equals(c.getName())) {
                rememberedEmail = c.getValue();
            }
        }
    }

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
    // userEmail 쿠키(자동 로그인용)가 있고, 현재 세션에 로그인 정보가 없으면 자동 로그인 처리
    if (autoLoginUserEmail != null && !autoLoginUserEmail.isEmpty() && session.getAttribute("loggedInUserEmail") == null) {
        session.setAttribute("loggedInUserEmail", autoLoginUserEmail); // 세션에 이메일 저장
        String contextPath = request.getContextPath();
    	response.sendRedirect(contextPath + "/vibesync/main.do");
        return;
    }
 	// 2. 이미 세션에 로그인 정보가 있다면 (그리고 POST 요청이 아니라면) main.jsp로 리디렉션
    // (로그인된 사용자가 login.jsp에 접근하는 것을 막음)
    if (session.getAttribute("loggedInUserEmail") != null) {
    	String contextPath = request.getContextPath();
    	response.sendRedirect(contextPath + "/vibesync/main.do");
        return; // 
    }
}
		// rememberedEmailForForm이 null일 경우 빈 문자열로 
		rememberedEmail = (rememberedEmail == null) ? "" : rememberedEmail;


%>
<%  // 에러, 성공 처리, 회원가입 실패 시 상태관리
    // 로그인 에러 메세지 
    String loginErrorForDisplay = null; // 화면 표시에 사용할 에러 메시지 변수
    if (session.getAttribute("sessionLoginError") != null) {
        loginErrorForDisplay = (String) session.getAttribute("sessionLoginError");
        session.removeAttribute("sessionLoginError"); // 세션에서 즉시 삭제 (일회성 표시 위함)
    }
    // 회원가입 에러 메세지
    String signupErrorForDisplay = null;
    if (session.getAttribute("signupErrorMsg") != null) {
        signupErrorForDisplay = (String) session.getAttribute("signupErrorMsg");
        session.removeAttribute("signupErrorMsg");
    }

    // 회원가입 성공 메시지
    String signupSuccessForDisplay = null;
    if (session.getAttribute("signupSuccessMsg") != null) {
        signupSuccessForDisplay = (String) session.getAttribute("signupSuccessMsg");
        session.removeAttribute("signupSuccessMsg");
    }
    
    // 이전 회원가입 시도 시 입력 값 가져오기
    String prevSignupName = (String) session.getAttribute("prevSignupName");
    String prevSignupNickname = (String) session.getAttribute("prevSignupNickname");
    String prevSignupEmail = (String) session.getAttribute("prevSignupEmail");

    //사용 후 세션에서 제거
    if (prevSignupName != null) session.removeAttribute("prevSignupName");
    if (prevSignupNickname != null) session.removeAttribute("prevSignupNickname");
    if (prevSignupEmail != null) session.removeAttribute("prevSignupEmail");

    // null일 경우 빈 문자열로 초기화 (input value에 "null" 문자열 출력 방지)
    prevSignupName = (prevSignupName == null) ? "" : prevSignupName;
    prevSignupNickname = (prevSignupNickname == null) ? "" : prevSignupNickname;
    prevSignupEmail = (prevSignupEmail == null) ? "" : prevSignupEmail;
    
    // rememberedEmailForForm이 null일 경우 빈 문자열로 (폼 value용)
    rememberedEmail = (rememberedEmail == null) ? "" : rememberedEmail;

    // 회원가입 등 오류 났을 때 보여줄 폼(login.js에서 사용)
    String formToShow = request.getParameter("formToShow");

%>

<%  
    if ("POST".equalsIgnoreCase(request.getMethod())) { // 요청 방식이 POST인지 확인
       
    	String emailParam = request.getParameter("userId"); // 폼에서 전달된 이메일
        String pwParam = request.getParameter("userPw"); // 폼에서 전달된 비밀번호 (평문)
        Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
        try{
	 		   conn = ConnectionProvider.getConnection();
	 		   String sql = "SELECT ac_idx, pw, name, salt FROM userAccount WHERE email = ?";
	 		   pstmt = conn.prepareStatement(sql);
	 		   pstmt.setString(1, emailParam);
	 		   rs = pstmt.executeQuery();
	 		   
                if (rs.next()) {
                	int userAcIdx = rs.getInt("ac_idx");
                    String storedHashedPassword = rs.getString("pw");
                    String storedSalt = rs.getString("salt");
                    
                    String hashedInputPassword = PasswordMigrator.hashPassword(pwParam, storedSalt);
    
                    if (hashedInputPassword != null && storedHashedPassword.equals(hashedInputPassword)) {
                    	session.setAttribute("loggedInUserAcIdx", userAcIdx);
                        session.setAttribute("loggedInUserEmail", emailParam); // 세션에 사용자 이메일 저장
                          
                        String autoLoginParam = request.getParameter("autoLogin");
                        String rememEmailParam = request.getParameter("RememEmail");

                        // ─ userEmail 쿠키 설정 (자동 로그인용) ─
                        Cookie autoLoginCookie = new Cookie("userEmail", emailParam);
                        if (autoLoginParam != null && "on".equals(autoLoginParam)) { // "Auto-Login" 체크 시
                            autoLoginCookie.setMaxAge(7 * 24 * 60 * 60); // 7일
                        } else { // "Auto-Login" 체크 해제 시 쿠키 삭제
                            autoLoginCookie.setMaxAge(0); 
                            autoLoginCookie.setValue(""); // 값도 비워주는 것이 좋음
                        }
                        autoLoginCookie.setPath("/");
                        response.addCookie(autoLoginCookie);

                        // ─ rememberEmail 쿠키 설정 (이메일 기억용) ─
                        if (rememEmailParam != null && "on".equals(rememEmailParam)) { // "Remember Email" 체크 시
                            Cookie remCookie = new Cookie("rememberEmail", emailParam);
                            remCookie.setMaxAge(30 * 24 * 60 * 60); // 30일
                            remCookie.setPath("/");
                            response.addCookie(remCookie);
                        } else { // "Remember Email" 체크 해제 시 쿠키 삭제
                            Cookie remCookie = new Cookie("rememberEmail", "");
                            remCookie.setMaxAge(0);
                            remCookie.setPath("/");
                            response.addCookie(remCookie);
                        }
                        
                        String contextPath = request.getContextPath();
                    	response.sendRedirect(contextPath + "/vibesync/main.do");
                        return; 
                        
                    } else { // 이메일은 존재하지만 비밀번호가 틀린 경우
                        session.setAttribute("sessionLoginError", "비밀번호가 일치하지 않습니다.");
                        response.sendRedirect("login.jsp");
                        return;
                    }
                } else { // 이메일이 DB에 존재하지 않는 경우
                    session.setAttribute("sessionLoginError", "존재하지 않는 이메일 입니다.");
                    response.sendRedirect("login.jsp");
                    return;
                }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("sessionLoginError", "로그인 중 오류가 발생했습니다.");
            response.sendRedirect("login.jsp");
            return;
        }finally{
 		   try{
 				 rs.close();
 				 pstmt.close();  
 			     conn.close(); 
 			   }catch(Exception e){
 				   e.printStackTrace();
 			   }
 		   } // try 
 		 
 		}
%>

<!DOCTYPE html>
<html lang="en"> <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=National+Park:wght@200..800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cal+Sans&display=swap" rel="stylesheet">
    <link rel="icon" href="../favicon.ico">
    <title>VibeSync Login</title> <link rel="stylesheet" href="./css/login.css"> </head>    

<body ondragstart="return false" ondrop="return false" onselectstart="return false"><canvas id="starfield"></canvas>

<div class="container">
    <div id="logo">
        <img src="./assets/logo1.png" alt="VibeSync 로고" width="30%"> </div>

    <div id="login">
        <div id="inner_logo"> <img src="./assets/footer_logo.png" alt="VibeSync 로고" style=" width: 150px; filter: drop-shadow(-1px 0px 0px #000) drop-shadow(-1px 0px 0px #000) drop-shadow(-1px 0px 0px #000) drop-shadow(1px 0px 0px #000) drop-shadow(0px 1px 0px #000);"> </div>
        <div class="login-wrapper">
            <div id="findYourVibeSync">Find<br>Your<br><span class="highlight">VibeSync</span><br></div>

            <div id="loginFormContainer">
                <form action="login.jsp" method="post" id="loginForm"> <%-- action을 login.jsp 또는 현재 페이지로 명시 --%>
                    <%-- 회원가입 성공 메시지 --%>
                    <% if (signupSuccessForDisplay != null && !signupSuccessForDisplay.isEmpty()) { %>
                        <p style="color: green; text-align: left; margin: 0px;"><%= signupSuccessForDisplay %></p>
                    <% } %>
                    <label for="userId" class="sr-only">이메일</label> 
                    <input type="email" id="userId" name="userId" placeholder="Email" required value="<%= rememberedEmail %>">
                    <label for="userPw" class="sr-only">비밀번호</label> 
                    <input type="password" id="userPw" name="userPw" placeholder="Password" required pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$" title="8자 이상, 영문자, 숫자, 특수문자를 모두 포함해야 합니다.">
                        <%
                            if (loginErrorForDisplay != null && !loginErrorForDisplay.isEmpty()) {
                        %>
                                <p style="color: red; text-align: left; margin:0; font-size: 0.8em"><%= loginErrorForDisplay %></p>
                        <%
                            }
                        %>

                    <div class="checkbox-group">
                        <div class="checkbox-pair">
                        <input type="checkbox" name="autoLogin" id="autoLogin" <% if (autoLoginUserEmail != null && !autoLoginUserEmail.isEmpty()) { %>checked<% } %>>
                        <label for="autoLogin">Auto-Login</label> </div>
                        <div class="checkbox-pair">
                        <input type="checkbox" name="RememEmail" id="RememEmail" <% if (rememberedEmail != null && !rememberedEmail.isEmpty()) { %>checked<% } %>>
                        <label for="RememEmail">Remember Email</label> </div>
                    </div>

                    <button type="submit" id="loginBtn">Login</button> 
                    </form>
                <div class="links">
                    Forget your account? <a href="#">Find ID</a> or <a href="#">Reset Password</a> </div>
            </div>

            <div id="signupFormContainer" style="display: none;">
                
                    <%-- 회원가입 에러 메시지 --%>
                    <% if (signupErrorForDisplay != null && !signupErrorForDisplay.isEmpty()) { %>
                        <p style="color: red; text-align: left; margin: 0px;"><%= signupErrorForDisplay %></p>
                    <% } %>
                <form action="signup_process.jsp" method="post" id="signupForm">
                    <label for="signupName" class="sr-only">이름</label>
                    <input type="text" id="signupName" name="signupName" placeholder="Name" value="<%= prevSignupName %>" required>

                    <label for="signupNickname" class="sr-only">닉네임</label>
                    <input type="text" id="signupNickname" name="signupNickname" placeholder="NickName" value="<%= prevSignupNickname %>" required>

                    <label for="signupEmail" class="sr-only">이메일</label>
                    <input type="email" id="signupEmail" name="signupEmail" placeholder="Email" value="<%= prevSignupEmail %>" required>

                    <label for="signupPw" class="sr-only">비밀번호</label>
                    <input type="password" id="signupPw" name="signupPw" placeholder="Password" pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$" title="8자 이상, 영문자, 숫자, 특수문자를 모두 포함해야 합니다." required>

                    <label for="confirmPw" class="sr-only">비밀번호 확인</label> 
                    <input type="password" id="confirmPw" name="confirmPw" placeholder="Confirm Password" required >
                    <p id="confirmPwError" class="error-message" style="display: none; color: red; font-size: 0.8em;"></p>
                    
                    <label for="category" class="sr-only">관심 카테고리</label>
                    <select id="category" name="category">
                        <option value="1">영화</option> 
                        <option value="2">드라마</option> 
                        <option value="3">음악</option> 
                        <option value="4">애니메이션</option> 
                        <option value="5">일상</option> 
                    </select>
                            
                    <button type="submit" id="signupBtn">Sign Up</button> </form>
                <div class="links">
                    Already have an account?<a href="#" id="switchToLoginLink"> Login</a> </div>
            </div>

            <div class="links switch-form-link">
                Not a member yet?<a href="#" id="switchToSignupLink">Sign Up</a> </div>
        </div>
    </div>
</div>

<script src="./js/login.js"></script>

<script>
    $(document).ready(function() {
        const formToShow = "<%= formToShow != null ? formToShow : "" %>"; // null 체크 추가
        if (formToShow === 'signup') {
            $('#loginFormContainer').hide();
            $('#signupFormContainer').show();
            $('.switch-form-link').hide(); 
        }
    });
</script>
</body>
</html>