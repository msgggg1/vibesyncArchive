package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.domain.dto.WatchPartyDTO;
import mvc.domain.vo.UserSummaryVO;
import mvc.persistence.dao.FollowDAO;
import mvc.persistence.dao.WatchPartyDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;
import mvc.persistence.daoImpl.WatchPartyDAOImpl;

public class WatchPartyService {

	public List<WatchPartyDTO> getFollowingWatchPartyList(int acIdx) {
		List<WatchPartyDTO> followingWatchParties = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			FollowDAO followDAO = new FollowDAOImpl(conn);
			List<Integer> followingUsers = followDAO.userFollowingIdList(acIdx);
			
			WatchPartyDAO watchPartyDAO = new WatchPartyDAOImpl(conn);
			followingWatchParties = watchPartyDAO.selectWatchPartyListByHostId(followingUsers);
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return followingWatchParties;
	}

}
