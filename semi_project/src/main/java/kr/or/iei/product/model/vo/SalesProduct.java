package kr.or.iei.product.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class SalesProduct {

	private String productNo;
    private String productName;
    private int productPrice;
    private Date enrollDate;
    private String productStatusCode;  // 상품 자체의 상태 코드
    private String productStatusName;  // 상품 상태명
    private String thumbnailPath;

    // 판매 관련 정보 (판매된 경우에만 값이 있음)
    private String orderNo;
    private Date purchaseDealDate;     // 실제 거래(결제)일
    private String buyerNickname;
    private String transactionStatusCode; // 실제 거래의 상태 코드 (예: 배송중, 배송완료)
    private String transactionStatusName; // 실제 거래의 상태명

}
