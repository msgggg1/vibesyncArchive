package mvc.command.service;

import mvc.domain.dto.SignUpDTO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.UserDAO;

public class SignUpService_KYJ {
	
    private UserDAO userAccountDAO;

    public SignUpService_KYJ(UserDAO userAccountDAO) {
        this.userAccountDAO = userAccountDAO;
    }

    public UserVO register(SignUpDTO dto) {
    	UserVO userInfo = null;
    	
    	Boolean isNicknameExists = userAccountDAO.isNicknameExists(dto.getNickname());
    	Boolean isEmailExists = userAccountDAO.isEmailExists(dto.getEmail());
    	
    	if (isNicknameExists || isEmailExists) {
    		if (isNicknameExists) throw new IllegalArgumentException("이미 사용 중인 닉네임입니다.");
    		if (isEmailExists) throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
    	} else {
    		userInfo = userAccountDAO.insertUser(dto);
    	}
    	
    	return userInfo;
    }
}
