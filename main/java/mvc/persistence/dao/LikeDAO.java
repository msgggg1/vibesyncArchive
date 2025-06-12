package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.DailyStatsDTO;

public interface LikeDAO {

    //게시글에 좋아요를 추가
    int addLike(int acIdx, int noteIdx) throws SQLException;
    
    // 게시글의 좋아요를 제거
    int removeLike(int acIdx, int noteIdx) throws SQLException;

    // 특정 사용자가 특정 게시글을 좋아하는지 확인
    boolean isLiked(int acIdx, int noteIdx) throws SQLException;

    // 게시글의 총 좋아요 수를 계산
    int getLikesCountForNote(int noteIdx) throws SQLException;
    
    // 여러 게시글의 좋아요 수 합산
    int getLikesCountForMultipleNotes(List<Integer> noteIdxList) throws SQLException;
    
    // 특정 사용자의 최근 N일간의 일별 게시글 좋아요 수 (일별 통계)
    List<DailyStatsDTO> getDailyLikeCountsForUserPosts(int acIdx, int days) throws SQLException;
}
