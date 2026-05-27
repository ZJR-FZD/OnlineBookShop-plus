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
	<link rel="stylesheet" href="bs/css/bootstrap.css">
	<script type="text/javascript" src="bs/js/jquery.min.js"></script>
	<script type="text/javascript" src="bs/js/bootstrap.js"></script>
	<link rel="stylesheet" type="text/css" href="bs/validform/style.css">
	<script type="text/javascript" src="bs/validform/Validform_v5.3.2_min.js"></script> 
	<script type="text/javascript" src="js/admin/adminManage/adminEdit.js"></script>
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

        /* label 颜色 */
        label.control-label{
            color:#4f46e5;
            font-weight:500;
        }

        /* 输入框聚焦 */
        .form-control:focus{
            border-color:#7c6ee6;
            box-shadow:0 0 0 0.2rem rgba(124,110,230,.25);
        }

        /* 主按钮：蓝紫渐变 */
        .btn-success{
            background:linear-gradient(135deg,#6a5af9,#8b7cfb);
            border:none;
        }
        .btn-success:hover{
            background:linear-gradient(135deg,#5a4fcf,#7c6ee6);
        }

        /* 次按钮：浅紫 */
        .btn-warning{
            background:#ede9fe;
            border:1px solid #c7d2fe;
            color:#5a4fcf;
        }
        .btn-warning:hover{
            background:#ddd6fe;
            color:#4f46e5;
        }

        /* 校验提示文字 */
        .Validform_checktip{
            color:#6b7280;
        }
    </style>
</head>
<body>
	<c:if test="${!empty adminMessage}">
		<h3 class="text-center">${adminMessage}</h3>
	</c:if>
	<div class="container">
		<h2 class="text-center">编辑销售人员</h2>
		<form action="jsp/admin/AdminManageServlet?action=update" method="post" class="form-horizontal" onsubmit="javascript:return checkAdd();">
				<input type="hidden" name="id" value="${adminInfo.id}">
				<div class="form-group">
					<label for="userName" class="col-sm-2 col-sm-offset-2 control-label">用户名：</label>
					<div class="col-sm-4">
						<span>${adminInfo.userName}</span>
					</div>
				</div>
				<div class="form-group">
					<label for="passWord" class="col-sm-2 col-sm-offset-2 control-label">密码：</label>
					<div class="col-sm-4">
						<input type="password" name="passWord" id="passWord" class="form-control" value="${adminInfo.passWord}">
					</div>
					<div class="col-sm-4">
						<span class="Validform_checktip">密码为4~8位字符</span>
					</div>
				</div>
				<div class="form-group">
					<label for="passWord_ck" class="col-sm-2 col-sm-offset-2 control-label">确认密码：</label>
					<div class="col-sm-4">
						<input type="password" name="passWord_ck" id="passWord_ck" class="form-control" value="${adminInfo.passWord}">
					</div>
					<div class="col-sm-4">
						<span class="Validform_checktip"></span>
					</div>
				</div>
				<div class="form-group">
					<label for="name" class="col-sm-2 col-sm-offset-2 control-label">姓名：</label>
					<div class="col-sm-4">
						<input type="text" id="name" name="name" class="form-control" value="${adminInfo.name}">
					</div>
					<div class="col-sm-4">
						<span class="Validform_checktip">姓名为2~8位字符</span>
					</div>
				</div>
				<div class="form-group">
					<label for="role" class="col-sm-2 col-sm-offset-2 control-label">角色：</label>
					<div class="col-sm-4">
						<select name="role" id="role" class="form-control">
							<option value="sales" ${adminInfo.role eq 'sales' ? 'selected' : ''}>销售人员</option>
							<option value="admin" ${adminInfo.role eq 'admin' ? 'selected' : ''}>管理员</option>
						</select>
					</div>
					<div class="col-sm-4">
						<span class="Validform_checktip">可用于销售人员密码重置或权限调整</span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 col-sm-offset-2 control-label">
						<input class="btn btn-success btn-block" type="submit" value="更新">
					</label>
					<label class="col-sm-2 control-label">
						<input class="btn btn-warning btn-block" type="reset" value="重置">
					</label>
				</div>
		</form>
	</div>
</body>
</html>