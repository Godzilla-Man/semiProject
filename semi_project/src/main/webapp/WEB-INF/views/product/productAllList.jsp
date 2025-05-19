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
			<div class="filter">
	            <select id="filter" onchange="filterChange()">
	                <option value="newest">최신순</option>
	                <option value="oldest">오래된순</option>
	                <option value="popular">인기순</option>
	                <option value="cheaper">최저가순</option>
	                <option value="expensive">최고가순</option>
	                <option value="setPrice">가격설정</option>
	            </select>
	        	<div class="price-range" style="display: none;">
	        		<input type="number" id="minPrice" placeholder="최소 가격"> ~ 
	        		<input type="number" id="maxPrice" placeholder="최대 가격">
	        		<button id="priceFilter">적용</button>
	        	</div>
        	</div>
    		<div class="style-review-board">
				<div class="cards-container">
					<!-- reviewList가 request scope에 있는 경우 반복문으로 카드 출력 -->
					<c:choose>
						<c:when test="${empty productList}">
							<span style="display: block; width: 250px;">해당하는 상품이 존재하지 않습니다.</span>
						</c:when>
						<c:otherwise>
							<c:forEach var="prod" items="${productList}">
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
										<span class="image-price">${prod.productPrice }</span>
									</div>
								</div>
							</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	
	<script>
		//필터 항목에서 가격 설정을 선택하면 가격 입력창이 나오게
		$(document).ready(function () {
			$('#filter').on('change', function () {
				if ($(this).val() === 'setPrice') {
					$('.price-range').show();  // 가격 설정 영역 표시
				} else {
					$('.price-range').hide();  // 그 외에는 숨김
				}
			});
		});
	
		//클릭 시 해당 상품 상세 페이지로 이동
		function clickProd(productNo) {
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