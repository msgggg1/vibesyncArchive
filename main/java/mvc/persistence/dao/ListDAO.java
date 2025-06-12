package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import mvc.domain.vo.PageVO;
import mvc.domain.vo.NoteVO;  // 추가

public interface ListDAO {
    /**
     * 검색 조건에 맞는 전체 게시물 수를 반환한다.
     */
    int selectCount(String searchType, String keyword) throws SQLException;

    /**
     * 검색 조건에 맞는 전체 PageVO 리스트를 반환한다.
     * DB에서 페이징이 아닌 전체를 조회한다.
     */
    List<PageVO> selectAll(String searchType, String keyword) throws SQLException;

    /**
     * 특정 userPg_idx 에 속한 모든 노트를 반환한다.
     */
    List<NoteVO> selectNotesByPage(int userPgIdx) throws SQLException;  // 추가
}
