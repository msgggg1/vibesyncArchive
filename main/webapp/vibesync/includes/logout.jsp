<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Cookie" %>
<%
    // 1. 모든 관련 쿠키 제거: userEmail, category_idx, rememberEmail
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("userEmail".equals(c.getName()) ||
                "category_idx".equals(c.getName()) ||
                "rememberEmail".equals(c.getName())) {
                c.setMaxAge(0);
                c.setPath("/");
                response.addCookie(c);
            }
        }
    }
    // 2. 로그인 페이지로 리디렉션
    response.sendRedirect("../login.jsp");
%>
