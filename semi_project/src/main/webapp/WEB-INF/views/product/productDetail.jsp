<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 상세</title>
    <link rel="stylesheet" href="/resources/css/default.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
<style>
/* 메인 콘텐츠 전체 중앙 정렬 */
main.container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 30px 20px;
}

/* 상품 상단 레이아웃 */
.product-top {
  display: flex;
  gap: 30px;
  align-items: flex-start;
  position: relative;
}

/* 상품 이미지 박스 */
.product-image-box {
  position: relative;
  width: 350px;
  height: 300px;
  border: 1px solid var(--line2);
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 10px; /* 인디케이터와 간격 확보 */
}

/*  이미지 + 인디케이터 전체를 세로 정렬하는 컨테이너 */
.image-section {
  display: flex;
  flex-direction: column;
  align-items: center;
}

/* 슬라이드 버튼 */
.slide-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  color: var(--gray4);
  font-size: 24px;
}
.slide-btn.left {
  left: 10px;
}
.slide-btn.right {
  right: 10px;
}

/* 슬라이드 인디케이터 영역 */
.image-indicators {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
  margin-top: 5px;
}

/* 각 인디케이터 원 */
.image-indicators .dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background-color: var(--gray5); /* 비활성 상태 색 */
  transition: background-color 0.3s;
}

/* 활성된 인디케이터 원 */
.image-indicators .dot.active {
  background-color: var(--main2); /* 선택된 이미지 강조 색 */
}



/* 상품 정보 요약 영역 */
.product-summary {
  flex: 1;
  min-width: 420px;
  margin-left: 100px;
  padding-top: 10px;
}

/* 판매중 배지 */
.product-status {
  font-size: 15px;
  color: #fff;
  background-color: #ff5c5c;
  display: inline-block;
  padding: 5px 12px;
  border-radius: 12px;
  margin-bottom: 15px;
}

/* 상품명 */
.product-title {
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 16px;
}

/* 가격 */
.product-price {
  font-size: 55px;
  color: var(--main2);
  font-family: ns-b;
  margin-bottom: 16px;
}

/* 상품 메타 정보 */
.product-meta {
  font-size: 16px;
  color: var(--gray3);
  margin-bottom: 25px;
}

