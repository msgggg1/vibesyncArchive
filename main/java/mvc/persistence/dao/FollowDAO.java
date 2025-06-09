package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.SidebarDTO;
import mvc.domain.vo.UserVO;

public interface FollowDAO {
	
	// 팔로우 목록
	List<UserVO> userFollowList(int ac_idx);
	
	// 팔로잉 목록
	List<UserVO> userFollowingList(int ac_idx);
	
	// 전체 카테고리의 인기 유저 조회
	List<UserVO> findPopularUsers(int limit) throws SQLException;
    
	// 특정 카테고리의 인기 유저 조회
	List<UserVO> findPopularUsersByCategory(int categoryIdx, int limit) throws SQLException;
	
	// 팔로우 관계를 추가
    int addFollow(int followerAcIdx, int followingAcIdx) throws SQLException;

    // 팔로우 관계를 제거
    int removeFollow(int followerAcIdx, int followingAcIdx) throws SQLException;

    // 특정 사용자가 다른 사용자를 팔로우하고 있는지 확인
    boolean isFollowing(int followerAcIdx, int followingAcIdx) throws SQLException;
    
    SidebarDTO getFollowingList(int acFollow);
}
