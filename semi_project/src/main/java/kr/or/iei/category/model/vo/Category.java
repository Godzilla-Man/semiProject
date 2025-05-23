package kr.or.iei.category.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 상품 카테고리 VO 클래스
 * - TBL_PROD_CATEGORY 테이블과 매핑됨
 * - 대/중/소 카테고리 구성을 위해 사용
 * - parCategoryCode가 A이면 대분류, B코드면 중분류, C코드면 소분류
 */

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Category {

    private String categoryCode;      // 카테고리 코드 (A01~C48 등, PK)
    private String categoryName;      // 카테고리 이름 (ex. '남성 아우터', '반바지')
    private String parCategoryCode;   // 상위 카테고리 코드 (null이면 대분류)

    private String midCategoryName;	  // 중분류명
    private String larCategoryName;   // 대분류명
}
