<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

/*  실제 이미지가 출력되는 박스: 크기 고정이 필요한 곳 */
.product-image-box {
  width: 400px;
  height: 400px;
  position: relative;       /* 자식 이미지의 absolute 기준 */
  overflow: hidden;
}


/*  이미지 + 인디케이터 전체를 세로 정렬하는 컨테이너 */
.image-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  
}

/* 슬라이드 컨테이너 */
.image-slider {
  width: 100%;
  height: 100%;             /*  반드시 높이를 100%로 */
  position: relative;
}

/* 슬라이드 이미지 공통 스타일 - 기존 클래스명을 유지하면서 애니메이션만 추가 */
.slide-image {
  position: absolute;               /* 겹치도록 배치 */
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;

  opacity: 0;                       /* 기본은 보이지 않게 */
  transform: scale(0.98);           /* 살짝 축소된 상태에서 시작 */
  transition: 
    opacity 0.5s ease-in-out,
    transform 0.5s ease-in-out;     /* 부드러운 페이드 + 확대 전환 */
  
  z-index: 0;
  pointer-events: none;             /* 비활성 상태일 땐 클릭 막기 */
}

/* 활성화된 이미지 - 자연스럽게 커지고 투명도 증가 */
.slide-image.active {
  opacity: 1;
  transform: scale(1);
  z-index: 1;
  pointer-events: auto;
}

/* 슬라이드 버튼 스타일 개선 */
.slide-btn {
  position: absolute;	
  z-index : 10;
  top: 50%;
  transform: translateY(-50%);
  width: 40px;
  height: 40px;
  background-color: rgba(0, 0, 0, 0.4);
  border: none;
  border-radius: 50%;
  color: white;
  font-size: 24px;
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: background-color 0.2s ease;
}
.slide-btn:hover {
  background-color: rgba(0, 0, 0, 0.7);
}
.slide-btn.left {
  left: 10px;
}
.slide-btn.right {
  right: 10px;
}

/* 인디케이터 원 만들기 */
.image-indicators {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-top: 12px; /* 슬라이더 하단 여백 */
}

/* 각 인디케이터 원 */
.image-indicators .indicator-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background-color: var(--gray5); /* 비활성 상태 색 */
  transition: background-color 0.3s;
}

/* 활성된 인디케이터 원 */
.image-indicators .indicator-dot.active {
  background-color: var(--main2); /* 선택된 이미지 강조 색 */
}





/* 상품 정보 요약 영역 */
.product-summary {
  flex: 1;
  min-width: 420px;
  margin-left: 100px;
  padding-top: 10px;
}

/* 판매중 뱃지 상태 */
.product-status {
  font-size: 15px;
  color: #fff;
  background-color: #ff5c5c;
  display: inline-block;
  padding: 5px 12px;
  border-radius: 12px;
  margin-bottom: 15px;
}

