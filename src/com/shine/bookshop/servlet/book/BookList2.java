package com.shine.bookshop.servlet.book;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shine.bookshop.bean.Book;
import com.shine.bookshop.bean.PageBean;
import com.shine.bookshop.dao.BookDao;
import com.shine.bookshop.dao.impl.BookDaoImpl;
import com.shine.bookshop.util.OperationLogUtil;

/**
 * Servlet implementation class BookList
 */
@WebServlet("/BookList2")
public class BookList2 extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final int MAX_LIST_SIZE = 12;
	private static final String BOOKLIST_PATH="jsp/book/booklist.jsp";
   

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		bookList(request,response,request.getParameter("searchname"));
	}

	private void bookList(HttpServletRequest request, HttpServletResponse response, String searchname) throws ServletException, IOException {
		BookDao bd = new BookDaoImpl();
		int curPage = 1;
		String page = request.getParameter("page");
		if (page != null) {
			curPage = Integer.parseInt(page);
		}
		
		PageBean pb;
		List<Book> bookList;
		if(searchname == null || searchname.trim().isEmpty()) {
			pb = new PageBean(curPage, MAX_LIST_SIZE, bd.bookReadCount());
			bookList = bd.bookList(pb);
		}else {
			pb = new PageBean(curPage, MAX_LIST_SIZE, bd.bookReadCount(searchname));
			bookList = bd.bookList(pb,searchname);
		}
		OperationLogUtil.recordBrowse((com.shine.bookshop.bean.User) request.getSession().getAttribute("landing"), null, "search:" + searchname, "book search");
		request.setAttribute("title", "所有图书");
		
		request.setAttribute("pageBean", pb);
		request.setAttribute("bookList",bookList);
		
		request.getRequestDispatcher(BOOKLIST_PATH).forward(request, response);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
