package com.shine.bookshop.util;

import com.shine.bookshop.bean.User;

public class OperationLogUtil {

	private static final String SQL = "insert into s_operation_log(userId,userName,logType,targetId,targetName,detail,ipAddress,duration,catalogId,createTime) values(?,?,?,?,?,?,?,?,?,?)";

	private OperationLogUtil() {
	}

	/** 记录浏览行为（兼容旧调用） */
	public static void recordBrowse(User user, Integer targetId, String targetName, String detail) {
		record(user, "BROWSE", targetId, targetName, detail, null, 0, null);
	}

	/** 记录浏览行为（带 IP+时长+分类） */
	public static void recordBrowse(User user, Integer bookId, String bookName, Integer catalogId, String ip, int duration) {
		record(user, "BROWSE", bookId, bookName, "book detail", ip, duration, catalogId);
	}

	/** 记录购买行为 */
	public static void recordPurchase(User user, String orderNum, double money, int itemCount) {
		String detail = "amount=" + money + ",items=" + itemCount;
		record(user, "PURCHASE", null, orderNum, detail, null, 0, null);
	}

	/** 记录购买行为（带 IP） */
	public static void recordPurchase(User user, String orderNum, double money, int itemCount, String ip) {
		String detail = "amount=" + money + ",items=" + itemCount;
		record(user, "PURCHASE", null, orderNum, detail, ip, 0, null);
	}

	/** 记录用户登录 */
	public static void recordLogin(User user, String ip) {
		record(user, "LOGIN", null, null, "用户登录", ip, 0, null);
	}

	/** 记录管理员/销售人员登录 */
	public static void recordAdminLogin(String userName, String role, String ip) {
		DbUtil.excuteUpdate(SQL,
				null, userName, "LOGIN", null, null,
				"后台登录 role=" + role, ip, 0, null, DateUtil.show());
	}

	/** 记录管理员操作 */
	public static void recordAdminOp(String userName, String action, String target, String ip) {
		DbUtil.excuteUpdate(SQL,
				null, userName, "ADMIN_OP", null, target,
				action, ip, 0, null, DateUtil.show());
	}

	private static void record(User user, String logType, Integer targetId, String targetName, String detail,
			String ip, int duration, Integer catalogId) {
		DbUtil.excuteUpdate(SQL,
				user == null ? null : user.getUserId(),
				user == null ? null : user.getUserName(),
				logType,
				targetId,
				targetName,
				detail,
				ip,
				duration,
				catalogId,
				DateUtil.show());
	}
}
