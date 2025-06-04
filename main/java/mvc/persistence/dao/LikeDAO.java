package mvc.persistence.dao;

import java.sql.Connection;
import java.sql.SQLException;

public interface LikeDAO {

    
    //게시글에 좋아요를 추가
    int addLike(Connection conn, int acIdx, int noteIdx) throws SQLException;

    
    // 게시글의 좋아요를 제거
    int removeLike(Connection conn, int acIdx, int noteIdx) throws SQLException;

    // 특정 사용자가 특정 게시글을 좋아하는지 확인
    boolean isLiked(Connection conn, int acIdx, int noteIdx) throws SQLException;

    // 게시글의 총 좋아요 수를 계산
    int getLikesCountForNote(Connection conn, int noteIdx) throws SQLException;
}
