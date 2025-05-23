<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
		  overflow: hidden;
		  background-color: var(--gray6);
		  display: flex;
		  justify-content: center;
		  align-items: center;
		}
		
		.seller-profile-img img {
		  width: 100%;
		  height: 100%;
		  object-fit: cover;
		  display: block;
		}

        .seller-profile-right {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

		/* 닉네임 (타이틀) */
		.seller-info-title {
		    font-family: ns-b;
		    font-size: 22px;   /* 기존 18px → 강조 */
		    margin-bottom: 12px;
		    color: #222;
		}

		.seller-rating {
		    display: flex;
		    justify-content: flex-end;
		    align-items: center;
		    gap: 30px;
		    font-size: 16px;
		    text-align: right;
		}
		
		/* 좋아요/싫어요/신고 영역 */
			.reaction-btn {
			    background-color: transparent;   /* 배경 투명 */
			    border: none;                   /* 테두리 제거 */
			    border-radius: 999px;           /* 완전한 둥근 버튼 */
			    padding: 6px 12px;              /* 적당한 여백 */
			    font-size: 18px;                /* 글자 크기 */
			    font-weight: bold;
			    cursor: pointer;
			    transition: all 0.2s ease;
			    display: inline-flex;
			    align-items: center;
			    gap: 6px;
			    color: #333;                    /* 기본 텍스트 색상 */
			}
		
			.reaction-btn:hover {
	    background-color: rgba(0, 0, 0, 0.05);  /* 살짝 음영 강조 */
	    transform: scale(1.05);
	}

		.reaction-count.like {
		    color: #3A8BE0; /* 연한 파란색 */
		}
		
		.reaction-count.dislike {
		    color: #FF6B6B; /* 연한 붉은색 */
		}
		

		/* 상품 개수 보기 영역 */
        .product-count-section {
            padding: 25px 30px;
            border-bottom: 1px solid var(--line2);
            background-color: var(--gray8);
            font-size: 16px;
        }

        .product-count-section .count {
        	all: unset; /* 모든 상속 스타일 제거 */
            color: var(--main2);
            font-weight: bold;
            font-size: 20px;
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
	    display: none !important;
	    
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

		.posting-wrap > .posting-item {
		  width: 300px;                 /* 가로 너비 확대 */
		  min-height: 460px;           /* 세로 높이 확보 */
		  box-sizing: border-box;
		  padding: 30px 25px;          /* 상하는 여유, 좌우는 적당히 */
		  background-color: var(--gray8);
		  border: 1px solid var(--gray5);     /* 기존보다 연하고 얇게 */
		  border-radius: 12px;                /* 부드러운 둥근 테두리 */
		  border: 1px solid var(--line2);
		  display: flex;
		  flex-direction: column;
		  justify-content: flex-start;
		  transition: all 0.2s ease;   /* 애니메이션 부드럽게 */
		}


		 /* 더보기 버튼 설정 */
		#moreBtn {
		  width: 400px;                       /* 가로 너비 넓힘 */
		  padding: 20px 20px;                 /* 세로 방향 패딩 증가 */
		  font-size: 25px;                    /* 텍스트 조금 키움 */
		  border-radius: 10px;                /* 모서리 둥글게 */
		  display: inline-flex;
		  align-items: center;
		  justify-content: center;
		  gap: 6px;
		
		  background-color: #A7C8F2;          /* 파스텔톤 파란색 */
		  color: #fff;                        /* 흰색 텍스트 */
		  border: none;
		  font-weight: bold;
		  cursor: pointer;
		  transition: background-color 0.2s ease;
		}
		
		#moreBtn:hover {
		  background-color: #90B9ED;          /* hover 시 더 진한 파랑 */
		}

		
		/* 상품 정보 전체를 세로 배치 */
		.posting-info {
		  display: flex;
		  flex-direction: column;
		  gap: 6px;
		  align-items: flex-start; /* 좌측 정렬 */
		  padding-left: 2px;       /* 살짝 더 붙이기 */
		}

		/* 가격 스타일 */
		.price-highlight {
		  font-size: 25px !important; /* 크기 키움 */
		  font-weight: bold;
		  color: #3A8BE0;  /* 연한 파란색 */
		  white-space: nowrap;
		}
		
		/* 배송비 정보 스타일 - 연한 회색 */
		.product-delivery-text {
		  font-size: 13px;
		  color: var(--gray4);
		}

		/* 썸네일 박스 */
		.posting-img-wrap {
		  width: 100%;
		  height: 300px;
		  overflow: hidden;
		  background-color: var(--gray7);
		  border-radius: 6px;
		  margin-bottom: 16px;
		}
		
		.posting-img-wrap img {
		  width: 100%;
		  height: 100%;
		  object-fit: cover;
		}
	
		.posting-title {
		  font-size: 16px;
		  font-weight: 600;
		  color: #222;
		}
		
		.posting-sub-info {
		  font-size: 15px;
		  color: #333;
		}
		
		.posting-date {
		  font-size: 12px;
		  color: var(--gray4);
		  text-align: right;
		  margin-top: auto;
		  align-self: flex-end;
		}
		
		/* 상품목록에 마우스를 올릴 경우 음영 효과 추가 */
		.posting-item:hover {
		  transform: scale(1.03);             /* 살짝 확대 */
		  box-shadow: 0 6px 24px rgba(100, 160, 230, 0.25); /* 그림자 강화 */
		  border: 1px solid var(--main2);     /* 강조 테두리 유지 */
		  z-index: 1;                          /* 겹침 우선순위 ↑ */
		}
		
		/* 등록일 + 배송비를 우측 하단에 나란히 표시 */
		.posting-meta-bottom {
		  display: flex;
		  justify-content: flex-end;
		  gap: 12px;
		  margin-top: auto;
		  width: 100%;
		}
		
		/* 배송비 표시 */
		.delivery-label {
		  font-size: 14px;
		  color: var(--gray4);
		  white-space: nowrap;
		}
		
		/* 등록일 표시 */
		.date-label {
		  font-size: 14px;           /* 크기 키움 */
		  color: var(--gray4);
		  white-space: nowrap;
		}
    </style>
