<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	pageContext.setAttribute("basePath", basePath);
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<base href="${basePath}">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>订单提交成功</title>
<link rel="stylesheet" href="bs/css/bootstrap.css">
<script type="text/javascript" src="bs/js/jquery.min.js"></script>
<script type="text/javascript" src="bs/js/bootstrap.js"></script>		
<script type="text/javascript" src="js/book/landing.js"></script>
<link href="css/book/head_footer.css" rel="stylesheet" type="text/css">
<style type="text/css">
	.wrapper {
        min-height: 500px;
        background: linear-gradient(135deg, #f5f7ff, #fdfcff);
    }

    /* 成功卡片 */
    .wrapper .main .info {
        width: 900px;
        margin: 80px auto 0;
        padding: 50px 60px;
        background: #ffffff;
        border-radius: 20px;
        box-shadow: 0 20px 40px rgba(102, 126, 234, 0.15);
        font-size: 22px;
    }

    /* 强调文字（订单号、金额） */
    .wrapper .main .info i {
        color: #667eea;
        font-style: normal;
        font-weight: 600;
    }

    /* 左侧成功图标 */
    .wrapper .main .info img {
        width: 120px;
    }

    /* 操作按钮区域 */
    .wrapper .main .info .op {
        width: 340px;
        margin: 30px auto 0;
        display: flex;
        justify-content: space-between;
    }

    /* 查看订单（主按钮） */
    .wrapper .main .info .op .btn-success {
        background: linear-gradient(135deg, #667eea, #764ba2);
        border: none;
        border-radius: 30px;
        padding: 10px 22px;
        font-size: 16px;
        color: #fff;
        transition: all 0.3s ease;
    }

    .wrapper .main .info .op .btn-success:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 24px rgba(102, 126, 234, 0.4);
    }

    /* 返回首页（次按钮） */
    .wrapper .main .info .op .btn-default {
        background: #f1f3ff;
        border: none;
        border-radius: 30px;
        padding: 10px 22px;
        font-size: 16px;
        color: #667eea;
        transition: all 0.3s ease;
    }

    .wrapper .main .info .op .btn-default:hover {
        background: #e4e7ff;
    }
</style>

</head>
<body>
	<div class="container-fullid">
		<%@include file="header.jsp" %>
		<div class="wrapper">
			<div class="main container">
				<div class="info">
					<div class="row">
						<div class="col-md-4">
							<img src="images/book/corr.png" alt="" />
						</div>
						<div class="col-md-8">
							<p>订单<i>${orderNum}</i>已成功生成，我们会尽快送达！</p>
							<p>订单金额：<i>￥${money}</i></p>
							<p>支付方式：货到付款</p>
						</div>
					</div>
					<div class="op">
						<a class="btn btn-success " href="OrderServlet?action=list">查看我的订单</a>
						<a class="btn btn-default" href="jsp/book/index.jsp">返回首页</a>
					</div>
				</div>
			</div>
		</div>

		<%@include file="footer.jsp" %>
	</div>


<script type="text/javascript">
	
</script>
</body>
</html>