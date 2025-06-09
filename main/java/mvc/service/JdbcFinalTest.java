package mvc.service;

import java.sql.Connection;
import java.sql.DriverManager; // DriverManager를 직접 사용
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class JdbcFinalTest {

    public static void main(String[] args) {
        Connection conn = null;
        int testAcIdx = 26; // 테스트용 사용자 ID
        String testText = "최종 테스트";
        String testGroup = "한글그룹"; // ★★★ 한글 데이터
        String testColor = "#FF0000";
        int generatedTodoIdx = 0;

        try {
            // --- ▼▼▼ 1. 여기에 본인의 DB 접속 정보를 정확히 입력해주세요 ▼▼▼ ---
            String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:XE"; // 예: XE, orcl 등 SID 확인
            String username = "vibesync"; // DB 사용자 이름
            String password = "ss123$"; // DB 비밀번호
            // --- ▲▲▲ ---

            System.out.println("====== 최종 JDBC 직접 연결 테스트 시작 ======");
            
            // JNDI 대신 JDBC DriverManager를 사용해 직접 연결합니다.
            Class.forName("oracle.jdbc.driver.OracleDriver"); // Oracle 드라이버 로드
            conn = DriverManager.getConnection(jdbcUrl, username, password);
            conn.setAutoCommit(false);
            System.out.println("1. DB 직접 연결 성공!");

            // --- [INSERT 테스트] ---
            String insertSql = "INSERT INTO todolist (todo_idx, text, ac_idx, status, todo_group, color, created_at) "
                             + "VALUES (todolist_seq.NEXTVAL, ?, ?, 0, ?, ?, SYSDATE)";
            String generatedColumns[] = { "todo_idx" };

            try (PreparedStatement pstmt_insert = conn.prepareStatement(insertSql, generatedColumns)) {
                pstmt_insert.setString(1, testText);
                pstmt_insert.setInt(2, testAcIdx);
                pstmt_insert.setString(3, testGroup);
                pstmt_insert.setString(4, testColor);
                
                System.out.println("2. INSERT 실행 -> todo_group: [" + testGroup + "]");
                pstmt_insert.executeUpdate();

                try (ResultSet rs_keys = pstmt_insert.getGeneratedKeys()) {
                    if (rs_keys.next()) {
                        generatedTodoIdx = rs_keys.getInt(1);
                        System.out.println("3. INSERT 성공! 생성된 todo_idx: " + generatedTodoIdx);
                    }
                }
            }

            // --- [SELECT 테스트] ---
            if (generatedTodoIdx > 0) {
                String selectSql = "SELECT todo_idx, text, todo_group FROM todolist WHERE todo_idx = ?";
                try (PreparedStatement pstmt_select = conn.prepareStatement(selectSql)) {
                    pstmt_select.setInt(1, generatedTodoIdx);
                    
                    System.out.println("4. 방금 INSERT한 데이터 SELECT 실행...");
                    try (ResultSet rs_select = pstmt_select.executeQuery()) {
                        if (rs_select.next()) {
                            String group = rs_select.getString("todo_group");
                            
                            System.out.println("\n========= [결과] =========");
                            System.out.println("DB에서 직접 읽은 todo_group: [" + group + "]"); // ★★★★★ 이 값이 어떻게 나오는지 확인!
                            System.out.println("==========================\n");
                        }
                    }
                }
            }
            
            System.out.println("5. 모든 테스트 완료. 롤백을 실행합니다.");
            conn.rollback();

        } catch (Exception e) {
            System.err.println("테스트 중 에러 발생!");
            e.printStackTrace();
             try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
        } finally {
            try { if(conn != null) conn.close(); } catch(Exception e) {}
            System.out.println("====== 최종 JDBC 테스트 종료 ======");
        }
    }
}