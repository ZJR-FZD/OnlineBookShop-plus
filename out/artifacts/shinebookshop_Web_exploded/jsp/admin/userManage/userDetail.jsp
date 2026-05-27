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
    <title>用户详情页</title>
    <link rel="stylesheet" href="bs/css/bootstrap.css">
    <style type="text/css">
       /* 现代化用户详情页样式 */
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
           content: '👤';
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
           max-width: 800px;
           margin: 0 auto;
           animation: fadeIn 0.5s ease;
       }

       /* 用户头像区域 */
       .user-avatar-section {
           text-align: center;
           margin-bottom: 40px;
           padding: 30px;
           background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
           border-radius: 15px;
       }

       .user-avatar {
           width: 120px;
           height: 120px;
           border-radius: 50%;
           background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
           display: flex;
           align-items: center;
           justify-content: center;
           margin: 0 auto 20px;
           font-size: 60px;
           color: white;
           box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
       }

       .user-name {
           font-size: 24px;
           font-weight: 700;
           color: #333;
           margin-bottom: 5px;
       }

       .user-id {
           font-size: 14px;
           color: #888;
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

       /* 性别图标 */
       .gender-male {
           color: #667eea;
           font-weight: 600;
       }

       .gender-male::before {
           content: '♂ ';
           font-size: 18px;
       }

       .gender-female {
           color: #f093fb;
           font-weight: 600;
       }

       .gender-female::before {
           content: '♀ ';
           font-size: 18px;
       }

       /* 状态徽章 */
       .status-badge {
           display: inline-block;
           padding: 6px 16px;
           border-radius: 20px;
           font-weight: 600;
           font-size: 14px;
       }

       .status-enabled {
           background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
           color: white;
       }

       .status-enabled::before {
           content: '✓ ';
       }

       .status-disabled {
           background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
           color: white;
       }

       .status-disabled::before {
           content: '✗ ';
       }

       /* 联系信息高亮 */
       .contact-info {
           padding: 20px;
           background: linear-gradient(135deg, rgba(67, 233, 123, 0.05) 0%, rgba(56, 249, 215, 0.05) 100%);
           border-radius: 12px;
           margin: 30px 0;
           border-left: 4px solid #43e97b;
       }

       .contact-title {
           font-size: 16px;
           font-weight: 700;
           color: #43e97b;
           margin-bottom: 15px;
           display: flex;
           align-items: center;
       }

       .contact-title::before {
           content: '📞';
           margin-right: 8px;
           font-size: 20px;
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

       .btn-info {
           background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
           color: white;
       }

       .btn-info:hover {
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

           .action-buttons .btn {
               display: block;
               width: 100%;
               margin: 10px 0;
           }

           h2 {
               font-size: 24px;
           }

           .user-avatar {
               width: 100px;
               height: 100px;
               font-size: 50px;
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
    <h2>用户详情</h2>
    <div class="container">
       <!-- 用户头像和基本信息 -->
       <div class="user-avatar-section">
          <div class="user-avatar">
             <c:choose>
                <c:when test="${userInfo.sex eq '男'}">♂</c:when>
                <c:when test="${userInfo.sex eq '女'}">♀</c:when>
                <c:otherwise>👤</c:otherwise>
             </c:choose>
          </div>
          <div class="user-name">${userInfo.name}</div>
          <div class="user-id">用户编号：${userInfo.userId}</div>
       </div>

       <!-- 基本信息 -->
       <div class="info-row">
          <div class="info-label">用户名</div>
          <div class="info-content"><strong>${userInfo.userName}</strong></div>
       </div>

       <div class="info-row">
          <div class="info-label">密码</div>
          <div class="info-content">${userInfo.userPassWord}</div>
       </div>

       <div class="info-row">
          <div class="info-label">真实姓名</div>
          <div class="info-content">${userInfo.name}</div>
       </div>

       <div class="info-row">
          <div class="info-label">性别</div>
          <div class="info-content">
             <c:choose>
                <c:when test="${userInfo.sex eq '男'}">
                   <span class="gender-male">男</span>
                </c:when>
                <c:when test="${userInfo.sex eq '女'}">
                   <span class="gender-female">女</span>
                </c:when>
                <c:otherwise>
                   ${userInfo.sex}
                </c:otherwise>
             </c:choose>
          </div>
       </div>

       <div class="info-row">
          <div class="info-label">年龄</div>
          <div class="info-content">${userInfo.age} 岁</div>
       </div>

       <div class="info-row">
          <div class="info-label">账号状态</div>
          <div class="info-content">
             <c:choose>
                <c:when test="${userInfo.enabled eq 'y'}">
                   <span class="status-badge status-enabled">启用</span>
                </c:when>
                <c:otherwise>
                   <span class="status-badge status-disabled">禁用</span>
                </c:otherwise>
             </c:choose>
          </div>
       </div>

       <!-- 联系信息 -->
       <div class="contact-info">
          <div class="contact-title">联系方式</div>

          <div class="info-row" style="margin-bottom: 10px;">
             <div class="info-label">📱 电话</div>
             <div class="info-content"><strong>${userInfo.tell}</strong></div>
          </div>

          <div class="info-row" style="margin-bottom: 0;">
             <div class="info-label">📍 地址</div>
             <div class="info-content">${userInfo.address}</div>
          </div>
       </div>

       <!-- 操作按钮 -->
       <div class="action-buttons">
          <button class="btn btn-primary" onclick="history.back()">← 返回列表</button>
          <button class="btn btn-info" onclick="location.href='jsp/admin/UserManageServlet?action=edit&id=${userInfo.userId}'">✏️ 编辑用户</button>
       </div>
    </div>
</body>
</html>