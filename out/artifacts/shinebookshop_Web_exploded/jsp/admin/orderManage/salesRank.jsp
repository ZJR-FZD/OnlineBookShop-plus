<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<base href="${pageContext.request.contextPath}/">
<meta charset="UTF-8"><title>销售排行榜</title>
<script src="bs/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="bs/css/bootstrap.css">
<link rel="stylesheet" href="bs/css/bootstrap-purple-theme.css">
<link rel="stylesheet" href="css/admin/adminManage/userList.css">
<style>body{background:#f0f2f5;} h2{border-left:4px solid #667eea;padding-left:12px;margin:20px 0;}
.btn-group{margin-bottom:16px;} canvas{max-height:300px;}
.chart-tab{background:#fff;border-radius:10px;padding:20px;margin-bottom:18px;box-shadow:0 2px 8px rgba(0,0,0,.08);}
</style>
</head>
<body>
<div class="container"><h2>商品销售排行榜</h2>

<div class="btn-group">
<a href="AnalyticsServlet?action=rank&sortBy=sold" class="btn btn-sm ${sortBy!='revenue'?'btn-info':'btn-default'}">按销量</a>
<a href="AnalyticsServlet?action=rank&sortBy=revenue" class="btn btn-sm ${sortBy=='revenue'?'btn-info':'btn-default'}">按金额</a>
</div>

<div class="chart-tab"><canvas id="rankChart"></canvas></div>

<table class="table table-striped table-bordered">
<tr class="success"><th>#</th><th>书名</th><th>分类</th><th>销量</th><th>金额(元)</th></tr>
<c:forEach items="${rankList}" var="r" varStatus="s">
<tr><td>${s.count}</td><td>${r.bookName}</td><td>${r.catalogName}</td><td>${r.sold}</td><td>${r.revenue}</td></tr>
</c:forEach></table>
</div>

<script>
var rd=[];
<c:forEach items="${rankList}" var="r">rd.push({n:'${r.bookName}',v:${sortBy=='revenue'?r.revenue:r.sold}});</c:forEach>
new Chart(document.getElementById('rankChart'),{type:'bar',data:{labels:rd.map(function(d){return d.n.length>8?d.n.substring(0,8)+'...':d.n;}),
datasets:[{data:rd.map(function(d){return d.v;}),backgroundColor:'#f5576c',borderRadius:4}]},
options:{indexAxis:'y',plugins:{legend:{display:false}},scales:{x:{beginAtZero:true}}}});
</script>
</body>
</html>
