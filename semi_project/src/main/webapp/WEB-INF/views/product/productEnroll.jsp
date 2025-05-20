<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>상품 등록</title>
  <link rel="stylesheet" href="/resources/css/default.css">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
 <style>
 
/* 전체 콘텐츠 중앙 정렬 */
  main.container {
    max-width: 700px;
    margin: 0 auto;
    padding: 30px 20px;
  }

  h2.section-title {
    font-size: 20px;
    font-weight: bold;
    border-bottom: 2px solid #000;
    padding-bottom: 10px;
    margin-bottom: 30px;
    text-align : center;
  }

  .form-row {
    display: flex;
    align-items: center;
    margin-bottom: 30px;
  }

  .form-label {
    width: 100px;
    font-weight: bold;
    font-size: 16px;
  }

  .product-name-input {
    width: 300px;
    height: 35px;
    font-size: 14px;
    padding: 5px 10px;
    border: 1px solid #ccc;
    border-radius: 6px;
  }

  .char-counter {
    margin-left: 10px;
    font-size: 12px;
    color: #666;
  }

  .form-input-box {
    display: flex;
    align-items: flex-start;
    gap: 20px;
  }
  

/* 상품 이미지 업로드 영역 스타일 */
/* 미리보기 이미지 박스 (이미지가 표시될 영역) */
.image-upload-box {
  width: 300px;
  height: 200px;
  border: 1px dashed #aaa;
  background-color: #fafafa;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
  position: relative;
}

/* 이미지 업로드 전체 감싸는 wrapper (슬라이드 버튼/카운터 포함) */
.image-upload-wrapper {
  position: relative;
  display: inline-block; /* absolute 요소 기준이 됨 */
}

/* 업로드된 이미지 스타일 */
.image-upload-box img,
.preview-img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  display: none; /* 선택된 이미지 외에는 감춤 */
}

/* 이미지 슬라이드 버튼 스타일 */
.slide-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  font-size: 18px;
  background: rgba(255, 255, 255, 0.5);
  border: none;
  cursor: pointer;
  padding: 4px 10px;
  opacity: 0.6;
  transition: opacity 0.2s ease-in-out;
  z-index: 10;
}

.slide-btn:hover {
  opacity: 1;
}

/* 슬라이드 버튼 위치 */
#prevBtn {
  left: 5px;
}
#nextBtn {
  right: 5px;
}


/* 이미지 수 카운터 오버레이 */

.image-count-overlay {
  position: absolute;
  right: 8px;
  bottom: 8px;
  font-size: 12px;
  background-color: rgba(128, 128, 128, 0.5); /* 기존 회색 계열로 자연스럽게 */
  color: #fff;
  padding: 2px 6px;
  border-radius: 10px;
  z-index: 9999;
  white-space: nowrap;
  pointer-events: none; /* 클릭 방해 방지 */
}


/* 이미지 업로드 외부 툴 (파일 선택 버튼 등) */

.image-tools-outside {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  align-items: flex-start;
  height: 200px;
  gap: 6px;
}

/* 파일 선택 버튼 */
.upload-btn {
  padding: 6px 10px;
  background-color: #f5f5f5;
  border: 1px solid #888;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
  display: inline-block;
}

/* 힌트 텍스트 */
.upload-hint {
  font-size: 11px;
  color: #999;
  max-width: 180px;
  text-align: left;
}

/* 숨겨진 실제 input 요소 */
.upload-btn input {
  display: none;
}



/* 전체 form-row 중에서 category-row만 위쪽 정렬 */
.form-row.category-row {
  align-items: flex-start;
}

/* 카테고리 3개 칼럼을 가로로 정렬하는 wrapper */
.form-row.category-row .category-container {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
}

/* 각 카테고리 칼럼 박스 */
.form-row.category-row .category-col {
  width: 150px;
  height: 200px;
  border: 1px solid #ccc;
  padding: 10px;
  box-sizing: border-box;
  background-color: #fff;
}

/* 리스트 항목 기본 스타일 제거 */
.form-row.category-row .category-col ul {
  list-style: none;
  margin: 0;
  padding: 0;
}

