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
<title>图书修改</title>

<link rel="stylesheet" href="bs/css/bootstrap.css">
<script src="bs/js/jquery.min.js"></script>

<link rel="stylesheet" href="bs/validform/style.css">
<script src="bs/validform/Validform_v5.3.2_min.js"></script>
<script src="js/admin/bookManage/bookAdd.js"></script>

<style>
/* ===== 页面背景 ===== */
body {
    background: linear-gradient(135deg, #f5f7ff, #fdfcff);
    font-family: "Microsoft YaHei", sans-serif;
}

/* ===== 卡片容器 ===== */
.container {
    margin-top: 60px;
    background: #fff;
    border-radius: 20px;
    padding: 40px 50px;
    box-shadow: 0 20px 40px rgba(102,126,234,0.15);
}

/* ===== 标题 ===== */
h2 {
    text-align: center;
    margin-bottom: 30px;
    font-weight: 600;
    color: #4f46e5;
}

/* ===== 行距 ===== */
.row {
    margin-top: 15px;
}

/* ===== 表单标签 ===== */
.control-label {
    font-weight: 500;
    color: #555;
}

/* ===== 输入框 ===== */
.form-control {
    border-radius: 10px;
    border: 1px solid #ddd;
    transition: all .3s;
}

.form-control:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
}

/* ===== 图片区域 ===== */
.img-box {
    width: 100px;
    height: 100px;
    border-radius: 12px;
    overflow: hidden;
    border: 2px dashed #dcdfff;
    cursor: pointer;
    transition: all .3s;
}

.img-box:hover {
    border-color: #667eea;
    box-shadow: 0 8px 20px rgba(102,126,234,0.3);
}

.img-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

#imgSpan {
    margin-left: 10px;
    color: #667eea;
    cursor: pointer;
}

/* ===== 校验提示 ===== */
.Validform_checktip,
.ckerr {
    color: #999;
    line-height: 34px;
}

/* ===== 按钮 ===== */
.btn-success {
    background: linear-gradient(135deg, #667eea, #764ba2);
    border: none;
    border-radius: 30px;
    font-size: 16px;
    padding: 10px 0;
    transition: all .3s;
}

.btn-success:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 24px rgba(102,126,234,0.4);
}

.btn-warning {
    background: #f1f3ff;
    border: none;
    border-radius: 30px;
    font-size: 16px;
    color: #667eea;
    padding: 10px 0;
    transition: all .3s;
}

.btn-warning:hover {
    background: #e4e7ff;
}

/* ===== 提示信息 ===== */
.text-center {
    color: #4f46e5;
}
</style>
</head>

<body>

<div class="container">

    <c:if test="${!empty bookMessage}">
        <h3 class="text-center">${bookMessage}</h3>
    </c:if>

    <h2>✏️ 图书修改</h2>

    <!-- 图片修改 -->
    <div class="row">
        <div class="col-sm-2 col-sm-offset-2 text-right">图书图片</div>
        <div class="col-sm-4">
            <div class="img-box" onclick="upImg()">
                <img src="${bookInfo.upLoadImg.imgSrc}">
            </div>
            <span id="imgSpan">点击图片更改图片</span>

            <form id="imgForm"
                  action="jsp/admin/BookManageServlet?action=updateImg&id=${bookInfo.bookId}"
                  method="post" enctype="multipart/form-data">
                <input type="file" id="editImg" name="img" style="display:none"/>
                <input type="submit" id="sub" value="更改"
                       class="btn btn-info"
                       style="display:none;margin-left:10px;">
            </form>
        </div>
    </div>

    <!-- 图书名 -->
    <div class="row">
        <div class="col-sm-2 col-sm-offset-2 text-right">图书名称</div>
        <div class="col-sm-4">
            <strong>${bookInfo.bookName}</strong>
        </div>
    </div>

    <!-- 修改表单 -->
    <form id="bookAddForm" class="form-horizontal"
          action="jsp/admin/BookManageServlet?action=update" method="post">

        <input type="hidden" name="bookId" value="${bookInfo.bookId}">

        <div class="form-group">
            <label class="col-sm-2 col-sm-offset-2 control-label">图书类型</label>
            <div class="col-sm-4">
                <select name="catalog" class="form-control">
                    <option value="">==请选择图书类型==</option>
                    <c:forEach items="${catalog}" var="i">
                        <option value="${i.catalogId}"
                                ${i.catalogId eq bookInfo.catalog.catalogId ? "selected" : ""}>
                            ${i.catalogName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-sm-4 Validform_checktip"></div>
        </div>

        <div class="form-group">
            <label class="col-sm-2 col-sm-offset-2 control-label">价格</label>
            <div class="col-sm-4">
                <input type="text" name="price" class="form-control" value="${bookInfo.price}">
            </div>
            <div class="col-sm-4 Validform_checktip"></div>
        </div>

          <div class="form-group">
              <label class="col-sm-2 col-sm-offset-2 control-label">库存</label>
              <div class="col-sm-4">
                  <input type="text" name="stock" class="form-control" value="${bookInfo.stock}">
              </div>
              <div class="col-sm-4 Validform_checktip">可直接调整库存数量</div>
          </div>

        <div class="form-group">
            <label class="col-sm-2 col-sm-offset-2 control-label">图书作者</label>
            <div class="col-sm-4">
                <input type="text" name="author" class="form-control" value="${bookInfo.author}">
            </div>
            <div class="col-sm-4 Validform_checktip"></div>
        </div>

        <div class="form-group">
            <label class="col-sm-2 col-sm-offset-2 control-label">出版社</label>
            <div class="col-sm-4">
                <input type="text" name="press" class="form-control" value="${bookInfo.press}">
            </div>
            <div class="col-sm-4 Validform_checktip"></div>
        </div>

        <div class="form-group">
            <label class="col-sm-2 col-sm-offset-2 control-label">备注</label>
            <div class="col-sm-4">
                <textarea rows="3" name="desc" class="form-control">${bookInfo.description}</textarea>
            </div>
            <span class="col-sm-4 ckerr">*选填</span>
        </div>

        <div class="form-group">
            <label class="col-sm-2 col-sm-offset-2 control-label">
                <input class="btn btn-success btn-block" type="submit" value="提交">
            </label>
            <label class="col-sm-2 control-label">
                <input class="btn btn-warning btn-block" type="reset" value="重置">
            </label>
        </div>

    </form>
</div>

<script>
function upImg(){
    $("#editImg").click();
}
$("#editImg").change(function(){
    $("#sub").show();
    $("#imgSpan").hide();
});
</script>

</body>
</html>