package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException; 
import java.util.List;

import com.util.ConnectionProvider;
import mvc.domain.vo.TodoVO;
import mvc.persistence.dao.TodoDAO;
import mvc.persistence.daoImpl.TodoDAOImpl;

public class TodoService {

    // 데이터를 조회만 하는 메소드는 트랜잭션 처리가 필요 없습니다. (기존 코드 유지)
    public List<TodoVO> getTodoListByUser(int acIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            TodoDAO todoDAO = new TodoDAOImpl(conn);
            return todoDAO.findAllByUser(acIdx);
        } finally {
            if (conn != null) conn.close();
        }
    }
    
    // 데이터를 변경하는 메소드에는 트랜잭션 처리가 반드시 필요합니다.
    public boolean updateTodoStatus(int todoIdx, boolean isCompleted) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // ★ 1. 트랜잭션 시작 (Auto-commit 해제)

            TodoDAO todoDAO = new TodoDAOImpl(conn);
            int status = isCompleted ? 1 : 0;
            int updatedRows = todoDAO.updateStatus(todoIdx, status);

            if (updatedRows > 0) {
                conn.commit(); // ★ 2. 성공 시 최종 저장 (커밋)
                return true;
            } else {
                conn.rollback(); // 업데이트된 행이 없으면 롤백
                return false;
            }
        } catch (SQLException e) {
            if (conn != null) conn.rollback(); // ★ 3. 에러 발생 시 모든 변경사항 취소 (롤백)
            throw e; // 예외를 다시 던져서 상위 계층에 알림
        } finally {
            if (conn != null) conn.close(); // ★ 4. 작업이 끝나면 커넥션 반납
        }
    }

    // 데이터를 삭제하는 메소드에도 똑같이 트랜잭션 처리를 적용합니다.
    public boolean deleteTodo(int todoIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // ★ 1. 트랜잭션 시작

            TodoDAO todoDAO = new TodoDAOImpl(conn);
            int deletedRows = todoDAO.delete(todoIdx);

            if (deletedRows > 0) {
                conn.commit(); // ★ 2. 성공 시 최종 저장
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            if (conn != null) conn.rollback(); // ★ 3. 에러 발생 시 롤백
            throw e;
        } finally {
            if (conn != null) conn.close(); // ★ 4. 커넥션 반납
        }
    }
    
    public boolean addTodo(TodoVO todo) throws Exception {
        Connection conn = null;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            TodoDAO todoDAO = new TodoDAOImpl(conn);
            int addedRows = todoDAO.addTodo(todo);

            if (addedRows > 0) {
                conn.commit(); // 성공 시 DB에 최종 반영
                return true;
            } else {
                conn.rollback(); // 추가된 행이 없으면 롤백
            }
        } catch (Exception e) {
            if (conn != null) conn.rollback(); // 에러 발생 시 롤백
            throw e; // 예외를 상위로 던져서 문제 인지시키기
        } finally {
            if (conn != null) conn.close(); // 커넥션 반납
        }
        return false;
    }
    
    public boolean updateTodo(TodoVO todo) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);
            TodoDAO todoDAO = new TodoDAOImpl(conn);
            int result = todoDAO.updateTodo(todo);
            if (result > 0) {
                conn.commit();
                return true;
            }
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
        return false;
    }
}