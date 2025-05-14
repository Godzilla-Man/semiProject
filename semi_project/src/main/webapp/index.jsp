<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/resources/css/main.css"> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ZUP ZUP</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<div class="main-wrap">
	        <img src="/" class="main-image">
	        <span><a href="#">최신 등록 상품</a></span> <%-- 클릭 시 전체 상품 화면으로 이동 --%>
	        <div class="sub-image">
	            <div>
	                <div class="image">
	                    <img src="/" onclick="clickProd(this)"> <%-- 최신 상품 이미지 url --%>
	                    <span class="material-symbols-outlined" onclick="addWishList(this)">favorite</span>
	                </div>
	                <div class="image-info" onclick="clickProd(this)">
	                    <span class="image-prod">상품명이 길면은 어떻게 보일까나</span>
	                    <span class="image-price">10,000원</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/" onclick="clickProd(this)">
	                    <span class="material-symbols-outlined" onclick="addWishList(this)">favorite</span>
	                </div>
	                <div class="image-info" onclick="clickProd(this)">
	                    <span class="image-prod">상품명</span>
	                    <span class="image-price">가격</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/" onclick="clickProd(this)">
	                    <span class="material-symbols-outlined" onclick="addWishList(this)">favorite</span>
	                </div>
	                <div class="image-info" onclick="clickProd(this)">
	                    <span class="image-prod">상품명</span>
	                    <span class="image-price">가격</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/" onclick="clickProd(this)">
	                    <span class="material-symbols-outlined" onclick="addWishList(this)">favorite</span>
	                </div>
	                <div class="image-info" onclick="clickProd(this)">
	                    <span class="image-prod">상품명</span>
	                    <span class="image-price">가격</span>
	                </div>
	            </div>
	        </div>
	        <div class="sub-image">
	            <div>
	                <div class="image">
	                    <img src="/" onclick="clickProd(this)">
	                    <span class="material-symbols-outlined" onclick="addWishList(this)">favorite</span>
	                </div>
	                <div class="image-info" onclick="clickProd(this)">
	                    <span class="image-prod">상품명</span>
	                    <span class="image-price">가격</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/" onclick="clickProd(this)">
	                    <span class="material-symbols-outlined" onclick="addWishList(this)">favorite</span>
	                </div>
	                <div class="image-info" onclick="clickProd(this)">
	                    <span class="image-prod">상품명</span>
	                    <span class="image-price">가격</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/" onclick="clickProd(this)">
	                    <span class="material-symbols-outlined" onclick="addWishList(this)">favorite</span>
	                </div>
	                <div class="image-info" onclick="clickProd(this)">
	                    <span class="image-prod">상품명</span>
	                    <span class="image-price">가격</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/" onclick="clickProd(this)">
	                    <span class="material-symbols-outlined" onclick="addWishList(this)">favorite</span>
	                </div>
	                <div class="image-info" onclick="clickProd(this)">
	                    <span class="image-prod">상품명</span>
	                    <span class="image-price">가격</span>
	                </div>
	            </div>
	        </div>
	        <button onclick="fullProduct()">+ 더보기</button>
	        <hr>
	        <span><a href="#">스타일 후기</a></span>
	        <div class="sub-image">
	            <div>
	                <div class="image">
	                    <img src="/">
	                </div>
	                <div class="image-info">
	                    <span class="image-style">이번 봄에 이렇게 입으려고 하는데 어떤가요</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/">
	                </div>
	                <div class="image-info">
	                    <span class="image-style">스타일 후기 제목</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/">
	                </div>
	                <div class="image-info">
	                    <span class="image-style">스타일 후기 제목</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/">
	                </div>
	                <div class="image-info">
	                    <span class="image-style">스타일 후기 제목</span>
	                </div>
	            </div>
        	</div>
        	<div class="sub-image">
	            <div>
	                <div class="image">
	                    <img src="/">
	                </div>
	                <div class="image-info">
	                    <span class="image-style">스타일 후기 제목</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/">
	                </div>
	                <div class="image-info">
	                    <span class="image-style">스타일 후기 제목</span>
	                </div>
	            </div>
	            <div>
	                <div class="image">
	                    <img src="/">
	                </div>
	                <div class="image-info">
	                    <span class="image-style">스타일 후기 제목</span>
	                </div>
	            </div>
            	<div>
	                <div class="image">
	                    <img src="/">
	                </div>
	                <div class="image-info">
	                    <span class="image-style">스타일 후기 제목</span>
	                </div>
            	</div>
        	</div>
        	<button onclick="styleReview()">+ 더보기</button>
    	</div>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	
	<script>
		//클릭 시 해당 상품 상세 페이지로 이동
		function clickProd(obj) {
			location.href="http://www.naver.com";
		}
	
		//찜하기 추가
		function addWishList(obj) {
			//1. 로그인이 안 되어 있는데 클릭 시 로그인하라는 알림창 띄워주기
			//2. 로그인이 되어 있으면 클릭 시 스타일 변경 및 찜한 상품에 등록
			$(obj).attr("class", "material-symbols-outlined fill");
			$(obj).attr("onclick", "delWhishList(this)");
		}
		
		//찜하기 삭제
		function delWhishList(obj) {
			//1. 클릭 시 스타일 변경 및 찜한 상품에서 삭제
			$(obj).attr("class", "material-symbols-outlined");
			$(obj).attr("onclick", "addWishList(this)");
		}
	</script>
</body>
</html>