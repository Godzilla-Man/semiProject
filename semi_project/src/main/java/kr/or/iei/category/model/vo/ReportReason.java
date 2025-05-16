package kr.or.iei.category.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 신고 사유 VO 클래스
 * - TBL_REPORT 테이블과 매핑됨
 * - 신고 코드(RE1 ~ RE4 등)와 해당 사유 명칭을 저장
 * - ex) RE1: 저작권 침해, RE3: 거래 금지 품목 등
 */

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReportReason {

    private String reportCode;     // 신고 사유 코드 (RE1, RE2, RE3, ...)
    private String reportReason;   // 신고 사유 내용 (저작권 침해, 상표권 침해 등)

}