/* 버튼 공통 크기 통일 - '바로구매' 기준, 가로 넉넉히 */
.action-buttons button {
  height: 48px;
  width: 160px;
  font-size: 16px;
  font-family: ns-b;
  border-radius: 6px;
  padding: 0;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

/* 버튼 기본 색상 유지 */
.btn-primary {
  border: 1px solid var(--main3);
  background-color: var(--main3);
  color: var(--gray8);
}
.btn-primary:hover {
  background-color: rgba(101, 146, 254, 0.9);
}

.btn-secondary {
  border: 1px solid var(--gray4);
  background-color: var(--gray4);
  color: var(--gray8);
}
.btn-secondary:hover {
  background-color: rgba(143, 143, 143, 0.9);
}

.btn-warning {
  border: 1px solid #f0a500;
  background-color: #f0a500;
  color: white;
}
.btn-warning:hover {
  background-color: #e19300;
}

/* 비슷한 상품 전체 섹션 */
.related-products {
  border-top: 1px solid var(--gray6);
  border-bottom: 1px solid var(--gray6);
  padding: 30px 0;
  margin: 40px 0;
}

/* 섹션 제목 */
.related-title {
  font-size: 18px;
  font-family: ns-b;
  margin-bottom: 20px;
}

/* 상품 카드 리스트 - default의 posting-wrap 재사용 */
.related-list {
  display: flex;
  gap: 20px;
  justify-content: center; /* 가운데 정렬 */
}


/* 상품 카드 아이템 - default의 posting-item 재사용 */
.related-item {
  width: 140px;
}

/* 상품 이미지 영역 */
.related-img {
  width: 100%;
  aspect-ratio: 1 / 1;
  background-color: var(--gray7);
  border: 1px solid var(--gray5);
  display: flex;
  justify-content: center;
  align-items: center;
  color: var(--gray4);
  font-size: 14px;
}

/* 상품명 - 좌측정렬, 생략표시 */
.related-name {
  font-size: 13px;
  margin-top: 6px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: left;
}

/* 상품 설명 + 판매자 정보 영역 전체 컨테이너 */
.product-info-section {
  display: flex;
  padding: 20px 0 40px 0;  /* 상단 20px로 줄임, 하단은 그대로 유지 */
  gap: 30px;
}

/* 상품 설명 - 좌측 8 비율 */
.product-detail-box {
  flex: 8;
  text-align: center;
}

/* 상품 설명 내용 */
.product-description {
  font-size: 14px;
  color: var(--gray3);
  line-height: 1.7;
  text-align: center;
  white-space: pre-line;
}

/* 판매자 정보 박스 */
.seller-info-box {
  flex: 2;
  border-left: 1px solid var(--gray6);
  padding-left: 20px;

  display: flex;
  flex-direction: column;

  gap: 16px;              /* 간격은 자연스럽게 유지 */
  height: fit-content;    /* 안의 콘텐츠 높이에 맞춰 박스가 자동 조절됨 */
}


.seller-title {
  font-size: 16px;
  font-family: ns-b;
  margin-bottom: 10px;
}


.seller-profile {
  font-size: 13px;
  margin: 0 0 20px 0; /* 위쪽 여백 제거 */
  color: var(--gray2);
}


/* 판매자 프로필 박스 내부의 이미지 공간 */
.profile-image {
  width: 120px;          /* 대략 한글 6자 분량 */
  height: 120px;         /* 정사각형 */
  background-color: var(--gray7);
  border: 1px solid var(--gray5);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: var(--gray4);
  margin-bottom: 10px;
}


.profile-name {
  margin-bottom: 4px;
}

.product-count {
  font-size: 12px;
  color: var(--gray4);
}

/* 판매자 링크 - 하단 고정 */
.seller-links {
  font-size: 13px;
  color: var(--gray2);
  text-align: left;
  margin-top: 20px;
}

.seller-links a {
  color: var(--gray2);
  text-decoration: underline;
  cursor: pointer;
}


/* 댓글 섹션 */
.comment-write-section{
  margin-top: 40px;
  padding-top: 20px;
  border-top: 1px solid var(--gray6);
}


/* 댓글 입력창 */
.comment-input-wrap {
  display: flex;
  flex-direction: column;
  gap: 8px;
}


textarea::placeholder {
  color: var(--gray4);         /* 연한 회색 */
  font-size: 14px;
  white-space: pre-line;       /* 줄바꿈 유지 */
  text-align : center;
}

.btn-wrap {
  display: flex;
  align-items: center;
  gap: 10px;
}

/* 전체 댓글 리스트 영역 */
.comment-box-section {
  margin-top: 40px;
  padding-top: 20px;
  border-top: 1px solid var(--gray6);
}

/* 리스트 상단 헤더 (댓글 개수 + 정렬) */
.comment-box-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 8px;
  margin-bottom: 16px;
  border-bottom: 1px solid var(--gray5);
}
.comment-box-header .comment-box-sort {
  font-size: 14px;
  color: var(--gray2);
}

/* 댓글 항목 전체 */
.comment-box-item {
  display: flex;
  gap: 16px;
  border: 1px solid var(--gray6);
  padding: 20px;
  background-color: var(--gray8);
  margin-bottom: 16px;
}

/* 프로필 영역 */
.comment-box-profile {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  width: 80px;
  flex-shrink: 0;
  font-size: 13px;
  color: var(--gray4);
}
.profile-image {
  width: 60px;
  height: 60px;
  background-color: var(--gray7);
  border: 1px solid var(--gray5);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  margin-bottom: 6px;
}
.comment-box-username {
  font-family: ns-b;
  text-align: center;
}	


/* 본문 전체 */
.comment-box-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}


