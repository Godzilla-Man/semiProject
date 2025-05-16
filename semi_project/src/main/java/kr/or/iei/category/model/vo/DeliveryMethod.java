package kr.or.iei.category.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 배송 방법 VO 클래스
 * - TBL_DELIVERY_FEE 테이블과 매핑됨
 * - 배송 코드(M1, M2, M3)와 해당 방식의 이름을 저장
 * - ex) M1: 배송비 포함, M2: 미포함, M3: 착불
 */

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DeliveryMethod {

    private String tradeMethodCode;   // 배송 방식 코드 (M1, M2, M3)
    private String tradeMethodName;   // 배송 방식 명칭 (배송비 포함, 착불 등)

}
