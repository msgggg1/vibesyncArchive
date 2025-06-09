<%@ page import="java.sql.Statement" %>
<%@ page import="java.math.BigInteger" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="com.util.DBConn_vibesync" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // ── 0. 기존 쿠키 확인 ──
    String currentUser = null;
    String rememberedEmail = null;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("userEmail".equals(c.getName())) {
                currentUser = c.getValue();
            } else if ("rememberEmail".equals(c.getName())) {
                rememberedEmail = c.getValue();
            }
        }
    }

    // autoLogin 쿠키가 있으면 바로 메인으로
    if (currentUser != null) {
        response.sendRedirect("main.jsp");
        return;
    }
    
    // ── category 목록 가져오기 ──
    Connection categoryConn = DBConn_vibesync.getConnection();
    PreparedStatement categoryStmt = categoryConn.prepareStatement(
        "SELECT category_idx, c_name FROM category"
    );
    ResultSet categoryRs = categoryStmt.executeQuery();

    String action = request.getParameter("mode");
    if (action != null && !action.trim().isEmpty()) {

        // ─ 회원가입 처리 ─
        if ("signup".equals(action)) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            String name      = request.getParameter("signupName");
            String nickname  = request.getParameter("signupNickname");
            String email     = request.getParameter("signupEmail");
            String password  = request.getParameter("signupPw");
            String category  = request.getParameter("category");

            try {
                conn = DBConn_vibesync.getConnection();

                // 이메일 중복 확인
                pstmt = conn.prepareStatement("SELECT 1 FROM useraccount WHERE email = ?");
                pstmt.setString(1, email);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    out.println("<script>alert('이미 존재하는 이메일입니다.'); location.href='login.jsp';</script>");
                } else {
                    // 비밀번호 SHA-256 암호화
                    MessageDigest md = MessageDigest.getInstance("SHA-256");
                    byte[] hash = md.digest(password.getBytes("UTF-8"));
                    StringBuilder sb = new StringBuilder();
                    for (byte b : hash) {
                        sb.append(String.format("%02x", b));
                    }
                    String encryptedPassword = sb.toString();

                    // 시퀀스 조회
                    int ac_idx = 0;
                    try (Statement seqStmt = conn.createStatement();
                         ResultSet seqRs = seqStmt.executeQuery("SELECT useraccount_seq.NEXTVAL FROM dual")) {
                        if (seqRs.next()) ac_idx = seqRs.getInt(1);
                    }

                    // 사용자 INSERT
                    String insertSql =
                      "INSERT INTO useraccount (ac_idx, email, pw, nickname, img, name, category_idx) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setInt(1, ac_idx);
                        insertStmt.setString(2, email);
                        insertStmt.setString(3, encryptedPassword);
                        insertStmt.setString(4, nickname);
                        insertStmt.setString(5, "./source/img.jpg");
                        insertStmt.setString(6, name);
                        insertStmt.setString(7, category);
                        insertStmt.executeUpdate();
                    }

                    out.println("<script>alert('회원가입 성공!'); location.href='login.jsp';</script>");
                }
            } catch (Exception e) {
                out.println("에러: " + e.getMessage());
            } finally {
                if (rs != null)    try { rs.close(); }    catch (Exception ignored) {}
                if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
                // Connection is intentionally not closed
            }

        // ─ 로그인 처리 ─
        } else if ("login".equals(action)) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            String email          = request.getParameter("userId");
            String password       = request.getParameter("userPw");
            String autoLoginParam = request.getParameter("autoLogin");
            String rememEmailParam= request.getParameter("RememEmail");

            try {
                conn = DBConn_vibesync.getConnection();

                // 비밀번호 SHA-256 암호화
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hash = md.digest(password.getBytes("UTF-8"));
                StringBuilder sb = new StringBuilder();
                for (byte b : hash) {
                    sb.append(String.format("%02x", b));
                }
                String encryptedPassword = sb.toString();

                // category_idx도 함께 조회
                pstmt = conn.prepareStatement(
                    "SELECT category_idx FROM useraccount WHERE email = ? AND pw = ?"
                );
                pstmt.setString(1, email);
                pstmt.setString(2, encryptedPassword);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    int userCategory = rs.getInt("category_idx");

                    // ─ userId 쿠키 설정 ─
                    Cookie loginCookie = new Cookie("userEmail", email);
                    if (autoLoginParam != null) {
                        loginCookie.setMaxAge(7 * 24 * 60 * 60); // 7일
                    }
                    loginCookie.setPath("/");
                    response.addCookie(loginCookie);

                    // ─ category_idx 쿠키 설정 ─
                    Cookie categoryCookie = new Cookie("category_idx", String.valueOf(userCategory));
                    if (autoLoginParam != null) {
                        categoryCookie.setMaxAge(7 * 24 * 60 * 60);
                    }
                    categoryCookie.setPath("/");
                    response.addCookie(categoryCookie);

                    // ─ RememEmail 쿠키 설정 ─
                    if (rememEmailParam != null) {
                        Cookie remCookie = new Cookie("rememberEmail", email);
                        remCookie.setMaxAge(30 * 24 * 60 * 60); // 30일
                        remCookie.setPath("/");
                        response.addCookie(remCookie);
                    } else {
                        Cookie remCookie = new Cookie("rememberEmail", "");
                        remCookie.setMaxAge(0);
                        remCookie.setPath("/");
                        response.addCookie(remCookie);
                    }

                    out.println("<script>alert('로그인 성공!'); location.href='main.jsp';</script>");
                } else {
                    out.println("<script>alert('로그인 실패: 이메일 또는 비밀번호가 잘못되었습니다.');</script>");
                }
            } catch (Exception e) {
                out.println("에러: " + e.getMessage());
            } finally {
                if (rs != null)    try { rs.close();    } catch (Exception ignored) {}
                if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
                // Connection is intentionally not closed
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"
          integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
          crossorigin="anonymous"></script>
  <link href="https://fonts.googleapis.com/css2?family=National+Park:wght@200..800&display=swap"
        rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Cal+Sans&display=swap"
        rel="stylesheet" />
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
        <img src="./assets/footer_logo.png" alt="VibeSync 로고"
             style="width:150px;filter:drop-shadow(-1px 0 0 #000)drop-shadow(1px 0 0 #000)"/>
      </div>
      <div class="login-wrapper">
        <div id="findYourVibeSync">
          Find<br/>Your<br/><span class="highlight">VibeSync</span><br/>
        </div>

        <!-- 로그인 폼 -->
        <div id="loginFormContainer">
          <form action="./login.jsp" method="post" id="loginForm">
            <input type="hidden" name="mode" value="login"/>
            <input type="email"  id="userId" name="userId" placeholder="Email" required
                   value="<%= rememberedEmail != null ? rememberedEmail : "" %>"/>
            <input type="password" id="userPw" name="userPw" placeholder="Password" required />
            <div class="checkbox-group">
              <label><input type="checkbox" name="autoLogin"/> Auto-Login</label>
              <label><input type="checkbox" name="RememEmail"
                    <%= rememberedEmail != null ? "checked" : "" %>/> Remember Email</label>
            </div>
            <button type="submit" id="loginBtn">Login</button>
          </form>
          <div class="links">
            Forget your account? <a href="#">Find ID</a> or <a href="#">Reset Password</a>
          </div>
        </div>

        <!-- 회원가입 폼 (기존 그대로) -->
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
              <%
                while (categoryRs.next()) {
              %>
                <option value="<%= categoryRs.getInt("category_idx") %>">
                  <%= categoryRs.getString("c_name") %>
                </option>
              <%
                }
              %>
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

<%
    // statement와 result set만 닫고, connection은 닫지 않음
    if (categoryRs != null) try { categoryRs.close(); } catch (Exception ignored) {}
    if (categoryStmt != null) try { categoryStmt.close(); } catch (Exception ignored) {}
%>
</body>
</html>