/* 각 항목 텍스트 스타일 */
.form-row.category-row .category-col li {
  cursor: pointer;
  padding: 6px 0;
  font-size: 14px;
  color: #000;
}

/* 마우스 오버 효과 */
.form-row.category-row .category-col li:hover {
  text-decoration: underline;
  color: #007acc;
}

/* 선택된 항목 강조 */
.form-row.category-row .category-col li.active {
  font-weight: bold;
  color: #d60000;
}

/* 선택 결과 표시 라벨 */
#selectedCategory {
  font-size: 14px;
  color: #d60000;
  font-weight: bold;
  margin-top: 5px;
}
/* 상품 설명 textarea + 글자 수 카운터 */
.description-box {
  position: relative;
  display: flex;
  flex-direction: column;
  width: 500px;
}

.description-box textarea {
  width: 100%;
  height: 180px;
  padding: 12px;
  font-size: 13px;
  border: 1px solid #ccc;
  border-radius: 6px;
  line-height: 1.5;
  color: #444;
  resize: none;
  font-family: 'inherit';
}

.description-box textarea::placeholder {
  color: #bbb;
  font-size: 13px;
  white-space: pre-line; /* 줄바꿈 유지 */
}

.description-count {
  margin-top: 6px;
  font-size: 12px;
  color: #888;
  text-align: right;
}
/* 가격 영역 전체 정렬 */
.form-row.price-row {
  align-items: flex-start;
}

