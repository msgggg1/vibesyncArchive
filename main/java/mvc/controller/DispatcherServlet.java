package mvc.controller;

import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.command.handler.CommandHandler;

//web.xml에 직접 설정
public class DispatcherServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    public DispatcherServlet() {
        super();
        
    }
    
	@Override
	public void destroy() {
		super.destroy();
		//System.out.println("> DispatcherServlet.destroy()");
	}

	// Map 선언 : key = url, value = 모델 객체를 생성해서 줌
	public Map<String, CommandHandler> commandHandlerMap = new HashMap<>();

	@Override
	public void init() throws ServletException { // 생성자 역할
		super.init();
	
		String mappingPath = this.getInitParameter("mappingPath");
		String realPath = this.getServletContext().getRealPath(mappingPath); 
		System.out.println("> realPath : " + realPath);
		
		Properties prop = new Properties(); // collection 클래스 key-value
		
		try(FileReader reader = new FileReader(realPath)){
			prop.load(reader);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		Set<Entry<Object, Object>> set = prop.entrySet();
		Iterator<Entry<Object, Object>> ir = set.iterator();
		while(ir.hasNext()) {
			Entry<Object, Object> entry = ir.next();
			String url = (String) entry.getKey(); // /vibesync/main.do
			String fullName = (String) entry.getValue(); // mvc.command.MainPageHandler
			
			Class<?> commandHandlerClass = null;
	         try {
	            commandHandlerClass = Class.forName(fullName);
	            try {
	               CommandHandler handler = (CommandHandler) commandHandlerClass.newInstance();
	               this.commandHandlerMap.put(url, handler); // 맵 추가
	            } catch (InstantiationException e) { 
	               e.printStackTrace();
	            } catch (IllegalAccessException e) { 
	               e.printStackTrace();
	            }
	         } catch (ClassNotFoundException e) { 
	            e.printStackTrace();
	         }
		}
	}
		
	// 1단계. 사용자에게 요청받기
	// GET 방식 요청
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 2단계. controller (DispatcherServlet) 에서 사용자 요청 분석
		
		String requestURI = request.getRequestURI(); // /jspPro/board/list.do
		System.out.println(request.getRequestURL());
		System.out.println(requestURI);
		// http://localhost/jspPro/board/list.do
		
		// 		/jspPro
		int beginIndex = request.getContextPath().length();
		//  	/board/list.do
		requestURI = requestURI.substring(beginIndex);
		
		System.out.println("[DispatcherServlet] 요청된 requestURI (commandKey): " + requestURI);
		
		// 3단계. 로직처리하는 모델 객체를 commandHandlerMap으로부터 얻어오기
		CommandHandler handler = this.commandHandlerMap.get(requestURI);
		if (handler == null) {
	        // 해당 URI에 매핑된 핸들러가 없으면 404 리턴
	        response.sendError(HttpServletResponse.SC_NOT_FOUND);
	        return;
	    }
		String view = null;
		
		try {
			// 4단계. request, session 객체에 결과 저장
			view = handler.process(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			throw new ServletException(e);
		}
		
		// 5단계. 뷰 출력(포워딩, 리다이렉트)
		if (view != null) {
			// 포워딩 (리다이렉트는 핸들러에서)
			RequestDispatcher dispatcher = request.getRequestDispatcher(view);
			dispatcher.forward(request, response);
		} // if
	}

	// POST 방식 요청 (1단계. 사용자에게 요청받기)
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { // post방식 서블릿 요청
	
		doGet(request, response); // doGET에서 모두 처리
	}

}