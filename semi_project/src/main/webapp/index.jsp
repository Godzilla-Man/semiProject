<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	        <span><a href="/product/allList">최신 등록 상품</a></span> <%-- 클릭 시 전체 상품 화면으로 이동 --%>
    		<div class="style-review-board">
				<div class="cards-container">
					<!-- reviewList가 request scope에 있는 경우 반복문으로 카드 출력 -->
					<c:choose>
						<c:when test="${empty productList}">
							<span style="display: block; width: 250px;">해당하는 상품이 존재하지 않습니다.</span>
						</c:when>
						<c:otherwise>
							<c:forEach var="prod" items="${productList}" begin="0" end="7">
							<div style="color: inherit; text-decoration: none;">
								<div class="card">
									<div class="image">
										<img src="/" alt="${prod.productName}" onclick="clickProd('${prod.productNo}')">
										<c:if test="${not empty sessionScope.loginMember}">
										<span class="material-symbols-outlined" onclick="addWishList(this)">favorite</span>
										</c:if>
									</div>
									<div class="image-info" onclick="clickProd(this)">
										<span class="image-prod"><a href="/?=productNo=${prod.productNo}">${prod.productName}</a></span>
										<span class="image-price">${prod.productPrice}</span>
									</div>
								</div>
							</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
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
		//첫 번째 더보기 클릭 시 전체 판매 상품 페이지로 이동
		function fullProduct() {
			location.href="/product/allList";
		}
		//두 번째 더보기 클릭 시 스타일 후기 게시판으로 이동
		function styleReview() {
			location.href="/";
		}
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