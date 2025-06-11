package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.util.ConnectionProvider;

import mvc.domain.dto.MainPageDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.vo.UserSummaryVO;
import mvc.persistence.dao.FollowDAO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;
import mvc.persistence.daoImpl.NoteDAOImpl;

public class MainPageService {

    public MainPageDTO loadMainPage(int preferredCategory) {
    	MainPageDTO mainPageDTO = null;
    	
    	List<NoteSummaryDTO> latestNotes = null; // 선호 카테고리 - 최신글
    	List<NoteSummaryDTO> popularNotesByMyCategory = null; // 선호 카테고리 - 인기글
    	List<UserSummaryVO> popularUsers = null; // 선호 카테고리 - 인기유저
    	Map<Integer, List<NoteSummaryDTO>> popularNotesNotByMyCategory = null; // 비선호 카테고리 인기글
    	
    	// 전체 카테고리 인기글
    	Map<Integer, List<NoteSummaryDTO>> popularNotes = null;
    	
    	Connection conn = null;
    	
		try {
    		conn = ConnectionProvider.getConnection();
            
            NoteDAO noteDAO = new NoteDAOImpl(conn);
    		FollowDAO followDAO = new FollowDAOImpl(conn);
            
			popularNotes = noteDAO.popularNoteByAllCategory(5);
			
			latestNotes = noteDAO.recentNoteByMyCategory(preferredCategory, 5);
			popularUsers = followDAO.findPopularUsersByCategory(preferredCategory, 5);
			popularNotesNotByMyCategory = new LinkedHashMap<Integer, List<NoteSummaryDTO>>(popularNotes);
			popularNotesByMyCategory = popularNotesNotByMyCategory.remove(preferredCategory);
            
			mainPageDTO = MainPageDTO.builder()
						            .latestNotes(latestNotes)
						            .popularNotes(popularNotesByMyCategory)
						            .popularUsers(popularUsers)
						            .popularNotesNotByMyCategory(popularNotesNotByMyCategory)
						            .build();
		} catch (Exception e) {
        	e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		
        return mainPageDTO;
    }
	
}
