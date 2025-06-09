package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.SidebarDTO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.FollowDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;

public class SidebarService {

    public SidebarDTO loadSidebar(int ac_idx) {
    	SidebarDTO sidebarDTO = null;
    	
    	List<UserVO> followingList = null;
    	
    	Connection conn = null;
    	
    	try {
			conn = ConnectionProvider.getConnection();
			
			FollowDAO followDAO = new FollowDAOImpl(conn);
			followingList = followDAO.userFollowingList(ac_idx);
			
			sidebarDTO = new SidebarDTO().builder()
										 .followingList(followingList)
										 .build();
			
		} catch (SQLException e) {
		    System.err.println("[SidebarService] DB 오류 발생: " + e.getMessage());
		    throw new RuntimeException("사이드바 로딩 실패", e);
		} catch (NamingException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
    	
    	return sidebarDTO;
    }
	
}
