package mvc.persistence;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.NoteVO;

public interface NoteDAO {
	List<NoteVO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
    List<NoteVO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException;
	List<NoteVO> recentAllNotes(int limit) throws SQLException;
}
