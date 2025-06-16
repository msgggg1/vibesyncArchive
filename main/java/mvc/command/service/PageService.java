package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.domain.dto.PageResultDTO;
import mvc.domain.vo.NoteVO;    // 추가
import mvc.domain.vo.PageVO;
import mvc.persistence.dao.ListDAO;
import mvc.persistence.daoImpl.ListDAOImpl;

public class PageService {
    private static final int DEFAULT_PAGE_SIZE = 10;

    /**
     * 페이징·검색 조건에 맞는 결과를 반환한다.
     */
    public PageResultDTO getPageResult(int page, int size, String searchType, String keyword)
            throws SQLException {
        int offset = (page - 1) * size;
        List<PageVO> fullList;
        int totalCount;

        try (Connection conn = ConnectionProvider.getConnection()) {
            ListDAO dao = new ListDAOImpl(conn);
            totalCount = dao.selectCount(searchType, keyword);
            fullList = dao.selectAll(searchType, keyword);
        } catch (NamingException e) {
            throw new SQLException("DB 연결 오류", e);
        }

        int fromIndex = Math.min(offset, fullList.size());
        int toIndex = Math.min(offset + size, fullList.size());
        List<PageVO> pageList = fullList.subList(fromIndex, toIndex);
        return new PageResultDTO(pageList, totalCount, fullList);
    }

    /**
     * AJAX용: 특정 userPg_idx 의 노트 리스트를 반환한다.
     */
    public List<NoteVO> getNotesByPage(int userPgIdx) throws SQLException {
        try (Connection conn = ConnectionProvider.getConnection()) {
            ListDAO dao = new ListDAOImpl(conn);
            return dao.selectNotesByPage(userPgIdx);
        } catch (NamingException e) {
            throw new SQLException("DB 연결 오류", e);
        }
    }
}
