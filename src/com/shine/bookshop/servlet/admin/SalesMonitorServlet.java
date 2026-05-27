package com.shine.bookshop.servlet.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shine.bookshop.util.DateUtil;
import com.shine.bookshop.util.DbUtil;

@WebServlet("/jsp/admin/SalesMonitorServlet")
public class SalesMonitorServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 订单状态统计
		List<Map<String, Object>> statusStats = DbUtil.executeQuery(
			"select orderStatus, count(*) as cnt, coalesce(sum(money),0) as totalMoney from s_order group by orderStatus order by orderStatus");

		// 库存预警 (stock <= 5)
		List<Map<String, Object>> lowStock = DbUtil.executeQuery(
			"select b.bookId, b.bookName, b.stock, c.catalogName from s_book b join s_catalog c on b.catalogId=c.catalogId where b.stock <= 5 order by b.stock asc limit 20");

		// 最近订单
		List<Map<String, Object>> recentOrders = DbUtil.executeQuery(
			"select o.orderId, o.orderNum, o.orderDate, o.money, o.orderStatus, u.userName from s_order o join s_user u on o.userId=u.userId order by o.orderId desc limit 10");
		String today = DateUtil.dateshow();
		req.setAttribute("todaySales", DbUtil.executeQuery(
				"select count(*) as cnt, coalesce(sum(money),0) as total from s_order where orderDate like '" + today + "%'"));
		req.setAttribute("avg7Sales", DbUtil.executeQuery(
				"select round(count(*)/7,1) as avgCnt, round(coalesce(sum(money),0)/7,1) as avgTotal from s_order where orderDate >= date_sub(curdate(), interval 7 day) and orderDate < '" + today + "'"));
		req.setAttribute("lowStockHot", DbUtil.executeQuery(
				"select b.bookName, b.stock, c.catalogName, coalesce(sum(oi.quantity),0) as recentSold from s_book b left join s_orderitem oi on b.bookId=oi.bookId left join s_catalog c on b.catalogId=c.catalogId where b.stock <= 5 group by b.bookId having recentSold > 0 order by b.stock asc limit 10"));
		req.setAttribute("zeroSalesCat", DbUtil.executeQuery(
				"select c.catalogName from s_catalog c where c.catalogId not in (select distinct b.catalogId from s_orderitem oi join s_book b on oi.bookId=b.bookId join s_order o on oi.orderId=o.orderId where o.orderDate like '" + today + "%')"));


		req.setAttribute("statusStats", statusStats);
		req.setAttribute("lowStock", lowStock);
		req.setAttribute("recentOrders", recentOrders);
		req.getRequestDispatcher("orderManage/salesMonitor.jsp").forward(req, resp);
	}
}
