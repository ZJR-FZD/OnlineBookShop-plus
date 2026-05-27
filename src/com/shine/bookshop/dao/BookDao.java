package com.shine.bookshop.dao;

import java.util.List;
import java.util.Map;

import com.shine.bookshop.bean.Book;
import com.shine.bookshop.bean.Catalog;
import com.shine.bookshop.bean.PageBean;

import net.sf.json.JSONObject;

public interface BookDao {
	// 获取图书总数
	long bookReadCount();
	
	//按书名获取图书总数
	long bookReadCount(String bookname);
	
	public List<Book> bookList(PageBean pageBean, String bookname);

	// 获取图书分页列表(视图)
	List<Book> bookList(PageBean pageBean);

	// 按分类获取图书数量
	long bookReadCount(int catalogId);

	// 按分类获取图书分页列表(视图)
	List<Book> bookList(PageBean pageBean, int catalogId);

	// 增加图书
	boolean bookAdd(Book book);

	// 根据图书id查找图书信息(视图)
	Book findBookById(int bookId);

	// 根据图书名称查找图书是否存在
	boolean findBookByBookName(String bookName);

	// 更新图书信息
	boolean bookUpdate(Book book);

	// 根据id删除图书
	boolean bookDelById(int bookId);

	// 根据id串查询图片id串
	String findimgIdByIds(String ids);

	// 批量删除图书
	boolean bookBatDelById(String ids);

	// 随机获取指定数量书
	List<Book> bookList(int num);

	// 获取指定数量新添加的图书
	List<Book> newBooks(int num);

	// 浏览此书的人也买了什么（关联规则）
	List<Map<String, Object>> findPurchasedByViewers(int bookId, int limit);

	// 购买此书的也买了什么（协同过滤）
	List<Map<String, Object>> findBoughtTogether(int bookId, int limit);

}
