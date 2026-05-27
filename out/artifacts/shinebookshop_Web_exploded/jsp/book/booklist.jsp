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
	<title>购物车</title>
	<link rel="stylesheet" href="bs/css/bootstrap.css">
	<script type="text/javascript" src="bs/js/jquery.min.js"></script>
	<script type="text/javascript" src="bs/js/bootstrap.js"></script>
	<link rel="stylesheet" href="css/book/head_footer.css" >
	<link rel="stylesheet" href="css/book/booklist.css" />
	<script type="text/javascript" src="js/book/getCatalog.js"></script>
	<script type="text/javascript" src="js/book/landing.js"></script>
	<script type="text/javascript" src="js/book/addcart.js"></script>
    <style>
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
							<h3>图书列表——${title}</h3>
							<div class="pro-list">
								<ul class="row">
									<c:choose>
										<c:when test="${!empty bookList}">
											<c:forEach items="${bookList}" var="i">
												<li class="col-md-3">
													<div class="list">
														<a href="bookdetail?bookId=${i.bookId}">
															<img class="img-responsive" src="${i.upLoadImg.imgSrc}" />
														</a>
														<div class="proinfo">
															<h2>
																<a class="text-center" href="bookdetail?bookId=${i.bookId}">${i.bookName}</a>
															</h2>
															<p>
																<i>${i.price}</i>
																																		<span style="margin-left:8px;color:#888;font-size:12px;">库存：${i.stock}</span>
																<a class="btn btn-danger btn-xs" onclick="addToCart(${i.bookId})" href="javascript:void(0)" data-toggle="modal" data-target=".bs-example-modal-sm">ADD</a>
															</p>
														</div>
													</div>
												</li>

											</c:forEach>
										</c:when>
										<c:otherwise>
											<p style="text-align:center;font-size:20px;height:200px;">当前没有图书信息</p>
										</c:otherwise>
									</c:choose>
								</ul>
								<!-- 分页栏 -->
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
		window.location="${bsePath}BookList?action=list&page=1";
	})
	$(".prePage").click(function(){
		window.location="${basePath}BookList?action=list&page=${pageBean.prePage}";
	})
	$(".nextPage").click(function(){

		window.location="${basePath}BookList?action=list&page=${pageBean.nextPage}";
	})
	$(".lastPage").click(function(){
		window.location="${basePath}BookList?action=list&page=${pageBean.pageCount}";
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
			window.location="${basePath}BookList?action=list&page="+page;
		}
	})



</script>
</body>
</html>