/* 댓글 내용 박스 - 고정 크기 */
.comment-box-content-fixed {
  background-color: var(--gray7);
  border: 1px solid var(--gray5);
  border-radius: 4px;
  padding: 12px 14px;
  font-size: 14px;
  color: var(--gray1);
  height: 100px;              /* 고정 높이 */
  overflow-y: auto;           /* 내용 넘칠 경우 스크롤 */
  line-height: 1.6;
  word-break: break-word;
}


/* 등록일자 + 버튼 행 */
.comment-box-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
}

/* 등록일자 */
.comment-box-date {
  font-size: 13px;
  color: var(--gray4);
}


/* 버튼 그룹 */
.comment-box-actions {
  display: flex;
  gap: 8px;
}

/* 답글 버튼 */
.comment-box-reply-btn {
  border: 1px solid var(--gray4);
  background-color: transparent;
  padding: 4px 10px;
  font-size: 13px;
  border-radius: 5px;
  cursor: pointer;
}

/* 신고 버튼 */
.comment-box-report-btn {
  border: none;
  background: none;
  color: var(--gray4);
  font-size: 13px;
  cursor: pointer;
  display: flex;
  align-items: center;
}
.comment-box-report-btn .material-icons {
  font-size: 16px;
  margin-right: 4px;
}
/* 대댓글 입력창 전체 */
.comment-box-reply-form {
  margin-top: 12px;
  padding-left: 0;              /* 좌측 들여쓰기 제거 */
  width: 100%;                  /* 부모 기준 전체 너비 */
}


/* 등록 버튼 우측 정렬 */
.reply-submit-wrap {
  display: flex;
  justify-content: flex-end;
  margin-top: 6px;
}
.comment-textarea {
  width: 100%;
  height: 80px;
  padding: 12px;
  border: 1px solid var(--line2);
  border-radius: 4px;
  font-size: 14px;
  resize: none;
  box-sizing: border-box;
}
.comment-char-count {
  font-size: 13px;
  color: var(--gray3);
  /* margin-right: auto; → 제거 또는 아래로 교체 */
  margin-right: 6px;  /* 버튼과 살짝 여백 두고 우측 정렬되도록 */
  padding-top: 6px;
}

.comment-submit-wrap {
  display: flex;
  justify-content: flex-end;   /* 등록 버튼 + 카운트 모두 우측 정렬 */
  align-items: center;
  gap: 10px;
}

.comment-box-replies {
  margin-top: 16px;
  padding-left: 30px;
  border-left: 2px solid var(--gray6);
}

.comment-box-item.comment-reply {
  background-color: var(--gray7);
  border: 1px solid var(--gray5);
  padding: 16px;
  margin-bottom: 12px;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.04);
}

.comment-box-item.comment-reply .comment-box-content-fixed {
  background-color: var(--gray8);
}

</style>

    
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="container">
		<br>
<!-- 상품 상단 영역 전체 컨테이너 -->
<section class="product-top">

  <!-- 좌측 - 이미지 전체 묶음 (이미지 + 인디케이터 포함) -->
  <div class="image-section">

    <!-- 상품 이미지 박스 + 슬라이드 버튼 포함 컨테이너 -->
    <div class="product-image-box">

      <!-- 좌측 슬라이드 버튼 -->
      <button class="slide-btn left material-icons">chevron_left</button>

      <!-- 현재 보여지는 메인 이미지 -->
      <img src="/resources/images/sample.png" alt="상품 이미지" id="mainImage" />

      <!-- 우측 슬라이드 버튼 -->
      <button class="slide-btn right material-icons">chevron_right</button>
    </div>

    <!-- 이미지 인디케이터 (●●●○○ 등) -->
    <div class="image-indicators"></div>

  </div>

  <!-- 우측 - 상품 정보 요약 영역 -->
  <div class="product-summary">
    <div class="product-status">판매중</div>
    <h2 class="product-title">상품명 예시</h2>
    <p class="product-price">₩120,000</p>
    <div class="product-meta">
      <span>찜 <strong>23</strong></span> |
      <span>조회수 <strong>145</strong></span> |
      <span>등록일 <strong>2025.05.14</strong></span>
    </div>

    <div class="action-buttons" style="display: flex; gap: 10px; align-items: center;">
      <button class="btn-secondary outline">찜하기</button>
      <button class="btn-warning">신고하기</button>
      <button class="btn-primary">바로구매</button>
    </div>
  </div>
