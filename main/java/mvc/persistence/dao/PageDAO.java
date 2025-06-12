package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import mvc.domain.vo.PageVO;

public interface PageDAO {
    /**
     * 전체 페이지 조회
     * @return 페이지 목록
     * @throws SQLException
     */
    List<PageVO> pageAll(int useridx) throws SQLException;

    /**
     * 페이지 생성
     * created_at은 DB DEFAULT 사용, re_userPg_idx는 null 기본값 처리
     * @param page 생성할 PageVO
     * @throws SQLException
     */
    void createPage(PageVO page) throws SQLException;

    /**
     * 페이지 수정
     * @param page 수정할 PageVO
     * @throws SQLException
     */
    void updatePage(PageVO page) throws SQLException;

    /**
     * 페이지 삭제
     * @param userPg_idx 삭제할 페이지 식별자
     * @throws SQLException
     */
    void deletePage(int userPg_idx) throws SQLException;
}  