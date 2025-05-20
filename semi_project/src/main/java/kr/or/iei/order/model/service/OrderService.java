package kr.or.iei.order.model.service;

import java.sql.Connection;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.order.model.dao.OrderDao;
import kr.or.iei.product.model.vo.Product;

public class OrderService {
	
	private OrderDao dao;
	
	public OrderService() {
		dao = new OrderDao();
	}

	public Product selectOrderProduct(String productId) {
		Connection conn = JDBCTemplate.getConnection();
		Product p = dao.selectOrderProduct(conn, productId);
		JDBCTemplate.close(conn);
		return p;		
	}
}
