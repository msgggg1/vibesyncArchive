<%@page import="java.util.Objects"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    boolean wasAutoLoginActive = false; // 자동 로그인이 활성화되어 있었는지 여부를 판단하는 플래그
    Cookie rememberEmailCookieInstance = null; // rememberEmail 쿠키 객체를 저장할 변수

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("userEmail".equals(cookie.getName())) { // 자동 로그인용 쿠키
                wasAutoLoginActive = true; // 자동 로그인이 활성화 되어 있었음을 표시
                
                cookie.setValue(""); 
                cookie.setPath("/"); 
                response.addCookie(cookie); // 자동 로그인 쿠키 삭제
            } else if ("rememberEmail".equals(cookie.getName())) {
                // rememberEmail 쿠키를 바로 삭제하지 않고, 인스턴스만 저장해둡니다.
                rememberEmailCookieInstance = cookie;
            }
        }
    }

    // 자동 로그인이 활성화되어 있었고, 이메일 기억하기 쿠키도 존재했다면 함께 삭제합니다.
    if (wasAutoLoginActive && rememberEmailCookieInstance != null) {
        rememberEmailCookieInstance.setValue("");
        rememberEmailCookieInstance.setMaxAge(0);
        rememberEmailCookieInstance.setPath("/"); 
        response.addCookie(rememberEmailCookieInstance); // 이메일 기억하기 쿠키 삭제
    }

    // 세션 초기화 (가장 확실한 방법)
    session.invalidate();

    // 로그아웃 후 login.jsp로 리디렉션 
    response.sendRedirect("login.jsp"); 
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그아웃</title>
</head>
<body>
    <h3>로그아웃 되었습니다.</h3>
    <a href="login.jsp">로그인 페이지로 돌아가기</a>
</body>
</html>