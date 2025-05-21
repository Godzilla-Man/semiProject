package kr.or.iei.order.model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.order.model.vo.Purchase;
import kr.or.iei.product.model.vo.Product;

public class OrderDao {

	public Product selectOrderProduct(Connection conn, String productId) {
		
		//자원 반환 객체 선언
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		//수행할 SQL 작성
		String query = "select * from TBL_PROD where PRODUCT_NO = ?"; // ? = 위치 홀더
		
		//결과를 관리할 자바 객체
		Product p = null;
		
		//실제 SQL 수행 후 결과를 받아올 객체 생성
		try {
			pstmt = conn.prepareStatement(query);
			
			//위치 홀더에 입력 값 셋팅
			pstmt.setString(1, productId); //첫번째 위치 홀더 값
			
			//SQL 수행하고 결과 받기 
			rset = pstmt.executeQuery();
			
			//결과 처리
			if(rset.next()) {
				p = new Product(); // prodcdut 객체 인스턴스화 > 안하면 p는 null 에러 발생!!
				
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
	
	//orderId를 생성하고 반환하는 메소드
	private String generateOrderId(Connection conn) {
	    PreparedStatement pstmtSeq = null;
        ResultSet rsetSeq = null;
        // SQL에서 직접 ORDER_NO 형식에 맞게 생성 및 조회
        String querySeq = "SELECT 'O' || TO_CHAR(SYSDATE, 'YYMMDD') || LPAD(SEQ_PURCHASE.NEXTVAL, 4, '0') AS ORDER_NO FROM DUAL";
        String newOrderId = null;
        	
    	try {
			pstmtSeq = conn.prepareStatement(querySeq);
			rsetSeq = pstmtSeq.executeQuery();
			if(rsetSeq.next()) {
				newOrderId = rsetSeq.getString("ORDER_NO");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rsetSeq);
			JDBCTemplate.close(pstmtSeq);
		}    	
        return newOrderId;
	}	
	
	public String createOrderId(Connection conn, Purchase readyOrder) {
        PreparedStatement pstmt = null;
        int insertResult = 0;
        String newOrderId = null;

        // 컬럼명을 명시하는 것이 더 안전하고 가독성이 좋습니다.
        // DEAL_DATE는 SYSDATE로 자동 입력됩니다.
        String query = "INSERT INTO TBL_PURCHASE ("
                     + "ORDER_NO, PRODUCT_NO, SELLER_MEMBER_NO, BUYER_MEMBER_NO, "
                     + "DELIVERY_ADDR, DELIVERY_FEE, ORDER_AMOUNT, "
                     + "PG_PROVIDER, PG_TRANSACTION_ID, PURCHASE_STATUS_CODE, DEAL_DATE"
                     + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";

        try {
            // 1. 새로운 ORDER_NO 생성
            newOrderId = generateOrderId(conn);
            readyOrder.setOrderNo(newOrderId); // 생성된 ID를 Purchase 객체에도 설정 (선택적이지만 유용할 수 있음)

            // 2. INSERT 실행
            pstmt = conn.prepareStatement(query);
            
            pstmt.setString(1, newOrderId); // 생성된 ORDER_NO
            pstmt.setString(2, readyOrder.getProductNo());
            pstmt.setString(3, readyOrder.getSellerMemberNo());
            pstmt.setString(4, readyOrder.getBuyerMemberNo());
            pstmt.setString(5, readyOrder.getDeliveryAddr());
            pstmt.setInt(6, readyOrder.getDeliveryFee());
            pstmt.setInt(7, readyOrder.getOrderAmount());
            pstmt.setString(8, readyOrder.getPgProvider());
            pstmt.setString(9, readyOrder.getPgTransactionId());
            pstmt.setString(10, readyOrder.getPurchaseStatusCode());        

            insertResult = pstmt.executeUpdate();

            if (insertResult > 0) {
                return newOrderId; // 성공 시 생성된 ORDER_NO 반환
            } else {
                // INSERT 실패 시 (이론적으로 executeUpdate가 0을 반환하는 경우는 드물지만 방어적으로 코딩)
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // 예외 발생 시 null 반환 (또는 사용자 정의 예외 throw)
            return null;
        } finally {
            JDBCTemplate.close(pstmt);
        }
    }

	public static Purchase selectOnePurchase(Connection conn, String orderId) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		Purchase purchase = null;
		
		String query = "select * from tbl_purchase where order_no = ?"; //주문번호로 구매 정보 조회
		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, orderId);
			rset = pstmt.executeQuery();
						
			if (rset.next()) {
				purchase = new Purchase();
				purchase.setOrderNo(rset.getString("ORDER_NO"));
				purchase.setProductNo(rset.getString("PRODUCT_NO"));
				purchase.setSellerMemberNo(rset.getString("SELLER_MEMBER_NO"));
				purchase.setBuyerMemberNo(rset.getString("BUYER_MEMBER_NO"));
				purchase.setDeliveryAddr(rset.getString("DELIVERY_ADDR"));
				purchase.setDeliveryFee(rset.getInt("DELIVERY_FEE"));
				purchase.setOrderAmount(rset.getInt("ORDER_AMOUNT"));
				purchase.setPgProvider(rset.getString("PG_PROVIDER"));
				purchase.setPgTransactionId(rset.getString("PG_TRANSACTION_ID"));
				purchase.setDealDate(rset.getDate("DEAL_DATE"));
				purchase.setPurchaseStatusCode(rset.getString("PURCHASE_STATUS_CODE"));				
			}			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}		
		
		return purchase;
	}

	public static int updatePurcahseStatusInfo(Connection conn, String orderId, String pgProvider, String paymentKey,
			String string, int paidAmount) {
		
		PreparedStatement pstmt = null;
		int result = 0;
		
		String query = "UPDATE TBL_PURCHASE SET PG_PROVIDER = ?, PG_TRANSACTION_ID = ?, PURCHASE_STATUS_CODE = ? WHERE ORDER_NO = ? AND ORDER_AMOUNT = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, pgProvider);
			pstmt.setString(2, paymentKey);
			pstmt.setString(3, "PS01");
			pstmt.setString(4, orderId);
			pstmt.setInt(5, paidAmount);
			
			result = pstmt.executeUpdate();		
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}
	
	
	/*
	public int createOrderId(Connection conn, Purchase readyOrder) {
		PreparedStatement pstmt = null;
		
		int result = 0;
		
		String query = "insert into TBL_PURCHASE values('O'|| to_char(sysdate, 'yymmdd') || lpad(seq_purchase.nextval, 4, '0'), ?, ?, ?, ?, ?, ?, ?, ?, sysdate, ?)";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, readyOrder.getProductNo());
			pstmt.setString(2, readyOrder.getSellerMemberNo());
			pstmt.setString(3, readyOrder.getBuyerMemberNo());
			pstmt.setString(4, readyOrder.getDeliveryAddr());
			pstmt.setInt(5, readyOrder.getDeliveryFee());
			pstmt.setInt(6, readyOrder.getOrderAmount());
			pstmt.setString(7, readyOrder.getPgProvider());
			pstmt.setString(8, readyOrder.getPgTransactionId());
			pstmt.setString(9, readyOrder.getPurchaseStatusCode());				
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}	 
		
		return result;
	}
	*/	
	
}
