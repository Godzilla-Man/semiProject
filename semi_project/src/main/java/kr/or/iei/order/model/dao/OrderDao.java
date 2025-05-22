package kr.or.iei.order.model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.order.model.vo.Purchase;
import kr.or.iei.product.model.vo.Product;

public class OrderDao {

	public Product selectOrderProduct(Connection conn, String productId) {
		
		//자원 반환 객체 선언
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		//수행할 SQL 작성
		String query = "SELECT P.*, M.MEMBER_NICKNAME AS SELLER_NICKNAME " +
                "FROM TBL_PROD P " +
                "JOIN TBL_MEMBER M ON P.MEMBER_NO = M.MEMBER_NO " +
                "WHERE P.PRODUCT_NO = ?";		
		
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
				//조인시킨 판매자 닉넴!
				p.setSellerNickname(rset.getString("seller_nickname"));
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

	public Purchase selectOnePurchaseCancel(Connection conn, String orderId, String memberNo) {
		PreparedStatement pstmt = null;
	    ResultSet rset = null;
	    Purchase purchase = null;
	    // 주문자 본인이고, 특정 상태(예: PS01)일 때만 조회되도록 조건 추가 가능
	    String query = "SELECT * FROM TBL_PURCHASE WHERE ORDER_NO = ? AND BUYER_MEMBER_NO = ?";
	    try {
	        pstmt = conn.prepareStatement(query);
	        pstmt.setString(1, orderId);
	        pstmt.setString(2, memberNo);
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
	        e.printStackTrace();
	    } finally {
	        JDBCTemplate.close(rset);
	        JDBCTemplate.close(pstmt);
	    }
	    return purchase;
	}

	public int updateOrderStatus(Connection conn, String orderId, String string) {
		PreparedStatement pstmt = null;
	    int result = 0;
	    String query = "UPDATE TBL_PURCHASE SET PURCHASE_STATUS_CODE = ? WHERE ORDER_NO = ?";
	    try {
	        pstmt = conn.prepareStatement(query);
	        pstmt.setString(1, "PS04");
	        pstmt.setString(2, orderId);
	        result = pstmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        JDBCTemplate.close(pstmt);
	    }
	    return result;
	}
	
	// 구매내역 정보룰 갖고 오기 위한 DAO!!
	public List<Purchase> selectPurchaseListByBuyerNo(Connection conn, String buyerMemberNo) {	
	    List<Purchase> list = new ArrayList();
	    PreparedStatement pstmt = null;
	    ResultSet rset = null;
	    // TBL_PURCHASE를 기준으로 TBL_PROD, TBL_MEMBER(판매자), TBL_FILE(대표이미지), TBL_PURCHASE_STATUS 조인
	    String query = "SELECT " +
	                   "    P.ORDER_NO, P.PRODUCT_NO, P.SELLER_MEMBER_NO, P.BUYER_MEMBER_NO, " +
	                   "    P.DELIVERY_ADDR, P.DELIVERY_FEE, P.ORDER_AMOUNT, " +
	                   "    P.PG_PROVIDER, P.PG_TRANSACTION_ID, P.DEAL_DATE, P.PURCHASE_STATUS_CODE, " +
	                   "    PROD.PRODUCT_NAME, PROD.PRODUCT_PRICE, " + // 상품명, 상품 가격
	                   "    SELLER.MEMBER_NICKNAME AS SELLER_NICKNAME, " + // 판매자 닉네임
	                   "    PS.STATUS_NAME AS PURCHASE_STATUS_NAME, " +   // 주문 상태명
	                   "    (SELECT FILE_PATH FROM (SELECT FILE_PATH FROM TBL_FILE F WHERE F.PRODUCT_NO = P.PRODUCT_NO ORDER BY F.FILE_NO ASC) WHERE ROWNUM = 1) AS THUMBNAIL_PATH " + // 대표 이미지 경로
	                   "FROM TBL_PURCHASE P " +
	                   "JOIN TBL_PROD PROD ON P.PRODUCT_NO = PROD.PRODUCT_NO " +
	                   "JOIN TBL_MEMBER SELLER ON P.SELLER_MEMBER_NO = SELLER.MEMBER_NO " +
	                   "JOIN TBL_PURCHASE_STATUS PS ON P.PURCHASE_STATUS_CODE = PS.PURCHASE_STATUS_CODE " +
	                   "WHERE P.BUYER_MEMBER_NO = ? " +
	                   "ORDER BY P.DEAL_DATE DESC"; // 최근 구매 순으로 정렬

	    try {
	        pstmt = conn.prepareStatement(query);
	        pstmt.setString(1, buyerMemberNo);
	        rset = pstmt.executeQuery();

	        while (rset.next()) {
	            Purchase p = new Purchase();
	            p.setOrderNo(rset.getString("ORDER_NO"));
	            p.setProductNo(rset.getString("PRODUCT_NO"));
	            p.setSellerMemberNo(rset.getString("SELLER_MEMBER_NO"));
	            p.setBuyerMemberNo(rset.getString("BUYER_MEMBER_NO"));
	            p.setDeliveryAddr(rset.getString("DELIVERY_ADDR"));
	            p.setDeliveryFee(rset.getInt("DELIVERY_FEE"));
	            p.setOrderAmount(rset.getInt("ORDER_AMOUNT"));
	            p.setPgProvider(rset.getString("PG_PROVIDER"));
	            p.setPgTransactionId(rset.getString("PG_TRANSACTION_ID"));
	            p.setDealDate(rset.getDate("DEAL_DATE"));
	            p.setPurchaseStatusCode(rset.getString("PURCHASE_STATUS_CODE"));

	            // 조인된 추가 정보 설정 
	            p.setProductName(rset.getString("PRODUCT_NAME"));
	            p.setProductPrice(rset.getInt("PRODUCT_PRICE")); // 상품 원가
	            p.setSellerNickname(rset.getString("SELLER_NICKNAME"));
	            p.setPurchaseStatusName(rset.getString("PURCHASE_STATUS_NAME"));
	            p.setThumbnailPath(rset.getString("THUMBNAIL_PATH"));

	            list.add(p);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        JDBCTemplate.close(rset);
	        JDBCTemplate.close(pstmt);
	    }
	    return list;
	}
	
	
	
	
}
