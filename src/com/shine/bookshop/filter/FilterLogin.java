package com.shine.bookshop.filter;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet Filter implementation class FilterLogin
 */
@WebFilter(filterName="FilterLogin",urlPatterns="/jsp/admin/*",
			initParams={@WebInitParam(name="allowPath",value="login.jsp;LoginServlet;images;css")})
public class FilterLogin implements Filter {
	private String allowPath;

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest  httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		String urlPath = httpRequest.getServletPath();
		Object adminUser = httpRequest.getSession().getAttribute("adminUser");
		if (adminUser != null) {
			Object roleObj = httpRequest.getSession().getAttribute("adminRole");
			String role = roleObj == null ? null : roleObj.toString();
			if ("admin".equalsIgnoreCase(role)) {
				chain.doFilter(request, response);
				return;
			}
			// sales 账号禁止访问人员管理模块和销售统计
			if (urlPath.contains("AdminManageServlet")
					|| urlPath.contains("UserManageServlet")
					|| urlPath.contains("/adminManage/")
					|| urlPath.contains("/userManage/")
					|| urlPath.endsWith("adminManage/adminAdd.jsp")
					|| urlPath.endsWith("adminManage/adminEdit.jsp")
					|| urlPath.endsWith("adminManage/adminList.jsp")
					|| urlPath.endsWith("userManage/userAdd.jsp")
					|| urlPath.endsWith("userManage/userEdit.jsp")
					|| urlPath.endsWith("userManage/userList.jsp")
					|| (urlPath.contains("OrderManageServlet") && "stat".equals(httpRequest.getParameter("action")))) {
				String noPath = httpRequest.getScheme() + "://" + httpRequest.getServerName() + ":"
						+ httpRequest.getServerPort() + httpRequest.getContextPath() + "/jsp/admin/index.jsp";
				PrintWriter pw = httpResponse.getWriter();
				pw.println("<script>alert('销售账号无权访问该模块');top.location.href='" + noPath + "'</script>");
				return;
			}
			chain.doFilter(request, response);
			return;
		}

		String[] urls = this.allowPath.split(";");
		for (String url : urls) {
			if (urlPath.contains(url)) {
				chain.doFilter(request, response);
				return;
			}
		}
		String noPath = httpRequest.getScheme() + "://" + httpRequest.getServerName() + ":"
				+ httpRequest.getServerPort() + httpRequest.getContextPath() + "/jsp/admin/login.jsp";
		PrintWriter pw = httpResponse.getWriter();
		pw.println("<script>top.location.href='" + noPath + "'</script>");
	}

	public void init(FilterConfig fConfig) {
		this.allowPath = fConfig.getInitParameter("allowPath");
	}
}
