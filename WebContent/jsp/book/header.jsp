<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="head">
			<div class="top">
				<div class="container">
					<div class="pull-right">
						<c:choose>
							<c:when test="${empty landing}">
								<div class="top-right">
									<a href="jsp/book/reg.jsp?type=reg">用户注册</a>
									<a href="jsp/book/reg.jsp?type=login">用户登录</a>
									<a href="jsp/admin/login.jsp?role=sales" class="sales-login-btn">销售登录</a>
									<a href="jsp/admin/login.jsp" class="admin-login-btn">管理员登录</a>
								</div>
							</c:when>
							<c:otherwise>
								<div class="btn-group adminName top-right">
									<a href="javascript:void(0)">
									    ${landing.name} <span class="caret"></span>
									</a>
									<ul class="dropdown-menu dropdown-menu-right">
									    <li><a href="OrderServlet?action=list">📦 我的订单</a></li>
                                        <li><a href="UserServlet?action=profile&id=${landing.userId}">👤 个人资料</a></li>
                                        <li><a class="logout-btn" href="UserServlet?action=off" onClick="return confirm('确定要退出登录吗？')">🚪 退出登录</a></li>
                                        <li><a class="delete-account-btn" href="UserServlet?action=delete&id=${landing.userId}" onClick="return confirm('⚠️ 警告：注销账号后将无法恢复，确定要注销账号吗？')">🗑️ 注销账号</a></li>
									</ul>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
			<div class="mid container">
				<div class="row">
					<div class="logo col-md-5" title="网上书城">
                        <span>欢迎来到当当小书屋~</span>
                    </div>

                   <!-- 首页按钮 -->
                   <div class="col-md-1" style="padding: 0;">
                       <a href="jsp/book/index.jsp" class="home-btn" title="返回首页">
                           🏠 首页
                       </a>
                   </div>

					<div class="search col-md-4">
						<div class="input-group">
							<form action="BookList2" method="get">
		     	 				<input style="float: left;width: 160px;" type="text" class="form-control" name="searchname" placeholder="输入要搜索的图书...">
		       					&nbsp;&nbsp;&nbsp;
		       					<input style="float: left;width: 55px;" class="btn btn-default" type="submit" value="搜索"/>
							</form>
   						</div>
					</div>
					<div class="shopcart col-md-2 col-md-offset-1">
						<a id="cart" href="jsp/book/cart.jsp">
							<span class="badge num">
								<c:choose>
									<c:when test="${!empty shopCart}">
										${shopCart.getTotQuan()}
									</c:when>
									<c:otherwise>
										0
									</c:otherwise>
								</c:choose>
							</span>
							<span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>
							<span>购物车</span>
							<span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span>
						</a>
					</div>
				</div>
			</div>
		</div>
