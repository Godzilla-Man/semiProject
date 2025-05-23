<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>스타일 후기 게시판</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"> <%-- Material Icons CSS --%>
  <style>
    /* 기본 스타일 */
    html {
        box-sizing: border-box;
    }
    *, *:before, *:after {
        box-sizing: inherit;
    }
    body {
        font-family: 'Noto Sans KR', sans-serif;
        margin: 0;
        padding: 0;
        color: #333; /* 기본 텍스트 색상 추가 */
    }
    main {
        width: 80%;
        max-width: 1000px;
        margin: 20px auto; /* 상하 마진 추가 */
        min-height: 52.2vh;
    }

    /* 카테고리 링크 영역 */
    .category-links {
        margin: 20px auto;
        width: 100%;
        text-align: center;
        padding-bottom: 20px;
        border-bottom: 1px solid #ddd;
    }
    .category-links ul {
        list-style: none;
        padding: 0;
        margin: 0 auto;
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
    }
    .category-links li {
        margin: 10px 15px; /* 좌우 마진 조정 */
        text-align: center;
    }
    .category-links a {
        text-decoration: none;
        color: #333;
        display: block;
        transition: transform 0.2s ease;
    }
    .category-links a:hover {
        transform: translateY(-3px); /* 호버 시 약간 위로 이동 */
    }
    .category-links img {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #ddd;
        display: block;
        margin: 0 auto 8px; /* 이미지와 텍스트 간격 */
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .category-links div { /* 카테고리 텍스트 */
        font-weight: 500;
        font-size: 0.95em;
    }
    /* 현재 선택된 카테고리 강조 스타일 */
    .category-links li.active a img {
        border-color: #007bff; /* 활성 테두리 색상 */
    }
    .category-links li.active div {
        color: #007bff; /* 활성 텍스트 색상 */
        font-weight: 700;
    }

    /* 스타일 후기 게시판 영역 */
    .style-review-board {
        width: 100%;
        margin: 30px 0;
    }
    .cards-container {
        display: grid;
        grid-template-columns: repeat(4, 1fr); /* 기본 4열 */
        gap: 25px; /* 카드 간 간격 */
    }
    .card {
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0,0,0,0.08);
        background: #fff;
        display: flex;
        flex-direction: column;
        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        text-decoration: none; /* 링크 밑줄 제거 */
        color: inherit; /* 부모 색상 상속 */
    }
    .card:hover {
        transform: translateY(-5px); /* 호버 시 위로 약간 이동 */
        box-shadow: 0 6px 12px rgba(0,0,0,0.12);
    }
    .card .image { /* 썸네일 이미지 컨테이너 */
        width: 100%;
        height: 250px; /* 썸네일 높이 조정 */
        background-color: #f0f0f0; /* 이미지 없을 때 배경색 */
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: hidden;
    }
    .card .image img {
        width: 100%;
        height: 100%;
        object-fit: cover; /* 이미지가 컨테이너를 꽉 채우도록 */
    }
    .card .image-info { /* 게시글 제목 등 정보 영역 */
        padding: 15px;
        width : 100%;
        box-sizing: border-box;
        text-align: left; 
    }
    .card .image-style { /* 게시글 제목 스타일 */
        font-size: 1em; 
        color: #333;
        font-weight: 500;
        display: block;
        white-space: nowrap; /* 한 줄로 표시 */
        overflow: hidden;    /* 넘치는 내용 숨김 */
        text-overflow: ellipsis; /* 넘치는 내용은 ...으로 표시 */
    }
    .card .author-info { /* 작성자 정보 (필요시 사용) */
        font-size: 0.85em;
        color: #777;
        margin-top: 8px;
    }

    /* 반응형 그리드 조정 */
    @media screen and (max-width: 1024px) {
        .cards-container {
            grid-template-columns: repeat(3, 1fr); /* 3열 */
        }
        main {
            width: 90%;
        }
    }
    @media screen and (max-width: 768px) {
        .cards-container {
            grid-template-columns: repeat(2, 1fr); /* 2열 */
        }
        main {
            width: 95%;
        }
        .category-links li {
            margin: 8px 10px;
        }
        .category-links img {
            width: 70px;
            height: 70px;
        }
    }
    @media screen and (max-width: 480px) {
        .cards-container {
            grid-template-columns: 1fr; /* 1열 */
        }
        .card .image {
            height: 280px;
        }
         .category-links img {
            width: 60px;
            height: 60px;
        }
    }

    /* 고정 등록 버튼 */
    .fixed-register {
        position: fixed;
        right: 30px;
        bottom: 30px;
        z-index: 1000;
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 50%;
        width: 60px;
        height: 60px;
        font-size: 24px; /* 아이콘 크기 조절을 위해 사용 */
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        text-decoration: none;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        transition: background-color 0.2s ease;
    }
    .fixed-register:hover {
        background-color: #0056b3;
    }
    .fixed-register .material-icons {
        font-size: 28px; 
        line-height: 1; /* 아이콘 수직 정렬 */
    }

    /* 고정 등록 버튼 반응형 */
    @media screen and (max-width: 768px) {
        .fixed-register {
            width: 55px;
            height: 55px;
            right: 20px;
            bottom: 20px;
        }
        .fixed-register .material-icons {
            font-size: 26px;
        }
    }
    @media screen and (max-width: 480px) {
        .fixed-register {
            width: 50px;
            height: 50px;
        }
        .fixed-register .material-icons {
            font-size: 24px;
        }
    }
    
    /* 데이터 없을 때 메시지 */
    .no-reviews-message {
        text-align: center;
        color: #6c757d;
        width: 100%;
        grid-column: 1 / -1; /* 그리드 전체 컬럼 차지 */
        padding: 50px 0;
        font-size: 1.1em;
    }
    /* 다른 페이지에서 포워드된 에러 메시지 (선택 사항) */
    .error-message-list {
        color: red;
        text-align: center;
        background-color: #ffebee;
        padding: 10px;
        border: 1px solid red;
        margin-bottom: 20px;
        border-radius: 4px;
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/common/header.jsp" />

  <main>
    <%-- 다른 페이지에서 errorMsg와 함께 포워드/리다이렉트된 경우 메시지 표시 --%>
    <c:if test="${not empty requestScope.errorMsg}"> 
        <p class="error-message-list"><c:out value="${requestScope.errorMsg}"/></p>
    </c:if>

    <section class="category-links">
      <ul>
        <li class="${(empty selectedCategory || selectedCategory eq 'all') ? 'active' : ''}">
	        <a href="${pageContext.request.contextPath}/review/list?category=all">
		        <img src="${pageContext.request.contextPath}/resources/images/category/all_icon.png" alt="전체 카테고리">
		        <div>전체</div>
	        </a>
        </li>
        <li class="${selectedCategory eq 'A01' ? 'active' : ''}">
        	<a href="${pageContext.request.contextPath}/review/list?category=A01">
        		<img src="${pageContext.request.contextPath}/resources/images/category/male_icon.png" alt="남성 카테고리">
        		<div>남성</div>
       		</a>
      	</li>
        <li class="${selectedCategory eq 'A02' ? 'active' : ''}">
	        <a href="${pageContext.request.contextPath}/review/list?category=A02">
		        <img src="${pageContext.request.contextPath}/resources/images/category/female_icon.png" alt="여성 카테고리">
		        <div>여성</div>
	        </a>
        </li>
        <li class="${selectedCategory eq 'A03' ? 'active' : ''}">
	        <a href="${pageContext.request.contextPath}/review/list?category=A03">
		        <img src="${pageContext.request.contextPath}/resources/images/category/unisex_icon.png" alt="공용 카테고리">
		        <div>공용</div>
	        </a>
        </li>
      </ul>
    </section>

    <div class="style-review-board">
      <div class="cards-container">
        <c:choose>
          <c:when test="${not empty reviewList}">
            <c:forEach var="review" items="${reviewList}">
              <%-- 카드 전체를 상세 페이지 링크로 만듦 --%>
              <a href="${pageContext.request.contextPath}/review/detail?stylePostNo=${review.stylePostNo}" class="card">
                  <div class="image">
                    <c:choose>
                      <c:when test="${not empty review.fileList and not empty review.fileList[0].filePath}">
                        <img src="${pageContext.request.contextPath}${review.fileList[0].filePath}" alt="<c:out value='${review.postTitle}'/> 썸네일" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/images/no_image.png';" />
                      </c:when>
                      <c:otherwise>
                        <img src="${pageContext.request.contextPath}/resources/images/no_image.png" alt="기본 이미지" />
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="image-info">
                    <span class="image-style"><c:out value="${review.postTitle}"/></span>
                  </div>
              </a>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <p class="no-reviews-message">등록된 스타일 후기가 없습니다.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    
    <%-- 로그인한 경우에만 등록 버튼 표시 --%>
    <c:if test="${not empty sessionScope.loginMember}">
        <a href="/review/writeFrm" class="fixed-register" title="스타일 후기 등록">
            <span class="material-icons">edit</span>
        </a>
    </c:if>
  </main>

  <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>