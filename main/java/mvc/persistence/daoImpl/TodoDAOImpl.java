package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import mvc.domain.vo.TodoVO;
import mvc.persistence.dao.TodoDAO;

public class TodoDAOImpl implements TodoDAO {

    private final Connection conn;

    public TodoDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<TodoVO> findAllByUser(int acIdx) throws SQLException {
        List<TodoVO> todos = new ArrayList<>();
        String sql = "SELECT todo_idx, created_at, text, todo_group, color, ac_idx, status  "
                   + "FROM todolist WHERE ac_idx = ? ORDER BY created_at DESC";

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = this.conn.prepareStatement(sql);
            pstmt.setInt(1, acIdx);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	
                TodoVO todo = TodoVO.builder()
                        .todo_idx(rs.getInt("todo_idx"))
                        .created_at(rs.getTimestamp("created_at"))
                        .text(rs.getString("text"))
                        .todo_group(rs.getString("todo_group"))
                        .color(rs.getString("color"))
                        .ac_idx(rs.getInt("ac_idx"))
                        .status(rs.getInt("status")) 
                        .build();
                todos.add(todo);
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
        return todos;
    }
    
    @Override
    public int updateStatus(int todoIdx, int status) throws SQLException {
        String sql = "UPDATE todolist SET status = ? WHERE todo_idx = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, status);
            pstmt.setInt(2, todoIdx);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int delete(int todoIdx) throws SQLException {
        String sql = "DELETE FROM todolist WHERE todo_idx = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, todoIdx);
            return pstmt.executeUpdate();
        }
    }
    
    @Override
    public int updateTodo(TodoVO todo) throws SQLException {
        String sql = "UPDATE todolist SET text = ?, todo_group = ?, color = ? WHERE todo_idx = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, todo.getText());
            pstmt.setString(2, todo.getTodo_group());
            pstmt.setString(3, todo.getColor()); 
            pstmt.setInt(4, todo.getTodo_idx());
            return pstmt.executeUpdate();
        }
    }
    
    @Override
    public int addTodo(TodoVO todo) throws SQLException {
        // status는 기본값 0(미완료)으로, created_at은 DB 기본값(SYSDATE)으로 자동 생성되도록 합니다.
        // todo_seq는 Oracle의 시퀀스 예시입니다.
        String sql = "INSERT INTO todolist (todo_idx, text, ac_idx, status, created_at, todo_group, color) VALUES (todolist_seq.NEXTVAL, ?, ?, 0, SYSDATE,?,?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, todo.getText());
            pstmt.setInt(2, todo.getAc_idx());
            pstmt.setString(3, todo.getTodo_group());
            pstmt.setString(4, todo.getColor());
            // INSERT, UPDATE, DELETE는 executeUpdate()를 사용합니다.
            // 성공적으로 추가된 행(row)의 개수를 반환합니다. (보통 1)
            return pstmt.executeUpdate();
        }
    }
}
