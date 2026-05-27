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
    body{
        background:#f5f3ff;
    }

    .wrapper{
        min-height:500px;
        padding:30px 0;
    }

    /* 表格整体 */
    table{
        background:#fff;
        border-radius:12px;
        overflow:hidden;
        box-shadow:0 8px 24px rgba(108,99,255,.15);
    }

    /* 表头 */
    table thead tr{
        background: linear-gradient(135deg,#6c63ff,#8a84ff);
        color:#554fd8;
    }

    table thead th{
        text-align:center;
        font-weight:600;
        border-bottom:none !important;
    }

    table td{
        vertical-align:middle !important;
    }

    /* 订单日期行 */
    tr.active{
        background:#f3f1ff !important;
        font-weight:600;
        color:#554fd8;
    }

    /* 图片 */
    .wrapper .bookImg{
        width:50px;
        border-radius:6px;
    }

    /* 状态文字 */
    .wrapper p{
        margin:0;
        color:#554fd8;
    }

    /* 按钮 */
    .btn-success{
        background:#6c63ff;
        border-color:#6c63ff;
    }

    .btn-success:hover{
        background:#554fd8;
        border-color:#554fd8;
    }

    /* 分页 */
    .pager{
        display:flex;
        justify-content:center;
        align-items:center;
        gap:12px;
        padding:25px 0;
        border-top:1px solid #e0dcff;
    }

    .pager button{
        border-radius:20px;
        color:#6c63ff;
        border:1px solid #dcd7ff;
        background:#fff;
    }

    .pager button:hover{
        background:#6c63ff;
        color:#fff;
    }

    #page-input{
        border-radius:12px;
        border:1px solid #dcd7ff;
    }

    /* 标题 */
t	/* 订单状态标签 */
		.status-tag { display:inline-block;padding:4px 12px;border-radius:14px;font-size:13px;color:#fff;margin:4px 0; }
		.status-tag.pending { background:#f0ad4e; }
		.status-tag.shipped { background:#5bc0de; }
		.status-tag.done { background:#5cb85c; }
	</style>
</head>
<body>
	<div class="container-fullid">
		<%@include file="header.jsp" %>
		<div class="wrapper">
			<div class="main container">
				<c:if test="${!empty orderMessage}"><div class="alert alert-success text-center">${orderMessage}</div></c:if>
				<h2>全部订单</h2>
				<table class="table table-bordered">
					<thead>
						<tr class="info">
							<th>商品</th>
							<th>单价</th>
							<th>数量</th>
							<th>商品操作</th>
							<th>实付款</th>
							<th>交易状态</th>
						</tr>
					</thead>
					<c:choose>
						<c:when test="${!empty orderList }">
							<c:forEach items="${orderList}" var="order" varStatus="varstatus">
								<c:if test="${!varstatus.first}"><tbody><tr><td colspan="6">&nbsp;</td></tr></tbody> </c:if>
								<tbody style="margin-top: 10px;">
									<tr class="active">
										<td>订单日期：${order.orderDate}</td>
										<td colspan="5">订单号：${order.orderNum }</td>
									</tr>
									<c:forEach items="${order.oItem}" var="oit" varStatus="vs">
										<tr>
											<td>
												<img class="img-responsive col-md-2" src="${oit.book.upLoadImg.imgSrc}" alt="" />
												<span class="col-md-10">${oit.book.bookName}</span>
											</td>
											<td>￥${oit.book.price}</td>
											<td>${oit.quantity}</td>
											<td><a href="javascript:void(0)">申请售后</a></td> 
											<c:choose>
												<c:when test="${vs.first}">
													<td style="border:0;border-left:1px solid #ddd;">￥${order.money }</td>
													<td style="border:0;border-left:1px solid #ddd;">
<c:if test="${order.orderStatus eq 1}"><span class="status-tag pending">待处理</span><p style="font-size:12px;color:#888;">(等待商家发货)</p></c:if>
														<c:if test="${order.orderStatus eq 2}">
													<span class="status-tag shipped">已发货</span>
															<a href="OrderServlet?action=ship&id=${order.orderId}" class="btn btn-sm btn-success" onclick="return confirm('确认收货了么？')">确认收货</a>
														</c:if>
													<c:if test="${order.orderStatus eq 3}"><span class="status-tag done">已完成</span></c:if>
													</td>
												</c:when>
												<c:otherwise>
													<td style="border:0;border-left:1px solid #ddd;">&nbsp</td>
													<td style="border:0;border-left:1px solid #ddd;">&nbsp</td>
												</c:otherwise>
											</c:choose>
										</tr>
									</c:forEach>
								</tbody>
								
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tbody>
								<tr><td colspan="6"><h2 class="text-center">您还没有订单！</h2></td></tr>
							</tbody>
						</c:otherwise>
					</c:choose>
				</table>
				<!-- 分页按钮 -->
				<ul class="pager row">
					<li><button class="homePage btn btn-default btn-sm">首页</button></li>
					<li><button class="prePage btn btn-sm btn-default">上一页</button></li>
					<li>总共 ${pageBean.pageCount} 页 | 当前 ${pageBean.curPage} 页</li>
					<li>
						跳转到
						<div class="input-group form-group page-div">
							<input id="page-input" class="form-control input-sm" type="text" name="page"/>
							<span>
								<button  class="page-go btn btn-sm btn-default">GO</button>
							</span>
						</div>
					</li>
					<li><button class="nextPage btn btn-sm btn-default">下一页</button></li>
					<li><button class="lastPage btn btn-sm btn-default">末页</button></li>
				</ul>
				
			</div>
		</div>

		<%@include file="footer.jsp" %>
	</div>


<script type="text/javascript">
	//按钮禁用限制
	if("${pageBean.curPage}"==1){
		$(".homePage").attr("disabled","disabled");
		$(".prePage").attr("disabled","disabled");
	}
	if("${pageBean.curPage}"=="${pageBean.pageCount}"){
		$(".page-go").attr("disabled","disabled");
		$(".nextPage").attr("disabled","disabled");
		$(".lastPage").attr("disabled","disabled");
	}
	//按钮事件
	$(".homePage").click(function(){
		window.location="${basePath}OrderServlet?action=list&page=1";
	})
	$(".prePage").click(function(){
		window.location="${basePath}OrderServlet?action=list&page=${pageBean.prePage}";
	})
	$(".nextPage").click(function(){
		
		window.location="${basePath}OrderServlet?action=list&page=${pageBean.nextPage}";
	})
	$(".lastPage").click(function(){
		window.location="${basePath}OrderServlet?action=list&page=${pageBean.pageCount}";
	})
	//控制页面跳转范围
	$(".page-go").click(function(){
		var page=$("#page-input").val();
		var pageCount=${pageBean.pageCount};
		if(isNaN(page)||page.length<=0){
			$("#page-input").focus();
			alert("请输入数字页码");
			return;
		}
		if(page > pageCount || page < 1 ){
			alert("输入的页码超出范围！");
			$("#page-input").focus(); 
		}else{
			window.location="${basePath}OrderServlet?action=list&page="+page;
		}
	}) 
	
		
		
</script>
</body>
</html>