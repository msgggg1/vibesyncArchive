package mvc.command.Service;

import java.sql.SQLException;

import mvc.domain.dto.NoteDetailDTO; 
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.NoteDAOImpl; 

public class NoteService { 

	private NoteDAO noteDAO; 


	public NoteService() {
		this.noteDAO = new NoteDAOImpl(); 
	}

	public NoteService(NoteDAO noteDAO) {
		this.noteDAO = noteDAO;
	}

	// 특정 게시글의 상세 정보 가져오기
	public NoteDetailDTO getNoteDetailById(int noteIdx) {
		NoteDetailDTO noteDetail = null;
        try {
            // 먼저 게시글의 조회수를 증가.
            noteDAO.increaseViewCount(noteIdx);
            noteDetail = noteDAO.printNote(noteIdx);

            if (noteDetail == null) {
                System.out.println("Service: 게시글 ID " + noteIdx + "에 해당하는 데이터를 찾을 수 없습니다 (조회수 증가 시도 후).");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null; 
        }
        return noteDetail;
    }

}
