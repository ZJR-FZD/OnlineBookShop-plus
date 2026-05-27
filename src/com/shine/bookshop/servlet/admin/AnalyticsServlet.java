package com.shine.bookshop.servlet.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shine.bookshop.util.DbUtil;

@WebServlet("/jsp/admin/AnalyticsServlet")
public class AnalyticsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");
		if (action == null) action = "profile";

		if ("profile".equals(action)) {
			userProfile(req, resp);
		}
	}

	private void userProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setAttribute("regionStats", DbUtil.executeQuery(
				"select address, count(*) as cnt from s_user group by address order by cnt desc limit 20"));
		req.setAttribute("genderStats", DbUtil.executeQuery(
				"select sex, count(*) as cnt from s_user group by sex"));
		req.setAttribute("ageStats", DbUtil.executeQuery(
				"select case when age < 20 then '20以下' when age between 20 and 29 then '20-29' when age between 30 and 39 then '30-39' else '40以上' end as ageGroup, count(*) as cnt from s_user group by ageGroup order by ageGroup"));

		// 每个用户的消费总额
		List<Map<String, Object>> userSpend = DbUtil.executeQuery(
				"select u.userId, coalesce(sum(o.money),0) as total from s_user u left join s_order o on u.userId=o.userId and o.orderStatus in (2,3) group by u.userId");
		int low = 0, mid = 0, high = 0;
		double totalSpend = 0;
		for (Map<String, Object> row : userSpend) {
			double t = ((Number) row.get("total")).doubleValue();
			totalSpend += t;
			if (t < 100) low++;
			else if (t <= 300) mid++;
			else high++;
		}
		int total = low + mid + high;
		req.setAttribute("spendLow", low);
		req.setAttribute("spendMid", mid);
		req.setAttribute("spendHigh", high);
		req.setAttribute("spendAvg", total > 0 ? Math.round(totalSpend / total) : 0);

		req.setAttribute("catalogPref", DbUtil.executeQuery(
				"select c.catalogName, coalesce(sum(oi.quantity),0) as cnt from s_orderitem oi join s_book b on oi.bookId=b.bookId join s_catalog c on b.catalogId=c.catalogId group by c.catalogName order by cnt desc"));

		req.getRequestDispatcher("orderManage/userProfile.jsp").forward(req, resp);
	}
}
