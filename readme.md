# 作者信息

- 班级：23级网络工程
- 姓名：曾婧茹
- 学号：202330452242

# 使用说明

http://113.46.205.78:8080/

点击上面的链接，即可进入首页。

## 默认账号

| 角色 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| 用户 | user | 1234 | 也可自行注册 |
| 销售人员 | salesperson | salesperson | 图书管理、订单处理、日志监控 |
| 管理员 | admin | admin | 人员管理、销售分析、用户分析 |

## 功能概览

### 🛒 用户端
- 注册/登录/注销（登录记录 IP）
- 浏览图书（记录停留时长、分类偏好）
- 加入购物车 → 下单 → 邮件确认
- 订单管理（确认收货）
- 「看了又买」关联推荐 + 「购买此书的也买了」协同过滤推荐
- 浏览时长追踪（反爬虫检测）

### 📦 销售人员端
- 图书管理：列表查看、价格/库存修改
- 分类管理：添加/删除图书类别
- 订单管理：订单列表、订单处理（发货）
- 销售分析：销售监控仪表盘、销售报表（日/周/月趋势+预测+排行）
- 用户分析：用户画像（性别/年龄/购买力/分类偏好）、行为日志

### 👑 管理员端
- 人员管理：销售人员账号管理（添加/删除/密码重置）、用户管理、工作人员日志
- 图书管理、销售分析、用户分析（同销售人员）
- 销售报表：商品排行榜、日/周/月趋势折线图+预测、类别销量图、订单状态表、库存汇总表
- 异常监控：今日销量对比告警、零销售分类、低库存热销预警
- 反爬虫侦测：IP 频率限制（10 秒 60 次），拦截记录可查

# 开发说明

## 核心环境

| 软件环境 | 推荐版本 |
| -------- | -------- |
| JDK | JDK 8（1.8.x） |
| Tomcat | Tomcat 9.x / 8.5.x |
| MySQL | MySQL 5.7 / 8.0 |
| MySQL 驱动包 | mysql-connector-java 5.1.x |
| 操作系统 | Ubuntu 20.04/22.04 LTS |

## 项目结构

```
OnlineBookShop/
├── src/com/shine/bookshop/
│   ├── bean/          (实体类)
│   ├── dao/           (数据访问接口+实现)
│   ├── filter/        (编码/登录/频率限制过滤器)
│   ├── listener/      (会话监听器)
│   ├── servlet/       (控制器)
│   │   ├── admin/     (后台管理)
│   │   └── book/      (前台书店)
│   └── util/          (工具类)
├── WebContent/
│   ├── WEB-INF/
│   │   ├── web.xml    (部署描述符)
│   │   └── lib/       (依赖 jar)
│   ├── jsp/
│   │   ├── admin/     (后台页面)
│   │   └── book/      (前台页面)
│   ├── css/ js/ images/
│   └── bs/            (Bootstrap)
├── bookshop.sql       (数据库初始化脚本)
└── out/artifacts/     (编译输出目录)
```

# 华为云部署

## 一、环境准备（华为云 ECS Ubuntu）

0. 购买华为云服务器，记录公网 IP，安全组开放 8080 端口（IPv4 + IPv6）

1. 更新系统并安装 JDK 8
```bash
apt update && apt install -y openjdk-8-jdk
java -version
```

2. 安装 Tomcat 9
```bash
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
tar -zxvf apache-tomcat-9.0.80.tar.gz -C /usr/local/
mv /usr/local/apache-tomcat-9.0.80 /usr/local/tomcat
/usr/local/tomcat/bin/startup.sh
```

3. 安装 MySQL 并配置认证
```bash
apt install -y mysql-server
systemctl start mysql && systemctl enable mysql
sudo mysql -u root
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
FLUSH PRIVILEGES; EXIT;
systemctl restart mysql
```

## 二、项目部署

1. 克隆代码
```bash
cd /usr/local/tomcat/webapps
git clone https://github.com/ZJR-FZD/OnlineBookShop.git
cd OnlineBookShop
```

2. 导入数据库
```bash
mysql -u root -p
SOURCE /usr/local/tomcat/webapps/OnlineBookShop/bookshop.sql;
SHOW TABLES;
EXIT;
```

3. 部署编译产物
```bash
cp -rf out/artifacts/shinebookshop_Web_exploded/* ./
```

4. 设置为 Tomcat 根路径
```bash
/usr/local/tomcat/bin/shutdown.sh
rm -rf /usr/local/tomcat/webapps/ROOT
mv /usr/local/tomcat/webapps/OnlineBookShop /usr/local/tomcat/webapps/ROOT
```

5. 替换服务器 IP（关键步骤）
```bash
cd /usr/local/tomcat/webapps/ROOT
sed -i 's/localhost:8080/你的公网IP:8080/g' $(grep -rl "localhost:8080" ./ | xargs)
grep -r "你的公网IP:8080" ./
/usr/local/tomcat/bin/startup.sh
```

## 三、邮件配置（可选）

编辑 `WEB-INF/classes/dbinfo.properties`，填入 QQ 邮箱 SMTP 授权码：
```properties
EMAIL_HOST=smtp.qq.com
EMAIL_PORT=465
EMAIL_USER=你的QQ邮箱@qq.com
EMAIL_PASS=你的QQ邮箱授权码
```
不配置则用户下单后不会发送邮件（不影响其他功能）。

## 四、服务器重启

```bash
systemctl start mysql
/usr/local/tomcat/bin/startup.sh
```

## 五、问题排查

1. **数据库连接失败**：`tail -f /usr/local/tomcat/logs/catalina.out` 查看日志
2. **404 错误**：确认项目已重命名为 ROOT，确认有编译后的 class 文件
3. **SQL 1060 Duplicate column**：表中已存在该列，忽略即可（ALTER TABLE 仅作增量兼容）
4. **Linux 大小写敏感**：确保 Java 代码中表名与 SQL 文件一致
