package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.dto.UserDTO;
import mvc.domain.vo.UserVO;
import mvc.domain.vo.UserVO;

public interface UserDAO {
	
	// 회원가입
	boolean insertUser(SignUpDTO dto);
	
	// 로그인
	UserVO login(LoginDTO dto);
	
	// 이메일로 계정 정보 조회
	UserVO findByEmail(String email);
	
	// 회원가입 시 중복 검사 : 닉네임, 이메일 한번에
	String[] duplicateTest(String nickname, String email);
	
	// 닉네임 중복 검사
	boolean isNicknameExists(String nickname);
	
	// 이메일 중복 검사
	boolean isEmailExists(String email);
	
	//////회원 활동 관련
	int preferredCategoryIdx(int acIdx) throws SQLException;
    // List<UserVO> findPopularUsers(int limit) throws SQLException; -> FollowDAO에서 구현?
    
    //특정 사용자의 기본 프로필 정보 (ID, 닉네임, 프로필 이미지 경로)를 조회.
    UserDTO getBasicUserInfoById(int acIdx) throws SQLException;

    //특정 사용자가 작성한 총 게시글 수를 조회
    int getPostCount(int userAcIdx) throws SQLException;

    // 특정 사용자를 팔로우하는 총 팔로워 수를 조회합니다.
    int getFollowerCount(int userAcIdx) throws SQLException;

    // 특정 사용자가 팔로우하고 있는 총 사용자 수를 조회합니다.
    int getFollowingCount(int userAcIdx) throws SQLException;
    
    // followerAcIdx가 followingAcIdx를 팔로우하고 있는지 확인
    boolean isFollowing(int followerAcIdx, int followingAcIdx) throws SQLException;
    
}