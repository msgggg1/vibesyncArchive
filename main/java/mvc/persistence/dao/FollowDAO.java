package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.SidebarDTO;
import mvc.domain.vo.UserSummaryVO;

public interface FollowDAO {
	
	// 팔로워 목록 : 유저를 팔로우하는 사용자 정보
	List<UserSummaryVO> userFollowerList(int ac_idx);
	
	// 팔로잉 목록 : 유저가 팔로우하고 있는 사용자 정보
	List<UserSummaryVO> userFollowingList(int ac_idx);
	
	// 팔로잉 목록 : 유저가 팔로우하고 있는 사용자 ID
	List<Integer> userFollowingIdList(int ac_idx);
	
	// 전체 카테고리의 인기 유저 조회
	List<UserSummaryVO> findPopularUsers(int limit) throws SQLException;
    
	// 특정 카테고리의 인기 유저 조회
	List<UserSummaryVO> findPopularUsersByCategory(int categoryIdx, int limit) throws SQLException;
	
	// 팔로우 관계를 추가
    int addFollow(int followerAcIdx, int followingAcIdx) throws SQLException;

    // 팔로우 관계를 제거
    int removeFollow(int followerAcIdx, int followingAcIdx) throws SQLException;

    // 특정 사용자가 다른 사용자를 팔로우하고 있는지 확인
    boolean isFollowing(int followerAcIdx, int followingAcIdx) throws SQLException;
    
    // 특정 사용자를 팔로우하는 총 팔로워 수를 조회합니다.
    int getFollowerCount(int userAcIdx) throws SQLException;

    // 특정 사용자가 팔로우하고 있는 총 사용자 수를 조회합니다.
    int getFollowingCount(int userAcIdx) throws SQLException;
    
}