/* 삭제된 상품 상태일 경우 (회색) */
.product-status.deleted {
  background-color: #b0b0b0;
  color: white;
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

/* 우측 상단 수정/삭제 텍스트 링크 */
.product-manage-links {
  position: absolute;
  top: 10px;
  right: 20px;
  font-size: 14px;
  color: var(--gray3);
  z-index: 10;
}

/* 링크형 텍스트 스타일 */
.product-manage-links a,
.product-manage-links .text-link-delete {
  color: var(--gray4);
  background: none;
  border: none;
  font-size: 13px;
  padding: 0;
  margin: 0 3px;
  cursor: pointer;
  text-decoration: underline;
}

.product-manage-links a:hover,
.product-manage-links .text-link-delete:hover {
  color: var(--main3);
}


/* 비슷한 상품 전체 섹션 */
.related-products {
  border-top: 1px solid var(--gray6);
  border-bottom: 1px solid var(--gray6);
  padding: 30px 0;
  margin: 40px 0;
   position: relative;
}

/* 섹션 제목 */
.related-title {
  font-size: 18px;
  font-family: ns-b;
  margin-bottom: 20px;
}

/* 가로 슬라이드 가능한 관련 상품 리스트 */
.related-list {
  display: flex;
  overflow-x: auto;
  scroll-behavior: smooth;
  gap: 16px;
  padding: 10px 0;
   scrollbar-width: none;        /* Firefox */
  -ms-overflow-style: none;     /* IE/Edge */
}

/* 슬라이더 삭제 */
.related-list::-webkit-scrollbar {
  display: none;                /* Chrome, Safari, Opera */
}

.related-item {
  width: 140px;
  padding: 10px;
  border: 1px solid var(--gray6);         /* 박스 구분선 */
  border-radius: 8px;
  background-color: #fff;                 /* 흰 배경 */
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease-in-out;       /* hover 부드럽게 */
  cursor: pointer;
  text-align: center;
}

.related-item:hover {
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 강조된 그림자 */
  transform: translateY(-2px);             /* 살짝 위로 */
  border-color: var(--primary);            /* 강조 색상 */
}

/* 상품 이미지 영역 */
.related-img {
  width: 100%;
  height: 140px; /* 고정 높이 지정 */
  overflow: hidden;
  border-radius: 6px;
  background-color: var(--gray5); /* 로딩 전 배경용 */
}

.related-img img {
  width: 100%;
  height: 100%;
  object-fit: cover; /* 비율 유지하면서 채우기 */
  display: block;
}

/* 카드 제목, 가격 표시 */
.related-name {
  font-size: 15px;            
  font-weight: bold;
  color: var(--gray1);          /* 텍스트 색상 강조 */
  margin: 6px 0 2px 0;
  background-color: rgba(255, 255, 255, 0.75); /* 반투명 배경 */
  padding: 2px 6px;
  border-radius: 4px;
  text-align: center;
  height: 42px;
  overflow: hidden;
  line-height: 1.3;
  word-break: break-word;
}

.related-price {
  font-size: 14px;              /* 가격은 살짝 작게 */
  color: var(--primary);        /* 강조 색상 사용 (default.css의 var) */
  font-family: ns-b;            /* 숫자 강조 시 읽기 쉬운 볼드체 */
  background-color: rgba(255, 255, 255, 0.65); /* 연한 배경 */
  padding: 2px 6px;
  border-radius: 4px;
  text-align: center;
}

/* 관련 상품 슬라이드 버튼 */
.related-slide-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  z-index: 10;
  background-color: rgba(255, 255, 255, 0.8); /* 반투명 흰 배경 */
  border: 1px solid var(--gray5);
  border-radius: 50%;
  font-size: 20px;
  width: 36px;
  height: 36px;
  cursor: pointer;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  transition: background-color 0.2s ease;
}

.related-slide-btn:hover {
  background-color: rgba(255, 255, 255, 1); /* hover 시 더 선명한 흰색 */
}

/* 왼쪽/오른쪽 위치 지정 */
#relatedPrevBtn {
  left: 4px;
}

#relatedNextBtn {
  right: 4px;
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

