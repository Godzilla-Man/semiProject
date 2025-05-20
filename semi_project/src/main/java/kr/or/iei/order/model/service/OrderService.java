package kr.or.iei.order.model.service;

import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.order.model.dao.OrderDao;
import kr.or.iei.order.model.vo.Purchase;
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

	public String createOrderId(Purchase readyOrder) {
		Connection conn = JDBCTemplate.getConnection();
		String generateOrderId = null;
		
		generateOrderId = dao.createOrderId(conn, readyOrder);		
		
		if(generateOrderId != null && !generateOrderId.isEmpty()) {
			JDBCTemplate.commit(conn);
		}else {
			JDBCTemplate.rollback(conn);
		}
		JDBCTemplate.close(conn);		
		
		return generateOrderId;		
	}

}
