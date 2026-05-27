package com.shine.bookshop.filter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.shine.bookshop.util.DateUtil;
import com.shine.bookshop.util.DbUtil;
import com.shine.bookshop.util.IpUtil;

@WebFilter(filterName = "RateLimitFilter", urlPatterns = "/*")
public class RateLimitFilter implements Filter {

	private static final int MAX_REQUESTS = 60;
	private static final int WINDOW_SECONDS = 10;
	private final Map<String, WindowCounter> counters = new ConcurrentHashMap<>();

	private static class WindowCounter {
		long windowStart = System.currentTimeMillis();
		int count = 0;
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) resp;

		String ip = IpUtil.getClientIp(request);
		String path = request.getRequestURI();
		if (path.contains(".css") || path.contains(".js") || path.contains(".jpg") || path.contains(".png")) {
			chain.doFilter(req, resp);
			return;
		}

		WindowCounter c = counters.computeIfAbsent(ip, k -> new WindowCounter());
		long now = System.currentTimeMillis();

		synchronized (c) {
			if (now - c.windowStart > WINDOW_SECONDS * 1000L) {
				c.windowStart = now;
				c.count = 0;
			}
			c.count++;

			if (c.count > MAX_REQUESTS) {
				DbUtil.excuteUpdate(
					"insert into s_operation_log(userName,logType,targetName,detail,ipAddress,duration,catalogId,createTime) values(?,?,?,?,?,?,?,?)",
					null, "CRAWLER", path, "rate limit blocked count=" + c.count, ip, 0, null, DateUtil.show());
				response.setStatus(429);
				response.getWriter().write("Too Many Requests");
				return;
			}
		}

		chain.doFilter(req, resp);
	}

	@Override
	public void init(FilterConfig fConfig) {}
	@Override
	public void destroy() {}
}