</section>




<!-- 비슷한 상품 추천 영역 -->
<section class="related-products">
  <h3 class="related-title">비슷한 상품을 찾아보세요</h3>
  
  <div class="related-list">
    <!-- 샘플 상품 6개 반복 -->
    <div class="related-item">
      <div class="related-img">상품 이미지</div>
      <p class="related-name">상품제목 좌측정렬....</p>
    </div>
    <div class="related-item">
      <div class="related-img">상품 이미지</div>
      <p class="related-name">상품제목 좌측정렬....</p>
    </div>
    <div class="related-item">
      <div class="related-img">상품 이미지</div>
      <p class="related-name">상품제목 좌측정렬....</p>
    </div>
    <div class="related-item">
      <div class="related-img">상품 이미지</div>
      <p class="related-name">상품제목 좌측정렬....</p>
    </div>
    <div class="related-item">
      <div class="related-img">상품 이미지</div>
      <p class="related-name">상품제목 좌측정렬....</p>
    </div>
        <div class="related-item">
      <div class="related-img">상품 이미지</div>
      <p class="related-name">상품제목 좌측정렬....</p>
    </div>
  </div>
</section>
<!-- 백엔드가 아직 구현이 안되서, 사진 파일로 대체. -->
<%-- 이후 c:foreach 를 사용해서 상품 연동 가능 ( 예정 ) --%>


<!-- 상품 정보 + 판매자 정보 섹션 -->
<section class="product-info-section">

  <!-- 좌측: 상품 설명 영역 -->
  <div class="product-detail-box">
    <h3 class="section-title">상품 정보</h3>

    <!-- 상품 설명 내용 - 나중에 서버에서 데이터를 주입할 예정 -->
    <div id="productDescription" class="product-description">
      <!-- 상품 설명이 이 영역에 동적으로 삽입될 예정 -->
            상품의 상태, 사용 기간, 구성품, 하자 유무 등을 구체적으로 기재해 주시기 바랍니다.
      구매에 도움이 될 수 있는 상세 정보(사이즈, 사용감 등)를 성실히 작성해 주세요.
      개인정보 입력(전화번호, 계좌번호, SNS 등)은 제한될 수 있으니 유의해 주세요.
	<br>
      상품에 알레르기 요소, 반려동물 접촉, 흡연 환경 노출 여부, 특수 오염 내역 등
      일반적인 사용 정보 외의 구매자가 꼭 알아야 할 특이사항이 있다면 작성해 주세요.
      구매 후 분쟁 예방에 도움이 될 수 있습니다.
    </div>
  </div>

  <!-- 우측: 판매자 정보 영역 -->
  <aside class="seller-info-box">
    <div class="seller-title">판매자 정보</div>

<div class="seller-profile">
  <!--  정사각형 프로필 사진 공간 -->
  <div class="profile-image">판매자 프로필</div>
  <div class="profile-name"><strong>판매자 이름</strong></div>
  
  <!--  나중에 상품 수를 동적으로 삽입할 수 있도록 id 추가 -->
  <div class="product-count" id="productCount">판매중인 상품갯수: 0개</div>
</div>


    <!-- 판매자 링크 영역 - 항상 하단에 위치 -->
    <div class="seller-links">
      <a href="#">판매자의 다른 상품 보기</a><br>
      <a href="#">판매자 후기 작성하기</a>
    </div>
  </aside>
</section>



