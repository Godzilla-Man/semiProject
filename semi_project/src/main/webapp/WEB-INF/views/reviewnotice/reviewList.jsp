<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>스타일 후기 게시판</title>
  <style>
    main {
      width: 80%;
      max-width: 1000px;
      margin: 0 auto;
    }
    .category-links {
      margin: 20px auto;
      width: 100%;
      text-align: center;
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
      margin: 10px;
      text-align: center;
    }
    .category-links a {
      text-decoration: none;
      color: #333;
    }
    .category-links img {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      object-fit: cover;
      border: 2px solid #ddd;
      display: block;
      margin: 0 auto 5px;
    }

    .style-review-board {
      width: 100%;
      margin: 20px 0;
    }
    .cards-container {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
    }
    .card {
      border: 1px solid #eee;
      border-radius: 5px;
      overflow: hidden;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      background: #fafafa;
      display: flex;
      flex-direction: column;
      transition: transform 0.2s ease-in-out;
    }
    .card:hover {
      transform: scale(1.02);
    }
    .card .image {
      width: 100%;
      height: 200px;
      background-color: #ccc;
    }
    .card .image img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .card .image-info {
      padding: 15px;
      width : 100%;
    }
    .card .image-style {
      font-size: 14px;
      color: #555;
    }

    @media screen and (max-width: 1024px) {
      .cards-container {
        grid-template-columns: repeat(3, 1fr);
      }
    }
    @media screen and (max-width: 768px) {
      .cards-container {
        grid-template-columns: repeat(2, 1fr);
      }
    }
    @media screen and (max-width: 480px) {
      .cards-container {
        grid-template-columns: 1fr;
      }
    }

    .fixed-register {
      position: fixed;
      right: 20px;
      bottom: 20px;
      z-index: 1000;
      background-color: #0066cc;
      color: #fff;
      border: none;
      border-radius: 50%;
      width: 60px;
      height: 60px;
      font-size: 16px;
      display: flex;
      justify-content: center;
      align-items: center;
      cursor: pointer;
    }
    @media screen and (max-width: 768px) {
      .fixed-register {
        width: 50px;
        height: 50px;
        font-size: 14px;
      }
    }
    @media screen and (max-width: 480px) {
      .fixed-register {
        width: 40px;
        height: 40px;
        font-size: 12px;
      }
    }
  </style>
</head>
<body>
  <!-- 헤더 영역 -->
  <jsp:include page="/WEB-INF/views/common/header.jsp" />

  <main>
    <!-- 카테고리 링크 -->
    <section class="category-links">
      <ul>
        <li>
          <a href="/review/list?category=5일챌린지">
            <img src="/" alt="5일챌린지">
            <div>남성</div>
          </a>
        </li>
        <li>
          <a href="/review/list?category=여성준비">
            <img src="/" alt="여성준비">
            <div>여성</div>
          </a>
        </li>
        <li>
          <a href="/review/list?category=반팔코디">
            <img src="/" alt="반팔코디">
            <div>공용</div>
          </a>
        </li>
      </ul>
    </section>

    <!-- 게시판 카드 리스트 -->
    <div class="style-review-board">
      <div class="cards-container">
        <c:forEach var="review" items="${reviewList}">
		  <a href="/review/detail?stylePostNo=${review.stylePostNo}" style="text-decoration: none; color: inherit;">
		    <div class="card">
		      <div class="image">
		        <c:choose>
		          <c:when test="${not empty review.fileList}">
		            <img src="/upload/${review.fileList[0].fileRename}" alt="썸네일 이미지" />
		          </c:when>
		          <c:otherwise>
		            <img src="/img/no-image.png" alt="기본 이미지" />
		          </c:otherwise>
		        </c:choose>
		      </div>
		      <div class="image-info">
		        <span class="image-style">${review.postTitle}</span>
		      </div>
		    </div>
		  </a>
		</c:forEach>

      </div>
    </div>

    <!-- 등록 버튼 -->
    <form action="/review/writeFrm" method="get">
      <button type="submit" class="fixed-register" title="스타일 후기 등록">등록</button>
    </form>
  </main>

  <!-- 푸터 영역 -->
  <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
