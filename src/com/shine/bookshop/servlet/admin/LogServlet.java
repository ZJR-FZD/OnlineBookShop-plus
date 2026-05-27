package com.shine.bookshop.servlet.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shine.bookshop.bean.PageBean;
import com.shine.bookshop.util.DbUtil;

@WebServlet("/jsp/admin/LogServlet")
public class LogServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String action = req.getParameter("action");
		if (action == null) action = "list";

		if ("staff".equals(action)) {
			listStaffLogs(req, resp);
		} else {
			listLogs(req, resp);
		}
	}

	private void listLogs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int curPage = 1;
		String page = req.getParameter("page");
		if (page != null && !page.trim().isEmpty()) curPage = Integer.parseInt(page);

		int maxSize = Integer.parseInt(req.getServletContext().getInitParameter("maxPageSize"));

		String filterType = req.getParameter("filterType");
		if (filterType != null && !filterType.matches("BROWSE|PURCHASE|EMAIL|CRAWLER")) {
			filterType = null;
		}
		String where = " where logType in ('BROWSE','PURCHASE','EMAIL','CRAWLER')";
		if (filterType != null) {
			where += " and logType='" + filterType + "'";
		}
		queryAndForward(req, resp, curPage, maxSize, where, filterType, null);
	}

	private void listStaffLogs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int curPage = 1;
		String page = req.getParameter("page");
		if (page != null && !page.trim().isEmpty()) curPage = Integer.parseInt(page);

		int maxSize = Integer.parseInt(req.getServletContext().getInitParameter("maxPageSize"));

		String staffRole = req.getParameter("staffRole");
		if (staffRole != null && !staffRole.matches("admin|sales")) {
			staffRole = null;
		}

		String where = " where logType in ('LOGIN','ADMIN_OP')";
		if (staffRole != null) {
			where += " and userName in (select userName from s_admin where role='" + staffRole + "')";
		}
		queryAndForward(req, resp, curPage, maxSize, where, "STAFF", staffRole);
	}

	private void queryAndForward(HttpServletRequest req, HttpServletResponse resp,
			int curPage, int maxSize, String where, String filterType, String staffRole)
			throws ServletException, IOException {

		String countSql = "select count(*) as cnt from s_operation_log" + where;
		List<Map<String, Object>> c = DbUtil.executeQuery(countSql);
		long total = c.isEmpty() ? 0 : ((Number) c.get(0).get("cnt")).longValue();

		PageBean pb = new PageBean(curPage, maxSize, total);
		String sql = "select * from s_operation_log" + where + " order by logId desc limit ?,?";
		List<Map<String, Object>> logs = DbUtil.executeQuery(sql,
				(pb.getCurPage() - 1) * pb.getMaxSize(), pb.getMaxSize());

		req.setAttribute("logList", logs);
		req.setAttribute("pageBean", pb);
		req.setAttribute("filterType", filterType);
		req.setAttribute("staffRole", staffRole);
		req.getRequestDispatcher("orderManage/logList.jsp").forward(req, resp);
	}
}
