<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String role = request.getParameter("role");
	boolean isSales = "sales".equals(role);
	String loginRoleTitle = isSales ? "销售人员登录" : "管理员登录";
	String roleTag = isSales ? "销售后台" : "管理后台";
	String defaultUser = isSales ? "salesperson" : "admin";
	String defaultPwd  = isSales ? "salesperson" : "admin";
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=loginRoleTitle%> - 当当小书屋</title>
<link rel="stylesheet" type="text/css" href="css/login/login.css" />
<style type="text/css">
	.default-hint { text-align:center;background:#fffbe6;border:1px solid #ffe58f;border-radius:8px;padding:12px 16px;margin:10px auto;max-width:360px;font-size:13px;color:#ad6800; }
	.default-hint code { background:#fff;padding:2px 6px;border-radius:3px;font-weight:bold; }
</style>
<script type="text/javascript">
	function checkForm(){
		var userName=document.getElementById("userName");
		var passWord=document.getElementById("passWord");
		if(userName.value.length<=0){
			alert("请输入用户名！");
			userName.focus();
			return false;
		}
		if(passWord.value.length<=0){
			alert("请输入密码！");
			passWord.focus();
			return false;
		}
		return true;
	}
</script>
</head>
<body>
<c:if test="${!empty infoList}">
	<c:forEach items="${infoList}" var="i">
		<script type="text/javascript">
			alert("${i}")
		</script>
	</c:forEach>
</c:if>

	<h1 id="title">
		书店后台管理系统&nbsp;<sup style="color:<%= isSales ? "#4facfe" : "#f5576c" %>;font-size:14px;"><%=roleTag%></sup>
	</h1>
	<p style="text-align:center;color:#666;margin-bottom:8px;"><%=loginRoleTitle%></p>

	<div class="default-hint">
		默认账号：<code><%=defaultUser%></code>　密码：<code><%=defaultPwd%></code>
	</div>

	<div id="login">
		<form action="jsp/admin/LoginServlet" method="post"
			onsubmit="javascript:return checkForm()">
			<p>
				<input type="text" name="userName" id="userName" placeholder="用户名" value="<%=defaultUser%>">
			</p>
			<p>
				<input type="password" name="passWord" id="passWord"
					placeholder="密码" value="<%=defaultPwd%>">
			</p>
			<p>
				<input type="submit" id="submit" value="登 录">
			</p>
		</form>
	</div>
</body>
</html>
