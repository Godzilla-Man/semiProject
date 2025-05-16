package kr.or.iei.category.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 상품 상태 코드 VO 클래스
 * - TBL_PROD_STATUS 테이블과 매핑
 * - 상품의 상태(S01~S12)를 코드와 이름으로 관리
 * - ex) S01: 판매 중, S05: 배송 중, S07: 거래 완료 등
 */

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProdStatus {

    private String statusCode;   // 상태 코드 (S01 ~ S12, PK)
    private String statusName;   // 상태 이름 (판매 중, 거래 완료 등)

}
