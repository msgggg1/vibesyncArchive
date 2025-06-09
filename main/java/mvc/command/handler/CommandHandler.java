package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface CommandHandler {
	
	// 뷰 경로
	String process(HttpServletRequest request, HttpServletResponse response) throws Exception;
	
}