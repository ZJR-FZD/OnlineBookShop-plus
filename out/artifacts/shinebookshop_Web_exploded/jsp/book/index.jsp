<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	pageContext.setAttribute("basePath", basePath);
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
	<base href="${basePath}">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>在线书城</title>
	<link rel="stylesheet" href="bs/css/bootstrap.css">
	<script type="text/javascript" src="bs/js/jquery.min.js"></script>
	<script type="text/javascript" src="bs/js/bootstrap.js"></script>
	<link href="css/book/head_footer.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="js/book/getCatalog.js"></script>
	<script type="text/javascript" src="js/book/index.js"></script>
	<script type="text/javascript" src="js/book/landing.js"></script>
	<link rel="stylesheet" href="css/book/index.css" />
	<script type="text/javascript" src="js/book/addcart.js"></script>
	<style type="text/css">
		.dropdown-menu{
			margin:0;
		}
        /* ===== 加入购物车按钮 ===== */
        .btn-buy {
            background: linear-gradient(135deg,#667eea,#764ba2);
            border: none;
            color: #fff;
            border-radius: 30px;
            padding: 10px 30px;
            font-size: 16px;
            font-weight: 600;
            transition: all .3s;
        }

        .btn-buy:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102,126,234,.45);
        }

        .buy_pro {
            margin-top: 20px;
        }

        .buy_pro + p {
            font-size: 13px;
            color: #888;
            margin-top: 10px;
        }
        /* ===== 弹窗样式 ===== */
        .modal-content {
            border-radius: 18px;
            overflow: hidden;
        }

        .modal-body {
            font-size: 22px;
            color: #4caf50;
            text-align: center;
            padding: 25px;
        }

        .modal-footer {
            background: #fafbff;
            display: flex;
            justify-content: space-between;
            padding: 15px 20px;
            border-top: none;
        }

        .modal-footer .btn-default {
            background: #f1f3ff;
            border: none;
            color: #667eea;
            border-radius: 30px;
            padding: 8px 18px;
        }

        .modal-footer .btn-success {
            background: linear-gradient(135deg,#667eea,#764ba2);
            border: none;
            border-radius: 30px;
            padding: 8px 22px;
        }
	</style>

</head>
<body>

	<div class="container-fullid">
		<%@include file="header.jsp" %>
		<div class="wrapper">
			<!-- banner start -->
			<div class="banner">
				<div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
					<!-- Indicators -->
					<ol class="carousel-indicators">
						<li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
						<li data-target="#carousel-example-generic" data-slide-to="1"></li>
						<li data-target="#carousel-example-generic" data-slide-to="2"></li>
						<li data-target="#carousel-example-generic" data-slide-to="3"></li>
						<li data-target="#carousel-example-generic" data-slide-to="4"></li>
					</ol>
				</div>
			</div>
			<!-- main start -->
			<div class="main container">
				<div class="row">
					<div class="col-md-2 main-left">
						<h3>图书分类</h3>

						<ul id="catalog-list">
							<li><a href="BookList">全部图书</a></li>

						</ul>
					</div>
					<div class="col-md-10 main-right">
						<div class="pro col-md-12">
							<h3>推荐图书</h3>
							<div id="recBooks" class="pro-list">
								<ul></ul>
							</div>
						</div>
						<div class="pro col-md-12">
							<h3>新书上架</h3>
							<div id="newBooks" class="pro-list">
								<ul >

								</ul>
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>

		<%@include file="footer.jsp" %>
	</div>
	<!--弹窗盒子start -->
	<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
	  	<div class="modal-dialog modal-sm">
	    	<div class="modal-content">
	    		<div class="modal-body" style="color:green;font-size:24px;">
				  <span class="glyphicon glyphicon-ok" aria-hidden="true"></span>&nbsp已加入购物车！
				</div>

	      		<div class="modal-footer">
	      			<a href="javascript:void(0)" type="button" class="btn btn-default" data-dismiss="modal">继续购物</a>
			        <a href="jsp/book/cart.jsp" type="button" class="btn btn-success">查看购物车</a>
			    </div>
	    	</div>
	  	</div>
	</div>
	<!--弹窗盒子end -->
</body>
</html>
