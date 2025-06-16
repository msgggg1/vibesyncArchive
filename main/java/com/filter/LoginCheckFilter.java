package com.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(		dispatcherTypes = {DispatcherType.REQUEST}
					,
				urlPatterns = { 
						"*.do" 
				})
public class LoginCheckFilter extends HttpFilter implements Filter {
       
    public LoginCheckFilter() {
        super();
    }

	public void destroy() {
		System.out.println(">LoginCheckFilter destroy()");
	}

	public void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
	        throws IOException, ServletException {
		System.out.println(">LoginCheckFilter doFilter()");
		
		String requestURI = request.getRequestURI();
		
		// ▼▼▼ 1. 공개적으로 접근 가능한 '허용된 경로(Whitelist)' 목록 정의 ▼▼▼
	    List<String> publicPaths = Arrays.asList("/user.do", "/postView.do", "/comment.do");
	    
	    boolean isPublicPath = false;
	    for (String path : publicPaths) {
	        if (requestURI.endsWith(path)) {
	            isPublicPath = true;
	            break;
	        }
	    }
	    
	    // 리소스 파일(css, js, 이미지 등)은 항상 허용
	    //웹 페이지를 올바르게 표시하는 데 필요한 정적 파일(CSS, JavaScript, 이미지, 폰트 등)에 대해서는 로그인 여부와 상관없이 항상 접근을 허용
	    if (requestURI.startsWith(request.getContextPath() + "/resources/")) {
	        isPublicPath = true;
	    }
		
		HttpSession session = request.getSession(false);
		boolean isLoggedIn = (session != null && session.getAttribute("userInfo") != null);

	    // 2. 로그인을 했거나, 허용된 공개 경로에 접근하는 경우 -> 통과!
	    if (isLoggedIn || isPublicPath) {
	        chain.doFilter(request, response);
	    } else {
	        // 3. 로그인을 안 했고, 허용된 경로도 아닌 경우 -> 로그인 페이지로!
	        HttpSession newSession = request.getSession();
	        

	        // ★★★★★ 디버깅 코드 추가 ① ★★★★★
	        System.out.println("--- [LoginCheckFilter] ---");
	        System.out.println("세션 ID: " + newSession.getId());
	        System.out.println("저장할 Referer: " + requestURI);
	        System.out.println("-------------------------");
	        // ★★★★★★★★★★★★★★★★★★★★★
	        
	        newSession.setAttribute("referer", requestURI);
	        
	        String loginPage = request.getContextPath() + "/vibesync/user.do";
	        response.sendRedirect(loginPage);
	    }
	}

	public void init(FilterConfig fConfig) throws ServletException {
		System.out.println(">LoginCheckFilter init()");
	}

}
