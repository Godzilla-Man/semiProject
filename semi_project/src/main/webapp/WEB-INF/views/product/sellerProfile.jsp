<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>판매자 프로필</title>
    <link rel="stylesheet" href="/resources/css/default.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
 <style>
 		/* 판매자 정보 상단 */
        .seller-profile-wrap {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            padding: 30px;
            background-color: var(--gray8);
            border-bottom: 1px solid var(--line2);
        }

        .seller-profile-left {
            width: 200px;
            text-align: center;
        }

        .seller-profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background-color: var(--gray6);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 14px;
            color: var(--gray3);
            margin: 0 auto;
        }

        .seller-profile-right {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .seller-info-title {
            font-family: ns-b;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .seller-info-list {
            font-size: 14px;
            color: var(--gray2);
            line-height: 1.8;
        }

        .seller-rating {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 20px;
            font-size: 14px;
        }

		/* 상품 개수 보기 영역 */
        .product-count-section {
            padding: 20px 30px;
            border-bottom: 1px solid var(--line2);
            background-color: var(--gray8);
            font-size: 16px;
        }

        .product-count-section .count {
            color: var(--main2);
            font-weight: bold;
        }
		
		/* 상품 없을 때 안내 방식 */
        .no-product-box {
            height: 300px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--gray4);
            font-size: 16px;
            background-color: var(--gray8);
        }
        
        /* 숨겨지는 상품 조형 */
        .hidden-product {
	    display: none;
	    
		}
		
		/* 아이콘 정렬 */
		.more-btn-area button span.material-icons {
		    vertical-align: middle;
		    margin-right: 4px;
		}
	        
		.posting-wrap {
		  display: flex;
		  flex-wrap: wrap;
		  justify-content: center; /* 중앙 정렬 */
		  gap: 30px;
		  padding: 10px;
		}

		/* 상품 취급 역할 */
		.posting-wrap > .posting-item {
		  width: 300px; /* 너비 고정 (3개가 깔끔하게 정렬되도록) */
		  box-sizing: border-box;
		  padding: 30px;
		  background-color: var(--gray8);
		  transition: all 0.3s ease;
		}

		/* 상품목록에 마우스를 올릴 경우 음영 효과 추가 */
		.posting-item:hover {
		  box-shadow: 0 2px 10px 0 rgba(0, 0, 0, 0.2);
		}

		 /* 더보기 버튼 설정 */
		#moreBtn {
		  width: 400px;                  /* 가로 너비 넓힘 */
		  padding: 20px 20px;            /* 세로 방향 패딩 증가 */
		  font-size: 16px;               /* 텍스트 조금 키움 */
		  border-radius: 10px;           /* 모서리 둥글게 */
		  display: inline-flex;
		  align-items: center;
		  justify-content: center;
		  gap: 6px;
		}

    </style>
</head>
<body>
    <div class="wrap">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="content">
            <!-- 판매자 프로필 상단 -->
            <section class="seller-profile-wrap">
                <div class="seller-profile-left">
                    <div class="seller-profile-img">회원 프로필 사진</div>
                </div>
                <div class="seller-profile-right">
                    <div>
                        <div class="seller-info-title">판매자 닉네임</div>
                        <ul class="seller-info-list">
                            <li>회원가입일 : YYYY-MM-DD</li>
                            <li>상품 판매 횟수 : N회</li>
                        </ul>
                    </div>
                    <div class="seller-rating">
                        <span>👍 좋아요 nn</span>
                        <span>👎 싫어요 nn</span>
                        <a href="#" style="color: var(--gray4); font-size: 12px;">신고하기</a>
                    </div>
                </div>
            </section>

            <!-- 판매 중인 상품 수 -->
			<div class="product-count-section">
			    <span>현재 판매중인 상품 목록</span>
			    <span class="count">${productCount}개</span>
			</div>


<!-- 판매 상품 영역 -->
<section class="section">
  <c:choose>
  
    <%-- case 1: 상품이 하나도 없는 경우 --%>
    <c:when test="${empty productList}">
      <div class="no-product-box">현재 판매중인 상품이 없습니다.</div>
    </c:when>

    <%-- case 2: 상품이 하나 이상 존재하는 경우 --%>
    <c:otherwise>
      <div class="posting-wrap" id="productContainer">
        <c:forEach var="prod" items="${productList}" varStatus="status">
          <!-- index 9 이상부터는 숨김처리 -->
          <c:choose>
            <c:when test="${status.index >= 9}">
              <div class="posting-item hidden-product">
            </c:when>
            <c:otherwise>
              <div class="posting-item">
            </c:otherwise>
          </c:choose>
              <a href="/product/detail?no=${prod.productNo}">
                <div class="posting-img">
                  <img src="${prod.imagePath}" alt="상품 이미지">
                </div>
                <div class="posting-info">
                  <div class="posting-title">${prod.title}</div>
                  <div class="posting-sub-info">
                    <span>${prod.price}원</span>
                  </div>
                  <div class="posting-sub-info">
                    <span>
                      <c:choose>
                        <c:when test="${prod.includeShipping}">배송비 포함</c:when>
                        <c:otherwise>배송비 별도</c:otherwise>
                      </c:choose>
                    </span>
                  </div>
                </div>
              </a>
            </div>
        </c:forEach>
      </div>

      <%-- 상품 개수가 9개 초과일 경우에만 '상품 더보기' 버튼 노출 --%>
      <c:if test="${fn:length(productList) > 9}">
        <div class="more-btn-area" id="moreBtnArea" style="text-align:center; margin-top:20px;">
          <button type="button" class="btn-secondary md" id="moreBtn">
            <span class="material-icons">add_circle</span> 상품 더보기
          </button>
        </div>
      </c:if>
    </c:otherwise>
  </c:choose>
</section>

</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</div>

    
<script>
// 더보기 버튼 관련 기능 함수 ( 숨겨진 상품 점진적 표시 )

document.addEventListener('DOMContentLoaded', () => {
  // '상품 더보기' 버튼 요소
  const moreBtn = document.getElementById('moreBtn');

  // 숨겨진 상품 요소들을 배열로 수집
  const hiddenProducts = Array.from(document.querySelectorAll('.hidden-product'));

  // 현재까지 보여준 숨겨진 상품의 수
  let currentIndex = 0;

  // 더보기 버튼 클릭 시 실행
  moreBtn.addEventListener('click', () => {
    const maxToShow = 9; // 한 번에 표시할 최대 상품 수
    let shown = 0;

    // 현재 인덱스부터 최대 maxToShow개만큼 보여주기
    for (let i = currentIndex; i < hiddenProducts.length && shown < maxToShow; i++) {
      hiddenProducts[i].style.removeProperty('display'); // 기존 스타일 복원
      hiddenProducts[i].classList.remove('hidden-product'); // 클래스 제거
      shown++;
    }

    // 다음 표시를 위해 인덱스 증가
    currentIndex += shown;

    // 더 이상 숨겨진 상품이 없으면 버튼 숨김
    if (currentIndex >= hiddenProducts.length) {
      moreBtn.style.display = 'none';
    }
  });

  // 숨길 상품이 애초에 없다면 버튼도 숨김 처리
  if (hiddenProducts.length === 0) {
    moreBtn.style.display = 'none';
  }
});
</script>


    
</body>
</html>