</head>
<body>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
            <div class="wrap">
        <main class="content">
            <!-- 판매자 프로필 상단 -->
            <section class="seller-profile-wrap">
                <div class="seller-profile-left">
					<c:set var="profileImg" value="${empty seller.profileImgPath ? '/resources/images/default.jpg' : seller.profileImgPath}" />
					<div class="seller-profile-img">
					  <img src="${profileImg}" alt="프로필 이미지" />
					</div>
                </div>
                <div class="seller-profile-right">
                    <div>
						<div class="seller-info-title">${seller.memberNickname}</div>
						<ul class="seller-info-list">
						  <li>회원가입일 : ${fn:substring(seller.join_date, 0, 10)}</li>
						  <li>거래 완료 횟수 : ${salesCount}회</li>
						</ul>
                    </div>
						<div class="seller-rating">
						    <c:choose>
						        <c:when test="${not empty sessionScope.loginMember}">
						            <span class="reaction-box">
						                <button type="button" class="reaction-btn" data-type="L" data-target="${seller.memberNo}">
						                    👍 <span class="reaction-count like" id="likeCount">좋아요 ${likeCount}</span>
						                </button>
						            </span>
						            <span class="reaction-box">
						                <button type="button" class="reaction-btn" data-type="D" data-target="${seller.memberNo}">
						                    👎 <span class="reaction-count dislike" id="dislikeCount">싫어요 ${dislikeCount}</span>
						                </button>
						            </span>
						        </c:when>
						        <c:otherwise>
						            <span class="reaction-disabled-text" style="font-size: 14px; color: var(--gray3); margin-right: auto;">
						                로그인 후 좋아요 / 싫어요를 누를 수 있습니다.
						            </span>
						        </c:otherwise>
						    </c:choose>
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
    <%-- case 1: 상품이 없는 경우 --%>
    <c:when test="${empty productList}">
      <div class="no-product-box">현재 판매중인 상품이 없습니다.</div>
    </c:when>
    <%-- case 2: 상품이 있는 경우 반복 출력 --%>
    <c:otherwise>
      <div class="posting-wrap" id="productContainer">
      
