<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<base href="${pageContext.request.contextPath}/">
<meta charset="UTF-8"><title>销售异常监控</title>
<link rel="stylesheet" href="bs/css/bootstrap.css">
<link rel="stylesheet" href="bs/css/bootstrap-purple-theme.css">
<link rel="stylesheet" href="css/admin/adminManage/userList.css">
<style>
body{background:#f0f2f5;} h2{border-left:4px solid #f5576c;padding-left:12px;margin:20px 0;}
.alert-card{background:#fff;border-radius:10px;padding:18px 22px;margin-bottom:14px;box-shadow:0 2px 8px rgba(0,0,0,.08);}
.alert-card h4{margin:0 0 8px;}
.warn{color:#d9534f;} .safe{color:#5cb85c;}
.stat-num{font-size:28px;font-weight:800;}
</style>
</head>
<body>
<div class="container"><h2>销售异常监控</h2>

<div class="row">
<c:forEach items="${todaySales}" var="t">
<c:forEach items="${avg7Sales}" var="a">
<div class="col-md-6"><div class="alert-card">
<h4>今日销量对比</h4>
<p>今日：<span class="stat-num">${t.cnt}</span> 单 / ￥${t.total}</p>
<p>前7天日均：<span class="stat-num">${a.avgCnt}</span> 单 / ￥${a.avgTotal}</p>
<c:set var="ratio" value="${t.cnt > 0 && a.avgCnt > 0 ? t.cnt / a.avgCnt * 100 : 0}"/>
<c:choose>
<c:when test="${t.cnt < a.avgCnt * 0.3}"><p class="warn">异常：今日销量不足日均30%</p></c:when>
<c:otherwise><p class="safe">正常</p></c:otherwise>
</c:choose>
</div></div>
</c:forEach></c:forEach>

<div class="col-md-6"><div class="alert-card">
<h4>零销售分类</h4>
<c:choose>
<c:when test="${!empty zeroSalesCat}">
<p class="warn">以下分类今日无销售：</p>
<c:forEach items="${zeroSalesCat}" var="z"><span class="label label-warning" style="margin:2px;">${z.catalogName}</span> </c:forEach>
</c:when>
<c:otherwise><p class="safe">所有分类均有销售</p></c:otherwise>
</c:choose>
</div></div>
</div>

<div class="alert-card"><h4>低库存热销预警（库存≤5 且近期有销售）</h4>
<c:choose>
<c:when test="${!empty lowStockHot}">
<table class="table table-bordered table-striped">
<tr class="success"><th>书名</th><th>分类</th><th>库存</th><th>近期销量</th><th>状态</th></tr>
<c:forEach items="${lowStockHot}" var="l">
<tr><td>${l.bookName}</td><td>${l.catalogName}</td><td>${l.stock}</td><td>${l.recentSold}</td>
<td><c:choose><c:when test="${l.stock eq 0}"><span class="label label-danger">售罄</span></c:when><c:otherwise><span class="label label-warning">库存不足</span></c:otherwise></c:choose></td></tr>
</c:forEach></table>
</c:when>
<c:otherwise><p class="safe">目前无低库存热销商品</p></c:otherwise>
</c:choose>
</div>
</div>
</body>
</html>
