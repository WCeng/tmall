package tmall.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

public class BackServletFilter implements Filter {

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		// TODO Auto-generated method stub
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		
		String contextPath = request.getServletContext().getContextPath();
//		System.out.println(contextPath);
		String uri = request.getRequestURI();
//		System.out.println(uri);
		uri = StringUtils.remove(uri, contextPath);
		
		if(uri.startsWith("/admin_")) {
			String servletPath = StringUtils.substringBetween(uri, "_", "_") + "Servlet";
			String method = StringUtils.substringAfterLast(uri, "_");
			request.setAttribute("method", method);
//			System.out.println(servletPath + method);
			request.getRequestDispatcher("/" + servletPath).forward(request, response);
			return;
		}
		
		chain.doFilter(request, response);
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		
	}

}
