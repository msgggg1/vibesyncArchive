package mvc.persistence.dao;

import java.sql.Connection;
import java.sql.SQLException;

public interface FollowDAO {

    // 팔로우 관계를 추가
    int addFollow(Connection conn, int followerAcIdx, int followingAcIdx) throws SQLException;

    // 팔로우 관계를 제거
    int removeFollow(Connection conn, int followerAcIdx, int followingAcIdx) throws SQLException;

    // 특정 사용자가 다른 사용자를 팔로우하고 있는지 확인
    boolean isFollowing(Connection conn, int followerAcIdx, int followingAcIdx) throws SQLException;
}