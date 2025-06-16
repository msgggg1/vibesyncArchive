package mvc.command.service;

import java.sql.Connection;
import java.util.List; 

import com.util.ConnectionProvider;
import mvc.domain.dto.NoteListDTO;
import mvc.domain.dto.NotePageResultDTO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.NoteDAOImpl;

public class ListService {

    public NotePageResultDTO getNoteListPage(int categoryIdx, int page, int size, String searchType, String keyword) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            NoteDAO dao = new NoteDAOImpl(conn);

            // 1. 전체 게시물 수 조회
            int totalCount = dao.selectNoteCount(categoryIdx, searchType, keyword);

            // 2. 페이징 처리된 게시물 목록 조회
            int offset = (page - 1) * size;
            List<NoteListDTO> list = dao.selectNotes(categoryIdx, offset, size, searchType, keyword);

            // 3. 페이징 결과 DTO 생성
            return new NotePageResultDTO(totalCount, page, size, list);
        }
    }
}