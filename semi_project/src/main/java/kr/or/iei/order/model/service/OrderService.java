package kr.or.iei.order.model.service;

import java.sql.Connection;
import java.util.Date;
import java.util.List;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.dao.FileDao;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.order.model.dao.OrderDao;
import kr.or.iei.order.model.vo.Purchase;
import kr.or.iei.product.model.dao.ProductDao;
import kr.or.iei.product.model.vo.Product;

public class OrderService {
	
	private OrderDao dao;
	private ProductDao productDao;
	private FileDao filedao;
	
	public OrderService() {
		dao = new OrderDao();	
		this.productDao = new ProductDao();
		this.filedao = new FileDao();
	}

	public Product selectOrderProduct(String productId) {
		Connection conn = JDBCTemplate.getConnection();
		Product p = dao.selectOrderProduct(conn, productId);		
		
        String thumbnailPath = filedao.selectThumbnail(conn, productId);
        p.setThumbnailPath(thumbnailPath);
		
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

	public Purchase processSuccessPay(String orderId, String paymentKey, String pgProvider, int paidAmount) {
		Connection conn = JDBCTemplate.getConnection();
		Purchase purchase = null;
		int purchaseUpdateResult = 0;
		int productUpdateResult = 0;
		
		//1. 주문 정보 조회
		purchase = OrderDao.selectOnePurchase(conn, orderId);
		
		if (purchase == null) {
            System.out.println("OrderService: 주문 정보를 찾을 수 없습니다. orderId: " + orderId);
            JDBCTemplate.rollback(conn); // 주문 정보 없으면 롤백
            return null;
        }
		
		// 2. 보안 검사: 실제 결제된 금액과 주문 금액이 일치하는지 확인
        if (purchase.getOrderAmount() != paidAmount) {
            System.out.println("OrderService: 주문 금액 불일치. orderId: " + orderId +
                               ". 예상 금액: " + purchase.getOrderAmount() + ", 실제 결제 금액: " + paidAmount);
            // 보안 문제 또는 사기 시도로 기록할 수 있음
            JDBCTemplate.rollback(conn);
            return null; // 또는 특정 예외 발생
        }
        
        // 3. tbl_purchase 업데이트(pg정보, 결제 완료 상태 'ps01')  
        purchaseUpdateResult = OrderDao.updatePurcahseStatusInfo(conn, orderId, pgProvider, paymentKey, "PS01", paidAmount);
        
		if(purchaseUpdateResult > 0) {
			//4. tbl_prod 업데이트(상품 상태 'S02' 결제 완료, 상품 수량 0으로 변경)
			productUpdateResult = ProductDao.updateProductStatusQuantity(conn, purchase.getProductNo(), "S02", 0);
			
		}
		
		//5. 모든 db 업데이트 성공 시 커밋, 하나라도 실패 시 롤백
		if (purchaseUpdateResult > 0 && productUpdateResult > 0) {
            JDBCTemplate.commit(conn);
            // 반환할 Purchase 객체에 업데이트된 정보 반영
            purchase.setPgProvider(pgProvider);
            purchase.setPgTransactionId(paymentKey);
            purchase.setPurchaseStatusCode("PS01");
        } else {
            System.out.println("OrderService: DB 업데이트 실패. 구매 업데이트 결과: " + purchaseUpdateResult + ", 상품 업데이트 결과: " + productUpdateResult);
            JDBCTemplate.rollback(conn);
            purchase = null; // 실패 표시
        }
		
		JDBCTemplate.close(conn);
		
		return purchase;
	}

	public Purchase getPurchaseDetails(String orderId) {
		Connection conn = JDBCTemplate.getConnection();
        Purchase purchase = OrderDao.selectOnePurchase(conn, orderId);
        JDBCTemplate.close(conn);
        return purchase;	
	}

	public boolean OrderCancel(String orderId, String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		boolean result = false;
		int updatePurchaseStatus = 0;
		int updateProductQuantity = 0;
		
		//1. 주문 정보 확인(취소 처리 하는데 문제 없는지. 본인? 취소 가능 상태?)
		Purchase purchase = dao.selectOnePurchaseCancel(conn, orderId, memberNo);
		
		if(purchase != null && "PS01".equals(purchase.getPurchaseStatusCode())) { //purchse 스테이터스가 결제완료(PS01) 상태일 때만 취소 가능!!
			//PS01 결제 완료 상태를 -> PS04 취소 완료 상태로 변환! 진행
			updatePurchaseStatus = dao.updateOrderStatus(conn, orderId, "PS04");
			
			if(updatePurchaseStatus > 0) {
				//Product Dao에상품 수량 및 상태 업데이트 진행
				updateProductQuantity = ProductDao.updateProductStatusAndQuantity(conn, purchase.getProductNo(), "S01", 1);
			}
			
			if(updatePurchaseStatus > 0 && updateProductQuantity > 0) {
				/*
			//PG사 결제 취소 API 호출 로직		
            boolean pgCancelSuccess = callPgCancelApi(purchase.getPgTransactionId(), purchase.getOrderAmount());
	            if (pgCancelSuccess) {            	
	                JDBCTemplate.commit(conn);
	                result = true;
	            } else {
	                JDBCTemplate.rollback(conn);
	                System.out.println("PG사 결제 취소 실패 - orderId: " + orderId);
	            }
				 */
				JDBCTemplate.commit(conn);
				result = true;
			} else {
				JDBCTemplate.rollback(conn);
				System.out.println("OrderService : 주문 취소 DB 처리 실패 - orderId: " + orderId);
			}
		} else {
			System.out.println("OrderService: 주문 취소 불가 상태이거나 권한 없음 - orderId: " + orderId);
		}
		
		JDBCTemplate.close(conn);
			
		return result;
	}
	
	// 구매내역 정보를 추출하기 위한 service 메소드!!
	public List<Purchase> getPurchaseListByBuyer(String buyerMemberNo) {
	    Connection conn = JDBCTemplate.getConnection();	    
	    List<Purchase> purchaseList = dao.selectPurchaseListByBuyerNo(conn, buyerMemberNo);
	    JDBCTemplate.close(conn);
	    return purchaseList;
	}

}
