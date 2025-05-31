package mvc.persistence;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.UserVO;

public interface UserDAO {
	int preferredCategoryIdx(int acIdx) throws SQLException;
    List<UserVO> findPopularUsers(int limit) throws SQLException;
}
