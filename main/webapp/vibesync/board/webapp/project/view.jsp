<%-- view.jsp --%>
<%@ page import="java.sql.*, java.util.Arrays" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    int id = 0;
    try { id = Integer.parseInt(request.getParameter("id")); } catch(Exception e) {}
    String title="", content="", images="", createdAt="";
    String[] imagePaths = null;

    try {
        try (Connection conn = DriverManager.getConnection(
                     "jdbc:oracle:thin:@localhost:1521:xe","vibesync","1234");
             PreparedStatement ps = conn.prepareStatement("SELECT title, content, images, TO_CHAR(created_at, 'YYYY-MM-DD HH24:MI:SS') AS created_at FROM board WHERE id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    title   = rs.getString("title");
                    content = rs.getString("content");
                    images = rs.getString("images");
                    createdAt = rs.getString("created_at");
                    if (images != null && !images.isEmpty()) {
                        imagePaths = images.split("\\|"); // 구분자로 분리
                    }
                    // content 내의 이미지 src를 실제 경로로 변경
                    if (imagePaths != null && imagePaths.length > 0) {
                        String[] contentImageTags = content.split("<img[^>]*>");
                        StringBuilder newContent = new StringBuilder();
                        int imageIndex = 0;
                        for (String part : contentImageTags) {
                            newContent.append(part);
                            if (imageIndex < imagePaths.length) {
                                newContent.append("<img src=\"./" + imagePaths[imageIndex] + "\">");
                                imageIndex++;
                            }
                        }
                        content = newContent.toString();
                    }
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
        <% if (imagePaths != null && imagePaths.length > 0) { %>
            <h3>첨부 이미지</h3>
            <ul>
            <% for (String imagePath : imagePaths) { %>
                <li>
                    <img src="./<%= imagePath %>" alt="첨부 이미지">
                    <p>이미지 저장 위치: <%= application.getRealPath("/project/") + imagePath %></p>
                </li>
            <% } %>
            </ul>
        <% } else { %>
            <p>첨부 이미지 없음</p>
        <% } %>
    </div>
    <div>작성일: <%= createdAt %></div>
</body>
</html>