<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	pageContext.setAttribute("basePath", basePath);
%>
<!DOCTYPE html>
<html>
<head>
<base href="${basePath}">
	<meta charset="UTF-8">
	<title>销售状态监控</title>
	<script type="text/javascript" src="bs/js/jquery.min.js"></script>
	<script type="text/javascript" src="bs/js/bootstrap.js"></script>
	<link rel="stylesheet" href="bs/css/bootstrap.css">
	<link rel="stylesheet" href="bs/css/bootstrap-purple-theme.css">
	<link rel="stylesheet" href="css/admin/adminManage/userList.css">
	<style type="text/css">
		.stat-cards { display:flex; gap:20px; margin:20px 0; flex-wrap:wrap; }
		.stat-card { flex:1; min-width:180px; background:#fff; border-radius:10px; padding:20px; text-align:center; box-shadow:0 2px 8px rgba(0,0,0,.08); }
		.stat-card .num { font-size:32px; font-weight:800; }
		.stat-card .label { color:#888;font-size:14px;margin-top:4px; }
		.stat-card.pending .num { color:#f0ad4e; }
		.stat-card.shipped .num { color:#5bc0de; }
		.stat-card.done .num { color:#5cb85c; }
		.stat-card.total .num { color:#667eea; }
		.warn-table td { vertical-align:middle; }
		.stock-low { color:#d9534f;font-weight:bold; }
		.stock-ok { color:#5cb85c; }
		.status-tag { display:inline-block;padding:3px 10px;border-radius:12px;font-size:12px;color:#fff; }
		.status-tag.st1 { background:#f0ad4e; }
		.status-tag.st2 { background:#5bc0de; }
		.status-tag.st3 { background:#5cb85c; }
		.section-title { border-left:4px solid #667eea;padding-left:12px;margin:24px 0 12px;font-size:18px; }
	</style>
</head>
<body>
	<h2 class="text-center">销售状态监控</h2>

	<!-- 订单状态卡片 -->
	<div class="container content">
		<h4 class="section-title">订单状态概览</h4>
		<div class="stat-cards">
			<c:set var="totalOrders" value="0"/>
			<c:set var="totalMoney" value="0"/>
			<c:forEach items="${statusStats}" var="s">
				<c:set var="totalOrders" value="${totalOrders + s.cnt}"/>
				<c:set var="totalMoney" value="${totalMoney + s.totalMoney}"/>
			</c:forEach>

			<c:forEach items="${statusStats}" var="s">
				<c:choose>
					<c:when test="${s.orderStatus eq 1}"><c:set var="cls" value="pending"/><c:set var="label" value="待处理"/></c:when>
					<c:when test="${s.orderStatus eq 2}"><c:set var="cls" value="shipped"/><c:set var="label" value="已发货"/></c:when>
					<c:when test="${s.orderStatus eq 3}"><c:set var="cls" value="done"/><c:set var="label" value="已完成"/></c:when>
					<c:otherwise><c:set var="cls" value="total"/><c:set var="label" value="其他"/></c:otherwise>
				</c:choose>
				<div class="stat-card ${cls}">
					<div class="num">${s.cnt}</div>
					<div class="label">${label}</div>
					<div style="font-size:13px;color:#999;">￥${s.totalMoney}</div>
				</div>
			</c:forEach>

			<div class="stat-card total">
				<div class="num">${totalOrders}</div>
				<div class="label">总订单数</div>
				<div style="font-size:13px;color:#999;">￥${totalMoney}</div>
			</div>
		</div>

		<!-- 库存预警 -->
		<h4 class="section-title">库存预警（库存 &le; 5）</h4>
		<table class="table table-striped table-hover warn-table">
			<tr class="success">
				<th>图书</th>
				<th>分类</th>
				<th>库存</th>
				<th>状态</th>
			</tr>
			<c:choose>
				<c:when test="${!empty lowStock}">
					<c:forEach items="${lowStock}" var="b">
					<tr>
						<td>${b.bookName}</td>
						<td>${b.catalogName}</td>
						<td>${b.stock}</td>
						<td>
							<c:choose>
								<c:when test="${b.stock eq 0}"><span class="stock-low">已售罄</span></c:when>
								<c:otherwise><span class="stock-low">库存不足</span></c:otherwise>
							</c:choose>
						</td>
					</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr><td colspan="4"><h4 class="text-center">所有商品库存充足</h4></td></tr>
				</c:otherwise>
			</c:choose>
		</table>

		<!-- 最近订单 -->
		<h4 class="section-title">最近订单</h4>
		<table class="table table-striped table-hover">
			<tr class="success">
				<th>订单编号</th>
				<th>用户</th>
				<th>日期</th>
				<th>金额</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
			<c:choose>
				<c:when test="${!empty recentOrders}">
					<c:forEach items="${recentOrders}" var="o">
					<tr>
						<td>${o.orderNum}</td>
						<td>${o.userName}</td>
						<td>${o.orderDate}</td>
						<td>￥${o.money}</td>
						<td>
							<c:choose>
								<c:when test="${o.orderStatus eq 1}"><span class="status-tag st1">待处理</span></c:when>
								<c:when test="${o.orderStatus eq 2}"><span class="status-tag st2">已发货</span></c:when>
								<c:when test="${o.orderStatus eq 3}"><span class="status-tag st3">已完成</span></c:when>
							</c:choose>
						</td>
						<td>
							<a class="btn btn-default btn-sm" href="jsp/admin/OrderManageServlet?action=detail&id=${o.orderId}">详情</a>
						</td>
					</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr><td colspan="6"><h4 class="text-center">暂无订单</h4></td></tr>
				</c:otherwise>
			</c:choose>
	<c:if test="${!empty todaySales}">
		<c:forEach items="${todaySales}" var="t">
		<c:forEach items="${avg7Sales}" var="a">
		<div style="background:#fff;border-radius:10px;padding:16px;margin:16px 0;box-shadow:0 2px 8px rgba(0,0,0,.08);">
		<h4 style="color:#d9534f;">今日异常监控</h4>
		<p>今日：<b>${t.cnt}</b> 单 / <b>${t.total}</b> 元 &nbsp;|&nbsp; 前7天日均：<b>${a.avgCnt}</b> 单 / <b>${a.avgTotal}</b> 元</p>
		<c:if test="${t.cnt < a.avgCnt * 0.3}"><p style="color:#d9534f;">异常：今日销量不足日均 30%</p></c:if>
		<c:if test="${!empty zeroSalesCat}"><p style="color:#d9534f;">今日零销售分类：
		<c:forEach items="${zeroSalesCat}" var="z"><span class="label label-warning">${z.catalogName}</span> </c:forEach></p></c:if>
		</div>
		</c:forEach></c:forEach></c:if>
		<c:if test="${!empty lowStockHot}">
		<div style="background:#fff;border-radius:10px;padding:16px;margin:16px 0;box-shadow:0 2px 8px rgba(0,0,0,.08);">
		<h4 style="color:#d9534f;">低库存热销预警</h4>
		<table class="table table-bordered table-condensed"><tr class="danger"><th>书名</th><th>库存</th><th>近期销量</th></tr>
		<c:forEach items="${lowStockHot}" var="l"><tr><td>${l.bookName}</td><td>${l.stock}</td><td>${l.recentSold}</td></tr></c:forEach></table>
		</div>
		</c:if>
		</table>
	</div>
</body>
</html>
