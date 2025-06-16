<%-- save.jsp --%>
<%@ page import="java.io.*, java.util.Base64, java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

  String message = null;
  String savedImagePathForDB = null; // DB에 저장할 이미지 경로
  String errorTitle = null;
  String errorContent = null;
  String errorDataUrl = null;

  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String dataUrl = request.getParameter("images");

    errorTitle = title;
    errorContent = content;
    errorDataUrl = dataUrl;

    String saveDir = application.getRealPath("/project/source"); // 이미지 저장 경로 명확히 지정
    File dir = new File(saveDir);
    if (!dir.exists() && !dir.mkdirs()) {
      message = "오류: 이미지 저장 디렉터리 생성 실패: " + saveDir;
    }

    String dbImgPathForContent = "";
    String savedFileName = null;
    if (dataUrl != null && !dataUrl.isEmpty() && message == null) {
      String base64Image = dataUrl.split(",")[1];
      byte[] imageBytes = Base64.getDecoder().decode(base64Image);
      savedFileName = System.currentTimeMillis() + ".jpg"; // 확장자를 jpg로 유지
      File imgFile = new File(dir, savedFileName);
      try (FileOutputStream fos = new FileOutputStream(imgFile)) {
        fos.write(imageBytes);
      } catch (IOException e) {
        message = "오류: 이미지 파일 저장 실패: " + e.getMessage();
        e.printStackTrace();
      }
      dbImgPathForContent = "./source/" + savedFileName; // content에 사용할 상대 경로 (요청사항)
      savedImagePathForDB = "source/" + savedFileName; // DB에 저장할 상대 경로

      // content의 img 태그 src 속성 변경 및 width 제거
      if (content != null && content.contains("<img")) {
        // width 속성 제거
        content = content.replaceAll("style=\"width: [0-9]+px;\"", "");
        // src 속성 변경
        String originalSrcRegex = "<img[^>]*src=\"data:image\\/(jpeg|png|gif);base64,[^\"]*\"[^>]*>";
        String replacementSrc = "<img src=\"./source/" + savedFileName + "\">";
        content = content.replaceAll(originalSrcRegex, replacementSrc);
      } else if (content != null && dataUrl != null && !dataUrl.isEmpty()) {
        // content에 img 태그가 없을 경우 새로 추가하는 로직 (선택 사항)
        content += "<img src=\"./source/" + savedFileName + "\">";
      }
    }

    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String user = "netflix";
    String password = "1234";
    String className = "oracle.jdbc.driver.OracleDriver";

    if (message == null) {
      Connection conn = null;
      PreparedStatement ps = null;
      ResultSet rs = null;
      try {
        Class.forName(className);
        conn = DriverManager.getConnection(url, user, password);
        String sql = "INSERT INTO board(title, content, images) VALUES( ?, ?, ?)";
        ps = conn.prepareStatement(sql, new String[]{"id"});
        ps.setString(1, title);
        ps.setString(2, content);
        ps.setString(3, savedImagePathForDB); // 이미지 파일 경로 DB에 저장
        int affectedRows = ps.executeUpdate();

        if (affectedRows > 0) {
          rs = ps.getGeneratedKeys();
          if (rs.next()) {
            int newId = rs.getInt(1);
            response.sendRedirect("view.jsp?id=" + newId);
            return;
          } else {
            message = "오류: 생성된 ID를 가져오지 못했습니다.";
          }
        } else {
          message = "오류: 데이터베이스에 저장 실패했습니다.";
        }
      } catch (ClassNotFoundException e) {
        message = "오류: JDBC 드라이버를 찾을 수 없습니다: " + e.getMessage();
        e.printStackTrace();
      } catch (SQLException e) {
        message = "오류: 데이터베이스 작업 실패: " + e.getMessage();
        e.printStackTrace();
      } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (ps != null) try { ps.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
      }
    }

    // 오류 메시지가 있다면 화면에 출력
    if (message != null) {
      %>
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <title>오류 발생</title>
      </head>
      <body>
        <h1>오류 발생</h1>
        <p><%= message %></p>
        <p>Title: <%= errorTitle %></p>
        <p>Content (수정 전): <%= errorContent %></p>
        <p>Data URL: <%= errorDataUrl %></p>
        <p><a href="javascript:history.back()">이전 페이지로 돌아가기</a></p>
      </body>
      </html>
      <%
    }
  }
%>