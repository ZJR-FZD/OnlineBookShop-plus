<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<base href="${pageContext.request.contextPath}/">
<meta charset="UTF-8"><title>用户画像</title>
<script src="bs/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="bs/css/bootstrap.css">
<link rel="stylesheet" href="bs/css/bootstrap-purple-theme.css">
<link rel="stylesheet" href="css/admin/adminManage/userList.css">
<style>
body{background:#f0f2f5;} h2{border-left:4px solid #667eea;padding-left:12px;margin:20px 0;}
.chart-box{background:#fff;border-radius:10px;padding:20px;margin-bottom:18px;box-shadow:0 2px 8px rgba(0,0,0,.08);}
canvas{max-height:260px;}
</style>
</head>
<body>
<div class="container"><h2>用户画像</h2>

<div class="row">
<div class="col-md-6"><div class="chart-box"><h4>性别分布</h4><canvas id="genderChart"></canvas></div></div>
<div class="col-md-6"><div class="chart-box"><h4>年龄分布</h4><canvas id="ageChart"></canvas></div></div>
</div>
<div class="row">
<div class="col-md-6"><div class="chart-box"><h4>购买力分层</h4><canvas id="spendChart"></canvas></div></div>
<div class="col-md-6"><div class="chart-box"><h4>分类偏好</h4><canvas id="catalogChart"></canvas></div></div>
</div>
<div class="chart-box"><h4>地域分布 TOP 20</h4>
<table class="table table-striped table-bordered"><tr class="success"><th>地址</th><th>用户数</th></tr>
<c:forEach items="${regionStats}" var="r"><tr><td>${r.address}</td><td>${r.cnt}</td></tr></c:forEach></table>
</div>
</div>

<script>
function pie(id, data){
  new Chart(document.getElementById(id),{type:'pie',data:{labels:data.map(function(d){return d.k;}),
  datasets:[{data:data.map(function(d){return d.v;}),backgroundColor:['#667eea','#f5576c','#43e97b','#f0ad4e','#5bc0de','#a855f7']}]}});
}
var gd=[],ad=[],sd=[],cd=[];
<c:forEach items="${genderStats}" var="g">gd.push({k:'${g.sex}',v:${g.cnt}});</c:forEach>
<c:forEach items="${ageStats}" var="a">ad.push({k:'${a.ageGroup}',v:${a.cnt}});</c:forEach>
<c:forEach items="${catalogPref}" var="c">cd.push({k:'${c.catalogName}',v:${c.cnt}});</c:forEach>
sd.push({k:'低(<100元)',v:${spendLow}},{k:'中(100-300元)',v:${spendMid}},{k:'高(>300元)',v:${spendHigh}});
pie('genderChart',gd); pie('ageChart',ad); pie('spendChart',sd);
new Chart(document.getElementById('catalogChart'),{type:'bar',data:{labels:cd.map(function(d){return d.k;}),
datasets:[{data:cd.map(function(d){return d.v;}),backgroundColor:'#667eea',borderRadius:4}]},
options:{indexAxis:'y',plugins:{legend:{display:false}},scales:{x:{beginAtZero:true}}}});
</script>
</body>
</html>
