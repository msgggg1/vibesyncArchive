<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String contextPath = request.getContextPath();
%>
<%--
    이 파일은 오직 .con_item 목록만 그리는 역할만 합니다.
    컨트롤러(핸들러)가 'posts'라는 이름으로 List<NoteSummaryDTO>를 넘겨주는 것을 가정합니다.
--%>
<c:forEach var="post" items="${posts}">
    <div class="con_item">
        <a href="${contextPath }/noteView.do?noteIdx=${post.note_idx}">
            <img src="${contextPath }/${not empty post.thumbnail_img ? post.thumbnail_img : 'sources/images/default_thumbnail.png'}" alt="${post.title} 썸네일">
            <p>${post.title}</p>
        </a>
    </div>
</c:forEach>