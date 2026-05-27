package com.shine.bookshop.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.ResourceBundle;

/**
 * 读取dbInfo.properties的参数类
 * @author thuih
 *
 */
public class PropertiesUtil {
	
	private static ResourceBundle bundle;
	

	
	public static String getValue(String key){
		try {
			bundle=ResourceBundle.getBundle(DbUtil.BASE_NAME);
		} catch (Exception e) {
			e.getStackTrace();
		}

		return bundle.getString(key);
	}

	public static String getProperty(String key, String defaultValue) {
		Properties p = new Properties();
		try {
			InputStream is = PropertiesUtil.class.getResourceAsStream("/dbinfo.properties");
			if (is != null) {
				p.load(is);
				is.close();
				return p.getProperty(key, defaultValue);
			}
		} catch (IOException e) {
			System.out.println(DateUtil.show() + ">>读取配置文件失败!" + e.getMessage());
		}
		return defaultValue;
	}
	

	
//	public static void main(String[] args) {
//		String Driver=PropertiesUtil.getValue("DB_DRIVER");
//		System.out.println(Driver);
//	}
	
//	public static String getValue(String name){
//		Properties p=new Properties();
//		try {
//			//查找dbInfo.properties文件。并返回输入流
//			InputStream is=PropertiesUtil.class.getResourceAsStream("/dbinfo.properties");
//			p.load(is);
//		} catch (IOException e) {
//			System.out.println(DateUtil.show()+">>数据库配置文件加载失败!"+e.getMessage());
//		}
//		
//		return p.getProperty(name);
//	}
}
