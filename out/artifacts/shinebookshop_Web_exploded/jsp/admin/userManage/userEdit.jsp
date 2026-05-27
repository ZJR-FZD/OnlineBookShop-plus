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
	<title>用户修改</title>
	<link rel="stylesheet" href="bs/css/bootstrap.css">
	<script type="text/javascript" src="bs/js/jquery.min.js"></script>
	<script type="text/javascript" src="bs/js/bootstrap.js"></script>
	<link rel="stylesheet" type="text/css" href="bs/validform/style.css">
	<script type="text/javascript" src="bs/validform/Validform_v5.3.2_min.js"></script> 
	<script type="text/javascript" src="js/admin/userManage/userEdit.js"></script>
	<style>
        body{
            background: linear-gradient(135deg,#eef2ff,#f5f3ff);
        }

        h2{
            color:#5a4fcf;
            font-weight:600;
            margin:30px 0;
        }

        .container{
            background:#fff;
            padding:40px 20px;
            border-radius:12px;
            box-shadow:0 8px 25px rgba(88,80,236,.18);
            margin-top:40px;
        }

        /* 输入框获取焦点 */
        .form-control:focus{
            border-color:#7c6ee6;
            box-shadow:0 0 0 0.2rem rgba(124,110,230,.25);
        }

        /* 提交按钮（蓝紫） */
        .btn-success{
            background:linear-gradient(135deg,#6a5af9,#8b7cfb);
            border:none;
        }
        .btn-success:hover{
            background:linear-gradient(135deg,#5a4fcf,#7c6ee6);
        }

        /* 重置按钮（浅紫） */
        .btn-warning{
            background:#ede9fe;
            border:1px solid #c7d2fe;
            color:#5a4fcf;
        }
        .btn-warning:hover{
            background:#ddd6fe;
            color:#4f46e5;
        }

        label.control-label{
            color:#4f46e5;
            font-weight:500;
        }
    </style>
</head>
<body>
	<c:if test="${!empty userMessage}">
		<h3 class="text-center">${userMessage}</h3>
	</c:if>
	<div class="container">
		<h2 class="text-center">用户修改</h2>
		<form id="myForm" action="jsp/admin/UserManageServlet?action=update" method="post" class="form-horizontal">
			<input type="hidden" name="userId" value="${userInfo.userId}">
			<div class="form-group">
				<label for="userName" class="col-md-2 col-md-offset-2 control-label">用户名：</label>
				<div class="col-md-4">
					<p class="form-control-static">${userInfo.userName}</p>
				</div>
				
			</div>
			<div class="form-group">
				<label for="passWord" class="col-md-2 col-md-offset-2 control-label">密码：</label>
				<div class="col-md-4">
					<input type="password" name="passWord" id="passWord" class="form-control" value="${userInfo.userPassWord }">
				</div>
				<div class="col-md-4">
					<span class="Validform_checktip"></span>
				</div>
			</div>
			<div class="form-group">
				<label for="c_passWord" class="col-md-2 col-md-offset-2 control-label">确认密码：</label>
				<div class="col-md-4">
					<input type="password" name="c_passWord" id="c_passWord" class="form-control" value="${userInfo.userPassWord }">
				</div>
				<div class="col-md-4">
					<span class="Validform_checktip"></span>
				</div>
			</div>
			<div class="form-group">
				<label for="name" class="col-md-2 col-md-offset-2 control-label">姓名：</label>
				<div class="col-md-4">
					<input type="text" id="name" name="name" class="form-control" value="${userInfo.name }">
				</div>
				<div class="col-md-4">
					<span class="Validform_checktip"></span>
				</div>
			</div>
			<div class="form-group">
				<label class="col-md-2 col-md-offset-2 control-label">性别：</label>
				<div class="col-md-4 ">
					<c:choose>
						<c:when test="${userInfo.sex eq '男'}">
							<label class="radio-inline">
								<input type="radio" name="sex" id="sex" checked="checked" class="pr1" value="男">男
							</label>
							<label class="radio-inline">
								<input type="radio" name="sex"  class="pr1"  value="女">女
							</label>
						</c:when>
						<c:otherwise>
							<label class="radio-inline">
								<input type="radio" name="sex" id="sex" class="pr1" value="男">男
							</label>
							<label class="radio-inline">
								<input type="radio" name="sex" checked="checked"  class="pr1"  value="女">女
							</label>
						</c:otherwise>
					</c:choose>
					
				</div>
				
			</div>
			<div class="form-group">
				<label for="age" class="col-md-2 col-md-offset-2 control-label">年龄：</label>
				<div class="col-md-4">
					<input type="text" id="age" name="age" class="form-control" value="${userInfo.age }">
				</div>
				<div class="col-md-4">
					<span class="Validform_checktip"></span>
				</div>
			</div>
			<div class="form-group">
				<label for="tell" class="col-md-2 col-md-offset-2 control-label">电话：</label>
				<div class="col-md-4">
					<input type="text" id="tell" name="tell" class="form-control" value="${userInfo.tell }">
				</div>
				<div class="col-md-4">
					<span class="Validform_checktip"></span>
				</div>
			</div>
			<div class="form-group">
				<label for="address" class="col-md-2 col-md-offset-2 control-label">地址：</label>
				<div class="col-md-4">
					<input type="text" id="address" name="address" class="form-control" value="${userInfo.address }">
				</div>
				<div class="col-md-4">
					<span class="Validform_checktip"></span>
				</div>
			</div>
			<div class="form-group">
					<label for="email" class="col-md-2 col-md-offset-2 control-label">邮箱：</label>
					<div class="col-md-4">
						<input type="text" id="email" name="email" class="form-control" value="${userInfo.email }" placeholder="选填">
					</div>
					<div class="col-md-4">
						<span class="Validform_checktip">选填</span>
					</div>
				</div>
			<div class="form-group">
				<label for="enabled" class="col-md-2 col-md-offset-2 control-label">启用状态</label>
				<div class="col-md-4">
					<select class="form-control" name="enabled" id="enabled">
						<c:choose>
							<c:when test="${userInfo.enabled eq 'y'}">
								<option value="y" selected="selected">启用</option>
								<option value="n">禁用</option>
							</c:when>
							<c:otherwise>
								<option value="y">启用</option>
								<option value="n" selected="selected">禁用</option>
							</c:otherwise>
						</c:choose>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col-md-2  control-label col-md-offset-2">
					<input class="btn btn-success btn-block" type="submit" value="更改">
				</label>
				<label class="col-md-2 control-label">
					<input class="btn btn-warning btn-block" type="reset" value="重置">
				</label>
			</div>
		</form>
	</div>
</body>
</html>