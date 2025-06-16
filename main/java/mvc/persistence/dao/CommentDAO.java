package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import mvc.domain.vo.CommentVO;

public interface CommentDAO {
    // 특정 노트의 모든 댓글 조회
    List<CommentVO> getCommentsByNoteId(int note_idx) throws SQLException;
    
    // [추가] ID로 특정 댓글 정보 조회
    CommentVO getCommentById(int commentlist_idx) throws SQLException;
    
    // 새 댓글 추가
    void addComment(CommentVO comment) throws SQLException;
    
    // 댓글 수정
    void updateComment(int commentlist_idx, String text) throws SQLException;
    
    // 댓글 삭제
    void deleteComment(int commentlist_idx) throws SQLException;
}