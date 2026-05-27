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
    <meta charset="UTF-8">
    <title>网上书城 - 商品详情</title>

    <link rel="stylesheet" href="bs/css/bootstrap.css">
    <script src="bs/js/jquery.min.js"></script>
    <script src="bs/js/bootstrap.js"></script>
    <script src="js/book/landing.js"></script>
    <script src="js/book/addcart.js"></script>
    <link href="css/book/head_footer.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        /* ===== 主体卡片 ===== */
        .wrapper .main {
            background: #fff;
            border-radius: 18px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(0,0,0,.08);
        }

        /* ===== 商品图片 ===== */
        .pro-img {
            border-radius: 16px;
            box-shadow: 0 12px 28px rgba(0,0,0,.15);
        }

        /* ===== 商品信息卡 ===== */
        .pro_info {
            background: #fafbff;
            border-radius: 16px;
            padding: 20px;
            width: 100%;
        }

        .pro_info tr {
            border-bottom: 1px dashed #e5e7f2;
        }

        .pro_info tr:last-child {
            border-bottom: none;
        }

        .pro_info td {
            padding: 8px 6px;
            vertical-align: top;
        }

        .pro_info td:first-child {
            width: 90px;
            font-weight: 600;
            color: #555;
        }

        .pro_info h2 {
            font-weight: 700;
            margin-bottom: 10px;
        }

        .pro_info i {
            font-size: 28px;
            font-style: normal;
            font-weight: bold;
            background: linear-gradient(135deg,#667eea,#764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
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

        /* ===== 图书简介 ===== */
        .pro_desc {
            margin-top: 30px;
            background: #fff;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 10px 25px rgba(0,0,0,.06);
        }

        .pro_desc h3 {
            border-left: 5px solid #667eea;
            padding-left: 12px;
            font-weight: 700;
        }

        .pro_desc div {
            margin-top: 15px;
            line-height: 1.9;
            color: #555;
            text-indent: 2em;
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
        <div class="main container">

            <!-- 面包屑 -->
            <ol class="breadcrumb">
                <li><a href="jsp/book/index.jsp">主页</a></li>
                <li><a href="#">${bookInfo.catalog.catalogName}</a></li>
                <li class="active">${bookInfo.bookName}</li>
            </ol>

            <!-- 商品主体 -->
            <div class="row">
                <div class="col-md-5">
                    <img class="img-responsive pro-img"
                         src="${bookInfo.upLoadImg.imgSrc}">
                </div>

                <div class="col-md-7">
                    <table class="pro_info">
                        <tr>
                            <td colspan="2"><h2>${bookInfo.bookName}</h2></td>
                        </tr>
                        <tr>
                            <td>价格</td>
                            <td><i>￥${bookInfo.price}</i></td>
                        </tr>
                        <tr>
                            <td>编号</td>
                            <td>${bookInfo.bookId}</td>
                        </tr>
                        <tr>
                            <td>分类</td>
                            <td>${bookInfo.catalog.catalogName}</td>
                        </tr>
                        <tr>
                            <td>作者</td>
                            <td>${bookInfo.author}</td>
                        </tr>
                        <tr>
                            <td>出版社</td>
                            <td>${bookInfo.press}</td>
                        </tr>
                        <tr>
                            <td>上架</td>
                            <td>${bookInfo.addTime}</td>
                        </tr>
                        <tr>
                            <td>库存</td>
                            <td>${bookInfo.stock}</td>
                        </tr>
                        <tr>
                            <td>服务</td>
                            <td>书城自营 · 三日内送达 · 支持7天无理由退货</td>
                        </tr>
                    </table>

                    <p class="buy_pro">
                        <button class="btn btn-buy"
                                onclick="addToCart(${bookInfo.bookId})"
                                data-toggle="modal"
                                data-target=".bs-example-modal-sm">
                            加入购物车
                        </button>
                    </p>
                    <p>温馨提示：正品保障 · 售后无忧</p>
                </div>
            </div>

            <!-- 简介 -->
            <div class="pro_desc">
                <h3>图书简介</h3>
                <div>${bookInfo.description}</div>
            </div>

        </div>
    </div>

    <%@include file="footer.jsp" %>
</div>

<!-- 加入购物车弹窗 -->
<div class="modal fade bs-example-modal-sm">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-body">
                <span class="glyphicon glyphicon-ok"></span>
                已加入购物车！
            </div>
            <div class="modal-footer">
                <a class="btn btn-default" data-dismiss="modal">继续购物</a>
                <a class="btn btn-success" href="jsp/book/cart.jsp">查看购物车</a>
            </div>
        </div>
    </div>
</div>

<c:if test="${!empty alsoBought}">
	<div class="container" style="margin-top:30px;">
		<h3 style="border-left:4px solid #667eea;padding-left:12px;">看了又买</h3>
		<div style="display:flex;gap:16px;overflow-x:auto;padding:15px 0;">
		<c:forEach items="${alsoBought}" var="ab">
		<div style="min-width:160px;background:#fff;border-radius:10px;padding:12px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,.08);">
			<a href="bookdetail?bookId=${ab.bookId}"><img src="${ab.imgSrc}" style="width:80px;height:80px;object-fit:cover;border-radius:6px;"></a>
			<p style="margin:8px 0 4px;font-weight:600;font-size:13px;"><a href="bookdetail?bookId=${ab.bookId}">${ab.bookName}</a></p>
			<p style="color:#f5576c;font-weight:bold;">￥${ab.price}</p>
		</div>
		</c:forEach>
		</div>
	</div>
	</c:if>
	<c:if test="${!empty boughtTogether}">
	<div class="container" style="margin-top:30px;">
		<h3 style="border-left:4px solid #43e97b;padding-left:12px;">购买此书的也买了</h3>
		<div style="display:flex;gap:16px;overflow-x:auto;padding:15px 0;">
		<c:forEach items="${boughtTogether}" var="bt">
		<div style="min-width:160px;background:#fff;border-radius:10px;padding:12px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,.08);">
			<a href="bookdetail?bookId=${bt.bookId}"><img src="${bt.imgSrc}" style="width:80px;height:80px;object-fit:cover;border-radius:6px;"></a>
			<p style="margin:8px 0 4px;font-weight:600;font-size:13px;"><a href="bookdetail?bookId=${bt.bookId}">${bt.bookName}</a></p>
			<p style="color:#f5576c;font-weight:bold;">￥${bt.price}</p>
		</div>
		</c:forEach>
		</div>
	</div>
	</c:if>

	<script>
	var _enterTime = Date.now();
	window.addEventListener('beforeunload', function(){
		var d = Math.floor((Date.now() - _enterTime) / 1000);
		var b = '${bookInfo.bookId}';
		if (b) navigator.sendBeacon('bookdetail?action=log&bookId=' + b + '&duration=' + d);
	});
	</script>
</body>
</html>