<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>欢迎</title>
<style>
	*{margin:0;padding:0;}
	body{background:#f0f2f5;font-family:"Microsoft YaHei","PingFang SC",sans-serif;display:flex;align-items:center;justify-content:center;min-height:100vh;}
	.msg{text-align:center;color:#999;font-size:15px;}
	.msg h3{color:#555;margin-bottom:8px;}
</style>
</head>
<body>
<div class="msg">
	<h3>欢迎，${adminUser.name}</h3>
	<p>请从左侧菜单选择功能</p>
</div>
</body>
</html>
