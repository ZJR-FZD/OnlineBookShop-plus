package com.shine.bookshop.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.shine.bookshop.bean.Book;
import com.shine.bookshop.bean.Catalog;
import com.shine.bookshop.bean.PageBean;
import com.shine.bookshop.bean.UpLoadImg;
import com.shine.bookshop.dao.BookDao;
import com.shine.bookshop.util.DateUtil;
import com.shine.bookshop.util.DbUtil;

public class BookDaoImpl implements BookDao {

	@Override
	public List<Book> bookList(PageBean pageBean) {
		List<Book> list = new ArrayList<>();

		String sql = "select * from view_book limit ?,?";
		// 查询的分页结果集
		List<Map<String, Object>> lm = DbUtil.executeQuery(sql, (pageBean.getCurPage() - 1) * pageBean.getMaxSize(),
				pageBean.getMaxSize());

		// 把查询的book结果由List<Map<String, Object>>转换为List<Book>
		if (lm.size() > 0) {
			for (Map<String, Object> map : lm) {
				Book book = new Book(map);
				list.add(book);
			}
		}

		return list;
	}

	@Override
	public long bookReadCount() {
		String sql = "select count(*) as count from s_book";
		List<Map<String, Object>> lm = DbUtil.executeQuery(sql);
		return lm.size() > 0 ? (long) lm.get(0).get("count") : 0;
	}

	@Override
	public boolean bookAdd(Book book) {
		String sql = "insert into s_book(bookName,catalogId,author,press,price,description,imgId,addTime,stock) values(?,?,?,?,?,?,?,?,?)";

		int i = DbUtil.excuteUpdate(sql, book.getBookName(), book.getCatalog().getCatalogId(), book.getAuthor(),
				book.getPress(), book.getPrice(), book.getDescription(), book.getUpLoadImg().getImgId(),
				DateUtil.getTimestamp(), book.getStock());

		return i > 0 ? true : false;
	}

	@Override
	public Book findBookById(int bookId) {
		String sql = "select * from view_book where bookId=?";
		Book book = null;
		List<Map<String, Object>> list = DbUtil.executeQuery(sql, bookId);
		if (list.size() > 0) {
			book = new Book(list.get(0));
		}
		return book;
	}

	/**
	 * 
	 */
	@Override
	public boolean findBookByBookName(String bookName) {
		String sql = "select * from s_book where bookName=?";
		List<Map<String, Object>> list = DbUtil.executeQuery(sql, bookName);
		return list.size() > 0 ? true : false;
	}

	/**
	 * 更新图书信息
	 */
	@Override
	public boolean bookUpdate(Book book) {
		String sql = "update s_book set catalogId=?,author=?,press=?,price=?,description=?,stock=? where bookId=?";
		int i = DbUtil.excuteUpdate(sql, book.getCatalogId(), book.getAuthor(), book.getPress(), book.getPrice(),
				book.getDescription(), book.getStock(), book.getBookId());
		return i > 0 ? true : false;
	}

