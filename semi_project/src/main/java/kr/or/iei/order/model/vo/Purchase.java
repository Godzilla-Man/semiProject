package kr.or.iei.order.model.vo;



import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class Purchase {
	private String orderNo; // 주문 번호 O + yymmdd + 0001 형식 (orderId 등)
	private String productNo; // 상품 번호
	private String sellerMemberNo; // 판매자 번호
	private String buyerMemberNo; // 구매자 번호
	private String deliveryAddr; // 주소
	private int deliveryFee; // 배송비
	private int orderAmount; // 총 구매 금액
	private String pgProvider; // PG 정보
	private String pgTransactionId; // PG 거래 ID 
	private Date dealDate; // 거래 일시
	private String purchaseStatusCode; // 주문 상태 코드
}
