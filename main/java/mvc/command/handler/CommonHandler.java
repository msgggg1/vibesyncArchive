package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.util.ConnectionProvider;
import mvc.command.service.PostViewService;
import mvc.domain.dto.SidebarDTO;
import mvc.domain.dto.UserNoteDTO;
import mvc.domain.vo.UserNoteVO;
import mvc.domain.vo.UserSummaryVO;
import mvc.domain.vo.UserVO;
import mvc.persistence.dao.UserNoteDAO;
import mvc.persistence.daoImpl.FollowDAOImpl;
import mvc.persistence.daoImpl.UserNoteDAOImpl;

public class CommonHandler implements CommandHandler {
	
	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String action = request.getParameter("action");
		
		if ("getFollowing".equals(action)) {
            
			String userIdxStr = request.getParameter("useridx");
	        
	        int userIdx = 0;
	        
	        try {
	            userIdx = Integer.parseInt(userIdxStr);
	            
	            Connection conn = ConnectionProvider.getConnection();
	            
	            FollowDAOImpl dao = new FollowDAOImpl(conn);
	            
	            List<UserSummaryVO> sidebarDTO = dao.userFollowingList(userIdx);
	            List<UserSummaryVO> list = sidebarDTO;
	            
	            StringBuilder sb = new StringBuilder();
	            sb.append("{\"followingList\":[");

	            for (int i = 0; i < list.size(); i++) {
	                UserSummaryVO u = list.get(i);
	                sb.append("{")
	                  .append("\"ac_idx\":").append(u.getAc_idx()).append(",")
	                  .append("\"nickname\":\"").append(u.getNickname()).append("\",")
	                  .append("\"category_idx\":").append(u.getCategory_idx())
	                  .append("}");
	                if (i < list.size() - 1) {
	                    sb.append(",");
	                }
	            }

	            sb.append("]}");
	            
		         // 4) JSON 응답 
	            response.setContentType("application/json;charset=UTF-8");
	            PrintWriter out = response.getWriter();
	            out.write(sb.toString());
	            out.flush();
	            System.out.println(sb.toString());
	            // AJAX용이므로 JSP 포워딩 없이 바로 null 리턴
	            return null;
	            
	        } catch (NumberFormatException e) {
	            // useridx가 잘못된 경우, 빈 리스트 반환
	            response.setContentType("application/json;charset=UTF-8");
	            PrintWriter out = response.getWriter();
	            out.write("{\"followingList\":[]}");
	            out.flush();
	            return null;
	        }
			
        } else {
        	// 다른 action 요청 시 빈 결과 리턴
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.write("{\"followingList\":[]}");
            out.flush();
            return null;
        }
	}
}