	/**
	 * 图书删除
	 */
	@Override
	public boolean bookDelById(int bookId) {
		try {
			// 第一步：检查是否有订单引用这本书
			String checkSql = "SELECT COUNT(*) as count FROM s_orderitem WHERE bookId=?";
			List<Map<String, Object>> checkResult = DbUtil.executeQuery(checkSql, new Object[]{bookId});
			long count = checkResult.size() > 0 ? (Long)checkResult.get(0).get("count") : 0L;

			// 第二步：如果有订单引用，先删除订单项
			if (count > 0) {
				String delOrderItemSql = "DELETE FROM s_orderitem WHERE bookId=?";
				DbUtil.excuteUpdate(delOrderItemSql, new Object[]{bookId});
			}

			// 第三步：删除图书
			String delBookSql = "DELETE FROM s_book WHERE bookId=?";
			int i = DbUtil.excuteUpdate(delBookSql, new Object[]{bookId});

			return i > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * 批量查询
	 */
	@Override
	public String findimgIdByIds(String ids) {
		String imgIds = "";
		String sql = "select imgId from s_book where bookId in(" + ids + ")";
		List<Map<String, Object>> list = DbUtil.executeQuery(sql);
		if (list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				if (i != list.size() - 1) {
					imgIds += list.get(i).get("imgId") + ",";
				} else {
					imgIds += list.get(i).get("imgId");
				}
			}
		}
		return imgIds;
	}

	// 批量删除
	@Override
	public boolean bookBatDelById(String ids) {
		try {
			// 第一步：删除这些图书相关的所有订单项
			String delOrderItemSql = "DELETE FROM s_orderitem WHERE bookId IN(" + ids + ")";
			DbUtil.excuteUpdate(delOrderItemSql, new Object[0]);

			// 第二步：删除图书
			String delBookSql = "DELETE FROM s_book WHERE bookId IN(" + ids + ")";
			int i = DbUtil.excuteUpdate(delBookSql, new Object[0]);

			return i > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// 随机查询一定数量的书
	@Override
	public List<Book> bookList(int num) {
		List<Book> list = new ArrayList<>();
		String sql = "select * from view_book order by rand() LIMIT ?";
		List<Map<String, Object>> lm = DbUtil.executeQuery(sql, num);
		// 把查询的book结果由List<Map<String, Object>>转换为List<Book>
		if (lm.size() > 0) {
			for (Map<String, Object> map : lm) {
				Book book = new Book(map);
				list.add(book);
			}
		}
		return list;
	}

	/**
	 * 查询指定数量新书
	 */
	@Override
	public List<Book> newBooks(int num) {
		List<Book> list = new ArrayList<>();
		String sql = "SELECT * FROM view_book ORDER BY addTime desc limit 0,?";
		List<Map<String, Object>> lm = DbUtil.executeQuery(sql, num);
		// 把查询的book结果由List<Map<String, Object>>转换为List<Book>
		if (lm.size() > 0) {
			for (Map<String, Object> map : lm) {
				Book book = new Book(map);
				list.add(book);
			}
		}
		return list;
	}

	/**
	 * 按分类id统计图书数量
	 */
	@Override
	public long bookReadCount(int catalogId) {
		String sql = "select count(*) as count from s_book where catalogId=?";
		List<Map<String, Object>> lm = DbUtil.executeQuery(sql, catalogId);
		return lm.size() > 0 ? (long) lm.get(0).get("count") : 0;
	}

	/**
	 * 按分类id获取图书列表
	 */
	@Override
	public List<Book> bookList(PageBean pageBean, int catalogId) {
		List<Book> list = new ArrayList<>();

		String sql = "select * from view_book where catalogId=? limit ?,?";
		// 查询的分页结果集
		List<Map<String, Object>> lm = DbUtil.executeQuery(sql, catalogId,
				(pageBean.getCurPage() - 1) * pageBean.getMaxSize(), pageBean.getMaxSize());

		// 把查询的book结果由List<Map<String, Object>>转换为List<Book>
		if (lm.size() > 0) {
			for (Map<String, Object> map : lm) {
				Book book = new Book(map);
				list.add(book);
			}
		}
		return list;
	}
	
	/**
	 * 按分类id获取图书列表
	 */
	@Override
	public List<Book> bookList(PageBean pageBean, String bookname) {
		List<Book> list = new ArrayList<>();

		String sql = "select * from view_book where bookName like '%"+bookname+"%' limit ?,?";
		// 查询的分页结果集
		List<Map<String, Object>> lm = DbUtil.executeQuery(sql,
				(pageBean.getCurPage() - 1) * pageBean.getMaxSize(), pageBean.getMaxSize());

		// 把查询的book结果由List<Map<String, Object>>转换为List<Book>
		if (lm.size() > 0) {
			for (Map<String, Object> map : lm) {
				Book book = new Book(map);
				list.add(book);
			}
		}
		return list;
	}


	@Override
	public long bookReadCount(String bookname) {
		String sql = "select count(*) as count from s_book where bookName like '%"+bookname+"%'";
		List<Map<String, Object>> lm = DbUtil.executeQuery(sql);
		return lm.size() > 0 ? (long) lm.get(0).get("count") : 0;
	}

	@Override
		public List<Map<String, Object>> findPurchasedByViewers(int bookId, int limit) {
			String sql = "select b2.bookId, b2.bookName, b2.price, b2.author, i.imgSrc, count(*) as cnt"
				+ " from s_operation_log l1"
				+ " join s_operation_log l2 on l1.userId = l2.userId"
				+ " join s_book b2 on l2.targetId = b2.bookId"
				+ " left join s_uploadimg i on b2.imgId = i.imgId"
				+ " where l1.logType='BROWSE' and l1.targetId = ?"
				+ " and l2.logType='PURCHASE' and l2.targetId is not null and l2.targetId != ?"
				+ " group by b2.bookId, b2.bookName, b2.price, b2.author, i.imgSrc"
				+ " order by cnt desc limit ?";
			return DbUtil.executeQuery(sql, bookId, bookId, limit);
		}
		@Override
		public List<Map<String, Object>> findBoughtTogether(int bookId, int limit) {
			String sql = "select b.bookId, b.bookName, b.price, i.imgSrc, count(*) as cnt"
				+ " from s_orderitem oi1"
				+ " join s_orderitem oi2 on oi1.orderId = oi2.orderId"
				+ " join s_book b on oi2.bookId = b.bookId"
				+ " left join s_uploadimg i on b.imgId = i.imgId"
				+ " where oi1.bookId = ? and oi2.bookId != ?"
				+ " group by b.bookId, b.bookName, b.price, i.imgSrc"
				+ " order by cnt desc limit ?";
			return DbUtil.executeQuery(sql, bookId, bookId, limit);
		}
}
