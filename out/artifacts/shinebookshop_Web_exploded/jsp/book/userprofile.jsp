<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人中心</title>
    <link rel="stylesheet" href="bs/css/bootstrap.css">

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI",
                         "PingFang SC", "Microsoft YaHei", sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 15px;
        }

        .profile-card {
            max-width: 700px;
            margin: auto;
            background: #fff;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
            animation: fadeIn 0.4s ease;
        }

        .profile-title {
            text-align: center;
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 30px;
            background: linear-gradient(135deg,#667eea,#764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .info-row {
            display: flex;
            margin-bottom: 15px;
            padding: 12px 15px;
            border-radius: 12px;
            transition: all .3s;
        }

        .info-row:hover {
            background: rgba(102,126,234,0.08);
        }

        .info-label {
            width: 120px;
            font-weight: 600;
            color: #667eea;
        }

        .info-value {
            flex: 1;
            color: #555;
        }

        .btn-area {
            margin-top: 35px;
            text-align: center;
        }

        .btn {
            border-radius: 25px;
            padding: 10px 28px;
            font-weight: 600;
            margin: 0 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg,#667eea,#764ba2);
            border: none;
            color: #fff;
        }

        .btn-primary:hover {
            box-shadow: 0 8px 25px rgba(102,126,234,0.5);
        }

        .btn-danger {
            background: linear-gradient(135deg,#ff6a6a,#ff4757);
            border: none;
            color: #fff;
        }

        .btn-danger:hover {
            box-shadow: 0 8px 25px rgba(255,71,87,0.5);
        }

        .btn-default {
            border: 2px solid #ddd;
            background: #f5f7fa;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>

<body>

<c:if test="${empty landing}">
    <script>
        alert("请先登录！");
        location.href="jsp/book/reg.jsp?type=login";
    </script>
</c:if>

<div class="profile-card">
    <div class="profile-title">👤 个人中心</div>

    <div class="info-row">
        <div class="info-label">用户名</div>
        <div class="info-value">${landing.userName}</div>
    </div>

    <div class="info-row">
        <div class="info-label">姓名</div>
        <div class="info-value">${landing.name}</div>
    </div>

    <div class="info-row">
        <div class="info-label">性别</div>
        <div class="info-value">${landing.sex}</div>
    </div>

    <div class="info-row">
        <div class="info-label">年龄</div>
        <div class="info-value">${landing.age}</div>
    </div>

    <div class="info-row">
        <div class="info-label">电话</div>
        <div class="info-value">${landing.tell}</div>
    </div>

    <div class="info-row">
        <div class="info-label">地址</div>
        <div class="info-value">${landing.address}</div>
    </div>
    <div class="info-row">
	        <div class="info-label">邮箱</div>
	        <div class="info-value">${empty landing.email ? '未设置' : landing.email}</div>
	    </div>

    <div class="btn-area">
        <!-- 返回首页 -->
        <a href="jsp/book/index.jsp" class="btn btn-default">🏠 返回首页</a>

        <!-- 退出登录 -->
        <a href="UserServlet?action=off"
           class="btn btn-primary"
           onclick="return confirm('确定要退出登录吗？')">
            🚪 退出登录
        </a>

        <!-- 注销账号 -->
        <a href="UserServlet?action=delete&id=${landing.userId}"
           class="btn btn-danger"
           onclick="return confirm('⚠️ 注销账号后无法恢复，确定继续吗？')">
            ❌ 注销账号
        </a>
    </div>
</div>

</body>
</html>