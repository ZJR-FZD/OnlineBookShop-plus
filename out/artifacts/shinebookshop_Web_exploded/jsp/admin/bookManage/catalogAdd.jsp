<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>增加分类</title>

<link rel="stylesheet" href="bs/css/bootstrap.css">
<script src="bs/js/jquery.min.js"></script>

<link rel="stylesheet" href="bs/validform/style.css">
<script src="bs/validform/Validform_v5.3.2_min.js"></script>

<style>
/* ===== 页面背景 ===== */
body{
    background: linear-gradient(135deg, #f5f7ff, #fdfcff);
    font-family: "Microsoft YaHei", sans-serif;
}

/* ===== 主卡片 ===== */
.container{
    margin-top: 80px;
    background: #fff;
    border-radius: 20px;
    padding: 40px 50px;
    max-width: 800px;
    box-shadow: 0 20px 40px rgba(102,126,234,0.15);
}

/* ===== 标题 ===== */
h2{
    text-align: center;
    margin-bottom: 30px;
    font-weight: 600;
    color: #4f46e5;
}

/* ===== 表单 ===== */
#catalogAddForm{
    margin-top: 20px;
}

/* ===== 表单标签 ===== */
.control-label{
    font-weight: 500;
    color: #555;
}

/* ===== 输入框 ===== */
.form-control{
    border-radius: 10px;
    border: 1px solid #ddd;
    transition: all .3s;
}

.form-control:focus{
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
}

/* ===== 校验提示 ===== */
.Validform_checktip{
    line-height: 34px;
    color: #999;
}

/* ===== 按钮 ===== */
.btn-success{
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none;
    border-radius: 30px;
    font-size: 16px;
    padding: 10px 0;
    transition: all .3s;
}

.btn-success:hover{
    transform: translateY(-2px);
    box-shadow: 0 10px 24px rgba(102,126,234,0.4);
}

.btn-warning{
    background: #f1f3ff;
    border: none;
    border-radius: 30px;
    font-size: 16px;
    color: #667eea;
    padding: 10px 0;
    transition: all .3s;
}

.btn-warning:hover{
    background: #e4e7ff;
}

/* ===== 提示信息 ===== */
.text-center{
    color: #4f46e5;
}
</style>

<script>
$(function(){
    var form = $("#catalogAddForm").Validform({
        tiptype:2
    });

    form.addRule([
        {
            ele:"#catalogName",
            datatype:"*2-15",
            ajaxurl:"jsp/admin/CatalogServlet?action=find",
            nullmsg:"请输入图书分类名称！",
            errormsg:"分类名称至少2个字符，最多15个字符！"
        }
    ]);
});
</script>

</head>

<body>

<div class="container">

    <c:if test="${!empty catalogMessage}">
        <h3 class="text-center">${catalogMessage}</h3>
    </c:if>

    <h2>📚 增加图书分类</h2>

    <form id="catalogAddForm" class="form-horizontal"
          action="jsp/admin/CatalogServlet?action=add" method="post">

        <div class="form-group">
            <label class="col-sm-2 col-sm-offset-2 control-label">分类名称</label>
            <div class="col-sm-4">
                <input type="text" name="catalogName" id="catalogName" class="form-control"/>
            </div>
            <div class="col-sm-4 Validform_checktip"></div>
        </div>

        <div class="form-group">
            <label class="col-sm-2 col-sm-offset-4 control-label">
                <input class="btn btn-success btn-block" type="submit" value="提交">
            </label>
            <label class="col-sm-2 control-label">
                <input class="btn btn-warning btn-block" type="reset" value="重置">
            </label>
        </div>

    </form>
</div>

</body>
</html>