package com.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class CharacterEncodingFilter implements Filter{ 
	
	String encoding ;
	

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		System.out.println(">CharacterEncodingFilter.init()" );
		this.encoding = filterConfig.getInitParameter("encoding");
		
		if (this.encoding == null) {
			this.encoding = "UTF-8";
		}
		
		Filter.super.init(filterConfig);
		
	}
	
	@Override
	public void destroy() {
		System.out.println(">CharacterEncodingFilter.destroy()" );
		Filter.super.destroy();
	}

						// 자식이 httpservletRequest
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		System.out.println(">CharacterEncodingFilter.doFilter()" );
		
		request.setCharacterEncoding(this.encoding);
		chain.doFilter(request, response); // 다음에게 넘겨주겟다.
	} 

}