/* 입력란 및 체크박스 등 포함할 전체 wrapper */
.price-box {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* 가격 입력 박스 + '원' 단위 */
.price-input-group {
  display: flex;
  align-items: center;
}

.price-input {
  width: 250px;
  height: 35px;
  padding: 6px 10px;
  font-size: 14px;
  border: 1px solid #ccc;
  border-radius: 6px;
}

.price-unit {
  margin-left: 8px;
  font-size: 14px;
  color: #555;
}

/* 체크박스 + 설명 문구 */
.price-option {
  font-size: 14px;
  color: #333;
}

/* 가격 안내 설명 */
.price-hint {
  margin-top: 4px;
  font-size: 12px;
  color: #999;
  line-height: 1.4;
}
/* 배송비 영역 전체 정렬 */
.form-row.delivery-row {
  align-items: flex-start;
}

/* 배송비 전체 wrapper (라디오 + 안내문 포함) */
.delivery-box {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

/* 각 라디오 버튼 항목 */
.delivery-option {
  font-size: 14px;
  color: #333;
  display: flex;
  align-items: center;
  gap: 6px;
}

/* 안내 문구 */
.delivery-hint {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
  line-height: 1.4;
}
/* 등록 버튼 행 전체 배경 및 레이아웃 */
.form-row.submit-row {
  position: relative;
  background-color: rgba(255, 192, 192, 0.2);
  padding: 40px 20px 40px 20px;
  min-height: 40px; /* 충분한 높이 확보 */
}

/* 버튼 wrapper: 위치 고정을 위해 flex 제거 + absolute 지정 */
.submit-box {
  position: absolute;
  bottom: 10px;
  right: 10px;
}

/* 등록 버튼 스타일 */
#submitBtn {
  padding: 15px 25px;
  font-size: 14px;
  color: white;
  background-color: #f8aaaa;
  border: 1px solid #f08888;
  border-radius: 5px;
  cursor: pointer;
}

#submitBtn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* 경고 메시지: 버튼 기준 좌하단에 고정 */
.submit-warning {
  position: absolute;
  right: 120px; /* 버튼에서 왼쪽으로 떨어뜨리기 */
  bottom: 10px;
  font-size: 12px;
  color: #d66;
  display: none;
}



</style>

</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">

  <form action="${editMode ? '/product/update' : '/product/enroll'}" method="post" enctype="multipart/form-data">

    <!-- 상품정보 제목 + 구분선 -->
    <h2 class="section-title">상품정보</h2>

	  <%-- 수정 모드일 경우 상품번호 hidden으로 전달 --%>
	  <c:if test="${editMode}">
	    <input type="hidden" name="productNo" value="${product.productNo}" />
	  </c:if>

  <!-- 상품명 -->
  <div class="form-row">
    <div class="form-label">상품명</div>
    <input type="text" name="productName" maxlength="30"
           placeholder="상품명을 입력하세요."
           class="product-name-input"
           value="<c:out value='${product.productName}' default=''/>"> <!-- 수정: JSTL 방식으로 안전하게 출력 -->
    <span class="char-counter" id="nameCounter">0 / 30</span>
  </div>

<!-- 상품 이미지 -->
<div class="form-row">
  <div class="form-label">상품 이미지</div>
  <div class="form-input-box">
  
    <!-- 미리보기 박스 + 좌우 화살표 포함 -->
    <div class="image-upload-wrapper" style="position: relative;">
      <div class="image-upload-box" id="imagePreviewContainer">
        <span class="placeholder-text">상품 이미지 등록</span>
      </div>
      <!-- 좌우 슬라이드 버튼 -->
      <button type="button" id="prevBtn" class="slide-btn">&#10094;</button>
      <button type="button" id="nextBtn" class="slide-btn">&#10095;</button>
      <!-- 이미지 갯수 -->
      <div id="imageCount" class="image-count-overlay">
        <span id="fileNum">0</span> / 10
      </div>
    </div>

    <div class="image-tools-outside">
      <label for="fileInput" class="upload-btn">사진 첨부하기</label>
      <input type="file" id="fileInput" name="productImages" multiple accept="image/*" style="display: none;">
      <div class="upload-hint">가장 먼저 등록한 이미지가<br>게시글 썸네일이 됩니다.</div>
    </div>
  </div>
</div>



<!-- 카테고리 선택 영역 -->
<div class="form-row category-row">
  <div class="form-label">카테고리</div>
  <div>
    <div class="category-container">
      <!-- 1단계 (대분류) -->
      <div class="category-col" id="category-level1">
        <ul>
          <li data-value="남성">1. 남성</li>
          <li data-value="여성">2. 여성</li>
          <li data-value="공용">3. 공용</li>
        </ul>
      </div>

      <!-- 2단계 (중분류) -->
      <div class="category-col" id="category-level2">
        <ul id="midCategoryList"></ul>
      </div>

      <!-- 3단계 (소분류: 동적 생성 영역) -->
      <div class="category-col" id="category-level3">
        <ul id="subCategoryList">
          <!-- JavaScript로 소분류 항목이 들어올 자리 -->
        </ul>
      </div>
    </div>

    <!--  현재 선택한 카테고리 출력 -->
    <div class="selected-category" id="selectedCategory">
      현재 설정한 카테고리:
    </div>
  </div>
</div>
<input type="hidden" name="categoryCode" id="categoryCode">




  <!-- 상품 설명 -->
  <div class="form-row">
    <div class="form-label">상품 설명</div>
    <div class="description-box">
      <textarea id="productDescription" name="productIntrod" maxlength="1000"
        placeholder="상품의 상태, 사용 기간, 구성품, 하자 유무 등을 구체적으로 기재해 주시기 바랍니다.
구매에 도움이 될 수 있는 상세 정보(사이즈, 사용감 등)를 성실히 작성해 주세요.
개인정보 입력(전화번호, 계좌번호, SNS 등)은 제한될 수 있으니 유의해 주세요.

특히 상품이 얼룩/오염/찢어짐/변형 등 하자 있을 경우 반드시 표기해 주세요.
일반적인 사용 정보 외에 판매자가 꼭 언급하고 싶은 특이사항이 있다면 함께 작성해 주세요.
구매 후 분쟁 예방에 도움이 될 수 있습니다."><c:out value='${product.productIntrod}' default=''/></textarea>
      <div class="description-count">
        <span id="descCharCount">0</span> / 1000
      </div>
    </div>
  </div>

    <!-- 가격정보 제목 + 구분선 -->
    <h2 class="section-title">가격</h2>

<!-- 가격 영역 -->
<div class="form-row price-row">
  <div class="form-label">가격</div>

  <div class="price-box">
  
  <!-- 가격 입력 -->
  <div class="price-input-group">
    <input type="number" name="productPrice" placeholder="가격을 입력하세요."
           class="price-input" max="11000000000"
           value="<c:out value='${product.productPrice}' default=''/>">
    <span class="price-unit">원</span>
  </div>

    <!-- 가격 제안 받기 -->
    <!-- 사용자가 체크하면 value="Y"가 전송됨, 체크하지 않으면 null 로 전달되어 기본값 'N' 처리됨 -->
    <div class="price-option">
      <label>
        <input type="checkbox" name="priceOffer" value="Y">
        가격제안 받기
      </label>

      <!-- 안내 문구 -->
      <p class="price-hint">
        가격제안은 댓글의 형태로 받을 수 있습니다.<br>
        제시받은 제안을 수락할 경우, 제시가로 판매가격이 수정됩니다.
      </p>
    </div>
  </div>
</div>


<!-- 배송비 영역 -->
<div class="form-row delivery-row">
  <div class="form-label">배송비</div>

  <div class="delivery-box">
  
  <!-- 배송방법 라디오 버튼 -->
  <input type="radio" name="tradeMethodCode" value="M1"
    <c:if test="${not empty product && product.tradeMethodCode eq 'M1'}">checked</c:if>> 배송비 포함
  <input type="radio" name="tradeMethodCode" value="M2"
    <c:if test="${not empty product && product.tradeMethodCode eq 'M2'}">checked</c:if>> 배송비 미포함
  <input type="radio" name="tradeMethodCode" value="M3"
    <c:if test="${not empty product && product.tradeMethodCode eq 'M3'}">checked</c:if>> 배송비 착불

    <!-- 안내 문구 -->
    <p class="delivery-hint">
      배송비는 5,000원으로 고정입니다.<br>
      직거래는 플랫폼 운영정책 상 금지하고 있습니다.
    </p>
  </div>
</div>

    <h2 class="section-title"></h2>

<!--  등록 버튼 -->
<div class="form-row submit-row">
  <!-- 경고 메시지 (초기 비활성화 상태) -->
  <div class="submit-warning" id="submitWarning">
    ※ 모든 필수 항목을 입력해야 등록할 수 있습니다.
  </div>

  <!-- 등록 버튼 -->
  <div class="submit-box">
      <!-- 등록/수정 버튼 텍스트 분기 -->
  <button type="submit" id="submitBtn" disabled>
    <c:choose>
      <c:when test="${editMode}">수정하기</c:when>
      <c:otherwise>등록하기</c:otherwise>
    </c:choose>
  </button>
  </div>
</div>
    </form>
  </main>
  <jsp:include page="/WEB-INF/views/common/footer.jsp" />
  
    <!-- 카테고리 히든 필드 (소분류 코드) -->
  <input type="hidden" name="categoryCode" id="categoryCode"
         value="<c:out value='${product.categoryCode}' default=''/>">
  
<script>

// 카테고리 선택 관련 스크립트 (대분류 - 중분류 - 소분류)
document.addEventListener('DOMContentLoaded', () => {
	
	  // HTML 요소 선택
	  const level1Items = document.querySelectorAll('#category-level1 li'); // 대분류 리스트
	  const midCategoryList = document.getElementById('midCategoryList');   // 중분류 영역
	  const subCategoryList = document.getElementById('subCategoryList');   // 소분류 영역
	  const selectedCategory = document.getElementById('selectedCategory'); // 선택한 결과 표시 영역

  // 중분류(B코드) 정의
  const midCategories = {
    '남성': [
      { code: 'B1', name: '남성 아우터' },
      { code: 'B2', name: '남성 상의' },
      { code: 'B3', name: '남성 하의' },
      { code: 'B4', name: '남성 악세사리' }
    ],
    '여성': [
      { code: 'B5', name: '여성 아우터' },
      { code: 'B6', name: '여성 상의' },
      { code: 'B7', name: '여성 하의' },
      { code: 'B8', name: '여성 악세사리' }
    ],
    '공용': [
      { code: 'B9', name: '공용 아우터' },
      { code: 'B10', name: '공용 상의' },
      { code: 'B11', name: '공용 하의' },
      { code: 'B12', name: '공용 악세사리' }
    ]
  };

//소분류(C코드) 정의 (기존 문자열 배열 → 객체 배열 {code, name}로 변경)
// 목적: 소분류 클릭 시 C코드를 함께 넘기기 위해 필요
const subCategories = {
 'B1': [
   { code: 'C01', name: '남성 점퍼' },
   { code: 'C02', name: '남성 자켓' },
   { code: 'C03', name: '남성 코트' },
   { code: 'C04', name: '남성 패딩' }
 ],
 'B2': [
   { code: 'C05', name: '남성 긴팔티' },
   { code: 'C06', name: '남성 반팔티' },
   { code: 'C07', name: '남성 니트' },
   { code: 'C08', name: '남성 후드' },
   { code: 'C09', name: '남성 셔츠' }
 ],
 'B3': [
   { code: 'C10', name: '남성 데님팬츠' },
   { code: 'C11', name: '남성 정장팬츠' },
   { code: 'C12', name: '남성 반바지' }
 ],
 'B4': [
   { code: 'C13', name: '남성 신발' },
   { code: 'C14', name: '남성 목걸이' },
   { code: 'C15', name: '남성 반지' },
   { code: 'C16', name: '남성 모자' }
 ],
 'B5': [
   { code: 'C17', name: '여성 점퍼' },
   { code: 'C18', name: '여성 자켓' },
   { code: 'C19', name: '여성 코트' },
   { code: 'C20', name: '여성 패딩' }
 ],
 'B6': [
   { code: 'C21', name: '여성 긴팔티' },
   { code: 'C22', name: '여성 반팔티' },
   { code: 'C23', name: '여성 니트' },
   { code: 'C24', name: '여성 후드' },
   { code: 'C25', name: '여성 셔츠' }
 ],
 'B7': [
   { code: 'C26', name: '여성 데님팬츠' },
   { code: 'C27', name: '여성 정장팬츠' },
   { code: 'C28', name: '여성 반바지' }
 ],
 'B8': [
   { code: 'C29', name: '여성 신발' },
   { code: 'C30', name: '여성 목걸이' },
   { code: 'C31', name: '여성 반지' },
   { code: 'C32', name: '여성 모자' }
 ],
 'B9': [
   { code: 'C33', name: '공용 점퍼' },
   { code: 'C34', name: '공용 자켓' },
   { code: 'C35', name: '공용 코트' },
   { code: 'C36', name: '공용 패딩' }
 ],
 'B10': [
   { code: 'C37', name: '공용 긴팔티' },
   { code: 'C38', name: '공용 반팔티' },
   { code: 'C39', name: '공용 니트' },
   { code: 'C40', name: '공용 후드' },
   { code: 'C41', name: '공용 셔츠' }
 ],
 'B11': [
   { code: 'C42', name: '공용 데님팬츠' },
   { code: 'C43', name: '공용 정장팬츠' },
   { code: 'C44', name: '공용 반바지' }
 ],
 'B12': [
   { code: 'C45', name: '공용 신발' },
   { code: 'C46', name: '공용 목걸이' },
   { code: 'C47', name: '공용 반지' },
   { code: 'C48', name: '공용 모자' }
 ]
};


  //선택된 항목 저장 변수
  let selectedMain = '';
  let selectedMid = '';
  let selectedSub = '';

  // 선택된 항목들을 텍스트로 갱신하는 함수
function updateCategoryText() {
	  
  // null이나 undefined 방지 + 값이 없을 땐 공백 처리
  const main = selectedMain || '';
  const mid = selectedMid || '';
  const sub = selectedSub || '';

  // 값이 존재하는 항목만 필터링해서 /로 조인
  const categoryParts = [main, mid, sub].filter(part => part !== '');
  selectedCategory.textContent = "현재 설정한 카테고리: " + categoryParts.join(" / ");
}


  // 1단계: 대분류 클릭
  level1Items.forEach(item => {
    item.addEventListener('click', () => {
    	
    	// 기존 선택 해제 후 현재 항목 강조
      level1Items.forEach(li => li.classList.remove('active'));
      item.classList.add('active');

      // 선택값 초기화
      selectedMain = item.dataset.value;
      selectedMid = '';
      selectedSub = ''; 
      midCategoryList.innerHTML = '';
      subCategoryList.innerHTML = '';

   // 선택한 대분류에 해당하는 중분류 항목 동적 생성
      const mids = midCategories[selectedMain];
      mids.forEach(mid => {
        const li = document.createElement('li');
        li.textContent = mid.name;
        li.dataset.code = mid.code;
        li.dataset.name = mid.name;
        li.classList.add('mid-category-item');

        // 2단계: 중분류 클릭
        li.addEventListener('click', () => {
          document.querySelectorAll('.mid-category-item').forEach(el => el.classList.remove('active'));
          li.classList.add('active');

          selectedMid = li.dataset.name;
          selectedSub = '';
          subCategoryList.innerHTML = '';

          // 소분류 항목 정의를 객체로 리팩토링: { code, name } 구조
          const subs = subCategories[li.dataset.code]; // li.dataset.code는 B코드

          subs.forEach(sub => {
            const subLi = document.createElement('li');
            subLi.textContent = sub.name;
            subLi.dataset.name = sub.name;
            subLi.dataset.code = sub.code; // C코드를 dataset에 포함
            subLi.classList.add('sub-category-item');

            // 3단계: 소분류 클릭
            subLi.addEventListener('click', () => {
              document.querySelectorAll('.sub-category-item').forEach(el => el.classList.remove('active'));
              subLi.classList.add('active');

              selectedSub = subLi.dataset.name;
              updateCategoryText(); // 텍스트 표시용

              // 선택된 C코드를 숨겨진 input에 설정
              document.getElementById("categoryCode").value = subLi.dataset.code;
            });

            subCategoryList.appendChild(subLi);
          });

          updateCategoryText(); // 중분류까지 선택 시 텍스트 갱신
        });

        midCategoryList.appendChild(li);
      });


      updateCategoryText(); // 대분류만 선택 시 갱신
    });
  });
});
</script>

<script>
  // 상품명 글자 수 카운트 함수
  const nameInput = document.querySelector('input[name="productName"]');
  const nameCounter = document.getElementById('nameCounter');

  if (nameInput && nameCounter) {
    nameInput.addEventListener('input', () => {
      nameCounter.textContent = nameInput.value.length + " / 30";
    });
  }
</script>

<script>
  //상품 설명 글자 수 카운트 함수
  const descInput = document.getElementById('productDescription');
  const countDisplay = document.getElementById('descCharCount');

  descInput.addEventListener('input', () => {
    countDisplay.textContent = descInput.value.length; // 입력된 글자 수 실시간 표시
  });
</script>

<script>
	//필수 항목 입력 여부에 따라 등록 버튼 활성화/비활성화 처리
document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('form');
  const submitBtn = document.getElementById('submitBtn');
  const warningMsg = document.getElementById('submitWarning');

  // 필수 입력 요소들
  const productNameInput = document.querySelector('input[name="productName"]');
  const productDescTextarea = document.querySelector('textarea[name="productIntrod"]');
  const priceInput = document.querySelector('input[name="productPrice"]');
  const tradeMethodRadios = document.querySelectorAll('input[name="tradeMethodCode"]');
  const imageInput = document.querySelector('input[name="productImages"]');

  //  상품 가격 상한 제한
  priceInput.addEventListener('input', () => {
    const value = parseInt(priceInput.value, 10);
    if (value > 1000000000) {
      alert("상품 가격은 10억 원 이하로 입력해야 합니다.");
      priceInput.value = '';
    }
    triggerValidation(); // 입력값 초기화 후 버튼 상태 다시 검사
  });
  
  // 유효성 검사 함수
  function validateForm() {
    const isName = productNameInput.value.trim() !== '';
    const isDesc = productDescTextarea.value.trim() !== '';
    const isPrice = priceInput.value.trim() !== '';
    const isTrade = Array.from(tradeMethodRadios).some(r => r.checked);
    const isImage = imageInput.files.length > 0;
    return isName && isDesc && isPrice && isTrade && isImage;
  }

  // 버튼 상태 갱신 함수
  function triggerValidation() {
    if (validateForm()) {
      submitBtn.disabled = false;
      warningMsg.style.display = 'none';
    } else {
      submitBtn.disabled = true;
      warningMsg.style.display = 'block';
    }
  }

  // 각각의 입력 요소에 이벤트 연결
  productNameInput.addEventListener('input', triggerValidation);
  productDescTextarea.addEventListener('input', triggerValidation);
  priceInput.addEventListener('input', triggerValidation);
  tradeMethodRadios.forEach(radio => radio.addEventListener('change', triggerValidation));
  imageInput.addEventListener('change', triggerValidation); // 파일은 change 이벤트

  //  페이지 로드 직후 한 번 상태 검사
  triggerValidation();
});
</script>

