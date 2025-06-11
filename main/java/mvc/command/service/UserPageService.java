package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.dto.UserPageDataDTO;
import mvc.domain.dto.UserPageInfoDTO;
import mvc.domain.vo.UserSummaryVO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.FollowDAO; // 실제 경로로
import mvc.persistence.dao.NoteDAO;   // 실제 경로로
import mvc.persistence.dao.UserDAO;
import mvc.persistence.daoImpl.FollowDAOImpl; // 실제 경로로
import mvc.persistence.daoImpl.NoteDAOImpl;   // 실제 경로로
import mvc.persistence.daoImpl.UserDAOImpl;

public class UserPageService {

    private static final int PAGE_SIZE = 9; // 한 번에 로드할 게시글 수
    
    Connection conn = null;

    public UserPageDataDTO getUserPageData(int profileUserAcIdx, Integer loggedInUserAcIdx, int pageNumber) throws SQLException {
        Connection conn = null;
        UserPageDataDTO pageData = new UserPageDataDTO();
        UserPageInfoDTO userProfileInfo = null;
        UserSummaryVO basicUserInfo = null; // UserDAO에서 받을 기본 정보 UserVO
        List<NoteSummaryDTO> posts = null;
        boolean hasMorePosts = false;
        // boolean autoCommitOriginalState = true; // 현재 코드에서는 트랜잭션 수동 관리가 주석처리 되어있음

        try {
            conn = ConnectionProvider.getConnection(); 

            UserDAO userDAO = new UserDAOImpl(conn);
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            FollowDAO followDAO = new FollowDAOImpl(conn);
            // 1. 프로필 사용자의 기본 정보 조회
            basicUserInfo = userDAO.getBasicUserInfoById(profileUserAcIdx);

            if (basicUserInfo == null) {
                // 사용자가 없는 경우
                return null;
            }

            // UserVO에서 UserPageInfoDTO로 기본 정보 복사
            userProfileInfo = new UserPageInfoDTO(basicUserInfo);

            // 2. 게시글 수, 팔로워 수, 팔로잉 수 설정
            userProfileInfo.setPostCount(userDAO.getPostCount(profileUserAcIdx));
            userProfileInfo.setFollowerCount(followDAO.getFollowerCount(profileUserAcIdx));
            userProfileInfo.setFollowingCount(followDAO.getFollowingCount(profileUserAcIdx));

            // 3. 현재 로그인한 사용자가 이 프로필 사용자를 팔로우하는지 여부 설정
            if (loggedInUserAcIdx != null && loggedInUserAcIdx != profileUserAcIdx) {
                userProfileInfo.setFollowedByCurrentUser(followDAO.isFollowing(loggedInUserAcIdx, profileUserAcIdx));
            } else {
                userProfileInfo.setFollowedByCurrentUser(false); // 본인이거나 비로그인 시
            }
            pageData.setUserProfile(userProfileInfo); // 완성된 UserPageInfoDTO를 pageData에 설정

            // 4. 사용자의 게시글 목록 조회 (페이징)
            int offset = (pageNumber - 1) * PAGE_SIZE;
            posts = noteDAO.getPostsByUser(profileUserAcIdx, offset, PAGE_SIZE);
            pageData.setPosts(posts);

            // 5. 더 많은 게시글이 있는지 확인
            int totalPosts = userProfileInfo.getPostCount();
            if ((offset + posts.size()) < totalPosts) {
                hasMorePosts = true;
            }
            pageData.setHasMorePosts(hasMorePosts);
            pageData.setNextPageNumber(pageNumber + 1);

        } catch (SQLException e) { // NamingException도 함께 처리하거나, throws에 추가
            throw e;
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            if (conn != null) {
                try {
                    conn.close(); 
                } catch (SQLException e) {
                    e.printStackTrace(); 
                }
            }
        }
        return pageData;
    }

    // 무한 스크롤로 추가 게시글 로드 시 사용될 수 있는 메소드
    public List<NoteSummaryDTO> getMorePosts(int profileUserAcIdx, int pageNumber) throws SQLException {
        Connection conn = null;
        List<NoteSummaryDTO> posts = null;
        try {
            conn = ConnectionProvider.getConnection();
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            int offset = (pageNumber - 1) * PAGE_SIZE;
            posts = noteDAO.getPostsByUser(profileUserAcIdx, offset, PAGE_SIZE);
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
            if (conn != null) conn.close();
        }
        return posts;
    }
}