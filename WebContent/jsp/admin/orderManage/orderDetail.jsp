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
    <meta charset="UTF-8">
    <title>订单详情页</title>
    <link rel="stylesheet" href="bs/css/bootstrap.css">
    <style type="text/css">
       /* 现代化订单详情页样式 */
       * {
           margin: 0;
           padding: 0;
           box-sizing: border-box;
       }

       body {
           font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
           background: linear-gradient(135deg, #f5f7fa 0%, #e8eaf6 100%);
           padding: 20px;
           min-height: 100vh;
       }

       /* 页面标题 */
       h2 {
           color: #333;
           font-weight: 700;
           margin: 25px 0 30px;
           padding-bottom: 15px;
           border-bottom: 3px solid #667eea;
           position: relative;
           text-align: center;
       }

       h2::before {
           content: '📦';
           margin-right: 12px;
           font-size: 32px;
       }

       h2::after {
           content: '';
           position: absolute;
           bottom: -3px;
           left: 50%;
           transform: translateX(-50%);
           width: 100px;
           height: 3px;
           background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
       }

       /* 主容器 */
       .container {
           background: white;
           border-radius: 20px;
           padding: 40px;
           box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
           max-width: 1000px;
           margin: 0 auto;
           animation: fadeIn 0.5s ease;
       }

       /* 信息行 */
       .info-row {
           display: flex;
           margin-bottom: 20px;
           padding: 15px;
           border-radius: 12px;
           transition: all 0.3s;
           align-items: center;
       }

       .info-row:hover {
           background: rgba(102, 126, 234, 0.05);
           transform: translateX(5px);
       }

       /* 标签 */
       .info-label {
           min-width: 120px;
           font-weight: 600;
           color: #667eea;
           font-size: 15px;
           padding: 5px 15px;
           background: rgba(102, 126, 234, 0.1);
           border-radius: 8px;
           margin-right: 20px;
           text-align: center;
           position: relative;
       }

       .info-label::after {
           content: '';
           position: absolute;
           right: -8px;
           top: 50%;
           transform: translateY(-50%);
           width: 0;
           height: 0;
           border-top: 6px solid transparent;
           border-bottom: 6px solid transparent;
           border-left: 8px solid rgba(102, 126, 234, 0.1);
       }

       /* 内容 */
       .info-content {
           flex: 1;
           color: #555;
           font-size: 15px;
           line-height: 1.6;
       }

       /* 订单状态徽章 */
       .status-badge {
           display: inline-block;
           padding: 6px 16px;
           border-radius: 20px;
           font-weight: 600;
           font-size: 14px;
       }

       .status-submitted {
           background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
           color: white;
       }

       .status-shipped {
           background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
           color: white;
       }

       .status-completed {
           background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
           color: white;
       }

       /* 商品列表区域 */
       .products-section {
           margin-top: 40px;
           padding: 25px;
           background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
           border-radius: 15px;
           border-left: 4px solid #667eea;
       }

       .products-title {
           font-size: 18px;
           font-weight: 700;
           color: #667eea;
           margin-bottom: 20px;
           display: flex;
           align-items: center;
       }

       .products-title::before {
           content: '🛍️';
           margin-right: 10px;
           font-size: 24px;
       }

       /* 商品表格 */
       .table {
           margin-top: 20px;
           border-radius: 12px;
           overflow: hidden;
           box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
       }

       .table thead tr {
           background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
       }

       .table thead th {
           color: white;
           font-weight: 600;
           padding: 15px;
           border: none;
           font-size: 14px;
       }

       .table tbody tr {
           transition: all 0.3s;
           border-bottom: 1px solid #f0f0f0;
       }

       .table tbody tr:hover {
           background: rgba(102, 126, 234, 0.05);
           transform: scale(1.01);
       }

       .table tbody td {
           padding: 15px;
           vertical-align: middle;
           border: none;
       }

       /* 商品信息 */
       .product-info {
           display: flex;
           align-items: center;
           gap: 15px;
       }

       .product-img {
           width: 80px;
           height: 80px;
           object-fit: cover;
           border-radius: 10px;
           box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
       }

       .product-details h4 {
           font-size: 16px;
           font-weight: 600;
           color: #333;
           margin-bottom: 5px;
       }

       .product-details p {
           font-size: 13px;
           color: #888;
           margin: 2px 0;
       }

       /* 价格样式 */
       .price {
           font-size: 18px;
           font-weight: 700;
           color: #f5576c;
       }

       .price::before {
           content: '¥';
           font-size: 14px;
       }

       /* 数量 */
       .quantity {
           font-size: 16px;
           font-weight: 600;
           color: #667eea;
       }

       /* 总金额 */
       .total-amount {
           font-size: 24px;
           font-weight: 700;
           color: #f5576c;
       }

       .total-amount::before {
           content: '¥';
           font-size: 18px;
       }

       /* 操作按钮区域 */
       .action-buttons {
           margin-top: 30px;
           text-align: center;
           padding-top: 30px;
           border-top: 2px solid #f0f0f0;
       }

       .action-buttons .btn {
           margin: 0 10px;
           padding: 10px 30px;
           border-radius: 25px;
           font-weight: 600;
           transition: all 0.3s;
           border: none;
           font-size: 15px;
       }

       .btn-primary {
           background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
           color: white;
       }

       .btn-primary:hover {
           transform: translateY(-3px);
           box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
       }

       .btn-success {
           background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
           color: white;
       }

       .btn-success:hover {
           transform: translateY(-3px);
           box-shadow: 0 8px 20px rgba(67, 233, 123, 0.4);
       }

       .btn-default {
           background: #f5f7fa;
           color: #555;
           border: 2px solid #e0e0e0;
       }

       .btn-default:hover {
           background: #e0e5ea;
           transform: translateY(-3px);
       }

       /* 响应式设计 */
       @media (max-width: 768px) {
           .container {
               padding: 20px;
               border-radius: 15px;
           }

           .info-row {
               flex-direction: column;
               align-items: flex-start;
           }

           .info-label {
               margin-bottom: 10px;
               margin-right: 0;
           }

           .info-label::after {
               display: none;
           }

           .product-info {
               flex-direction: column;
               text-align: center;
           }

           .action-buttons .btn {
               display: block;
               width: 100%;
               margin: 10px 0;
           }

           h2 {
               font-size: 24px;
           }

           .table {
               font-size: 13px;
           }
       }

       /* 加载动画 */
       @keyframes fadeIn {
           from {
               opacity: 0;
               transform: translateY(20px);
           }
           to {
               opacity: 1;
               transform: translateY(0);
           }
       }
    </style>
</head>
<body>
    <h2>订单详情</h2>
    <div class="container">
       <!-- 订单号 -->
       <div class="info-row">
          <div class="info-label">订单号</div>
          <div class="info-content"><strong>${order.orderNum}</strong></div>
       </div>

       <!-- 客户ID -->
       <div class="info-row">
          <div class="info-label">客户编号</div>
          <div class="info-content">${order.userId}</div>
       </div>

       <!-- 客户姓名 -->
       <div class="info-row">
          <div class="info-label">客户姓名</div>
          <div class="info-content">${order.user.name}</div>
       </div>

       <!-- 寄送地址 -->
       <div class="info-row">
          <div class="info-label">📍 寄送地址</div>
          <div class="info-content">${order.user.address}</div>
       </div>

       <!-- 联系方式 -->
       <div class="info-row">
          <div class="info-label">📱 联系方式</div>
          <div class="info-content">${order.user.tell}</div>
       </div>

       <!-- 订单状态 -->
       <div class="info-row">
          <div class="info-label">订单状态</div>
          <div class="info-content">
             <c:if test="${order.orderStatus eq 1}">
                <span class="status-badge status-submitted">🔴 待处理</span>
             </c:if>
             <c:if test="${order.orderStatus eq 2}">
                <span class="status-badge status-shipped">🚚 已发货</span>
             </c:if>
             <c:if test="${order.orderStatus eq 3}">
                <span class="status-badge status-completed">✅ 已完成</span>
             </c:if>
          </div>
       </div>

       <!-- 订单商品信息 -->
       <div class="products-section">
          <div class="products-title">订单商品信息</div>

          <table class="table">
             <thead>
                <tr>
                   <th style="width: 50%;">商品信息</th>
                   <th style="width: 15%;">单价</th>
                   <th style="width: 15%;">数量</th>
                   <th style="width: 20%;">金额</th>
                </tr>
             </thead>
             <tbody>
                <c:forEach items="${order.oItem}" var="i" varStatus="vs">
                   <tr>
                      <td>
                         <div class="product-info">
                            <img class="product-img" src="${i.book.upLoadImg.imgSrc}" alt="${i.book.bookName}" />
                            <div class="product-details">
                               <h4>${i.book.bookName}</h4>
                               <p>作者：${i.book.author}</p>
                               <p>出版社：${i.book.press}</p>
                            </div>
                         </div>
                      </td>
                      <td><span class="price">${i.book.price}</span></td>
                      <td><span class="quantity">x ${i.quantity}</span></td>
                      <c:choose>
                         <c:when test="${vs.first}">
                            <td rowspan="${order.oItem.size()}" style="vertical-align: middle; font-weight: bold;">
                               <div style="text-align: center;">
                                  <div style="color: #888; font-size: 14px; margin-bottom: 5px;">订单总额</div>
                                  <span class="total-amount">${order.money}</span>
                               </div>
                            </td>
                         </c:when>
                      </c:choose>
                   </tr>
                </c:forEach>
             </tbody>
          </table>
       </div>

       <!-- 操作按钮 -->
       <div class="action-buttons">
          <button class="btn btn-primary" onclick="history.back()">← 返回订单列表</button>
          <button class="btn btn-success" onclick="window.print()">🖨️ 打印订单</button>
       </div>
    </div>
</body>
</html>