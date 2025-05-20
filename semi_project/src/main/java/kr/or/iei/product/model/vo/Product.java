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
    private String wishYn;				//찜하기 여부

    // 25-05-20 이후로 추가된 속성
    private String productStatus;      // 상품판매상태 (임시저장, 이후 삭제 예정)
    private int wishlistCount;         // 찜 횟수 (JSP 출력용)
    private String priceOfferYn;	   // 가격 제안 여부 ('Y' 또는 'N')
    private String thumbnailPath;	   // 제품 대표 썸네일 ( 등록 당시 첫번째 사진 )
    private int productQuantity;	   // 상품 수량(1 : 판매 가능/ 0 : 불가)

}
