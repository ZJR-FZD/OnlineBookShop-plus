package com.shine.bookshop.servlet.book;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shine.bookshop.bean.User;
import com.shine.bookshop.dao.UserDao;
import com.shine.bookshop.dao.impl.AdminDaoImpl;
import com.shine.bookshop.dao.impl.UserDaoImpl;
import com.shine.bookshop.util.IpUtil;
import com.shine.bookshop.util.OperationLogUtil;

import net.sf.json.JSONObject;

/**
 * Servlet implementation class UserManage
 */
@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String LOGIN_PATH="jsp/book/reg.jsp?type=login";
	private static final String REG_PATH="jsp/book/reg.jsp?type=reg";
	private static final String INDEX_PATH="jsp/book/index.jsp";
	private static final String LANDING="landing";				//前台用户session标识

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String action=request.getParameter("action");
		switch(action){
			case "login":
				login(request,response);
				break;
			case "off":
				offlogin(request,response);
				break;
			case "ajlogin":
				ajlogin(request,response);
				break;
			case "reg":
				reg(request,response);
				break;
			case "landstatus":
				landstatus(request,response);
				break;
			case "profile":
				profile(request, response);
				break;
			case "delete":
				deleteAccount(request,response);
				break;
		}
	}

	// 获取用户详细资料
	private void profile(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		User loginUser = (User) session.getAttribute(LANDING);

		// 未登录，强制去登录
		if (loginUser == null) {
			response.sendRedirect(LOGIN_PATH);
			return;
		}

		// 查最新用户信息（防止 session 旧）
		UserDao userDao = new UserDaoImpl();
		User user = userDao.findUser(loginUser.getUserId());

		request.setAttribute("user", user);
		request.getRequestDispatcher("jsp/book/userprofile.jsp")
				.forward(request, response);
	}

	/**
	 * 注销账号
	 * @param request
	 * @param response
	 * @throws IOException
	 * @throws ServletException
	 */
	private void deleteAccount(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(LANDING);

		// 检查用户是否登录
		if (currentUser == null) {
			response.sendRedirect(LOGIN_PATH);
			return;
		}

		// 获取要删除的用户ID
		String userIdStr = request.getParameter("id");
		if (userIdStr == null || userIdStr.isEmpty()) {
			response.sendRedirect(INDEX_PATH);
			return;
		}

		int userId = Integer.parseInt(userIdStr);

		// 安全检查：只能注销自己的账号
		if (currentUser.getUserId() != userId) {
			request.setAttribute("infoList", "无法注销他人账号！");
			request.getRequestDispatcher(INDEX_PATH).forward(request, response);
			return;
		}

		// 执行注销操作
		UserDao ud = new UserDaoImpl();
		boolean result = ud.delUser(userId);

		if (result) {
			// 注销成功，清除session并跳转到首页
			session.invalidate();

			// 跳转到首页并显示提示
			response.sendRedirect(INDEX_PATH);
		} else {
			// 注销失败
			request.setAttribute("infoList", "账号注销失败，请稍后重试或联系管理员！");
			request.getRequestDispatcher(INDEX_PATH).forward(request, response);
		}
	}

	//判断登陆状态
	private void landstatus(HttpServletRequest request, HttpServletResponse response) throws IOException {

		User user=  (User) request.getSession().getAttribute(LANDING);

		PrintWriter pw = response.getWriter();
		JSONObject json=new JSONObject();

		if(user!=null) {
			json.put("status", "y");
		}else {
			json.put("status", "n");
		}
		pw.print(json.toString());
		pw.flush();

	}
	//ajax登陆
	private void ajlogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String userName = request.getParameter("userName");
		String passWord = request.getParameter("passWord");
		User user=new User(userName,passWord);
		PrintWriter pw = response.getWriter();
		JSONObject json=new JSONObject();
		UserDao ud=new UserDaoImpl();
		User user2=ud.userLogin(user);

		if(user2!=null) {
			if("y".equals(user2.getEnabled())) {
				request.getSession().setAttribute(LANDING, user2);
				OperationLogUtil.recordLogin(user2, IpUtil.getClientIp(request));
				json.put("status","y" );
			}else {
				json.put("info", "该用户已被禁用，请联系管理员");
			}
		}else {
			json.put("info", "用户名或密码错误，请重新登陆！");

		}
		pw.print(json.toString());
	}

	private void reg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UserDao ud=new UserDaoImpl();
		User user=new User(
				request.getParameter("userName"),
				request.getParameter("passWord"),
				request.getParameter("name"),
				request.getParameter("sex"),
				Integer.parseInt(request.getParameter("age")),
				request.getParameter("tell"),
				request.getParameter("address"),
				request.getParameter("email"));
		user.setEnabled("y");//默认添加的用户启用
		//添加之前判断用户名是否在库中存在
		if(new AdminDaoImpl().findUser(user.getUserName())){
			request.setAttribute("infoList", "用户添加失败！用户名已存在");
			request.getRequestDispatcher(REG_PATH).forward(request, response);
		}else{
			//执行dao层添加操作
			if(ud.userAdd(user)){
				request.setAttribute("infoList", "注册成功！请登陆！");
				request.getRequestDispatcher(LOGIN_PATH).forward(request, response);
			}else{
				request.setAttribute("userMessage", "用户添加失败！");
				request.getRequestDispatcher(REG_PATH).forward(request, response);
			}
		}

	}

	private void offlogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		User user =  (User) request.getSession().getAttribute(LANDING);
		if(user!=null) {
			request.getSession().removeAttribute(LANDING);
		}
		response.sendRedirect(INDEX_PATH);

	}

	private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userName=request.getParameter("userName");
		String passWord=request.getParameter("passWord");
		User user=new User(userName,passWord);
		UserDao ud=new UserDaoImpl();
		User user2=ud.userLogin(user);
		if(user2!=null) {
			if("y".equals(user2.getEnabled())) {
				OperationLogUtil.recordLogin(user2, IpUtil.getClientIp(request));
				request.getSession().setAttribute(LANDING, user2);
				response.sendRedirect(INDEX_PATH);

			}else {
				request.setAttribute("infoList", "该用户已被禁用，请联系管理员");
				request.getRequestDispatcher(LOGIN_PATH).forward(request, response);
			}
		}else {
			request.setAttribute("infoList", "用户名或密码错误，请重新登陆！");
			request.getRequestDispatcher(LOGIN_PATH).forward(request, response);
		}

	}

}