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
<title>购物车</title>
<link rel="stylesheet" href="bs/css/bootstrap.css">
<script type="text/javascript" src="bs/js/jquery.min.js"></script>
<script type="text/javascript" src="bs/js/bootstrap.js"></script>
<script type="text/javascript" src="js/book/landing.js"></script>
<link href="css/book/head_footer.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/book/addcart.js"></script>
<link rel="stylesheet" type="text/css" href="bs/validform/style.css">
<script type="text/javascript" src="bs/validform/Validform_v5.3.2_min.js"></script> 
<script type="text/javascript" src="js/book/user_reg_login.js"></script>
<style type="text/css">
/* ===== 购物车 · 蓝紫主题 ===== */

.wrapper {
    min-height: 400px;
}

.wrapper .main {
    padding: 30px 50px;
}

/* 标题 */
.wrapper h3 span {
    font-size: 26px;
    font-weight: 800;
    background: linear-gradient(135deg, #667eea, #764ba2);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

/* 表格整体 */
.table {
    background: #fff;
    border-radius: 18px;
    overflow: hidden;
    box-shadow: 0 15px 40px rgba(0,0,0,0.15);
}

.table th {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: #fff;
    font-size: 15px;
    border: none !important;
    text-align: center;
}

.table td {
    vertical-align: middle !important;
    text-align: center;
    border-color: #eee !important;
}

/* 商品信息 */
.table td a {
    color: #667eea;
    font-weight: 600;
}

.table td a:hover {
    color: #764ba2;
}

/* 数量 spinner */
.spinner {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
}

.spinner input {
    width: 45px;
    height: 28px;
    text-align: center;
    border-radius: 6px;
    border: 1px solid #ccc;
}

.spinner .btn {
    border-radius: 50%;
    padding: 2px 8px;
    background: #f5f7fa;
    border: 1px solid #ddd;
}

.spinner .btn:hover {
    background: #667eea;
    color: #fff;
}

/* 小计价格 */
.price {
    font-size: 20px;
    font-weight: 700;
    color: #ff4757;
}

/* 底部合计 */
#totPrice b {
    font-size: 26px;
    color: #ff4757;
}

/* 按钮统一 */
.btn {
    border-radius: 25px !important;
    font-weight: 600;
    transition: all .3s;
}

/* 蓝紫主按钮 */
.btn-success,
#tosettle {
    background: linear-gradient(135deg, #667eea, #764ba2) !important;
    border: none !important;
    color: #fff !important;
}

.btn-success:hover,
#tosettle:hover {
    box-shadow: 0 8px 25px rgba(102,126,234,0.45);
    transform: translateY(-2px);
}

/* 温和版危险按钮（灰紫系） */
.btn-danger {
    background: #f1f2f6 !important;
    color: #666 !important;
    border: 1px solid #ddd !important;
}

