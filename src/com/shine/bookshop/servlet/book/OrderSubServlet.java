package com.shine.bookshop.servlet.book;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shine.bookshop.bean.Cart;
import com.shine.bookshop.bean.CartItem;
import com.shine.bookshop.bean.Book;
import com.shine.bookshop.bean.Order;
import com.shine.bookshop.bean.OrderItem;
import com.shine.bookshop.bean.PageBean;
import com.shine.bookshop.bean.User;
import com.shine.bookshop.dao.BookDao;
import com.shine.bookshop.dao.OrderDao;
import com.shine.bookshop.dao.OrderItemDao;
import com.shine.bookshop.dao.impl.BookDaoImpl;
import com.shine.bookshop.dao.impl.OrderDaoImpl;
import com.shine.bookshop.dao.impl.OrderItemDaoImpl;
import com.shine.bookshop.util.DateUtil;
import com.shine.bookshop.util.DbUtil;
import com.shine.bookshop.util.EmailUtil;
import com.shine.bookshop.util.IpUtil;
import com.shine.bookshop.util.OperationLogUtil;
import com.shine.bookshop.util.RanUtil;

/**
 * 订单前台一些请求
 * Servlet implementation class OrderSubServlet
 */
@WebServlet(name = "OrderServlet", urlPatterns = { "/OrderServlet" })
public class OrderSubServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final int  MAX_LIST_SIZE=5;
	private static final String CART_PATH="jsp/book/cart.jsp" ;
	private static final String ORDER_PAY_PATH="jsp/book/ordersuccess.jsp";

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
		switch(action) {
		case "subOrder":
			subOrder(request,response);
			break;
		case "list":
			myOrderList(request,response);
			break;
		case "ship":
			orderShip(request,response);
			break;
		}
		
	}
	private void orderShip(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String orderId=request.getParameter("id");
		OrderDao orderDao=new OrderDaoImpl();
		
		if(orderDao.orderStatus(Integer.parseInt(orderId),3)) {
			request.setAttribute("orderMessage", "一个订单操作成功");
		}else {
			request.setAttribute("orderMessage", "一个订单操作失败");
		}
		myOrderList(request,response);
		
	}

	//我的订单列表请求
	private void myOrderList(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		
		User user=(User)request.getSession().getAttribute("landing");
		if(user==null) {
			response.sendRedirect("jsp/book/reg.jsp?type=login");
		}else {
			OrderDao orderDao=new OrderDaoImpl();
			OrderItemDao oItem=new OrderItemDaoImpl();
			BookDao bookDao=new BookDaoImpl();
			int curPage = 1;
			String page = request.getParameter("page");
			if (page != null) {
				curPage = Integer.parseInt(page);
			}
			PageBean pb= new PageBean(curPage, MAX_LIST_SIZE,orderDao.orderReadCount(user.getUserId()) );
			
			List<Order> orderList = orderDao.orderList(pb,user.getUserId());	
			
			for(Order order:orderList) {
				//通过订单编号查询订单项集合
				order.setoItem(oItem.findItemByOrderId(order.getOrderId()));
				for(OrderItem oi:order.getoItem()) {
					//通过图书id获取图书对象
					oi.setBook(bookDao.findBookById(oi.getBookId()));
				}
				
			}
			
			
			request.setAttribute("pageBean", pb);
			request.setAttribute("orderList",orderList);		
			request.getRequestDispatcher("jsp/book/myorderlist.jsp").forward(request, response);
			
		}
	}

	//订单提交处理，生成订单号并存入数据库（这里订单状态未1;未付款），
	private void subOrder(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//获得及生成一些需要的对象和数据
		HttpSession session = request.getSession();
		Cart cart=(Cart) session.getAttribute("shopCart");
		User user=(User) session.getAttribute("landing");
		String orderNum=RanUtil.getOrderNum();//生成的订单号
		String orderDate=DateUtil.show();//生成订单日期
		Order order=new Order();
		OrderDao orderDao=new OrderDaoImpl();
		OrderItemDao oItemDao=new OrderItemDaoImpl();
		BookDao bookDao=new BookDaoImpl();

		for(Map.Entry<Integer, CartItem> meic:cart.getMap().entrySet()) {
			Book book = bookDao.findBookById(meic.getKey());
			if(book == null || book.getStock() < meic.getValue().getQuantity()) {
				request.setAttribute("suberr", "图书【" + (book == null ? meic.getKey() : book.getBookName()) + "】库存不足，请调整购物车后再下单");
				request.getRequestDispatcher(CART_PATH).forward(request, response);
				return;
			}
		}
		
		//给订单对象属性赋值
		order.setOrderNum(orderNum);
		order.setOrderDate(orderDate);
		order.setMoney(cart.getTotPrice());
		order.setOrderStatus(1);
		order.setUserId(user.getUserId());
		
		if(orderDao.orderAdd(order)) {
			//订单保存成功通过订单号获取订单编号，订单项留用
			order.setOrderId(orderDao.findOrderIdByOrderNum(orderNum));
			int itemCount = 0;
			//
			for(Map.Entry<Integer, CartItem> meic:cart.getMap().entrySet()) {
				OrderItem oi=new OrderItem();
				oi.setBookId(meic.getKey());
				oi.setQuantity(meic.getValue().getQuantity());
				oi.setOrderId(order.getOrderId());
				oItemDao.orderAdd(oi);
				DbUtil.excuteUpdate("update s_book set stock = stock - ? where bookId=?", meic.getValue().getQuantity(), meic.getKey());
				itemCount += meic.getValue().getQuantity();
			}
			OperationLogUtil.recordPurchase(user, orderNum, order.getMoney(), itemCount, IpUtil.getClientIp(request));
			EmailUtil.sendOrderConfirm(user, orderNum, order.getMoney(), itemCount);
			//订单项保存结束清空购物车，返回订单提交成功
			session.removeAttribute("shopCart");
			request.setAttribute("orderNum", order.getOrderNum());
			request.setAttribute("money", order.getMoney());
			request.getRequestDispatcher(ORDER_PAY_PATH).forward(request, response);
		}else {
			request.setAttribute("suberr", "订单提交失败，请重新提交");
			request.getRequestDispatcher(CART_PATH).forward(request, response);
		}
		
	}

}
