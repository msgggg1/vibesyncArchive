package mvc.command.service;

import mvc.persistence.dao.UserDAO;
import mvc.persistence.daoImpl.UserDAOImpl;

import java.sql.Connection;

import com.util.ConnectionProvider;

import mvc.domain.dto.LoginDTO;
import mvc.domain.vo.UserVO;

public class LoginService {

    // 로그인 : 이메일, 비밀번호 활용
	public UserVO login(LoginDTO dto) throws Exception {
		UserVO userVO = null;
		
		Connection conn = null;
		
		try {
    		conn = ConnectionProvider.getConnection();
            
            UserDAO userDAO = new UserDAOImpl(conn);
            
            // 로그인
            userVO = userDAO.login(dto);
            
		} catch (Exception e) {
        	e.printStackTrace();
		} finally {
			if (conn != null) conn.close();
		}
		
        return userVO;
    }
	
	// 자동로그인 : 쿠키의 사용자 이메일 정보 활용
	public UserVO autoLogin(String email) throws Exception {
		UserVO userVO = null;
		
		Connection conn = null;
		
		try {
    		conn = ConnectionProvider.getConnection();
            
            UserDAO userDAO = new UserDAOImpl(conn);
            
            // 이메일로 로그인
            userVO = userDAO.findByEmail(email);
            
		} catch (Exception e) {
        	e.printStackTrace();
		} finally {
			if (conn != null) conn.close();
		}
		
        return userVO;
    }
}
