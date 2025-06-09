<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    int id = 0;
    try { id = Integer.parseInt(request.getParameter("id")); } catch(Exception e) {}
    String title="", content="", images="", createdAt="";
    String absoluteImagePath = "";

    try {
        try (Connection conn = DriverManager.getConnection(
                     "jdbc:oracle:thin:@localhost:1521:xe","netflix","1234");
             PreparedStatement ps = conn.prepareStatement("SELECT title, content, images, TO_CHAR(created_at, 'YYYY-MM-DD HH24:MI:SS') AS created_at FROM board WHERE id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    title   = rs.getString("title");
                    content = rs.getString("content");
                    images = rs.getString("images");

                    if (images != null && !images.isEmpty()) {
                        // save.jsp에서 이미지를 저장한 실제 경로를 기반으로 절대 경로 생성
                        String webAppRoot = application.getRealPath("/project"); // 변경된 부분
                        String relativeImagePath = images.replaceFirst("^\\./", ""); // "./" 제거
                        java.io.File imageFile = new java.io.File(webAppRoot, relativeImagePath);
                        absoluteImagePath = imageFile.getAbsolutePath();
                    }

                    createdAt = rs.getString("created_at");
                }
            }
        }
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>글 보기</title></head>
<body>
    <h2><%= title %></h2>
    <div><%= content %></div>
    <div>
        <% if (images != null && !images.isEmpty()) { %>
            <img src="./<%= images %>" alt="첨부 이미지">
            <p>이미지 저장 위치 (전체 경로): <%= absoluteImagePath %></p>
        <% } else { %>
            <p>첨부 이미지 없음</p>
        <% } %>
    </div>
    <div>작성일: <%= createdAt %></div>
</body>
</html>