<c:forEach var="prod" items="${productList}" varStatus="status">
  <c:if test="${prod.statusCode ne 'S99'}">
    <div class="${status.index >= 9 ? 'posting-item hidden-product' : 'posting-item'}">
      <a href="/product/detail?no=${prod.productNo}">
        <div class="posting-img-wrap">
          <img src="${empty prod.thumbnailPath ? '/upload/product/default.jpg' : prod.thumbnailPath}" alt="상품 이미지">
        </div>
        <div class="posting-info">
          <div class="posting-title">${prod.productName}</div>
          <div class="posting-sub-info">
            <span class="price-highlight">
              ₩<fmt:formatNumber value="${prod.productPrice}" pattern="#,###"/>
            </span>
          </div>
          <div class="posting-meta-bottom">
            <span class="delivery-label">
              <c:choose>
                <c:when test="${prod.tradeMethodCode eq 'M1'}">배송비 포함</c:when>
                <c:otherwise>배송비 별도</c:otherwise>
              </c:choose>
            </span>
            <span class="date-label">
              <fmt:formatDate value="${prod.enrollDate}" pattern="yy-MM-dd"/>
            </span>
          </div>
        </div>
      </a>
    </div>
  </c:if>
</c:forEach>


      </div>
      
      <%-- 상품 개수가 9개 초과일 경우 '더보기' 버튼 노출 --%>
		<c:if test="${fn:length(productList) > 9}">
		  <div class="more-btn-area" id="moreBtnArea" style="text-align:center; margin-top:20px;">
		    <button type="button" class="btn-secondary md" id="moreBtn">
		       상품 더보기
		    </button>
		  </div>
		</c:if>
    </c:otherwise>
  </c:choose>
</section>


</main>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />


    
<script>
// 더보기 버튼을 눌렀을 때, 숨겨진 상품을 일정 개수씩 순차적으로 보여주는 기능

document.addEventListener('DOMContentLoaded', () => {
  const moreBtn = document.getElementById('moreBtn');
  if (!moreBtn) return;

  // 숨겨진 상품 요소들 수집
  let hiddenProducts = Array.from(document.querySelectorAll('.hidden-product'));
  let currentIndex = 0; // 현재까지 보여준 인덱스

  moreBtn.addEventListener('click', () => {
    const maxToShow = 9;
    let end = currentIndex + maxToShow;

    // 범위 내 요소만 표시
    for (let i = currentIndex; i < end && i < hiddenProducts.length; i++) {
      hiddenProducts[i].classList.remove('hidden-product');
      hiddenProducts[i].style.removeProperty('display');
    }

    currentIndex += maxToShow;

    // 더 이상 숨긴 상품이 없으면 버튼 숨김
    if (currentIndex >= hiddenProducts.length) {
      moreBtn.style.display = 'none';
    }
  });

  // 초기에 숨겨진 상품이 없으면 버튼 숨김
  if (hiddenProducts.length === 0) {
    moreBtn.style.display = 'none';
  }
});

</script>

<script>
document.addEventListener('DOMContentLoaded', () => {
  // 좋아요/싫어요 버튼 클릭 이벤트
  const buttons = document.querySelectorAll('.reaction-btn');

  buttons.forEach(btn => {
    btn.addEventListener('click', () => {
      const reactionType = btn.dataset.type;               // 'L' 또는 'D'
      const targetMemberNo = btn.dataset.target;           // 판매자 회원 번호

      fetch('/reaction/toggle', {
    	  method: 'POST',
    	  headers: {
    	    'Content-Type': 'application/x-www-form-urlencoded'
    	  },
    	  body: new URLSearchParams({
    		  targetMemberNo: targetMemberNo,
    		  reactionType: reactionType
    		})
    	})
    	.then(response => {
    	  if (!response.ok) {
    	    throw new Error("서버 응답 오류: " + response.status);
    	  }
    	  return response.json();
    	})
    	.then(data => {
    		document.getElementById('likeCount').textContent = '좋아요 ' + data.likeCount;
    		document.getElementById('dislikeCount').textContent = '싫어요 ' + data.dislikeCount;
    	})
    	.catch(error => {
    	  console.error("오류 발생:", error);
    	  alert("로그인이 필요하거나 서버 오류가 발생했습니다.");
    	});
    });
  });
});
</script>


    
</body>
</html>