/* 상품설명내용 폰트작성*/
.product-description-text {
  font-family: 'Segoe UI', 'Malgun Gothic', sans-serif;
  font-size: 15px;
  line-height: 1.6;
  background-color: rgba(245, 245, 245, 0.85);
  padding: 14px;
  border-radius: 6px;
  white-space: pre-wrap;
  word-break: break-word;
  color: var(--gray2);
  text-align: center;
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

/* 가격 제안 알림 영역 */
.price-offer-notice {
  display: flex;
  align-items: center;
  margin: 12px 0 20px 0;   /* 위: 상품 메타와 간격 / 아래: 버튼 그룹과 간격 */
  font-size: 15px;
  color: #ff6600;
  gap: 6px;
}

.price-offer-notice .material-icons {
  font-size: 20px;
  vertical-align: middle;
}


.profile-name {
  font-size: 16px;               /* 살짝 크게 (기존 대비) */
  font-family: 'Pretendard', sans-serif;  /* 부드럽고 귀여운 느낌의 글꼴 */
  font-weight: 500;              /* 너무 두껍지 않은 중간 굵기 */
  color: var(--gray1);           /* 선명하고 안정된 글자색 */
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
  background-color: #e3ecff; /* 연한 파스텔 하늘색 */
  margin-bottom: 16px;
}

/* 프로필 영역 */
.comment-box-profile {
  display:  flex;
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


/* 댓글 본문 박스 내부: 너비 제한 및 flex 대응 */
.comment-box-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 0;  /* flex 하위에서 overflow 방지 */
}


/* 댓글 내용 박스 - 고정 크기 */
.comment-box-content-fixed {
  background-color: #ffffff;
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
.comment-box-reply-btn,
.comment-box-delete-btn,
.comment-box-edit-btn {
  border: 1px solid var(--gray4);
  background-color: transparent;
  padding: 4px 10px;
  font-family: inherit;
  font-size: inherit;
  border-radius: 5px;
  cursor: pointer;
}

/* 신고 버튼 */
.comment-box-report-btn {
  border: none;
  background: none;
  color: var(--gray4);
  font-family: inherit;
  font-size: inherit;
  cursor: pointer;
  display: flex;
  align-items: center;
}
.comment-box-report-btn .material-icons {
  font-size: 16px;
  margin-right: 4px;
}

/* 대댓글 입력 영역 전체 */
.comment-box-reply-form {
  display: block;             /* flex 안에서 불필요한 확장 방지 */
  width: 100%;
  max-width: 100%;
  padding-left: 60px;         /* 프로필 공간 확보 */
  margin-top: 12px;
  box-sizing: border-box;
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
  background-color: #d2ddff; /* 댓글보다 조금 진한 파스텔 블루 */
  border: 1px solid var(--gray5);
  padding: 16px;
  margin-bottom: 12px;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.04);
}

.comment-box-item.comment-reply .comment-box-content-fixed {
  background-color: var(--gray8);
}

/* 대댓글 폼 내부 textarea */
.comment-box-reply-form .comment-textarea {
  width: 100%;
  height: 80px;
  resize: none;
  padding: 10px;
  font-size: 14px;
  border: 1px solid var(--gray5);
  border-radius: 6px;
  box-sizing: border-box;
  background-color: var(--gray9);
}

/* 대댓글 등록 버튼 우측 정렬 */
.comment-box-reply-form .comment-submit-wrap {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 6px;
}

.modal-overlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background-color: rgba(0,0,0,0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.modal-content {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  width: 400px;
  max-width: 90%;
  box-shadow: 0 4px 10px rgba(0,0,0,0.2);
}

.modal-content h3 {
  margin-bottom: 12px;
  font-size: 18px;
}

.modal-textarea {
  width: 100%;
  height: 100px;
  padding: 10px;
  font-size: 14px;
  resize: none;
  border: 1px solid var(--gray4);
  border-radius: 4px;
  margin-bottom: 12px;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

/* 기본 상태는 숨김 상태 */
#replyModal,
#editModal {
  display: none; /* 기본적으로 숨김 */
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  justify-content: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.4);
  z-index: 1000;
}

/* 댓글이 1개도 등록되있지 않을때 */
.comment-empty-box {
  margin-top: 20px;
  padding: 30px;
  text-align: center;
  background-color: rgba(41, 64, 246, 0.15); /* 옅은 파란색 (투명도 15%) */
  color: #ffffff; /* 흰색 글자 */
  font-size: 16px;
  border-radius: 10px;
}

/* 기존 .product-status와 동일한 모양을 유지하되 색상만 다름 */
.product-status.delivery-included {
  background-color: #e1f7e3;  /* 연한 초록 */
  color: #237a3b;
}

.product-status.delivery-excluded {
  background-color: #ffe8ec;  /* 연한 분홍 */
  color: #9d3b50;
}

/* 판매자 정보 프로필 구간 */
.seller-profile-thumbnail {
  width: 100px;
  height: 100px;
  border-radius: 8px;
  overflow: hidden;
  background-color: var(--gray6);
  display: block;              /* 좌측 정렬 유지 */
  margin-bottom: 10px;         /* 아래 여백 */
}

.seller-profile-thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
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
		
		<!-- 현재 보여지는 메인 이미지 -->
		<div class="image-slider">
		  <c:forEach var="file" items="${fileList}" varStatus="status">
		    <img src="${file.filePath}" 
		         alt="상품 이미지 ${status.index + 1}" 
		         class="slide-image" 
		         >
		  </c:forEach>
		</div>

     <!-- 좌측 슬라이드 버튼 -->
     <button class="slide-btn left material-icons">chevron_left</button>
     
     <!-- 우측 슬라이드 버튼 -->
     <button class="slide-btn right material-icons">chevron_right</button>
    </div>

	<!-- 이미지 인디케이터 (●●●○○ 등) -->
	<div class="image-indicators">
	  <c:forEach var="file" items="${fileList}" varStatus="status">
	    <span class="indicator-dot ${status.first ? 'active' : ''}"></span>
	  </c:forEach>
	</div>
  </div>


<!-- 우측 - 상품 정보 요약 영역 -->
<div class="product-summary">

<%-- (1) 수정/삭제 링크: 작성자 또는 admin 계정일 경우만 출력 --%>
<c:if test="${loginMember != null && (loginMember.memberNo eq product.memberNo || loginMember.memberId eq 'admin')}">
  <div class="product-manage-links">
    <a href="/product/edit?no=${product.productNo}">수정</a>
    |
    <form action="/product/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');" style="display:inline;">
      <input type="hidden" name="productNo" value="${product.productNo}">
      <button type="submit" class="text-link-delete">삭제</button>
    </form>
  </div>
</c:if>

<div style="display: flex; align-items: center; gap: 8px; margin-bottom: 25px;">
<c:choose>
  <c:when test="${product.statusCode eq 'S99'}">
    <c:if test="${loginMember != null and loginMember.memberId eq 'admin'}">
      <div class="product-status deleted">${product.productStatus}</div>
    </c:if>
  </c:when>
  <c:otherwise>
    <div class="product-status">${product.productStatus}</div>
  </c:otherwise>
</c:choose>


  <!-- 배송비 조건별 스타일 표시 -->
  <c:choose>
    <c:when test="${product.tradeMethodCode eq 'M1'}">
      <div class="product-status delivery-included">배송비 포함</div>
    </c:when>
    <c:otherwise>
      <div class="product-status delivery-excluded">
        <c:choose>
          <c:when test="${product.tradeMethodCode eq 'M2'}">배송비 별도</c:when>
          <c:otherwise>배송비 착불</c:otherwise>
        </c:choose>
      </div>
    </c:otherwise>
  </c:choose>
</div>



  <!-- 상품명 -->
  <h2 class="product-title">${product.productName}</h2>

  <!-- 상품 가격 -->
  <p class="product-price">
    ₩<fmt:formatNumber value="${product.productPrice}" pattern="#,###"/>
  </p>

  <!-- 찜, 조회수, 등록일 -->
  <div class="product-meta">
    <span>찜 <strong>${product.wishlistCount}</strong></span> |
    <span>조회수 <strong>${product.readCount}</strong></span> |
    <span>등록일 <strong><fmt:formatDate value="${product.enrollDate}" pattern="yyyy.MM.dd"/></strong></span>
  </div>

<%-- 가격제안 여부(product.priceOfferYn == 'Y')일 때만 안내 문구 표시 --%>
<c:if test="${product.priceOfferYn eq 'Y'}">
  <div class="price-offer-notice">
    <span class="material-icons">local_offer</span>
    이 상품은 <strong>가격 제안</strong>을 받을 수 있어요!
  </div>
</c:if>


  <!-- 액션 버튼 -->
  <div class="action-buttons" style="display: flex; gap: 10px; align-items: center;">
  
<!-- 찜 버튼: 로그인한 사용자만 사용 가능하며, 한 번 누르면 찜/찜 해제가 토글됨 -->
<!-- 로그인 정보는 서버 세션에서 처리함 -->

<form id="wishlistForm" action="/wishlist/toggle" method="post">
  <!-- 현재 상품 번호 전달 -->
  <input type="hidden" name="productNo" value="${product.productNo}">

  <!-- 찜 여부에 따라 버튼 텍스트를 동적으로 변경 -->
  <button type="submit" class="btn-secondary outline" id="wishlistBtn">
    <c:choose>
      <c:when test="${isWished}">
        찜 해제
      </c:when>
      <c:otherwise>
        찜하기
      </c:otherwise>
    </c:choose>
  </button>
  
</form>


    <button class="btn-warning">신고하기</button>

    
    <!-- ★동주 : 바로구매 시 결제 페이지 연동/하단에 해당 스크립트도 추가!!★ 시작 -->    
    <button class="btn-primary" onclick="goToOrderPage('${product.productNo}')">바로구매</button>
    <!-- ★동주 : 바로구매 시 결제 페이지 연동/하단에 해당 스크립트도 추가!!★  끝 -->

 
  </div>
</div>

</section>




<%--
  관련 상품 추천 영역.
  서버로부터 전달받은 'relatedProducts' 리스트를 반복 출력하여,
  현재 상품과 동일한 카테고리(CATEGORY_CODE)를 가진 최근 등록 상품 6개를 소개함.
  각 상품은 대표 이미지(thumbnailPath), 상품명, 가격으로 구성되어 있으며,
  카드 전체를 <a> 태그로 감싸서 클릭 시 상세 페이지로 이동하도록 구성함.
--%>

<section class="related-products">
  <h3 class="related-title">비슷한 상품을 찾아보세요</h3>

  <!-- 관련 상품 슬라이드 좌우 버튼: 고유 id/class 사용 -->
  <button type="button" class="related-slide-btn left" id="relatedPrevBtn">&#10094;</button>
  <button type="button" class="related-slide-btn right" id="relatedNextBtn">&#10095;</button>

  <!-- 슬라이드 가능한 관련 상품 리스트 -->
  <div class="related-list" id="relatedListSlider">
    <c:forEach var="prod" items="${relatedProducts}">
      <c:if test="${prod.statusCode ne 'S99'}">
        <a href="${pageContext.request.contextPath}/product/detail?no=${prod.productNo}" class="related-item-link">
          <div class="related-item">
            <div class="related-img">
              <img src="${prod.thumbnailPath}" alt="${prod.productName}">
            </div>
            <div class="related-name">${prod.productName}</div>
            <div class="related-price">
              ₩<fmt:formatNumber value="${prod.productPrice}" pattern="#,###"/>
            </div>
          </div>
        </a>
      </c:if>
    </c:forEach>
  </div>
</section>







<!-- 상품 정보 + 판매자 정보 섹션 -->
<section class="product-info-section">

  <!-- 좌측: 상품 설명 영역 -->
  <div class="product-detail-box">
    <h3 class="section-title">상품 정보</h3>	
	<!-- 상품 설명 출력 영역 -->
	<div class="form-row">
	  <div class="product-description">
	    <pre class="product-description-text">${product.productIntrod}</pre>
	  </div>
	</div>
  </div>

<!-- 우측: 판매자 정보 영역 -->
<aside class="seller-info-box">
  <div class="seller-title">판매자 정보</div>

  <div class="seller-profile">
    <!-- 프로필 이미지 -->
		  <div class="seller-profile-thumbnail">
		    <img 
		      src="${empty seller.profileImgPath ? '/resources/images/default.jpg' : seller.profileImgPath}" 
		      alt="판매자 프로필 이미지" />
		  </div>

    <!-- 판매자 이름 출력 -->
    <div class="profile-name">
      <strong>${seller.memberName}</strong>
    </div>
  </div>


    <!-- 판매자 링크 영역 - 항상 하단에 위치 -->
    <div class="seller-links">
      <a href="/product/seller?memberNo=${not empty product.memberNo ? product.memberNo : 'M00000001'}">판매자의 다른 상품 보기</a>
		<br>
      <a href="#">판매자 후기 작성하기</a>
    </div>
  </aside>
</section>



<!-- 댓글 입력 영역 -->
<section class="comment-write-section section">
  <h3 class="section-title" style="margin-bottom: 14px;">댓글 작성하기</h3>

  <!-- 댓글 작성 form -->
  <form action="/product/insertComment" method="post" class="comment-form">
    <input type="hidden" name="productRef" value="${product.productNo}" />

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
  <div class="comment-box-header">
    <h3 class="section-title">전체 댓글 (<span>${fn:length(commentList)}</span>개)</h3>
    <div class="comment-box-sort">정렬 : <strong>최신순</strong></div>
  </div>
      <!-- 댓글이 0개일 경우 나오는 화면 -->
    <c:if test="${empty commentList}">
  <div class="comment-empty-box">
    현재 등록된 댓글은 0개입니다.
  </div>
</c:if>

  <!-- 댓글 목록 반복 -->
  <c:forEach var="comment" items="${commentList}">
    <c:if test="${empty comment.parentCommentNo}">
      <!--  일반 댓글 박스 -->
      <div class="comment-box-item">
        <div class="comment-box-profile">
          <div class="profile-image">${fn:substring(comment.memberNickname, 0, 1)}</div>
          <div class="comment-box-username">${comment.memberNickname}</div>
        </div>
        <div class="comment-box-body">
          <div class="comment-box-content-fixed">${comment.content}</div>
          <div class="comment-box-footer">
            <span class="comment-box-date">
              <fmt:formatDate value="${comment.createdDate}" pattern="yyyy-MM-dd" />
            </span>
            <div class="comment-box-actions">
            	<c:if test="${loginMember.memberNo == comment.memberNo}">
					<button class="comment-box-edit-btn"
					        onclick="openEditModal(${comment.commentNo}, '${fn:replace(fn:replace(comment.content, '\'', '\\\'') , '&#10;', '')}')">
					  수정
					</button>
				</c:if>
		        <c:if test="${loginMember.memberNo == comment.memberNo or loginMember.memberNickname eq 'admin'}">
				 <button class="comment-box-delete-btn" onclick="deleteComment(${comment.commentNo}, '${comment.productNo}')">
					  삭제
				 </button>
				</c:if>
              <button class="comment-box-reply-btn" onclick="openReplyModal(${comment.commentNo})">답글</button>
            </div>
          </div>
        </div>
      </div>

      <!--  대댓글 반복 -->
      <div class="comment-box-replies">
        <c:forEach var="reply" items="${commentList}">
          <c:if test="${not empty reply.parentCommentNo and reply.parentCommentNo eq comment.commentNo}">
            <div class="comment-box-item comment-reply">
              <div class="comment-box-profile">
                <div class="profile-image">${fn:substring(reply.memberNickname, 0, 1)}</div>
                <div class="comment-box-username">${reply.memberNickname}</div>
              </div>
              <div class="comment-box-body">
                <div class="comment-box-content-fixed">${reply.content}</div>
                <div class="comment-box-footer">
                  <span class="comment-box-date">
                    <fmt:formatDate value="${reply.createdDate}" pattern="yyyy-MM-dd" />
                  </span>
                  <div class="comment-box-actions">
					 <c:if test="${loginMember.memberNo == reply.memberNo}">
					  <button class="comment-box-edit-btn"
					          onclick="openEditModal(${reply.commentNo}, '${fn:replace(fn:replace(reply.content, '\'', '\\\'') , '&#10;', '')}')">
					    수정
					  </button>
					</c:if>
                  <c:if test="${loginMember.memberNo == reply.memberNo or loginMember.memberNickname eq 'admin'}">
					  <button class="comment-box-delete-btn" onclick="deleteComment(${reply.commentNo}, '${reply.productNo}')">
					    삭제
					  </button>
				  </c:if>
                  </div>
                </div>
              </div>
            </div>
          </c:if>
        </c:forEach>
      </div> <!-- /대댓글 -->
    </c:if>
  </c:forEach>
</section>

<!-- 대댓글 작성 모달 -->
<div id="replyModal"
     class="modal-overlay"
     role="dialog"
     aria-modal="true"
     style="display: none; justify-content: center; align-items: center;">
  
  <div class="modal-content"
       style="width: 90%; max-width: 600px; padding: 24px;">
    
    <!-- 대댓글 입력 폼 -->
    <form action="/product/insertComment" method="post" class="reply-form">

      <!-- 필수 hidden 값들 -->
      <input type="hidden" name="productRef" value="${product.productNo}" />
      <input type="hidden" name="commentWriter" value="${loginMember.memberNo}" />
      <input type="hidden" name="parentCommentNo" id="modalParentCommentNo" />

      <!-- 대댓글 입력창 -->
      <textarea name="commentContent"
                class="comment-textarea"
                maxlength="500"
                placeholder="대댓글 내용을 입력해주세요."
                style="height: 120px; font-size: 1rem;"></textarea>

      <!-- 버튼 영역 -->
      <div class="comment-submit-wrap" style="margin-top: 14px;">
        <button type="submit" class="btn-primary sm">등록</button>
        <button type="button" class="btn-secondary sm" onclick="closeReplyModal()">취소</button>
      </div>
    </form>
  </div>
</div>

<!-- 댓글 수정 모달 -->
<div id="editModal"
     class="modal-overlay"
     style="display: none; justify-content: center; align-items: center;">

  <div class="modal-content"
       style="width: 90%; max-width: 600px; padding: 24px;">

    <form action="/product/updateComment" method="post" class="reply-form">
      <!-- 댓글 번호 전달 -->
      <input type="hidden" name="commentNo" id="modalEditCommentNo">
      <input type="hidden" name="productNo" value="${param.no}">

      <!-- 수정 textarea -->
      <textarea name="commentContent"
                id="modalEditContent"
                class="comment-textarea"
                maxlength="500"
                placeholder="댓글 내용을 수정하세요."
                style="height: 120px; font-size: 1rem;"></textarea>

      <!-- 버튼 영역 -->
      <div class="comment-submit-wrap" style="margin-top: 14px;">
        <button type="submit" class="btn-primary sm">수정 완료</button>
        <button type="button" class="btn-secondary sm" onclick="closeEditModal()">취소</button>
      </div>
    </form>
  </div>
</div>


    </main>
		<div class="fixed" style="right: 280px;">
			<div class="top" onclick="scrollToTop()">
				<span class="material-symbols-outlined">arrow_upward</span>
			</div>
		</div>
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
    

<script>
	//우측 하단 ↑ 버튼 클릭 시 상단으로 스크롤 이동
    function scrollToTop() {
        window.scrollTo({
        top: 0,
        behavior: 'smooth' // 부드럽게 스크롤
        });
    }
</script>

<script>
// DOM 로드 후 슬라이드 관련 로직 실행
document.addEventListener("DOMContentLoaded", function () {
  const images = document.querySelectorAll(".slide-image");
  const indicators = document.querySelectorAll(".indicator-dot"); // 존재 시 인디케이터도 처리
  const prevBtn = document.querySelector(".slide-btn.left");
  const nextBtn = document.querySelector(".slide-btn.right");

  let currentIndex = 0;

  // 현재 인덱스의 이미지와 인디케이터만 'active' 클래스 부여
  function showImage(index) {
    if (images.length === 0) return;

    images.forEach((img, i) => {
      img.classList.remove("active");
    });
    if (indicators.length > 0) {
      indicators.forEach((dot, i) => {
        dot.classList.remove("active");
      });
    }

    images[index].classList.add("active");
    if (indicators.length > 0) {
      indicators[index].classList.add("active");
    }

    currentIndex = index;
  }

  // 버튼 이벤트 - 이전
  if (prevBtn) {
    prevBtn.addEventListener("click", () => {
      const newIndex = (currentIndex - 1 + images.length) % images.length;
      showImage(newIndex);
    });
  }

  // 버튼 이벤트 - 다음
  if (nextBtn) {
    nextBtn.addEventListener("click", () => {
      const newIndex = (currentIndex + 1) % images.length;
      showImage(newIndex);
    });
  }

  // 인디케이터 클릭 이동
  if (indicators.length > 0) {
    indicators.forEach((dot, i) => {
      dot.addEventListener("click", () => showImage(i));
    });
  }

  showImage(0); // 첫 이미지 초기 표시
});
</script>



<script>

	// 비슷한 상품 찾아보기 전용 슬라이더
document.addEventListener('DOMContentLoaded', () => {
  const slider = document.getElementById('relatedListSlider');
  const prevBtn = document.getElementById('relatedPrevBtn');
  const nextBtn = document.getElementById('relatedNextBtn');

  //  슬라이드 너비 기준 자동 계산
  const scrollAmount = 600; // 600정도 이동

  if (slider && prevBtn && nextBtn) {
    prevBtn.addEventListener('click', () => {
      slider.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
    });

    nextBtn.addEventListener('click', () => {
      slider.scrollBy({ left: scrollAmount, behavior: 'smooth' });
    });
  }
});
</script>



<script>
// 댓글 입력창에서 글자 수 실시간 카운팅 함수
document.addEventListener('DOMContentLoaded', () => {
  const textareas = document.querySelectorAll('.comment-textarea');

  textareas.forEach(textarea => {
    const container = textarea.closest('.comment-input-wrap, .comment-box-reply-form');

    // 보호 조건: container가 존재할 때만 querySelector 실행
    if (container) {
      const countSpan = container.querySelector('.current-count');
      if (countSpan) {
        textarea.addEventListener('input', () => {
          countSpan.textContent = textarea.value.length;
        });
      }
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

<script>
	// 대댓글 전용 팝업창 작성

  function openReplyModal(parentCommentNo) {
    // 부모 댓글 번호를 hidden input에 설정
    document.getElementById("modalParentCommentNo").value = parentCommentNo;

    // 모달을 화면 중앙에 표시 (flex 기반 중앙 정렬)
    const modal = document.getElementById("replyModal");
    modal.style.display = "flex";
  }
   // 대댓글 작성 모달을 닫습니다.
   
  function closeReplyModal() {
    const modal = document.getElementById("replyModal");
    modal.style.display = "none";
  }
</script>

<script>
  // 댓글 수정 모달을 엽니다.
  function openEditModal(commentNo, content) {
    // 댓글 번호를 hidden input에 설정
    const commentNoInput = document.getElementById("modalEditCommentNo");
    commentNoInput.value = commentNo;

    // 기존 댓글 내용을 textarea에 설정
    const contentTextarea = document.getElementById("modalEditContent");
    contentTextarea.value = content;

    // 모달을 화면 중앙에 표시 (flex 기반 중앙 정렬)
    const modal = document.getElementById("editModal");
    modal.style.display = "flex";
  }

  // 댓글 수정 모달을 닫습니다.
  function closeEditModal() {
    const modal = document.getElementById("editModal");
    modal.style.display = "none";
  }
</script>



<script>
// 댓글 삭제 경고문
	function deleteComment(commentNo, productNo) {
    if (confirm("정말 이 댓글을 삭제하시겠습니까?")) {
      location.href = "/product/deleteComment?no=" + commentNo + "&product=" + productNo;
    }
  }
</script>

<!-- ★동주 : 바로구매 버튼 클릭 시 결제 페이지 이동 연결 스크립트★ 시작-->
<script>
function goToOrderPage(productId) {
  if (productId) {
    // 구매 페이지 URL (OrderStartServlet의 매핑된 주소)
    const orderStartPageUrl = "${pageContext.request.contextPath}/order/orderStart?productId=" + productId;
    window.location.href = orderStartPageUrl;
  } else {
    alert("상품 정보를 가져올 수 없습니다.");
  }
}
</script>
<!-- ★동주 : 바로구매 버튼 클릭 시 결제 페이지 이동 연결 스크립트★ 끝-->

</body>
</html>



