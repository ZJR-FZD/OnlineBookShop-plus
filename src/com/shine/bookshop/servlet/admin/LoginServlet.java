package com.shine.bookshop.servlet.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shine.bookshop.bean.Admin;
import com.shine.bookshop.dao.AdminDao;
import com.shine.bookshop.dao.impl.AdminDaoImpl;
import com.shine.bookshop.util.IpUtil;
import com.shine.bookshop.util.OperationLogUtil;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/jsp/admin/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
      
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String mainPath="index.jsp";
		String loginPath="login.jsp";
		
		String userName=request.getParameter("userName");
		String passWord=request.getParameter("passWord");
		Admin admin=new Admin(userName, passWord);
		AdminDao ud=new AdminDaoImpl();
		
		List<String> list=new ArrayList<String>();
		if(userName==null) {
			list.add("用户名不能为空");
		}
		if(passWord==null) {
			list.add("密码不能为空");
		}
		if(list.size()==0) {
			if(ud.userLogin(admin)) {
				request.getSession().setAttribute("adminUser",admin );
				request.getSession().setAttribute("adminRole", admin.getRole());
				OperationLogUtil.recordAdminLogin(admin.getUserName(), admin.getRole(), IpUtil.getClientIp(request));
				response.sendRedirect(mainPath);
				return;
			}else {
				list.add("用户名或密码错误!请重新输入");	
			}
		}
		request.setAttribute("infoList", list);
		request.getRequestDispatcher(loginPath).forward(request, response);
		

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