<script>
document.addEventListener('DOMContentLoaded', () => {

  const fileInput = document.getElementById('fileInput');
  const previewContainer = document.getElementById('imagePreviewContainer');
  const fileNum = document.getElementById('fileNum');  // 이미지 순서 숫자 표시용
  const prevBtn = document.getElementById('prevBtn');
  const nextBtn = document.getElementById('nextBtn');

  let currentIndex = 0;
  let previewImages = [];

  // 슬라이드에서 현재 인덱스의 이미지만 보여주는 함수
  function showImage(index) {
    previewImages.forEach((img, i) => {
      img.style.display = i === index ? 'block' : 'none';
    });
  }

  // 파일 첨부 시 실행
  fileInput.addEventListener('change', () => {
    const files = fileInput.files;
    const totalFiles = files.length;

    // 이미지 수 초기화 및 숫자 표시
    fileNum.textContent = totalFiles > 0 ? 1 : 0;

    //  placeholder-text가 남아있다면 제거 (중복 표시 방지)
    const placeholder = previewContainer.querySelector('.placeholder-text');
    if (placeholder) {
      placeholder.remove();
    }

    // 이미지 미리보기 배열 초기화 및 컨테이너 비우기
    previewImages = [];
    currentIndex = 0;
    previewContainer.innerHTML = '';

    // 이미지가 없는 경우, placeholder 다시 표시
    if (totalFiles === 0) {
      previewContainer.innerHTML = '<span class="placeholder-text">상품 이미지 등록</span>';
      prevBtn.style.display = 'none';
      nextBtn.style.display = 'none';
      return;
    }

    let loadedCount = 0;

    Array.from(files).forEach((file) => {
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = document.createElement('img');
        img.src = e.target.result;
        img.classList.add('preview-img');
        img.style.display = 'none';  // 기본은 숨김
        previewImages.push(img);
        previewContainer.appendChild(img);

        loadedCount++;

        // 모든 이미지 로딩 완료 시, 첫 이미지 표시 + 버튼 활성화
        if (loadedCount === totalFiles) {
          showImage(0);
          currentIndex = 0;
          fileNum.textContent = 1;
          prevBtn.style.display = totalFiles > 1 ? 'inline-block' : 'none';
          nextBtn.style.display = totalFiles > 1 ? 'inline-block' : 'none';
        }
      };
      reader.readAsDataURL(file);
    });
  });

  // 이전 이미지 보기
  prevBtn.addEventListener('click', () => {
    if (previewImages.length <= 1) return;
    previewImages[currentIndex].style.display = 'none';
    currentIndex = (currentIndex - 1 + previewImages.length) % previewImages.length;
    previewImages[currentIndex].style.display = 'block';
    fileNum.textContent = currentIndex + 1;
  });

  // 다음 이미지 보기
  nextBtn.addEventListener('click', () => {
    if (previewImages.length <= 1) return;
    previewImages[currentIndex].style.display = 'none';
    currentIndex = (currentIndex + 1) % previewImages.length;
    previewImages[currentIndex].style.display = 'block';
    fileNum.textContent = currentIndex + 1;
  });

});
</script>


</body>
</html>
