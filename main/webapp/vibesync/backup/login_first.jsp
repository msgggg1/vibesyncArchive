<%@page import="java.sql.Statement"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="com.util.DBConn_vibesync"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String action = request.getParameter("mode");

if (action != null && !action.trim().isEmpty()) {
	// 값이 있을 때
    if ("signup".equals(action)) {
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String name = request.getParameter("signupName");
        String nickname = request.getParameter("signupNickname");
        String email = request.getParameter("signupEmail");
        String password = request.getParameter("signupPw");
        String confirm = request.getParameter("confirmPw");
        String category = request.getParameter("category");
        System.out.println("name : " + name + " / nickname : " + nickname + " / email : " + email + " / password : " + password + " / confirm : " + confirm + " / category : " + category);

        try {
            conn = DBConn_vibesync.getConnection();
            
            // 이메일 중복 확인
            pstmt = conn.prepareStatement("select * from useraccount where email = ?");
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
            	System.out.print("이미있다");
                out.println("<script>alert('이미 존재하는 이메일입니다.'); location.href='login.jsp';</script>");
            } else {
                // 비밀번호 MD5 암호화
                MessageDigest md = MessageDigest.getInstance("MD5");
                md.update(password.getBytes());
                String encryptedPassword = new BigInteger(1, md.digest()).toString(16);
            	System.out.println("login : " + email + " / pw : " + encryptedPassword);
               
                String img = "./source/img.jpg";
                
                // 2) useraccount_seq.NEXTVAL 조회
                int ac_idx = 0;
                Statement seqStmt = conn.createStatement();
                ResultSet seqRs = seqStmt.executeQuery(
                    "SELECT useraccount_seq.NEXTVAL FROM dual");
                if (seqRs.next()) {
                    ac_idx = seqRs.getInt(1);
                }
                
            
             // 4) useraccount INSERT (ac_idx 직접 바인딩)
                String insertUserSql =
                    "INSERT INTO useraccount (ac_idx, email, pw, nickname, img, name ) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertUserSql);
                pstmt.setInt(1, ac_idx);
                pstmt.setString(2, email);
                pstmt.setString(3, encryptedPassword);
                pstmt.setString(4, nickname);
                pstmt.setString(5, "./source/img.jpg");  // 기본 이미지 경로
                pstmt.setString(6, name);
                System.out.println(insertUserSql);
                pstmt.executeUpdate();
                
                int category_num = 0;
                if (category != null && !category.trim().isEmpty()) {
                	category_num = Integer.parseInt(category);
                }

                pstmt = conn.prepareStatement("insert into categoryperuser (ca_ac_idx, ac_idx, category_idx) values (categoryperuser_seq.NEXTVAL, ?, ?)");
                pstmt.setInt(1, ac_idx);
                pstmt.setInt(2, category_num);
                pstmt.executeUpdate();

                response.sendRedirect("login.jsp");
                out.println("<script>alert('회원가입 성공!'); location.href='login.jsp';</script>");

            }
        } catch (Exception e) {
            out.println("에러: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        }
  
    } else if ("login".equals(action)) {
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String email = request.getParameter("userId");
        String password = request.getParameter("userPw");

        try {
        	conn = DBConn_vibesync.getConnection();
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(password.getBytes());
            String encryptedPassword = new BigInteger(1, md.digest()).toString(16);

            pstmt = conn.prepareStatement("select * from useraccount where email = ? and pw = ?");
            pstmt.setString(1, email);
            pstmt.setString(2, encryptedPassword); 
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // 로그인 성공 처리 위치
                response.sendRedirect("main.html");
                out.println("<script>alert('로그인 성공!'); location.href = 'main.html';</script>");
            } else {
                out.println("<script>alert('로그인 실패: 이메일 또는 비밀번호가 잘못되었습니다.');</script>");
            }
        } catch (Exception e) {
            out.println("에러: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        }
    }
}
%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=National+Park:wght@200..800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Cal+Sans&display=swap" rel="stylesheet" />
    <link rel="icon" href="./favicon.ico" />
    <title>VibeSync Login</title>
    <link rel="stylesheet" href="./login/login.css" />
  </head>

  <body ondragstart="return false" ondrop="return false" onselectstart="return false">
    <canvas id="starfield"></canvas> 

    <div class="container">
      <div id="logo">
        <img src="./assets/logo1.png" alt="VibeSync 로고" width="30%" />
      </div>

      <div id="login">
        <div id="inner_logo">
          <img src="./assets/footer_logo.png" alt="VibeSync 로고" style="width: 150px; filter: drop-shadow(-1px 0px 0px #000) drop-shadow(-1px 0px 0px #000) drop-shadow(-1px 0px 0px #000) drop-shadow(1px 0px 0px #000) drop-shadow(0px 1px 0px #000);" />
        </div>
        <div class="login-wrapper">
          <div id="findYourVibeSync">
            Find<br />Your<br /><span class="highlight">VibeSync</span><br />
          </div>

          <div id="loginFormContainer">
            <form action="./login.jsp" method="post" id="loginForm">
              <input type="hidden" name="mode" value="login">
              <label for="userId" class="sr-only">이메일</label>
              <input type="email" id="userId" name="userId" placeholder="Email" required />

              <label for="userPw" class="sr-only">비밀번호</label>
              <input type="password" id="userPw" name="userPw" placeholder="Password" required pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$" title="8자 이상, 영문자, 숫자, 특수문자를 모두 포함해야 합니다." />

              <div class="checkbox-group">
                <div class="checkbox-pair">
                  <input type="checkbox" name="autoLogin" id="autoLogin" />
                  <label for="autoLogin">Auto-Login</label>
                </div>
                <div class="checkbox-pair">
                  <input type="checkbox" name="RememEmail" id="RememEmail" />
                  <label for="RememEmail">Remember Email</label>
                </div>
              </div>

              <button type="submit" id="loginBtn">Login</button>
            </form>
            <div class="links">
              Forget your account? <a href="#">Find ID</a> or
              <a href="#">Reset Password</a>
            </div>
          </div>

          <div id="signupFormContainer" style="display: none">
            <form action="./login.jsp" method="post" id="signupForm">
              <input type="hidden" name="mode" value="signup">

              <label for="signupEmail" class="sr-only">이름</label>
              <input type="text" id="signupName" name="signupName" placeholder="Name" required />

              <label for="signupEmail" class="sr-only">닉네임</label>
              <input type="text" id="signupNickname" name="signupNickname" placeholder="NickName" required />

              <label for="signupEmail" class="sr-only">이메일</label>
              <input type="email" id="signupEmail" name="signupEmail" placeholder="Email" required />

              <label for="signupPw" class="sr-only">비밀번호</label>
              <input type="password" id="signupPw" name="signupPw" placeholder="Password" required pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$" title="8자 이상, 영문자, 숫자, 특수문자를 모두 포함해야 합니다." />

              <label for="confirmPw" class="sr-only">비밀번호 확인</label>
              <input type="password" id="confirmPw" name="confirmPw" placeholder="Confirm Password" required />
              <p id="confirmPwError" class="error-message" style="display: none; color: red; font-size: 0.8em;"></p>
              
              <label for="category" class="sr-only">관심 카테고리</label>
              <select id="category" name="category">
			   <option value="1">영화</option> 
			   <option value="2">드라마</option> 
			   <option value="3">음악</option> 
			   <option value="4">애니메이션</option> 
			   <option value="5">일상</option> 
			  </select>

			  

              <button type="submit" id="signupBtn">Sign Up</button>
            </form>
            <div class="links">
              Already have an account?<a href="#" id="switchToLoginLink">Login</a>
            </div>
          </div>

          <div class="links switch-form-link">
            Not a member yet?<a href="#" id="switchToSignupLink">Sign Up</a>
          </div>
        </div>
      </div>
    </div>

    <script src="./login/login.js"></script>
  </body>
</html>