<%@page import="com.util.ConnectionProvider"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.util.PasswordMigrator"%>
<%@page import="java.util.Base64"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%! // JSP Declaration: 헬퍼 메소드 정의
    /**
     * 회원가입 오류 발생 시, 세션에 오류 메시지와 이전 입력 값을 저장하고
     * 회원가입 폼으로 리다이렉트합니다.
     *
     * @return true 리다이렉트가 성공적으로 요청되었으면 true, 그렇지 않으면 false (실제로는 항상 true를 반환하거나 void로 변경 후 호출부에서 return)
     * @throws java.io.IOException response.sendRedirect()에서 발생 가능
     */
    private boolean handleErrorAndRedirect(HttpSession session, HttpServletResponse response,
                                           String errorMessage,
                                           String name, String nickname, String email) throws java.io.IOException {
        session.setAttribute("signupErrorMsg", errorMessage);
        session.setAttribute("prevSignupName", (name != null) ? name : "");
        session.setAttribute("prevSignupNickname", (nickname != null) ? nickname : "");
        session.setAttribute("prevSignupEmail", (email != null) ? email : "");
        response.sendRedirect("login.jsp?formToShow=signup");
        return true; // 리다이렉트 했음을 알림 (호출부에서 return;을 위함)
    }
%>
<% 
	if(!"post".equalsIgnoreCase(request.getMethod())){
		response.sendRedirect("login.jsp"); // 비정상 접근 시 로그인 페이지로
		return;
	} // if
	
	request.setCharacterEncoding("UTF-8");
	
	String name = request.getParameter("signupName");
	String nickname = request.getParameter("signupNickname");
	String email = request.getParameter("signupEmail");
	String pw = request.getParameter("signupPw");
	String cpw = request.getParameter("confirmPw");
	int category = Integer.parseInt(request.getParameter("category"));
	
	// 유효성 검사 1. 모든 필수 항목 입력
	if(name == null || name.trim().isEmpty() ||  nickname == null || nickname.trim().isEmpty() ||
	        email == null || email.trim().isEmpty() || 
	        pw == null || pw.isEmpty() ||
	        cpw == null || cpw.isEmpty()){
		if (handleErrorAndRedirect(session, response, "모든 필수 항목을 입력해주세요.", name, nickname, email)) {
            return;
        }
	     return;
	}
	
	// 유효성 검사 2. 비밀번호와 비밀번호확인 일치
	if (!pw.equals(cpw)) {
		if (handleErrorAndRedirect(session, response, "비밀번호와 비밀번호 확인이 일치하지 않습니다.", name, nickname, email)) {
            return;
        }
	  }

	// 유효성 검사 3. 이메일 형식 검사
	String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    if (!email.matches(emailRegex)) {
    	if (handleErrorAndRedirect(session, response, "유효하지 않은 이메일 형식입니다.", name, nickname, email)) {
            return;
        }
        return;
    }
    
 // 유효성 검사 4: 비밀번호 강도 검사 
    // (8자 이상, 영문자, 숫자, 특수문자 포함)
    String passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$";
    if (!pw.matches(passwordRegex)) {
    	if (handleErrorAndRedirect(session, response, "비밀번호는 8자 이상의 영문자, 숫자, 특수문자(!@#$%^&*)를 모두 포함한 문자열이어야 합니다.", name, nickname, email)) {
            return;
        }
        return;
    }
	
		Connection conn = null;
		PreparedStatement pstmtChk = null;
		PreparedStatement pstmtInsert = null;
		ResultSet rsChk = null;
	
	 try{
		   conn = ConnectionProvider.getConnection();
		   conn.setAutoCommit(false); // 트랜잭션 관리
		   
		   // 이메일 중복 확인
		   String chkEmailsql = "SELECT COUNT(*) FROM userAccount WHERE email = ?";
		   pstmtChk = conn.prepareStatement(chkEmailsql);
		   pstmtChk.setString(1, email);
		   rsChk = pstmtChk.executeQuery();
		   if( rsChk.next() && rsChk.getInt(1)>0){
			   if (handleErrorAndRedirect(session, response, "이미 사용 중인 이메일입니다.", name, nickname, email)) {
	                return;
	            }
		   }
		   
		   if (rsChk != null) rsChk.close();
	       if (pstmtChk != null) pstmtChk.close();
	       
	       //닉네임 중복 확인
	       String chkNicknameSql = "SELECT COUNT(*) FROM userAccount WHERE nickname = ?";
	       pstmtChk = conn.prepareStatement(chkNicknameSql);
	       pstmtChk.setString(1, nickname);
	       rsChk = pstmtChk.executeQuery();
	       if (rsChk.next() && rsChk.getInt(1) > 0) {
	    	   if (handleErrorAndRedirect(session, response, "이미 사용 중인 닉네임입니다.", name, nickname, email)) {
	                // if (conn != null) try { conn.rollback(); } catch (SQLException ex_rb) { ex_rb.printStackTrace(); }
	                return;
	            }
	        }
	       
	       
	       // 유효성 검사 통과 시 사용자 등록
	       // salt 생성
	       String base64Salt = PasswordMigrator.generateSalt();
	       // 비밀번호 해싱
	       String hashedPassword = PasswordMigrator.hashPassword(pw, base64Salt);
	       if (hashedPassword == null) { // 해싱 실패 시
	            throw new Exception("비밀번호 해싱에 실패했습니다.");
	        }
	       
	       //ac_idx생성: 지금은 임의로 26 삽입
	       String insertSql = "INSERT INTO userAccount (ac_idx, email, pw, nickname, img,  name, created_at, salt, category_idx) " +
                  			 " VALUES (useraccount_seq.nextval, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?, ?)";
			pstmtInsert = conn.prepareStatement(insertSql);
			pstmtInsert.setString(1, email);
			pstmtInsert.setString(2, hashedPassword);
			pstmtInsert.setString(3, nickname);
			pstmtInsert.setString(4, null); // 기본 이미지 또는 null
			pstmtInsert.setString(5, name);
			pstmtInsert.setString(6, base64Salt);
			pstmtInsert.setInt(7, category);
			
			int result = pstmtInsert.executeUpdate();
			
			if (result > 0) {
	            conn.commit(); // 트랜잭션 성공
	            
	            //  회원가입 성공 시, 'rememberEmail' 쿠키 삭제 로직 
	            Cookie rememberEmailCookieToRemove = new Cookie("rememberEmail", "");
	            rememberEmailCookieToRemove.setMaxAge(0); 
	            rememberEmailCookieToRemove.setPath("/"); 
	            response.addCookie(rememberEmailCookieToRemove);
	            
	            session.setAttribute("signupSuccessMsg", "회원가입이 성공적으로 완료되었습니다. 로그인해주세요.");
	            response.sendRedirect("login.jsp");
	        } else {
	            conn.rollback(); // 트랜잭션 실패
	            session.setAttribute("signupErrorMsg", "회원가입 중 오류가 발생했습니다.");
	            session.setAttribute("prevSignupName", name);
	            session.setAttribute("prevSignupNickname", nickname);
	            session.setAttribute("prevSignupEmail", email);
	            response.sendRedirect("login.jsp?formToShow=signup");
	        }
              
	   }catch(Exception e){
		   if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
	        e.printStackTrace();
	        if (handleErrorAndRedirect(session, response, "회원가입 처리 중 예기치 않은 오류가 발생했습니다.", name, nickname, email)) {
	            return;
	        }
	   }finally{
		   try{
			 rsChk.close();
			 pstmtChk.close();
			 pstmtInsert.close();  
		     conn.close(); 
		   }catch(Exception e){
			   e.printStackTrace();
		   }
	   } // try 
	 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>