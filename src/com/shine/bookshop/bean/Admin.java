package com.shine.bookshop.bean;

import java.util.Date;
import java.util.Map;
/**
 * 管理员用户类
 * @author thuih
 *
 */
public class Admin {
	private Integer id;				//用户编号
	private String userName;			//用户名
	private String passWord;			//用户密码
	private String name;				//用户姓名
	private String role;				//角色：admin / sales
	private Date lastLoginTime;		//最后登录时间
	
	public Admin() {}
	
	public Admin(String userName,String passWord) {
		this.userName=userName;
		this.passWord=passWord;
		this.role = "sales";
	}
	
	public Admin(Integer id, String passWord, String name) {
		super();
		this.id = id;
		this.passWord = passWord;
		this.name = name;
		this.role = "sales";
	}


	public Admin(String userName, String passWord, String name) {
		super();
		this.userName = userName;
		this.passWord = passWord;
		this.name = name;
		this.role = "sales";
	}

	public Admin(Integer id, String passWord, String name, String role) {
		super();
		this.id = id;
		this.passWord = passWord;
		this.name = name;
		this.role = role;
	}

	public Admin(String userName, String passWord, String name, String role) {
		super();
		this.userName = userName;
		this.passWord = passWord;
		this.name = name;
		this.role = role;
	}

	public Admin(Map<String,Object> map) {
		this.id = (Integer) map.get("id");
		this.userName=(String) map.get("userName");
		this.passWord = (String) map.get("passWord");
		this.name = (String) map.get("name");
		Object roleValue = map.get("role");
		this.role = roleValue == null ? "sales" : String.valueOf(roleValue);
		this.lastLoginTime=(Date) map.get("lastLoginTime");
	}
	
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassWord() {
		return passWord;
	}

	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}


	public Date getLastLoginTime() {
		return lastLoginTime;
	}

	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}

	
}
