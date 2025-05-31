<%@page import="java.sql.SQLException"%>
<%@page import="com.util.PasswordMigrator"%>
<%@page import="com.util.DBConn"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.doit.domain.UserAccountVO"%>
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
    
	// 회원가입 등 오류 났을 때 보여줄 폼(login.js에서 사용)
	String formToShow = request.getParameter("formToShow");

%>
<%
	// 이메일 기억하기
    String rememberedEmail = ""; // 기본값은 빈 문자열
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("rememberedUserEmail".equals(cookie.getName())) {
                rememberedEmail = cookie.getValue();
                break; // 쿠키를 찾았으면 반복 중단
            }
        }
    } 
    // 이 rememberedEmail 변수를 아래 HTML의 email input 태그의 value로 사용
%>
<%
	if ("POST".equalsIgnoreCase(request.getMethod())) { // 요청 방식이 POST인지 확인
	    String emailParam = request.getParameter("userId"); // 폼에서 전달된 이메일
	    String pwParam = request.getParameter("userPw");    // 폼에서 전달된 비밀번호 (평문)
	    
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean loginSuccess = false;
		boolean emailFound = false;
	
	 try{
		   conn = DBConn.getConnection();
		   String sql = "SELECT pw, name, salt FROM userAccount WHERE email = ?";
		   pstmt = conn.prepareStatement(sql);
		   pstmt.setString(1, emailParam);
		   rs = pstmt.executeQuery();
		   
		   if( rs.next() ){
			   emailFound = true;
			   String storedHashedPassword = rs.getString("pw"); 
			   String storedSalt = rs.getString("salt"); 
				// 사용자가 입력한 평문 비밀번호와 DB에서 가져온 salt를 사용하여 해시값 생성
			   String hashedInputPassword = PasswordMigrator.hashPassword(pwParam, storedSalt);

               // 생성된 해시값과 DB에 저장된 해시값 비교
               if (hashedInputPassword != null && hashedInputPassword.equals(storedHashedPassword)) {
                   loginSuccess = true;
                   session.setAttribute("loggedInUserEmail", emailParam); // 세션에 사용자 이메일 저장

                   // "Remember Email" 기능 처리
                   String rememberEmail = request.getParameter("RememEmail"); // 체크박스 값 가져오기
                   if ("on".equals(rememberEmail)) { // 체크박스가 선택되었다면 (HTML에서 checkbox가 check되면 "on" 값을 가짐)
                       Cookie emailCookie = new Cookie("rememberedUserEmail", emailParam);
                       emailCookie.setMaxAge(60 * 60 * 24 * 30); // 쿠키 유효 기간: 30일 (초 단위)
                       emailCookie.setPath("/"); // 웹 애플리케이션 전체 경로에서 사용 가능하도록 설정
                       response.addCookie(emailCookie);
                   } else { // 체크박스가 선택되지 않았다면 기존 쿠키 삭제
                       Cookie emailCookie = new Cookie("rememberedUserEmail", "");
                       emailCookie.setMaxAge(0); // 쿠키 즉시 만료
                       emailCookie.setPath("/");
                       response.addCookie(emailCookie);
                   }
                   
               }
		   }

		   if (loginSuccess) {
               response.sendRedirect("main.jsp"); // 로그인 성공 시 이동할 페이지
               return; // login.jsp의 나머지 부분 처리를 중단
           } else {
        	   if (!emailFound) { // ★ 이메일이 DB에 존재하지 않는 경우
                   session.setAttribute("sessionLoginError", "존재하지 않는 이메일 입니다.");
               } else { // 이메일은 존재하지만 비밀번호가 틀린 경우
                   session.setAttribute("sessionLoginError", "비밀번호가 일치하지 않습니다.");
               }
               		response.sendRedirect("login.jsp");
               return;
               }
			   
	   }catch(Exception e){
		   e.printStackTrace();
		   session.setAttribute("sessionLoginError", "로그인 중 오류가 발생했습니다. 다시 시도해 주세요.");
           response.sendRedirect("login.jsp"); 
           return;
	   }finally{
		   try{
			 rs.close();
			 pstmt.close();  
		     DBConn.close(); 
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
    <link rel="icon" href="./favicon.ico" />
    <title>VibeSync Login</title> <link rel="stylesheet" href="../css/login.css"> </head>   

<body ondragstart="return false" ondrop="return false" onselectstart="return false"><!-- Prevent drag and drop actions -->
        <canvas id="starfield"></canvas>

<div class="container">
    <div id="logo">
        <img src="../assets/logo1.png" alt="VibeSync 로고" width="30%"> </div>

    <div id="login">
        <div id="inner_logo"> <img src="../assets/footer_logo.png" alt="VibeSync 로고" style=" width: 150px; filter: drop-shadow(-1px 0px 0px #000) drop-shadow(-1px 0px 0px #000) drop-shadow(-1px 0px 0px #000) drop-shadow(1px 0px 0px #000) drop-shadow(0px 1px 0px #000);"> </div>
        <div class="login-wrapper">
            <div id="findYourVibeSync">Find<br>Your<br><span class="highlight">VibeSync</span><br></div>

            <div id="loginFormContainer">
                <form action="" method="post" id="loginForm">
					<%-- 회원가입 성공 메시지 --%>
				    <% if (signupSuccessForDisplay != null && !signupSuccessForDisplay.isEmpty()) { %>
				        <p style="color: green; text-align: left; margin: 0px;"><%= signupSuccessForDisplay %></p>
				    <% } %>
                    <label for="userId" class="sr-only">이메일</label> <input type="email" id="userId" name="userId" placeholder="Email" required value="<%= rememberedEmail %>"><!-- value="teen_hero@example.com" -->
                    <label for="userPw" class="sr-only">비밀번호</label> <input type="password" id="userPw" name="userPw" placeholder="Password" required pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$" title="8자 이상, 영문자, 숫자, 특수문자를 모두 포함해야 합니다."><!-- value="Pw123!!!" -->
            	 		<%
                            if (loginErrorForDisplay != null && !loginErrorForDisplay.isEmpty()) {
                        %>
                            <p style="color: red; text-align: left; margin:0; font-size: 0.8em"><%= loginErrorForDisplay %></p>
                        <%
                            }
                        %>

                    <div class="checkbox-group">
                        <div class="checkbox-pair">
                        <input type="checkbox" name="autoLogin" id="autoLogin">
                        <label for="autoLogin">Auto-Login</label> </div>
                        <div class="checkbox-pair">
                        <input type="checkbox" name="RememEmail" id="RememEmail">
                        <label for="RememEmail">Remember Email</label> </div>
                    </div>

                    <button type="submit" id="loginBtn">Login</button> </form>
                <div class="links">
                    Forget your account? <a href="#">Find ID</a> or <a href="#">Reset Password</a> </div>
            </div>

            <div id="signupFormContainer" style="display: none;">
				
				    <%-- ★ 회원가입 에러 메시지 ★ --%>
				    <% if (signupErrorForDisplay != null && !signupErrorForDisplay.isEmpty()) { %>
				        <p style="color: red; text-align: left; margin: 0px;"><%= signupErrorForDisplay %></p>
				    <% } %>
                <form action="signup_process.jsp" method="post" id="signupForm">
                    <label for="signupEmail" class="sr-only">이름</label>
                    <input type="text" id="signupName" name="signupName" placeholder="Name" value="<%= prevSignupName %>" required>

                    <label for="signupEmail" class="sr-only">닉네임</label>
                    <input type="text" id="signupNickname" name="signupNickname" placeholder="NickName" value="<%= prevSignupNickname %>" required>

                    <label for="signupEmail" class="sr-only">이메일</label>
                    <input type="email" id="signupEmail" name="signupEmail" placeholder="Email" value="<%= prevSignupEmail %>" required>

                    <label for="signupPw" class="sr-only">비밀번호</label>
                    <input type="password" id="signupPw" name="signupPw" placeholder="Password" pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$" title="8자 이상, 영문자, 숫자, 특수문자를 모두 포함해야 합니다." required>

                    <label for="confirmPw" class="sr-only">비밀번호 확인</label> <input type="password" id="confirmPw" name="confirmPw" placeholder="Confirm Password" required >
                    <p id="confirmPwError" class="error-message" style="display: none; color: red; font-size: 0.8em;"></p>
                    <button type="submit" id="signupBtn">Sign Up</button> </form>
                <div class="links">
                    Already have an account?<a href="#" id="switchToLoginLink"> Login</a> </div>
            </div>

            <div class="links switch-form-link">
                Not a member yet?<a href="#" id="switchToSignupLink">Sign Up</a> </div>
        </div>
    </div>
</div>

<script src="../js/login.js"></script> 

<script>

</script>
</body>
</html>