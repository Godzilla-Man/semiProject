package kr.or.iei.product.model.vo;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class Product {
    private String productNo;          // 상품 번호 (P + yymmdd + 0001 형식)
    private String memberNo;           // 판매자 회원 번호
    private String productName;        // 상품명
    private String productIntrod;      // 상품 설명
    private int productPrice;          // 상품 가격
    private String categoryCode;       // 카테고리 코드 (소분류 CXX)
    private String tradeMethodCode;    // 배송방법 코드 (M1/M2/M3)
    private String statusCode;         // 상품 상태 코드 (S01~S12)
    private Date enrollDate;           // 등록일
    private int readCount;             // 조회수
}