<!-- 댓글 입력 영역 -->
<section class="comment-write-section section">
  <h3 class="section-title" style="margin-bottom: 14px;">댓글 작성하기</h3>

  <!-- 댓글 작성 form -->
  <form action="/product/insertComment" method="post" class="comment-form">
    <input type="hidden" name="productRef" value="${product.prodNo}" />
    <input type="hidden" name="commentWriter" value="${loginMember.memberNo}" />

    <!-- 댓글 입력 전체 영역 -->
    <div class="comment-input-wrap">
      
      <!-- 댓글 입력창 -->
      <textarea
        class="comment-textarea"
        name="commentContent"
        maxlength="500"
        placeholder="댓글 작성 시 타인에게 불쾌감을 줄 수 있는 비방, 욕설, 개인정보 노출은 삼가주시기 바랍니다.
부적절한 내용은 사전 경고 없이 삭제될 수 있으며, 반복 시 이용이 제한될 수 있습니다.
거래와 무관한 광고성 댓글은 금지되며, 신고 대상이 될 수 있습니다."></textarea>

      <!-- 글자 수 + 등록 버튼 -->
      <div class="comment-submit-wrap">
        <div class="btn-wrap">
          <span class="comment-char-count"><span class="current-count">0</span> / 500</span>
          <button type="submit" class="btn-primary sm">등록</button>
        </div>
      </div>
    </div>
  </form>
</section>

<!-- 전체 댓글 영역 시작 -->
<section class="comment-box-section section">

  <!-- 댓글 헤더 전체 개수 + 정렬 옵션 -->
  <div class="comment-box-header">
    <h3 class="section-title">전체 댓글 (<span>3</span>개)</h3>
    <div class="comment-box-sort">정렬 : <strong>최신순</strong></div>
  </div>

  <!-- 댓글 1개 항목 시작 -->
  <div class="comment-box-item">

    <!-- 좌측: 프로필 이미지 + 사용자명 -->
    <div class="comment-box-profile">
      <div class="profile-image">A</div>
      <div class="comment-box-username">홍길동</div>
    </div>

    <!-- 우측: 댓글 본문 -->
    <div class="comment-box-body">

      <!-- 본문 내용 박스 -->
      <div class="comment-box-content-fixed">
        이 상품 괜찮아 보이네요. 상태는 어떤가요?
      </div>

      <!-- 하단: 등록일자 + 버튼 -->
      <div class="comment-box-footer">
        <span class="comment-box-date">2025-05-15</span>
        <div class="comment-box-actions">
          <button class="comment-box-reply-btn" onclick="toggleReplyForm(this)">답글</button>
          <button class="comment-box-report-btn">
            <span class="material-icons">block</span>신고하기
          </button>
        </div>
      </div>

      <!-- 답글 입력창: 클릭 시 펼쳐지는 영역 -->
      <div class="comment-box-reply-form" style="display: none;">
        <textarea class="comment-textarea" maxlength="500" placeholder="댓글 작성 시 타인에게 불쾌감을 줄 수 있는 비방, 욕설, 개인정보 노출은 삼가주시기 바랍니다.
부적절한 내용은 사전 경고 없이 삭제될 수 있으며, 반복 시 이용이 제한될 수 있습니다.
거래와 무관한 광고성 댓글은 금지되며, 신고 대상이 될 수 있습니다."></textarea>

        <!-- 글자 수 카운트 + 등록 버튼 -->
        <div class="comment-submit-wrap">
          <span class="comment-char-count"><span class="current-count">0</span> / 500</span>
          <button type="button" class="btn-primary sm">등록</button>
        </div>
      </div>

      <!-- 대댓글 목록 (예시) -->
      <div class="comment-box-replies">

        <!-- 대댓글 1 -->
        <div class="comment-box-item comment-reply">
          <div class="comment-box-profile">
            <div class="profile-image">판매</div>
            <div class="comment-box-username">판매자</div>
          </div>
          <div class="comment-box-body">
            <div class="comment-box-content-fixed">
              사용감 거의 없고 깨끗합니다 :)
            </div>
            <div class="comment-box-footer">
              <span class="comment-box-date">2025-05-15</span>
              <div class="comment-box-actions">
                <button class="comment-box-report-btn">
                  <span class="material-icons">block</span>신고하기
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- 대댓글 2 -->
        <div class="comment-box-item comment-reply">
          <div class="comment-box-profile">
            <div class="profile-image">C</div>
            <div class="comment-box-username">유저123</div>
          </div>
          <div class="comment-box-body">
            <div class="comment-box-content-fixed">
              저도 여기서 샀는데 만족했어요!
            </div>
            <div class="comment-box-footer">
              <span class="comment-box-date">2025-05-15</span>
              <div class="comment-box-actions">
                <button class="comment-box-report-btn">
                  <span class="material-icons">block</span>신고하기
                </button>
              </div>
            </div>
          </div>
        </div>

      </div> <!-- .comment-box-replies -->

    </div> <!-- .comment-box-body -->

  </div> <!-- .comment-box-item -->

