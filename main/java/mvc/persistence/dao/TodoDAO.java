package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import mvc.domain.vo.TodoVO;

public interface TodoDAO {
    
     //특정 사용자의 모든 할 일 목록을 조회
    public List<TodoVO> findAllByUser(int acIdx) throws SQLException;
    
    // 상태 업데이트
    int updateStatus(int todoIdx, int status) throws SQLException; 
    // 삭제
    int delete(int todoIdx) throws SQLException; 
    
    int addTodo(TodoVO todo) throws SQLException;
    
    int updateTodo(TodoVO todo) throws SQLException;
}