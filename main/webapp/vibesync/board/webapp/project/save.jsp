<%-- save.jsp --%>
<%@ page import="java.io.*, java.util.Base64, java.sql.*, java.util.ArrayList, java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

    String message = null;
    List<String> savedImagePathsForDB = new ArrayList<>(); // DB에 저장할 이미지 경로 리스트
    String errorTitle = null;
    String errorContent = null;
    String errorDataUrl = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String base64Images = request.getParameter("images"); // Base64 이미지 데이터들 (구분자 '|')

        errorTitle = title;
        errorContent = content;
        errorDataUrl = base64Images;

        String saveDir = application.getRealPath("/project/source");
        File dir = new File(saveDir);
        if (!dir.exists() && !dir.mkdirs()) {
            message = "오류: 이미지 저장 디렉터리 생성 실패: " + saveDir;
        }

        String processedContent = content;
        List<String> dbRelativePaths = new ArrayList<>();

        if (base64Images != null && !base64Images.isEmpty() && message == null) {
            String[] imageDataArray = base64Images.split("\\|");
            for (String base64Data : imageDataArray) {
                if (base64Data != null && !base64Data.isEmpty()) {
                    try {
                        String[] parts = base64Data.split(",");
                        if (parts.length != 2 || !parts[0].startsWith("data:image/")) {
                            message = "오류: 잘못된 이미지 데이터 형식입니다.";
                            break;
                        }

                        String imageType = parts[0].substring("data:image/".length(), parts[0].indexOf(";base64"));
                        String base64ImageContent = parts[1];
                        byte[] imageBytes = Base64.getDecoder().decode(base64ImageContent);
                        String savedFileName = System.currentTimeMillis() + "_" + System.nanoTime() + "." + imageType;
                        File imgFile = new File(dir, savedFileName);

                        try (FileOutputStream fos = new FileOutputStream(imgFile)) {
                            fos.write(imageBytes);
                            String dbRelativePath = "source/" + savedFileName;
                            dbRelativePaths.add(dbRelativePath);
                            savedImagePathsForDB.add(dbRelativePath);

                            // content의 img 태그 src 속성 변경 (이미 write.jsp에서 처리됨)

                        } catch (IOException e) {
                            message = "오류: 이미지 파일 저장 실패: " + e.getMessage();
                            e.printStackTrace();
                            break;
                        }
                    } catch (ArrayIndexOutOfBoundsException | IllegalArgumentException e) {
                        message = "오류: 잘못된 이미지 데이터 형식입니다.";
                        e.printStackTrace();
                        break;
                    }
                }
            }
        }

        // DB에 저장할 이미지 경로를 구분자로 연결
        String imagesForDB = String.join("|", dbRelativePaths);

        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String user = "vibesync";
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
                ps.setString(2, content); // write.jsp에서 content가 이미 변경됨
                ps.setString(3, imagesForDB); // 이미지 경로들을 구분자로 연결하여 저장
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
                <p>Data URLs: <%= errorDataUrl %></p>
                <p><a href="javascript:history.back()">이전 페이지로 돌아가기</a></p>
            </body>
            </html>
            <%
        }
    }
%>