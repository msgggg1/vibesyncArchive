package mvc.command.handler;

import java.io.BufferedReader;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import mvc.command.service.MessageService;
import mvc.domain.vo.UserVO;

public class MessageHandler implements CommandHandler {

	private MessageService messageService;
	
	public MessageHandler() {
		this.messageService = new MessageService();
	}

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    response.setContentType("application/json; charset=UTF-8");
	    PrintWriter out = response.getWriter();
	    Gson gson = new Gson();

	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("userInfo") == null) {
	        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        out.print(gson.toJson(Map.of("success", false, "message", "로그인 필요")));
	        return null;
	    }
	    UserVO userInfo = (UserVO) session.getAttribute("userInfo");
	    int senderIdx = userInfo.getAc_idx();

	    String method = request.getMethod();

	    if ("POST".equalsIgnoreCase(method)) {
	        // POST 요청 : 메시지 보내기
	        StringBuilder sb = new StringBuilder();
	        String line;
	        try (BufferedReader reader = request.getReader()) {
	            while ((line = reader.readLine()) != null) sb.append(line);
	        }
	        Map<String, Object> body = gson.fromJson(sb.toString(), Map.class);

	        int receiverIdx = ((Double)body.get("receiverIdx")).intValue(); // gson이 double로 파싱함
	        String text = (String) body.get("text");

	        // 메시지 저장 (인서트 작업)
	        boolean insertResult = messageService.sendMessage(senderIdx, receiverIdx, text);

	        out.print(gson.toJson(Map.of("success", insertResult)));
	        return null;
	        
	    } else if ("GET".equalsIgnoreCase(method)) {
	        // GET 요청 : 채팅 내역 조회
	        int otherIdx = Integer.parseInt(request.getParameter("senderIdx"));
	        Object serviceResult = messageService.getChatHistory(senderIdx, otherIdx);
	        out.print(gson.toJson(serviceResult));
	        return null;
	        
	    }
	    
	    response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
	    out.print(gson.toJson(Map.of("success", false, "message", "허용되지 않은 요청")));
	    return null;
	}
	
}
