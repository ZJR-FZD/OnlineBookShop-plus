package com.shine.bookshop.servlet.book;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shine.bookshop.bean.Book;
import com.shine.bookshop.bean.User;
import com.shine.bookshop.dao.BookDao;
import com.shine.bookshop.dao.impl.BookDaoImpl;
import com.shine.bookshop.util.IpUtil;
import com.shine.bookshop.util.OperationLogUtil;

@WebServlet("/bookdetail")
public class bookdetailed extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String DETAIL_PATH = "jsp/book/bookdetails.jsp";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 接收浏览时长回传
		String action = request.getParameter("action");
		if ("log".equals(action)) {
			String durationStr = request.getParameter("duration");
			String bookIdStr = request.getParameter("bookId");
			if (durationStr != null && bookIdStr != null) {
				System.out.println("[Duration] bookId=" + bookIdStr + " duration=" + durationStr + "s");
			}
			return;
		}

		int bookId = Integer.parseInt(request.getParameter("bookId"));
		BookDao bd = new BookDaoImpl();
		Book book = bd.findBookById(bookId);
		request.setAttribute("bookInfo", book);

		User user = (User) request.getSession().getAttribute("landing");
		String ip = IpUtil.getClientIp(request);
		Integer catalogId = book != null && book.getCatalog() != null ? book.getCatalog().getCatalogId() : null;

		OperationLogUtil.recordBrowse(user, bookId,
				book == null ? null : book.getBookName(),
				catalogId, ip, 0);

	request.setAttribute("alsoBought", bd.findPurchasedByViewers(bookId, 5));
		request.setAttribute("boughtTogether", bd.findBoughtTogether(bookId, 5));

		request.getRequestDispatcher(DETAIL_PATH).forward(request, response);
	}
}
