package mvc.command.service;

import mvc.persistence.dao.UserDAO;
import mvc.persistence.daoImpl.UserDAOImpl;
import mvc.domain.dto.LoginDTO;
import mvc.domain.vo.UserVO;

public class LoginService_KYJ {
    private UserDAO userDAO;

    public LoginService_KYJ(UserDAO userDAO) {
    	this.userDAO = userDAO;
	}

    // 로그인 : 이메일, 비밀번호 활용
	public UserVO login(LoginDTO dto) throws Exception {
		UserVO userSessionVO = null;
		userSessionVO = userDAO.login(dto);
		
        return userSessionVO;
    }
	
	// 자동로그인 : 쿠키의 사용자 이메일 정보 활용
	public UserVO autoLogin(String email) throws Exception {
		UserVO userSessionVO = null;
		userSessionVO = userDAO.findByEmail(email);
		
        return userSessionVO;
    }
}
