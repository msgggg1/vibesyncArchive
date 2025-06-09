package mvc.persistence.daoImpl;

import java.net.ConnectException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.PasswordMigrator;

import mvc.domain.dto.LoginDTO;
import mvc.domain.dto.SignUpDTO;
import mvc.domain.vo.UserVO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.UserDAO;

public class UserDAOImpl_KYJ implements UserDAO {
    private Connection conn = null;
    private PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // 생성자
    public UserDAOImpl_KYJ(Connection conn) {
    	this.conn = conn;
    }

    // 회원가입
    @Override
    public UserVO insertUser(SignUpDTO dto) {
    	UserVO userInfo = null;
    	
    	Connection conn = null;
        PreparedStatement pstmt = null;
    	
    	String sql = "INSERT INTO userAccount " + 
    				 "(ac_idx, email, pw, nickname, img, name, created_at, salt, category_idx) " +
    				 " VALUES (useraccount_seq.nextval, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?, ?) ";
    	
    	try {
    		conn = ConnectionProvider.getConnection();
    		pstmt = conn.prepareStatement(sql);
    		
    		String email = dto.getEmail();
    		String hashedPw = null;
    		String nickname = dto.getNickname();
    		String img = null;
    		String name = dto.getName();
    		String salt = null;
    		int category_idx = 1;
    		
    		try {
    			salt = PasswordMigrator.generateSalt();
    			hashedPw = PasswordMigrator.hashPassword(dto.getPassword(), salt);
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    		
    		pstmt.setString(1, email);
    		pstmt.setString(2, hashedPw);
    		pstmt.setString(3, nickname);
    		pstmt.setString(4, img); // 기본 이미지 없음
    		pstmt.setString(5, name);
    		pstmt.setString(6, salt);
    		pstmt.setInt(7, dto.getCategory_idx());
    		
    		if (pstmt.executeUpdate() > 0) {
    			userInfo = new UserVO().builder()
    					.email(email)
    					.nickname(nickname)
    					.img(img)
    					.category_idx(category_idx)
    					.build();
    		}
    		
    	} catch (SQLException e) {
    		throw new RuntimeException("회원가입 과정에서 오류가 발생했습니다.");
    	} catch (NamingException e) {
    		throw new RuntimeException("회원가입 과정에서 오류가 발생했습니다.");
		} finally {
    		try {
    			if (pstmt != null) pstmt.close();
    			if (conn != null) conn.close();
    		} catch (Exception e) {
				e.printStackTrace();
			}
    	}
    	
    	return userInfo;
    }
    
    // 로그인
    @Override
    public UserVO login(LoginDTO dto) {
    	UserVO userInfo = null;
    	
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
    	
    	String sql = "SELECT pw, salt FROM userAccount WHERE email = ? ";
    	
    	try {
			conn = ConnectionProvider.getConnection();
    		pstmt = conn.prepareStatement(sql);
			
			String emailParam = dto.getEmail(); // 폼에서 전달된 이메일
			String pwParam = dto.getPassword(); // 폼에서 전달된 비밀번호 (평문)
	 		
			pstmt.setString(1, emailParam);
	 		rs = pstmt.executeQuery();
	 		
            if (rs.next()) { // 이메일 존재
                String storedHashedPassword = rs.getString("pw");
                String storedSalt = rs.getString("salt");
                
                String hashedInputPassword = PasswordMigrator.hashPassword(pwParam, storedSalt);

                if (hashedInputPassword != null && storedHashedPassword.equals(hashedInputPassword)) {
                	// 로그인 성공 (비밀번호 일치)
                	userInfo = this.findByEmail(emailParam);
                }
            }
		} catch (SQLException e) {
			throw new RuntimeException("로그인 과정에서 오류가 발생했습니다.");
		} catch (NamingException e) {
			throw new RuntimeException("로그인 과정에서 오류가 발생했습니다.");
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
    	
    	return userInfo;
    }
    
	// 이메일로 계정 정보 조회
	@Override
	public UserVO findByEmail(String email) {
		UserVO userInfo = null;
		
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		
		String sql = "SELECT nickname, img, category_idx FROM userAccount WHERE email = ? ";
		
		try {
			conn = ConnectionProvider.getConnection();
			pstmt = conn.prepareStatement(sql);
	 		pstmt.setString(1, email);
	 		rs = pstmt.executeQuery();
	 		
	 		if (rs.next()) {
	 			String nickname = rs.getString("nickname");
	 			String img = rs.getString("img");
	 			int category_idx = rs.getInt("category_idx");
	 			
	 			userInfo = new UserVO().builder()
	 										  .email(email)
	 										  .nickname(nickname)
	 										  .img(img)
	 										  .category_idx(category_idx)
	 										  .build();
	 		}
	 		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return userInfo;
	}
	
	// 중복 검사 : 닉네임, 이메일
	
	// 닉네임 중복 검사
	@Override
	public boolean isNicknameExists(String nickname) {
		Boolean isNicknameExists = false;
		
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		
		String sql = "SELECT COUNT(ac_idx) ac_idx FROM userAccount WHERE nickname = ? ";
		try {
			conn = ConnectionProvider.getConnection();
			pstmt = conn.prepareStatement(sql);
	 		pstmt.setString(1, nickname);
	 		rs = pstmt.executeQuery();
	 		
	 		if (rs.next()) {
	 			int ac_idx = rs.getInt("ac_idx");
	 			if (ac_idx > 0) isNicknameExists = true;
	 		}
	 		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return isNicknameExists;
	}
	
	// 이메일 중복 검사
	@Override
	public boolean isEmailExists(String email) {
		Boolean isEmailExists = false;
		
    	Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		
		String sql = "SELECT COUNT(ac_idx) ac_idx FROM userAccount WHERE email = ? ";
		try {
			conn = ConnectionProvider.getConnection();
			pstmt = conn.prepareStatement(sql);
	 		pstmt.setString(1, email);
	 		rs = pstmt.executeQuery();
	 		
	 		if (rs.next()) {
	 			int ac_idx = rs.getInt("ac_idx");
	 			if (ac_idx > 0) isEmailExists = true;
	 		}
	 		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return isEmailExists;
	}
	
	// 전체 카테고리 - 인기 유저 조회
	@Override
	public List<UserVO> findPopularUsers(int limit) throws SQLException {
		 List<UserVO> users = new ArrayList<>();
		 
	     Connection conn = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
		 
	     // 인기 유저: (받은 좋아요 수 + 팔로워 수) 합산 기준, Oracle TOP-N 쿼리
	     String sql = "SELECT nickname, img, created_at, popularity_score " +
	                " FROM ( " +
	                "    SELECT " +
	                "        ua.ac_idx, " +
	                "        ua.nickname, " +
	                "        ua.img, " +
	                "        COALESCE(follower_counts.total_followers, 0) AS popularity_score, " + // 인기도 점수를 팔로워 수로만 계산
	                "        ROW_NUMBER() OVER (ORDER BY COALESCE(follower_counts.total_followers, 0) DESC, ua.created_at DESC) as rn " +
	                "    FROM " +
	                "        userAccount ua " +
	                "    LEFT JOIN " +
	                "        (SELECT ac_following, COUNT(follows_idx) AS total_followers " +
	                "         FROM follows " +
	                "         GROUP BY ac_following) follower_counts ON ua.ac_idx = follower_counts.ac_following " +
	                " ) " +
	                " WHERE rn <= ? ";

	     try {
	    	 conn = ConnectionProvider.getConnection();
	    	 pstmt = this.conn.prepareStatement(sql);
	         pstmt.setInt(1, limit);
	         rs = pstmt.executeQuery();

	         while (rs.next()) {
	        	 UserVO user = new UserVO();
	             user.setNickname(rs.getString("nickname"));
	             user.setImg(rs.getString("img"));
	             user.setCreated_at(rs.getDate("created_at"));
	             users.add(user);
	         }
	      
	      } catch (Exception e) {
	    	  e.printStackTrace();
	      } finally {
	    	  if (rs != null) rs.close();
	    	  if (pstmt != null) pstmt.close();
	    	  if (conn != null) conn.close();
	      }
	        
	      return users;
	}

	// 특정 카테고리의 인기 유저 조회
	@Override
	public List<UserVO> findPopularUsersByCategory(int categoryIdx, int limit) throws SQLException {
		 List<UserVO> users = new ArrayList<>();
		 
	     Connection conn = null;
	     PreparedStatement pstmt = null;
	     ResultSet rs = null;
		 
	     String sql = " SELECT * " +
	    		 	" FROM ( " + 
	    		 	"	SELECT " +
	    		 	"		 u.nickname, " + 
	    		 	"		 u.img, " + 
	    		 	"		 u.created_at, " + 
	    		 	"		 COUNT(f.ac_follow) AS follower_count " + 
	                " 	FROM " + 
	    		 	"		userAccount u " +
	    		 	" 	LEFT JOIN follows f ON u.ac_idx = f.ac_following " +
	                " 	WHERE " + 
	    		 	" 		u.category_idx = ? " + 
	    		 	" 	GROUP BY " +
	                "		u.nickname, u.img, u.category_idx, u.created_at " + 
	                "	ORDER BY " + 
	                "		follower_count DESC " + 
	                " ) " +
	                " WHERE ROWNUM <= ? ";

	     try {
	    	 conn = ConnectionProvider.getConnection();
	    	 pstmt = this.conn.prepareStatement(sql);
	         pstmt.setInt(1, categoryIdx);
	         pstmt.setInt(2, limit);
	         rs = pstmt.executeQuery();

	         while (rs.next()) {
	        	 UserVO user = new UserVO().builder()
	        			 				   .nickname(rs.getString("nickname"))
	        			 				   .img(rs.getString("img"))
	        			 				   .created_at(rs.getDate("created_at"))
	        			 				   .category_idx(categoryIdx)
	        			 				   .build();
	             users.add(user);
	         }
	      
	      } catch (Exception e) {
	    	  e.printStackTrace();
	      } finally {
	    	  if (rs != null) rs.close();
	    	  if (pstmt != null) pstmt.close();
	    	  if (conn != null) conn.close();
	      }
	        
	      return users;
	}

}