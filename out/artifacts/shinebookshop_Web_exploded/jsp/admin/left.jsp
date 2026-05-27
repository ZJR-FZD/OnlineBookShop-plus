<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title></title>
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<link rel="stylesheet" href="css/admin/left.css">
</head>
<body>
<div class="left">
<ul>
	<c:if test="${adminUser.role eq 'admin'}">
	<li class="list">
		<h3>人 员 管 理</h3>
		<ul>
			<li><a href="jsp/admin/AdminManageServlet?action=list" target="rFrame">销售人员管理</a></li>
			<li><a href="jsp/admin/UserManageServlet?action=list" target="rFrame">用户管理</a></li>
			<li><a href="jsp/admin/LogServlet?action=staff" target="rFrame">工作人员日志</a></li>
		</ul>
	</li>
	</c:if>

	<li class="list">
		<h3>图 书 管 理</h3>
		<ul>
			<li><a href="jsp/admin/BookManageServlet?action=list" target="rFrame">图书列表</a></li>
			<li><a href="jsp/admin/CatalogServlet?action=list" target="rFrame">分类管理</a></li>
		</ul>
	</li>

	<c:choose>
		<c:when test="${adminUser.role eq 'admin'}">
		<li class="list">
			<h3>销 售 分 析</h3>
			<ul>
				<li><a href="jsp/admin/SalesMonitorServlet" target="rFrame">销售监控</a></li>
				<li><a href="jsp/admin/OrderManageServlet?action=stat" target="rFrame">销售报表</a></li>
			</ul>
		</li>
		<li class="list">
			<h3>用 户 分 析</h3>
			<ul>
				<li><a href="jsp/admin/AnalyticsServlet?action=profile" target="rFrame">用户画像</a></li>
				<li><a href="jsp/admin/LogServlet?action=list" target="rFrame">行为日志</a></li>
			</ul>
		</li>
		</c:when>
		<c:otherwise>
		<li class="list">
			<h3>订 单 管 理</h3>
			<ul>
				<li><a href="jsp/admin/OrderManageServlet?action=list" target="rFrame">订单列表</a></li>
				<li><a href="jsp/admin/OrderManageServlet?action=processing" target="rFrame">订单处理</a></li>
			</ul>
		</li>
		<li class="list">
			<h3>销 售 分 析</h3>
			<ul>
				<li><a href="jsp/admin/SalesMonitorServlet" target="rFrame">销售监控</a></li>
				<li><a href="jsp/admin/OrderManageServlet?action=stat" target="rFrame">销售报表</a></li>
			</ul>
		</li>
		<li class="list">
			<h3>用 户 分 析</h3>
			<ul>
			<li><a href="jsp/admin/AnalyticsServlet?action=profile" target="rFrame">用户画像</a></li>
				<li><a href="jsp/admin/LogServlet?action=list" target="rFrame">行为日志</a></li>
			</ul>
		</li>
		</c:otherwise>
	</c:choose>

</ul>
</div>
<script type="text/javascript">
$(document).ready(function() {
	$(".list ul").hide();
	$(".list h3").click(function(){
		var $submenu = $(this).next("ul");
		if($submenu.is(":hidden")){
			$(".list ul").slideUp(300);
			$(".list h3").removeClass("active").css("color","#fff");
			$submenu.slideDown(300);
			$(this).addClass("active").css("color","#fff");
		} else {
			$submenu.slideUp(300);
			$(this).removeClass("active");
		}
	});
	$(".list ul a").click(function(){
		$(".list ul a").removeClass("active").css("color","#555");
		$(this).addClass("active").css("color","#667eea");
	});
});
</script>
</body>
</html>
