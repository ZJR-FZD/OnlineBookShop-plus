package com.shine.bookshop.servlet.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shine.bookshop.bean.Order;
import com.shine.bookshop.bean.OrderItem;
import com.shine.bookshop.bean.PageBean;
import com.shine.bookshop.dao.BookDao;
import com.shine.bookshop.dao.OrderDao;
import com.shine.bookshop.dao.OrderItemDao;
import com.shine.bookshop.dao.UserDao;
import com.shine.bookshop.dao.impl.BookDaoImpl;
import com.shine.bookshop.dao.impl.OrderDaoImpl;
import com.shine.bookshop.dao.impl.OrderItemDaoImpl;
import com.shine.bookshop.dao.impl.UserDaoImpl;
import com.shine.bookshop.util.DbUtil;

@WebServlet("/jsp/admin/OrderManageServlet")
public class OrderManageServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final String ORDERLIST_PATH = "orderManage/orderlist.jsp";
	private static final String ORDERDETAIL_PATH = "orderManage/orderDetail.jsp";
	private static final String ORDEROP_PATH = "orderManage/orderOp.jsp";

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		if (action == null || action.trim().isEmpty()) {
			orderList(request, response);
			return;
		}

		switch (action) {
			case "list":
				orderList(request, response);
				break;

			case "detail":
				orderDetail(request, response);
				break;

			case "processing":
				orderProcessing(request, response);
				break;

			case "ship":
				orderShip(request, response);
				break;

			case "search":
				searchOrder(request, response);
				break;

			case "delete":
				deleteOrder(request, response);
				break;

			case "stat":
				orderStatistic(request, response);
				break;

			default:
				orderList(request, response);
				break;
		}
	}

	/** 订单列表 */
	private void orderList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int curPage = 1;
		String page = request.getParameter("page");
		if (page != null && !page.trim().isEmpty()) {
			curPage = Integer.parseInt(page);
		}

		int maxSize = Integer.parseInt(
				request.getServletContext().getInitParameter("maxPageSize"));

		OrderDao orderDao = new OrderDaoImpl();
		PageBean pb = new PageBean(curPage, maxSize, orderDao.orderReadCount());

		request.setAttribute("pageBean", pb);
		request.setAttribute("orderList", orderDao.orderList(pb));
		request.getRequestDispatcher(ORDERLIST_PATH).forward(request, response);
	}

	/** 订单详情（⭐⭐⭐ 重点） */
	private void orderDetail(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int orderId = Integer.parseInt(request.getParameter("id"));

		OrderDao orderDao = new OrderDaoImpl();
		OrderItemDao itemDao = new OrderItemDaoImpl();
		UserDao userDao = new UserDaoImpl();
		BookDao bookDao = new BookDaoImpl();

		Order order = orderDao.findOrderByOrderId(orderId);

		// 绑定用户
		order.setUser(userDao.findUser(order.getUserId()));

		// 绑定订单项
		order.setoItem(itemDao.findItemByOrderId(order.getOrderId()));

		// 给每个订单项绑定图书
		for (OrderItem item : order.getoItem()) {
			item.setBook(bookDao.findBookById(item.getBookId()));
		}

		request.setAttribute("order", order);
		request.getRequestDispatcher(ORDERDETAIL_PATH).forward(request, response);
	}

	/** 待处理订单 */
	private void orderProcessing(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int curPage = 1;
		String page = request.getParameter("page");
		if (page != null && !page.trim().isEmpty()) {
			curPage = Integer.parseInt(page);
		}

		int maxSize = Integer.parseInt(
				request.getServletContext().getInitParameter("maxPageSize"));

		OrderDao orderDao = new OrderDaoImpl();
		PageBean pb = new PageBean(curPage, maxSize,
				orderDao.orderReadCountByStatus(1));

		request.setAttribute("pageBean", pb);
		request.setAttribute("orderList",
				orderDao.orderListByStatus(pb, 1));

		request.getRequestDispatcher(ORDEROP_PATH).forward(request, response);
	}

	/** 发货 */
	private void orderShip(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int orderId = Integer.parseInt(request.getParameter("id"));
		OrderDao orderDao = new OrderDaoImpl();

		boolean success = orderDao.orderStatus(orderId, 2);
		request.setAttribute("orderMessage",
				success ? "一个订单操作成功" : "一个订单操作失败");

		orderProcessing(request, response);
	}

	/** 搜索订单 */
	private void searchOrder(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int curPage = 1;
		String page = request.getParameter("page");
		if (page != null && !page.trim().isEmpty()) {
			curPage = Integer.parseInt(page);
		}

		int maxSize = Integer.parseInt(
				request.getServletContext().getInitParameter("maxPageSize"));

		String ordername = request.getParameter("ordername");
		OrderDao orderDao = new OrderDaoImpl();
		PageBean pb;

		if (ordername != null && !ordername.trim().isEmpty()) {
			pb = new PageBean(curPage, maxSize,
					orderDao.orderReadCount(ordername));
			request.setAttribute("orderList",
					orderDao.orderList(pb, ordername));
		} else {
			pb = new PageBean(curPage, maxSize,
					orderDao.orderReadCount());
			request.setAttribute("orderList",
					orderDao.orderList(pb));
		}

		request.setAttribute("pageBean", pb);
		request.getRequestDispatcher(ORDERLIST_PATH).forward(request, response);
	}

	/** 删除订单 */
	private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String id = request.getParameter("id");

		if (id != null && !id.trim().isEmpty()) {
			int orderId = Integer.parseInt(id);
			OrderDao orderDao = new OrderDaoImpl();
			orderDao.deleteOrderItem(orderId);
			orderDao.deleteOrder(orderId);
		}

		orderList(request, response);
	}

	/** 销售报表（排行+趋势+分类+库存） */
	private void orderStatistic(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 商品销售排行 TOP 20
		request.setAttribute("rankList", DbUtil.executeQuery(
				"select b.bookName, c.catalogName, coalesce(sum(oi.quantity),0) as sold, coalesce(sum(oi.quantity*b.price),0) as revenue from s_orderitem oi join s_book b on oi.bookId=b.bookId join s_catalog c on b.catalogId=c.catalogId group by oi.bookId order by sold desc limit 20"));

		// 按日销售趋势（最近30天）
		request.setAttribute("dayStats", DbUtil.executeQuery(
				"select DATE_FORMAT(orderDate, '%m-%d') as day, count(*) as cnt, coalesce(sum(money),0) as total from s_order where orderDate >= date_sub(curdate(), interval 30 day) group by day order by day"));

		// 按周销售趋势（最近12周）
		request.setAttribute("weekStats", DbUtil.executeQuery(
				"select concat(year(orderDate),'-W',week(orderDate)) as wk, count(*) as cnt, coalesce(sum(money),0) as total from s_order where orderDate >= date_sub(curdate(), interval 84 day) group by wk order by wk"));

		// 按月份销售统计
		request.setAttribute("monthStats", DbUtil.executeQuery(
				"select DATE_FORMAT(orderDate, '%Y-%m') as month, count(*) as cnt, coalesce(sum(money),0) as totalMoney from s_order group by month order by month"));

		// 按图书类别销售统计
		request.setAttribute("catalogSales", DbUtil.executeQuery(
				"select c.catalogName, coalesce(sum(oi.quantity),0) as soldCount, coalesce(sum(oi.quantity * b.price),0) as totalMoney from s_orderitem oi join s_book b on oi.bookId=b.bookId join s_catalog c on b.catalogId=c.catalogId join s_order o on oi.orderId=o.orderId group by c.catalogName order by soldCount desc"));

		// 订单状态汇总
		request.setAttribute("statusStats", DbUtil.executeQuery(
				"select orderStatus, count(*) as total, coalesce(sum(money),0) as money from s_order group by orderStatus order by orderStatus"));

		// 库存汇总
		request.setAttribute("catalogStock", DbUtil.executeQuery(
				"select c.catalogName, count(*) as bookCount, coalesce(sum(b.stock),0) as stockTotal from s_book b join s_catalog c on b.catalogId=c.catalogId group by c.catalogName order by bookCount desc"));

		request.getRequestDispatcher("orderManage/orderStatistic.jsp")
				.forward(request, response);
	}
}