.btn-danger:hover {
    background: linear-gradient(135deg, #ff6b81, #ff4757) !important;
    color: #fff !important;
    border-color: transparent !important;
}

/* 空购物车 */
.table td[colspan] {
    color: #666;
    font-weight: 600;
}

.table td[colspan] a {
    color: #667eea;
    font-weight: 700;
}

/* ===== 登录 Modal 蓝紫化 ===== */

.modal-content {
    border-radius: 18px;
    overflow: hidden;
}

.modal-header {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: #fff;
}

.modal-title {
    font-weight: 700;
}

.modal .btn-success {
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none;
}

.modal .btn-warning {
    background: linear-gradient(135deg, #f6d365, #fda085);
    border: none;
    color: #fff;
}
</style>

</head>
<body>
	<c:if test="${!empty suberr}">
		<script type="text/javascript">
			alert("${suberr}")
		</script>
	</c:if>
	<div class="container-fullid">
		<%@include file="header.jsp" %>
		<div class="wrapper">
			<!-- main start -->
			<div class="main container">
				<h3>
					<span>我的购物车</span>
				</h3>
				<div class="content table-responsive">
					<table class="table">
						
						<c:choose>
							<c:when test="${!empty shopCart}">
								<tr class="info row">
									<th class="col-md-6">商品</th>
									<th class="col-md-2">单价</th>
									<th class="col-md-1">数量</th>
									<th class="col-md-2">小计</th>
									<th class="col-md-1">操作</th>
								</tr>
								<c:forEach items="${shopCart.map}" var="i">
									<tr class="row" id="pro-tr-${i.key}">
										<td><img class="img-responsive col-md-4"
											src="${i.value.book.upLoadImg.imgSrc }" alt="" />
											<div class="col-md-8">
												<a href="bookdetail?bookId=${i.key}">${i.value.book.bookName}</a>
												<p>${i.value.book.author}</p>
												<p>${i.value.book.press}</p>
											</div>
										</td>
										<td >￥<i>${i.value.book.price}</i></td>
										<td>
											<div class="spinner">
												<span onclick="addval(this,${i.key})"
													class="btn btn-xs btn-default"> <b>-</b>
												</span> 
												<input type="text" value="${i.value.quantity}" onchange="changeinput(this,${i.key})" >
												<span onclick="cutval(this,${i.key})"
													class="btn btn-xs btn-default"> <b>+</b>
												</span>
											</div>
										</td>
										<td class="price" style="color:red;font-size:20px;">￥<i>${i.value.subtotal}</i></td>
										<td><a  class="btn btn-danger btn-sm" href="CartServlet?action=delItem&id=${i.key}" onClick="return confirm('确定要删除此项了么？')">删除</a></td>
									</tr>
								</c:forEach>
								<tr class="row">
									<td colspan="2"><a href="CartServlet?action=delAll" class="btn btn-danger">清空购物车</a></td>
									<td class="pull-right" style="font-size: 24px;">合计：</td>
									<td id="totPrice"><b style="color:red;font-size: 24px;">
										￥
										<i>
										<c:choose>
											<c:when test="${!empty shopCart}">
												${shopCart.totPrice}
											</c:when>
											<c:otherwise>
												0.00
											</c:otherwise>
										</c:choose>
										
										</i></b></td>
									<td><a id="tosettle" class="btn btn-success" href="javascript:void(0)">去结算</a></td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="6"
										style="height: 200px; line-height: 100px; font-size: 24px;">
										购物车内暂时没有商品， <a style="font-size: 24px; color: red"
										href="BookList">去购物>>></a>
									</td>
								</tr>
							</c:otherwise>
						</c:choose>
						
					</table>

				</div>
			</div>
		</div>

		<%@include file="footer.jsp" %>
	</div>

	<!-- 弹窗 -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title" id="myModalLabel">登陆</h4>
				</div>
				<div class="modal-body">
					<!-- //登陆表单主体 -->
					<p class="info" style="text-align: center;color:red"></p>
	        		<div id="tab_login" class="tab-pane fade in active">
						<form id="loginForm" name="loginForm"  method="post" class="form-horizontal" >
							<div class="form-group">
								<label for="l_userName" class="col-md-4 control-label">用户名：</label>
								<div class="col-md-6">
									<input name="userName" id="l_userName" type="text" class="form-control" >
									<span class="Validform_checktip">&nbsp</span>
								</div>
								
							</div> 
							<div class="form-group">
								<label for="l_passWord" class="col-md-4  control-label">密码：</label>
								<div class="col-md-6">
									<input type="password" name="passWord" id="l_passWord" class="form-control">
									<span class="Validform_checktip">&nbsp</span>
								</div>
								
							</div>

							<div class="form-group">
								<label class="col-md-2 control-label col-md-offset-4">
									<button class="btn btn-success btn-block" type="submit" >登录</button>
								</label>
								<label class="col-md-2 control-label">
									<button class="btn btn-warning btn-block" type="reset">重置</button>
								</label>
								
							</div>
						</form>
					</div>
				</div>
				
			</div>
		</div>
	</div>
	<script type="text/javascript">
	//登录验证
	
		
		var form=$("#loginForm").Validform({
			tiptype:3
		});
		
		form.addRule([
			{
				ele:"#l_userName",
			    datatype:"*",
			    nullmsg:"*请输入用户名！",
			    errormsg:"*用户名输入不正确，请重新输入！" 
			},
			{ 
				ele:"#l_passWord",
				datatype:"*",
				nullmsg:"*请输入密码！",
				errormsg:"*密码输入不正确，请重新输入"
			}
		]);
		
	
	//增减按钮处理
	  function addval(obj,id) {  
		  var input=$(obj).parent().find("input");
		  if(input.val()>1){
			  input.val(parseInt(input.val()) - 1); 
			  changeQ(obj,id,input.val());
			}
		 }
	  function cutval(obj,id){
		  var input=$(obj).parent().find("input");
		  if(input.val()<999){
			  input.val(parseInt(input.val()) + 1); 
			  changeQ(obj,id,input.val());
			}
	 	}
	  //输入框处理
		function changeinput(obj,id){
			var val=$(obj).val();
			var rge=/^[0-9]*[1-9][0-9]*/;
			if(!rge.test(val)){
				$(obj).val(1);
				changeinput(obj,id);
				alert("商品数量为整数，请重新输入!");
				return;
			}else{
				changeQ(obj,id,val);
			}
			
		}
		function ckinput(val){
			
		}
		//ajax提交处理
		function changeQ(obj,id,val){
			$.ajax({
				url:"CartServlet?action=changeIn",
				dataType:"json",
				async:true,
				data:{"bookId":id,"quantity":val},
				type:"POST",
				success:function(data){
					$(obj).parent().parent().parent().find(".price i").html(data.subtotal);
					$(obj).parent().find("input").val(data.quantity);
					$("#totPrice i").html(data.totPrice);
					$("#cart .num").html(data.totQuan);
					
				}
					
			})
		}
		//去结算处理
		$("#tosettle").click(function(){
			$.get("UserServlet?action=landstatus",function(data){
				if(data.status=="y"){
					window.location.href="${basePath}jsp/book/conorder.jsp";
				}else{
					$("#myModal").modal("show");
				}
			},"json")
			
			return;
		})
		//登陆处理
		$("#loginForm").submit(function(){
			$.post("UserServlet?action=ajlogin", $('#loginForm').serialize(),function(data){
				if("y"==data.status){
					window.location.href="${basePath}jsp/book/conorder.jsp";
					
				}else{
					
					$("#myModal .info").html(data.info);
				}
			},"json")
			return false;
		})
</script>
</body>
</html>