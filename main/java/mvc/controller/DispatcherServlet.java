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

import mvc.command.CommandHandler;

//web.xml에 직접 설정
public class DispatcherServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
       
	
    public DispatcherServlet() {
        super();
        
    }

    
	@Override
	public void destroy() {
		super.destroy();
		//System.out.println(">DispatcherServlet.destroy()");
	}

	// Map 선언 : key = url, value= 모델 객체를 생성해서 줌
	public Map<String, CommandHandler> commandHandlerMap = new HashMap<>();

	@Override
	public void init() throws ServletException { // 생성자역할
		super.init();
	
		String mappingPath = this.getInitParameter("mappingPath");
		String realPath = this.getServletContext().getRealPath(mappingPath); 

		Properties prop = new Properties(); // collection 클래스  key-value
		
		try(FileReader reader = new FileReader(realPath)){
			prop.load(reader);
		}catch(Exception e){
			throw new ServletException();
		}
		
		Set<Entry<Object, Object>> set = prop.entrySet();
		Iterator<Entry<Object, Object>> ir = set.iterator();
		while(ir.hasNext()) {
			Entry<Object, Object> entry = ir.next();
			String url = (String)entry.getKey(); // /board/list.do
			String fullName = (String)entry.getValue(); // days08.mvc.command.ListHandler
			
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
		

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { // get방식 요청
		// 1 2 3 4 5
		// 1단계. 요청받음
		// 2단계. 요청분석
		// 		/jspPro/board/list.do
		String requestURI = request.getRequestURI();
		// http://localhost/jspPro/board/list.do
		//request.getRequestURL();
		
		// 		/jspPro
		int beginIndex = request.getContextPath().length();
		//  	/board/list.do
		requestURI = requestURI.substring(beginIndex);
		
		System.out.println("[DispatcherServlet] 요청된 requestURI (commandKey): " + requestURI);
		
		// 3단계. 로직처리하는 모델객체를 commandHandlerMap으로 부터 얻어옴
		CommandHandler handler = this.commandHandlerMap.get(requestURI);
		String view = null;	  
		
		try {
			view = handler.process(request, response);
			// 4. request, session 객체에 결과 저장
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// 5단계 - 뷰 출력(포워딩, 리다이렉트)
		if (view != null) {
			// 포워딩
			// 리다이렉트는 핸들러에서
			RequestDispatcher dispatcher = request.getRequestDispatcher(view);
			dispatcher.forward(request, response);
		} // if
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { // post방식 서블릿 요청
	
		doGet(request, response); // 다 doGET이 처리하겠다.
	}

}
