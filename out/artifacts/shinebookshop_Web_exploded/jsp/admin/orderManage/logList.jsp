<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	pageContext.setAttribute("basePath", basePath);
%>
<!DOCTYPE html>
<html>
<head>
<base href="${basePath}">
	<meta charset="UTF-8">
	<title>用户行为日志</title>
	<script type="text/javascript" src="bs/js/jquery.min.js"></script>
	<script type="text/javascript" src="bs/js/bootstrap.js"></script>
	<link rel="stylesheet" href="bs/css/bootstrap.css">
	<link rel="stylesheet" href="bs/css/bootstrap-purple-theme.css">
	<link rel="stylesheet" href="css/admin/adminManage/userList.css">
	<style type="text/css">
		.tag { display:inline-block;padding:3px 10px;border-radius:12px;font-size:12px;color:#fff; }
		.tag.BROWSE { background:#4facfe; }
		.tag.PURCHASE { background:#f5576c; }
		.tag.EMAIL { background:#43e97b; }
		.tag.LOGIN { background:#f0ad4e; }
		.tag.ADMIN_OP { background:#a855f7; }
	.tag.CRAWLER { background:#d9534f; }
	</style>
</head>
<body>
	<c:choose>
		<c:when test="${filterType eq 'STAFF'}">
		<h2 class="text-center">工作人员日志</h2>
		<div class="funbtn" style="padding-left:180px">
			<div class="search col-md-4">
				<div class="btn-group">
					<a class="btn btn-sm ${empty staffRole ? 'btn-info' : 'btn-default'}" href="jsp/admin/LogServlet?action=staff">全部</a>
					<a class="btn btn-sm ${staffRole eq 'admin' ? 'btn-info' : 'btn-default'}" href="jsp/admin/LogServlet?action=staff&staffRole=admin">管理员</a>
					<a class="btn btn-sm ${staffRole eq 'sales' ? 'btn-info' : 'btn-default'}" href="jsp/admin/LogServlet?action=staff&staffRole=sales">销售人员</a>
				</div>
			</div>
		</div>
		</c:when>
		<c:otherwise>
		<h2 class="text-center">用户行为日志</h2>
		<div class="funbtn" style="padding-left:180px">
			<div class="search col-md-4">
				<div class="btn-group">
					<a class="btn btn-sm ${empty filterType ? 'btn-info' : 'btn-default'}" href="jsp/admin/LogServlet?action=list">全部</a>
					<a class="btn btn-sm ${filterType eq 'BROWSE' ? 'btn-info' : 'btn-default'}" href="jsp/admin/LogServlet?action=list&filterType=BROWSE">浏览</a>
					<a class="btn btn-sm ${filterType eq 'PURCHASE' ? 'btn-info' : 'btn-default'}" href="jsp/admin/LogServlet?action=list&filterType=PURCHASE">购买</a>
					<a class="btn btn-sm ${filterType eq 'EMAIL' ? 'btn-info' : 'btn-default'}" href="jsp/admin/LogServlet?action=list&filterType=EMAIL">邮件</a>
					<a class="btn btn-sm ${filterType eq 'CRAWLER' ? 'btn-info' : 'btn-default'}" href="jsp/admin/LogServlet?action=list&filterType=CRAWLER">爬虫拦截</a>
				</div>
			</div>
		</div>
		</c:otherwise>
	</c:choose>
	<div class="container content">
		<table class="table table-striped table-hover">
			<tr class="success">
				<th>编号</th>
				<th>用户</th>
				<th>类型</th>
				<th>目标</th>
				<th>详情</th>
				<th>时间</th>
				<th>操作</th>
			</tr>
			<c:choose>
				<c:when test="${!empty logList}">
					<c:forEach items="${logList}" var="log">
					<tr>
						<td>${log.logId}</td>
						<td>${log.userName} <small>(ID:${log.userId})</small></td>
						<td><span class="tag ${log.logType}">${log.logType}</span></td>
						<td>${log.targetName}</td>
						<td>${log.detail}</td>
						<td>${log.createTime}</td>
						<td>
							<a class="btn btn-default btn-sm" href="javascript:void(0)"
								onclick="showDetail('${log.logId}','${log.userName}','${log.logType}','${log.targetName}','${log.detail}','${log.createTime}')">详情</a>
						</td>
					</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="7"><h4 class="text-center">暂无日志记录</h4></td>
					</tr>
				</c:otherwise>
			</c:choose>
		</table>

		<ul class="pager">
			<li><button class="homePage btn btn-default btn-sm" <c:if test="${pageBean.curPage eq 1}">disabled</c:if>>首页</button></li>
			<li><button class="prePage btn btn-sm btn-default" <c:if test="${pageBean.curPage eq 1}">disabled</c:if>>上一页</button></li>
			<li>总共 ${pageBean.pageCount} 页 | 当前 ${pageBean.curPage} 页</li>
			<li>
				跳转到
				<div class="input-group form-group page-div">
					<input id="page-input" class="form-control input-sm" type="text" name="page"/>
					<span>
						<button class="page-go btn btn-sm btn-default">GO</button>
					</span>
				</div>
			</li>
			<li><button class="nextPage btn btn-sm btn-default" <c:if test="${pageBean.curPage eq pageBean.pageCount}">disabled</c:if>>下一页</button></li>
			<li><button class="lastPage btn btn-sm btn-default" <c:if test="${pageBean.curPage eq pageBean.pageCount}">disabled</c:if>>末页</button></li>
		</ul>
	</div>

	<!-- 详情弹窗 -->
	<div class="modal fade" id="detailModal" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">日志详情</h4>
				</div>
				<div class="modal-body">
					<table class="table table-bordered">
						<tr><th style="width:80px;">编号</th><td id="d_id"></td></tr>
						<tr><th>用户</th><td id="d_user"></td></tr>
						<tr><th>类型</th><td id="d_type"></td></tr>
						<tr><th>目标</th><td id="d_target"></td></tr>
						<tr><th>详情</th><td id="d_detail"></td></tr>
						<tr><th>时间</th><td id="d_time"></td></tr>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		var basePath = "${basePath}";
		var curPage = ${pageBean.curPage};
		var pageCount = ${pageBean.pageCount};
		var filterType = "${filterType}";

		$(".homePage").click(function(){
			window.location = basePath + "jsp/admin/LogServlet?action=list&page=1&filterType=" + filterType;
		});
		$(".prePage").click(function(){
			window.location = basePath + "jsp/admin/LogServlet?action=list&page=" + (curPage - 1) + "&filterType=" + filterType;
		});
		$(".nextPage").click(function(){
			window.location = basePath + "jsp/admin/LogServlet?action=list&page=" + (curPage + 1) + "&filterType=" + filterType;
		});
		$(".lastPage").click(function(){
			window.location = basePath + "jsp/admin/LogServlet?action=list&page=" + pageCount + "&filterType=" + filterType;
		});
		$(".page-go").click(function(){
			var page = $("#page-input").val();
			if (isNaN(page) || page.length <= 0) {
				$("#page-input").focus();
				alert("请输入数字页码");
				return;
			}
			if (page > pageCount || page < 1) {
				alert("输入的页码超出范围！");
				$("#page-input").focus();
			} else {
				window.location = basePath + "jsp/admin/LogServlet?action=list&page=" + page + "&filterType=" + filterType;
			}
		});

		function showDetail(id, user, type, target, detail, time) {
			$("#d_id").text(id);
			$("#d_user").text(user);
			$("#d_type").html('<span class="tag ' + type + '">' + type + '</span>');
			$("#d_target").text(target || '-');
			$("#d_detail").text(detail || '-');
			$("#d_time").text(time);
			$("#detailModal").modal("show");
		}
	</script>
</body>
</html>
