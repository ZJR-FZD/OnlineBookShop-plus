package com.shine.bookshop.servlet.book;

import java.io.IOException;
import java.util.ArrayList;
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
@WebServlet("/BookList")
public class BookList extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final int MAX_LIST_SIZE = 12;
	private static final String BOOKLIST_PATH="jsp/book/booklist.jsp";
   

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action=request.getParameter("action");
		if(action==null) {
			action="list";
		}
		switch(action) {
		case "d":
			break;
			
		case "list"://默认全部图书列表
			bookList(request,response);
			break;
		}
	}

	private void bookList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		BookDao bd = new BookDaoImpl();
		int curPage = 1;
		String page = request.getParameter("page");
		if (page != null) {
			curPage = Integer.parseInt(page);
		}
		
		PageBean pb=null;
		List<Book> bookList=new ArrayList<Book>();
		String catalogIdStr = request.getParameter("catalogId");//获取有没有分类id，没有就是查全部
		
		if(catalogIdStr!=null) {
			int catalogId=Integer.parseInt(catalogIdStr);
			pb = new PageBean(curPage, MAX_LIST_SIZE, bd.bookReadCount(catalogId));
			bookList = bd.bookList(pb,catalogId);
			OperationLogUtil.recordBrowse((com.shine.bookshop.bean.User) request.getSession().getAttribute("landing"), catalogId, "catalog:" + catalogId, "book list");
			
			if(bookList.size()>0) {
				request.setAttribute("title", bookList.get(0).getCatalog().getCatalogName());//从返回的分类集合中第一个获取数据的分类
			}
			
		}else {
			pb = new PageBean(curPage, MAX_LIST_SIZE, bd.bookReadCount());
			bookList = bd.bookList(pb);
			request.setAttribute("title", "所有图书");
			OperationLogUtil.recordBrowse((com.shine.bookshop.bean.User) request.getSession().getAttribute("landing"), null, "all-books", "book list");
		}
		
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
