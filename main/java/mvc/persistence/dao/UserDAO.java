package mvc.persistence.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import mvc.domain.UserVO;
import mvc.domain.dto.UserDTO;
import mvc.domain.dto.UserPageInfoDTO;

public interface UserDAO {
	int preferredCategoryIdx(int acIdx) throws SQLException;
    List<UserVO> findPopularUsers(int limit) throws SQLException;
    
    //특정 사용자의 기본 프로필 정보 (ID, 닉네임, 프로필 이미지 경로)를 조회.
    UserDTO getBasicUserInfoById(Connection conn, int acIdx) throws SQLException;

    //특정 사용자가 작성한 총 게시글 수를 조회
    int getPostCount(Connection conn, int userAcIdx) throws SQLException;

    // 특정 사용자를 팔로우하는 총 팔로워 수를 조회합니다.
    int getFollowerCount(Connection conn, int userAcIdx) throws SQLException;

    // 특정 사용자가 팔로우하고 있는 총 사용자 수를 조회합니다.
    int getFollowingCount(Connection conn, int userAcIdx) throws SQLException;
	
}
