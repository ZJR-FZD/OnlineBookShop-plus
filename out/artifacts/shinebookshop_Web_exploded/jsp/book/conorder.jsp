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
<title>确认订单</title>
<link rel="stylesheet" href="bs/css/bootstrap.css">
<script type="text/javascript" src="bs/js/jquery.min.js"></script>
<script type="text/javascript" src="bs/js/bootstrap.js"></script>		
<script type="text/javascript" src="js/book/landing.js"></script>
<link href="css/book/head_footer.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/book/addcart.js"></script>
<style type="text/css">
/* ===== 确认订单页 - 蓝紫风格 ===== */

.wrapper .main h3 {
    text-align: center;
    padding: 15px 0;
    font-size: 26px;
    font-weight: 700;
    color: #667eea;
    border-bottom: none;
}

/* 公共卡片样式 */
.wrapper .main .info,
.wrapper .main .payMethod,
.wrapper .main .pro,
.wrapper .main .settle {
    background: #fff;
    border-radius: 16px;
    padding: 20px 25px;
    margin: 25px 0;
    box-shadow: 0 8px 30px rgba(102,126,234,0.15);
}

/* 小标题 */
.wrapper .main .row > h4 {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 15px;
    color: #5a5f8f;
}

/* 收货信息 */
.wrapper .main .info .default {
    border: none;
    background: linear-gradient(135deg, #f5f7ff, #f0ecff);
    border-radius: 14px;
    padding: 15px;
}

.wrapper .main .info .default b {
    font-size: 16px;
    color: #667eea;
}

/* 支付方式 */
.wrapper .main .payMethod label {
    font-size: 15px;
    margin-right: 20px;
}

/* 商品表格 */
.wrapper .main .pro table {
    border-radius: 12px;
    overflow: hidden;
}

.wrapper .main .pro table th {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: #fff;
    text-align: center;
    border: none !important;
}

.wrapper .main .pro table td {
    vertical-align: middle !important;
    border-color: #eee;
}

.wrapper .main .pro table a {
    color: #667eea;
    font-weight: 500;
}

.wrapper .main .pro table a:hover {
    color: #764ba2;
}

/* 结算信息 */
.wrapper .main .settle .settle-info {
    border: none;
    background: linear-gradient(135deg, #f8f9ff, #f3efff);
    border-radius: 16px;
    padding: 25px;
}

.wrapper .main .settle .settle-info span {
    display: inline-block;
    width: 140px;
    text-align: right;
    color: #555;
}

/* 应付金额 */
.wrapper .main .settle .settle-info .totprice {
    font-size: 26px;
    font-weight: bold;
    margin: 15px 0;
}

.wrapper .main .settle .settle-info .totprice b {
    color: #ff4d6d;
}

/* 提交订单按钮 */
.wrapper .main .settle .btn-success {
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none;
    border-radius: 30px;
    padding: 12px 30px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s;
}

.wrapper .main .settle .btn-success:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(102,126,234,0.4);
}
</style>

</head>
<body>
	<div class="container-fullid">
		<%@include file="header.jsp" %>
		<div class="wrapper">
			<div class="main container">
				<h3>
					<span>订单详情</span>
				</h3>
				<div class="container">
					<div class="info row">
						<h4 class="col-md-12">收货信息：</h4>
                        <div class="col-md-3 default">
                            <p>
                                <strong>收货人：</strong>
                                <span>${landing.name}</span>
                            </p>
                            <p>
                                <strong>收货地址：</strong>
                                <span>${landing.address}</span>
                            </p>
                            <p>
                                <strong>联系电话：</strong>
                                <span>${landing.tell}</span>
                            </p>
                        </div>
					</div>
					<div class="payMethod row">
						<h4 class="col-md-12">支付方式:</h4>
						<label class="radio-inline">
							<input type="radio" name="paymeth" id="inlineRadio1" checked="checked" value="option1">货到付款
						</label>
						<!-- <label class="radio-inline">
						  	<input type="radio" name="paymeth" id="inlineRadio3" value="option3"> 货到付款
						</label> -->
					</div>
					
					<div class="pro row">
						<h4 class="col-md-12">商品信息</h4>
						<table class="table table-bordered">
							<tr class="info">
								<th class="col-md-6">&nbsp</th>
								<th class="col-md-2">单价</th>
								<th class="col-md-2">数量</th>
								<th class="col-md-2">小计</th>
							</tr>
							<c:forEach items="${shopCart.map}" var="i">
								<tr class="pro-list">
									<td><img width="50px" class="img-responsive col-md-2"
										src="${i.value.book.upLoadImg.imgSrc }" alt="" />
										<div class="col-md-8">
											<a href="bookdetail?bookId=${i.key}">${i.value.book.bookName}</a>
											<p>${i.value.book.author}</p>
											<p>${i.value.book.press}</p>
										</div>
									</td>
									<td>￥<i>${i.value.book.price}</i></td>
									<td>${i.value.quantity}</td>
									<td><b>￥<i>${i.value.subtotal}</i></b></td>
								</tr>
							</c:forEach>
						</table>
					</div>
					
					<div class="row settle">
						<h4 class="">结算信息</h4>
						<div class=" settle-info row">
							<div class="col-md-4 col-md-offset-8 settle-li">
								<div class="">
									<span>${shopCart.totQuan}件商品总价:</span>
									<span>￥<i>${shopCart.totPrice}</i></span>
								</div>
								<div>
									<span>运费:</span>
									<span>￥0.00</span>
								</div>
								<div>
									<span>优惠:</span>
									<span>-￥0.00</span>
								</div>
								<div class="totprice">
									<span>应付金额:</span>
									<span><b>￥<i>${shopCart.totPrice}</i></b></span>
								</div>
								<div>
									<a href="OrderServlet?action=subOrder" onclick="subOrder()" class="btn btn-lg btn-success pull-right">提交订单</a>
								</div>
							</div>
						</div>
					</div>
					
					
				</div>
			</div>
		</div>

		<%@include file="footer.jsp" %>
	</div>


<script type="text/javascript">
	/* function subOrder(){
		$.get("OrderServlet?action=subOrder",function(data){
			if("ok"==data.status){
				window.location.href="${basePath}jsp/book/ordersuccess.jsp";
			}else{
				alert("订单提交失败，请重新提交")
			}
		},"json")
	} */
</script>
</body>
</html>