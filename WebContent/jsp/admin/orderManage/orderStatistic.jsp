<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<meta charset="UTF-8"><title>销售报表</title>
<script src="bs/js/jquery.min.js"></script>
<script src="bs/js/bootstrap.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="bs/css/bootstrap.css">
<link rel="stylesheet" href="bs/css/bootstrap-purple-theme.css">
<link rel="stylesheet" href="css/admin/adminManage/userList.css">
<style>
body{background:#f0f2f5;} h3{border-left:4px solid #667eea;padding-left:12px;margin:20px 0 14px;}
.box{background:#fff;border-radius:10px;padding:20px;margin-bottom:16px;box-shadow:0 2px 8px rgba(0,0,0,.08);}
canvas{max-height:260px;} .nav-tabs{margin-bottom:16px;}
.status-tag{display:inline-block;padding:3px 10px;border-radius:12px;font-size:12px;color:#fff;}
.status-tag.st1{background:#f0ad4e;} .status-tag.st2{background:#5bc0de;} .status-tag.st3{background:#5cb85c;}
</style>
</head>
<body>
<div class="container">

<%-- ===== 1. 销售趋势(日/周/月) + 预测 ===== --%>
<div class="box"><h3>销售趋势与预测</h3>
<ul class="nav nav-tabs"><li class="active"><a data-toggle="tab" href="#tabDay">日</a></li><li><a data-toggle="tab" href="#tabWeek">周</a></li><li><a data-toggle="tab" href="#tabMonth">月</a></li></ul>
<div class="tab-content">
<div id="tabDay" class="tab-pane active"><canvas id="dc" height="100"></canvas></div>
<div id="tabWeek" class="tab-pane"><canvas id="wc" height="100"></canvas></div>
<div id="tabMonth" class="tab-pane"><canvas id="mc" height="100"></canvas></div>
</div></div>

<%-- ===== 2. 商品销售排行榜 ===== --%>
<div class="box"><h3>商品销售排行榜 TOP 20</h3>
<canvas id="rankChart" height="120"></canvas>
<table class="table table-striped table-bordered" style="margin-top:14px;">
<tr class="success"><th>#</th><th>书名</th><th>分类</th><th>销量</th><th>金额(元)</th></tr>
<c:forEach items="${rankList}" var="r" varStatus="s">
<tr><td>${s.count}</td><td>${r.bookName}</td><td>${r.catalogName}</td><td>${r.sold}</td><td>${r.revenue}</td></tr>
</c:forEach></table></div>

<%-- ===== 3. 类别销售 + 状态表 ===== --%>
<div class="row">
<div class="col-md-6"><div class="box"><h3>按类别销售</h3><canvas id="catChart" height="100"></canvas></div></div>
<div class="col-md-6"><div class="box"><h3>订单状态汇总</h3>
<table class="table table-bordered table-striped"><tr class="success"><th>状态</th><th>数量</th><th>金额(元)</th></tr>
<c:forEach items="${statusStats}" var="s"><tr><td>
<c:choose><c:when test="${s.orderStatus eq 1}"><span class="status-tag st1">待处理</span></c:when>
<c:when test="${s.orderStatus eq 2}"><span class="status-tag st2">已发货</span></c:when>
<c:when test="${s.orderStatus eq 3}"><span class="status-tag st3">已完成</span></c:when>
<c:otherwise>其他</c:otherwise></c:choose>
</td><td>${s.total} 单</td><td>${s.money}</td></tr></c:forEach></table>
</div></div></div>

<%-- ===== 4. 库存汇总 ===== --%>
<div class="box"><h3>库存汇总（按分类）</h3>
<table class="table table-bordered table-striped"><tr class="success"><th>分类</th><th>图书种类数</th><th>库存总量</th></tr>
<c:forEach items="${catalogStock}" var="c">
<tr><td>${c.catalogName}</td><td>${c.bookCount} 种</td><td>${c.stockTotal} 册</td></tr></c:forEach>
<c:set var="sb" value="0"/><c:set var="ss" value="0"/>
<c:forEach items="${catalogStock}" var="c"><c:set var="sb" value="${sb+c.bookCount}"/><c:set var="ss" value="${ss+c.stockTotal}"/></c:forEach>
<tr style="font-weight:bold;background:#f7f8fa;"><td>总计</td><td>${sb} 种</td><td>${ss} 册</td></tr>
</table></div>
</div>

<script>
function lineChart(id,lab,val,pre,plabel){
  var ds=[{label:'实际',data:val,borderColor:'#667eea',backgroundColor:'rgba(102,126,234,0.1)',fill:true,tension:0.3}];
  if(pre&&pre.length>0) ds.push({label:plabel,data:pre,borderColor:'#f5576c',borderDash:[5,5],fill:false,tension:0.3});
  new Chart(document.getElementById(id),{type:'line',data:{labels:lab,datasets:ds},
  options:{plugins:{legend:{position:'bottom'}},scales:{y:{beginAtZero:true,ticks:{stepSize:1}}}}});
}
function barH(id,lab,val,color){
  new Chart(document.getElementById(id),{type:'bar',data:{labels:lab,datasets:[{data:val,backgroundColor:color||'#667eea',borderRadius:3}]},
  options:{indexAxis:'y',plugins:{legend:{display:false}},scales:{x:{beginAtZero:true}}}});
}
function predict(arr,n){
  if(arr.length<3) return [];
  var s=0,r=[],i;
  for(i=0;i<arr.length;i++){s+=arr[i]; if(i>=n-1){r.push(Math.round(s/n));s-=arr[i-n+1];}else r.push(null);}
  var a=Math.round(arr.slice(-n).reduce(function(a,b){return a+b;},0)/n);
  r.push(null); r.push(a); return r;
}

var dl=[],dv=[],wl=[],wv=[],ml=[],mv=[];
<c:forEach items="${dayStats}" var="d">dl.push('${d.day}');dv.push(${d.cnt});</c:forEach>
<c:forEach items="${weekStats}" var="w">wl.push('${w.wk}');wv.push(${w.cnt});</c:forEach>
<c:forEach items="${monthStats}" var="m">ml.push('${m.month}');mv.push(${m.cnt});</c:forEach>

lineChart('dc',dl.concat('预测'),dv.concat(null),predict(dv,7),'7日预测');
lineChart('wc',wl.concat('预测'),wv.concat(null),predict(wv,4),'4周预测');
lineChart('mc',ml.concat('预测'),mv.concat(null),predict(mv,3),'3月预测');

var rl=[],rv=[];
<c:forEach items="${rankList}" var="r">rl.push('${r.bookName}');rv.push(${r.sold});</c:forEach>
barH('rankChart',rl,rv,'#f5576c');

var cl=[],cv=[];
<c:forEach items="${catalogSales}" var="c">cl.push('${c.catalogName}');cv.push(${c.soldCount});</c:forEach>
barH('catChart',cl,cv,'#43e97b');
</script>
</body>
</html>
