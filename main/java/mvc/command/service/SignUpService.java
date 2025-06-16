package mvc.command.service;

import java.sql.Connection;

import com.util.ConnectionProvider;

import mvc.domain.dto.SignUpDTO;
import mvc.persistence.dao.UserDAO;
import mvc.persistence.daoImpl.UserDAOImpl;

public class SignUpService {

    public boolean register(SignUpDTO dto) throws Exception {
    	boolean isRegisterd = false;
    	
    	Connection conn = null;
    	String[] duplicateTest = null;
    	
		conn = ConnectionProvider.getConnection();
        conn.setAutoCommit(false);

        // 유저의 정보를 실제 JDBC에 CRUD 하는 기능들을 담당하는 DAO 클래스 : UserDAO, UserDAOImpl
        UserDAO userDAO = new UserDAOImpl(conn);
        
        // 닉네임, 이메일 중복 검사
        duplicateTest = userDAO.duplicateTest(dto.getNickname(), dto.getEmail());
        
        if (duplicateTest == null) { // 중복되는 닉네임, 이메일 없음
        	// 회원가입
        	isRegisterd = userDAO.insertUser(dto);
        	conn.commit();
        	
        } else {
        	String nickname = duplicateTest[0];
        	String email = duplicateTest[1];
        	
        	if (nickname != null && email != null) {
        		throw new IllegalArgumentException(String.format("닉네임 [%s]이 이미 사용 중입니다.<br>이미 가입한 정보가 존재하는 이메일입니다.", nickname));
        	} else if (nickname != null) {
        		throw new IllegalArgumentException(String.format("[%s]는 이미 사용 중인 닉네임입니다.", nickname));
        	} else if (email != null) {
        		throw new IllegalArgumentException("이미 가입한 정보가 존재하는 이메일입니다.");
        	}
        }
    	
        if (conn != null) conn.close();
    	
    	return isRegisterd;
    }
}
