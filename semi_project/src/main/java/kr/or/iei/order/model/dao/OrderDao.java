package kr.or.iei.order.model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.product.model.vo.Product;

public class OrderDao {

	public Product selectOrderProduct(Connection conn, String productId) {
		
		//자원 반환 객체 선언
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		//수행할 SQL 작성
		String query = "select * from TBL_PROD where PRODUCT_NO = ?"; // ? = 위치 홀더
		
		//결과를 관리할 자바 객체
		Product p  = null;
		
		//실제 SQL 수행 후 결과를 받아올 객체 생성
		try {
			pstmt = conn.prepareStatement(query);
			
			//위치 홀더에 입력 값 셋팅
			pstmt.setString(1, productId); //첫번째 위치 홀더 값
			
			//SQL 수행하고 결과 받기 
			rset = pstmt.executeQuery();
			
			//결과 처리
			if(rset.next()) {
				p.setProductNo(rset.getString("product_no"));
				p.setMemberNo(rset.getString("member_no"));
				p.setProductName(rset.getString("product_name"));
				p.setProductIntrod(rset.getString("product_introd"));
				p.setProductPrice(rset.getInt("product_price"));
				p.setCategoryCode(rset.getString("category_code"));
				p.setTradeMethodCode(rset.getString("trade_method_code"));
				p.setStatusCode(rset.getString("status_code"));
				p.setEnrollDate(rset.getDate("enroll_date"));
				p.setReadCount(rset.getInt("read_count"));
				p.setProductQuantity(rset.getInt("product_quantity"));
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}		
		
		return p;
	}
	
}
