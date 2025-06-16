package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import mvc.domain.dto.DailyStatsDTO;
import mvc.domain.dto.NoteDetailDTO;
import mvc.domain.dto.NoteListDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.vo.UserNoteVO;

public interface NoteDAO {
	// [신규] 카테고리, 검색, 페이징을 적용하여 게시물 목록 조회
    List<NoteListDTO> selectNotes(int categoryIdx, int offset, int limit, String searchType, String keyword) throws SQLException;
    
    // [신규] 카테고리, 검색을 적용하여 전체 게시물 수 조회
    int selectNoteCount(int categoryIdx, String searchType, String keyword) throws SQLException;
	
	// 전체 카테고리 - 인기글
	Map<Integer, List<NoteSummaryDTO>> popularNoteByAllCategory(int limit) throws SQLException;
	
    // 선호 카테고리 - 최신글
    List<NoteSummaryDTO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException;

    // 선호 카테고리 - 인기글
    List<NoteSummaryDTO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
 	
 	// 포스트 뷰 출력 2
 	UserNoteVO getUserNoteById(int noteIdx);
    
    // 포스트 뷰 출력
 	NoteDetailDTO printNote(int noteIdx);

 	// 조회수 증가 **********안쓰면 확인 후 삭제
 	void increaseViewCount(int noteIdx) throws SQLException; 
 	
 	// 특정 사용자가 작성한 게시글 목록을 페이징 처리하여 조회. (최신순 정렬)
    List<NoteSummaryDTO> getPostsByUser(int userAcIdx, int offset, int limit) throws SQLException;

	/* 워크스페이스 */
	// 특정 사용자가 작성한 글 인기순으로 가져오기 (미리보기용)
	List<NoteSummaryDTO> findMyPostsByPopularity(int acIdx) throws SQLException;

	// 특정 사용자가 작성한 글 전체 목록 인기순으로 가져오기 (모달용)
	List<NoteSummaryDTO> findAllMyPostsByPopularity(int acIdx) throws SQLException;

	// 좋아요한 글 (미리보기)
	List<NoteSummaryDTO> findLikedPostsByRecent(int acIdx) throws SQLException;

	// 좋아요한 글 (전체)
	List<NoteSummaryDTO> findAllLikedPostsByRecent(int acIdx) throws SQLException;
     
    // 특정 사용자가 작성한 게시글 조회수 총합
    int getViewCountsForNotesAllByUser(int userAcIdx) throws SQLException;
    
    // 특정 사용자가 작성한 게시글 note_idx 조회
    List<Integer> getNoteIdxListByUser(int userAcIdx) throws SQLException;
    
    // 게시글들의 조회수 총합 조회
    int getViewCountsForMultipleNotes(List<Integer> noteIdx) throws SQLException;
    
    // 특정 사용자의 최근 N일간의 일별 게시글 작성수 (일별 통계)
    List<DailyStatsDTO> getDailyPostCounts(int acIdx, int days) throws SQLException;
    
    // 특정 사용자의 최근 N주간의 주별 게시글 작성수 (주별 통계)
    List<DailyStatsDTO> getWeeklyPostCounts(int acIdx, int weeks) throws SQLException;
    
    // 특정 사용자의 최근 N달간의 월별 게시글 작성수 (월별 통계)
    List<DailyStatsDTO> getMonthlyPostCounts(int acIdx, int months) throws SQLException;
    
    // 특정 사용자의 최근 N년간의 연도별 게시글 작성수 (연도별 통계)
    List<DailyStatsDTO> getYearlyPostCounts(int acIdx, int years) throws SQLException;
    
    // 특정 사용자의 최근 N주간의 일별 게시글 조회수 (일별 통계)
    List<DailyStatsDTO> getDailyViewCounts(int acIdx, int days) throws SQLException;
    
    // 특정 사용자의 최근 N일간의 주별 게시글 조회수 (주별 통계)
    List<DailyStatsDTO> getWeeklyViewCounts(int acIdx, int weeks) throws SQLException;
    
    // 특정 사용자의 최근 N달간의 월별 게시글 조회수 (월별 통계)
    List<DailyStatsDTO> getMonthlyViewCounts(int acIdx, int months) throws SQLException;
    
    // 특정 사용자의 최근 N년간의 연도별 게시글 조회수 (연도별 통계)
    List<DailyStatsDTO> getYearlyViewCounts(int acIdx, int years) throws SQLException;
    
}