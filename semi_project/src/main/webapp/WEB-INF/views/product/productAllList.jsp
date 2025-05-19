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
										<span class="material-symbols-outlined" onclick="addWishList(this, '${loginMember.memberNo}', '${prod.productNo}')">favorite</span>
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
		function addWishList(obj, memberNo, productNo) {
			swal({
				title : "알림",
				text : "해당 상품을 찜하기 리스트에 추가하시겠습니까?",
				icon : "warning",
				buttons : {
					cancel : {
						text : "취소",
						value : false,
						visible : true,
						closeModal : true
					},
					confirm : {
						text : "추가",
						value : true,
						visible : true,
						closeModal : true
					}
				}
			}).then(function(val){
				if(val){ //추가 버튼 클릭 시
					$.ajax({
						url : "/product/addWishList",
						data : {"memberNo" : memberNo, "productNo" : productNo},
						type : "get",
						success : function(res){
							if(res > 0){ //찜하기 성공
								swal({
									title : "성공",
									text : "찜하기 리스트에 추가되었습니다.",
									icon : "success"
								});
								
								//클릭시 스타일 변경
								$(obj).attr("class", "material-symbols-outlined fill");
								$(obj).attr("onclick", "delWhishList(this, " + memberNo + ", " + productNo + ")");
								
							}else if(res == 0){ //찜하기 실패
								swal({
									title : "실패",
									text : "찜하기 리스트 추가 중 오류가 발생했습니다.",
									icon : "error"
								});
							}else if(res == -1){ //이미 찜한 상품
								swal({
									title : "실패",
									text : "이미 찜한 상품입니다.",
									icon : "error"
								});
							}else{
								swal({ //내가 등록한 상품
									title : "실패",
									text : "내가 등록한 상품입니다.",
									icon : "error"
								});
							}
						},
						error : function(){
							console.log("ajax 통신 오류");
						}
					});
				}
			});
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