package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import mvc.domain.dto.NoteDetailDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.vo.NoteVO;

public interface NoteDAO {
	
	// 전체 카테고리 - 인기글
	Map<Integer, List<NoteVO>> popularNoteByAllCategory(int limit) throws SQLException;
	
    // 선호 카테고리 - 최신글
    List<NoteVO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException;

    // 선호 카테고리 - 인기글
    List<NoteVO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
    
    // 포스트 뷰 출력
 	NoteDetailDTO printNote(int noteIdx);
 	
 	// 조회수 증가
 	void increaseViewCount(int noteIdx) throws SQLException; 
 	
 	// 특정 사용자가 작성한 게시글 목록을 페이징 처리하여 조회. (최신순 정렬)
     List<NoteSummaryDTO> getPostsByUser(int userAcIdx, int offset, int limit) throws SQLException;
     

}