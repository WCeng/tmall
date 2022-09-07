package tmall.filter;

import java.io.IOException;
import java.util.Arrays;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import tmall.bean.User;

public class ForeAuthFilter implements Filter{

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void doFilter(ServletRequest arg0, ServletResponse arg1, FilterChain chain)
			throws IOException, ServletException {
		// TODO Auto-generated method stub
		HttpServletRequest request = (HttpServletRequest)arg0;
		HttpServletResponse response = (HttpServletResponse)arg1;
		
		String[] noNeedAuthMethos = new String[]{
			"home",
			"login",
			"register",
			"product",
			"category",
			"search",
			"loginAjax",
			"checkLogin"
		};
		
		String contextPath = request.getServletContext().getContextPath();
		
		String uri = request.getRequestURI();
		
		uri = StringUtils.remove(uri, contextPath);
//		System.out.println(uri);
		if(uri.startsWith("/fore") && !uri.startsWith("/foreServlet")) {
			String method = StringUtils.substringAfterLast(uri, "/fore");
			if(!Arrays.asList(noNeedAuthMethos).contains(method)) {
				User user = (User) request.getSession().getAttribute("user");
				if(user == null) {
					response.sendRedirect("login.jsp");
					return;
				}
				
			}
			
		}
		chain.doFilter(request, response);
		
		
		
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		
	}

}