</section>


    </main>
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
    
 <script>
 
// 이미지 슬라이더 기능 함수
// [1] 이미지 배열 정의 (샘플 이미지 경로들)
const images = [
  "/resources/images/sample1.jpg",
  "/resources/images/sample2.jpg",
  "/resources/images/sample3.jpg",
  "/resources/images/sample4.jpg",
  "/resources/images/sample5.jpg",
  "/resources/images/sample6.jpg",
  "/resources/images/sample7.jpg"
];

// [2] 현재 인덱스를 기억할 변수
let currentIndex = 0;

// [3] DOM 요소 선택
const mainImage = document.getElementById("mainImage");
const indicatorsContainer = document.querySelector(".image-indicators");
const prevBtn = document.querySelector(".slide-btn.left");
const nextBtn = document.querySelector(".slide-btn.right");

let indicatorDots = []; // 동적으로 생성되는 dot들 참조용

// [4] 인디케이터(dot) 생성 함수
function renderIndicators() {
  indicatorsContainer.innerHTML = ""; // 초기화

  images.forEach((_, index) => {
    const dot = document.createElement("span");
    dot.classList.add("dot");
    if (index === currentIndex) dot.classList.add("active");

    // [추가 기능] 클릭 시 해당 이미지로 이동
    dot.addEventListener("click", () => {
      currentIndex = index;
      updateSlider();
    });

    indicatorsContainer.appendChild(dot);
    indicatorDots.push(dot);
  });
}

// [5] 슬라이더 갱신 함수
function updateSlider() {
  // 이미지 변경
  mainImage.src = images[currentIndex];

  // 인디케이터 갱신
  indicatorDots.forEach((dot, idx) => {
    dot.classList.toggle("active", idx === currentIndex);
  });
}

// [6] 좌우 버튼 클릭 이벤트
prevBtn.addEventListener("click", () => {
  currentIndex = (currentIndex - 1 + images.length) % images.length;
  updateSlider();
});
nextBtn.addEventListener("click", () => {
  currentIndex = (currentIndex + 1) % images.length;
  updateSlider();
});

// [7] 초기 세팅
renderIndicators();
updateSlider();
</script>

<script>
// 댓글 입력창에서 글자 수 실시간 카운팅 함수
document.addEventListener('DOMContentLoaded', () => {
  const textareas = document.querySelectorAll('.comment-textarea');

  textareas.forEach(textarea => {
    const countSpan = textarea
      .closest('.comment-input-wrap, .comment-box-reply-form')
      .querySelector('.current-count');

    if (countSpan) {
      textarea.addEventListener('input', () => {
        countSpan.textContent = textarea.value.length;
      });
    }
  });
});
</script>


<script>
// 답글버튼 토글 기능 함수
  function toggleReplyForm(button) {
    const commentItem = button.closest('.comment-box-item');
    const replyForm = commentItem.querySelector('.comment-box-reply-form');
    replyForm.style.display = (replyForm.style.display === 'none') ? 'block' : 'none';
  }
</script>

</body>
</html>
