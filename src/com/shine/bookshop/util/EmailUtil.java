package com.shine.bookshop.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.shine.bookshop.bean.User;

/**
 * 邮件发送工具 —— 通过 QQ 邮箱 SMTP 发送真实邮件。
 * SMTP 配置从 dbinfo.properties 读取。
 */
public class EmailUtil {

	private static final String SQL_LOG = "insert into s_operation_log(userId,userName,logType,targetId,targetName,detail,createTime) values(?,?,?,?,?,?,?)";

	private static String smtpHost;
	private static String smtpPort;
	private static String smtpUser;
	private static String smtpPass;
	private static String smtpFrom;

	static {
		smtpHost = PropertiesUtil.getProperty("EMAIL_HOST", "smtp.qq.com");
		smtpPort = PropertiesUtil.getProperty("EMAIL_PORT", "465");
		smtpUser = PropertiesUtil.getProperty("EMAIL_USER", "");
		smtpPass = PropertiesUtil.getProperty("EMAIL_PASS", "");
		smtpFrom = PropertiesUtil.getProperty("EMAIL_FROM", smtpUser);
	}

	private EmailUtil() {
	}

	/**
	 * 发送订单确认邮件。user.email 为空则不发送。
	 */
	public static void sendOrderConfirm(User user, String orderNum, double money, int itemCount) {
		if (user == null || user.getEmail() == null || user.getEmail().trim().isEmpty()) {
			System.out.println("[Email] 用户 " + (user != null ? user.getUserName() : "null") + " 未设置邮箱，跳过发送");
			return;
		}
		String to = user.getEmail().trim();
		String userName = user.getName() != null ? user.getName() : user.getUserName();
		String subject = "【当当小书屋】订单确认通知 - " + orderNum;
		String body = buildOrderEmailBody(userName, orderNum, money, itemCount);

		boolean sent = sendMail(to, subject, body);
		String status = sent ? "SUCCESS" : "FAILED";
		System.out.println("[Email] 发送" + status + " -> " + to + " | " + subject);

		DbUtil.excuteUpdate(SQL_LOG,
				user.getUserId(),
				user.getUserName(),
				"EMAIL",
				null,
				orderNum,
				"status=" + status + " | to=" + to,
				DateUtil.show());
	}

	private static boolean sendMail(String to, String subject, String body) {
		try {
			Properties props = new Properties();
			props.put("mail.smtp.host", smtpHost);
			props.put("mail.smtp.port", smtpPort);
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.ssl.enable", "true");
			props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

			Session session = Session.getInstance(props, new Authenticator() {
				@Override
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(smtpUser, smtpPass);
				}
			});

			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(smtpFrom));
			msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
			msg.setSubject(subject);
			msg.setText(body);

			Transport.send(msg);
			return true;
		} catch (Exception e) {
			System.err.println("[Email] 发送失败: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	private static String buildOrderEmailBody(String userName, String orderNum, double money, int itemCount) {
		return "亲爱的 " + userName + "：\n\n"
				+ "感谢您在当当小书屋购物！您的订单已确认。\n\n"
				+ "━━━━━━━━━━━━━━━━━━━━\n"
				+ "  订单编号：" + orderNum + "\n"
				+ "  订单金额：¥" + String.format("%.2f", money) + "\n"
				+ "  商品数量：" + itemCount + " 件\n"
				+ "━━━━━━━━━━━━━━━━━━━━\n\n"
				+ "我们会尽快为您发货，请耐心等待。\n"
				+ "如有问题，请联系客服。\n\n"
				+ "当当小书屋 客服团队\n"
				+ DateUtil.show();
	}
}
