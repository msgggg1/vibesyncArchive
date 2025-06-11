package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.WatchPartyDTO;
import mvc.domain.vo.WatchPartyVO;

public interface WatchPartyDAO {

	// 1) 전체 WatchParty 목록 조회 (비로그인 / 비호스트 시)
	public List<WatchPartyVO> selectAll();
	
	// 2) 특정 호스트의 WatchParty 목록 조회
	public List<WatchPartyVO> selectByHost(int hostIdx);
	
	// 3) 새로운 WatchParty 삽입
	public int insert(WatchPartyVO wp);
	
	// 4) 단일 WatchParty 조회 (watch.jsp에서 영상 재생 시)
	public WatchPartyVO selectOne(int watchPartyIdx);
	
	// 5) ???
	public WatchPartyVO selectLatestByUniqueFields(String title, String videoId, int host);
	
	// 6) 여러 명의 호스트의 WatchParty 목록 조회
	public List<WatchPartyDTO> selectWatchPartyListByHostId(List<Integer> hostList) throws SQLException;
	
}
