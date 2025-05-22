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
			<div class="category">
				<span>'${search}'(으)로 검색하신 결과입니다.</span>
			</div>
			<div class="filter">
	            <select id="filter" onchange="filterChange(this, '${search}', '${searchOption}')">
	                <option value="newest" selected>최신순</option>
	                <option value="oldest">오래된순</option>
	                <option value="cheaper">최저가순</option>
	                <option value="expensive">최고가순</option>
	                <option value="setPrice">가격설정</option>
	            </select>
	        	<div class="price-range" style="display: none;">
	        		<input type="number" id="minPrice" placeholder="최소 가격"> ~ 
	        		<input type="number" id="maxPrice" placeholder="최대 가격" max="1000000000">
	        		<button id="priceFilter" onclick="priceFilter(this, '${search}', '${searchOption}')">적용</button>
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
										<%-- 이미지 출력 절차 --%>
										<c:choose>
											<c:when test="${empty prod.filePath}">
											<img src="/" alt="해당 상품에 등록된 이미지가 존재하지 않습니다." onclick="clickProd('${prod.productNo}')">
											</c:when>
											<c:otherwise>
											<img src="${prod.filePath}" alt="${prod.productName}" onclick="clickProd('${prod.productNo}')">
											</c:otherwise>
										</c:choose>
										<c:if test="${not empty sessionScope.loginMember}">
											<c:if test="${prod.wishYn eq 'Y'}">
												<span class="material-symbols-outlined fill" onclick="delWhishList(this, '${loginMember.memberNo}', '${prod.productNo}')">favorite</span>
											</c:if>
											<c:if test="${prod.wishYn ne 'Y'}">
												<span class="material-symbols-outlined" onclick="addWishList(this, '${loginMember.memberNo}', '${prod.productNo}')">favorite</span>
											</c:if>
										</c:if>
									</div>
									<div class="image-info">
										<span class="image-prod"><a href="/product/detail?no=${prod.productNo}">${prod.productName}</a></span>
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
		
		<div class="fixed" style="right: 280px;">
			<%-- 로그인 시에만 판매 글을 올릴 수 있는 등록 버튼 표시 --%>
			<c:if test="${!empty sessionScope.loginMember}">
			<div class="post" onclick="productEnroll()">
				<span class="material-symbols-outlined">add</span>
			</div>
			</c:if>
			<div class="top" onclick="scrollToTop()">
				<span class="material-symbols-outlined">arrow_upward</span>
			</div>
		</div>
		
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	
	<script>
	 	//로그인 후 우측 하단 + 버튼 클릭 시 상품 판매 페이지로 이동
	 	function productEnroll() {
	 		location.href = "/product/enroll";
	 	}
	 
	 	//우측 하단 ↑ 버튼 클릭 시 상단으로 스크롤 이동
	    function scrollToTop() {
	        window.scrollTo({
	        top: 0,
	        behavior: 'smooth' // 부드럽게 스크롤
	        });
	    }
		//필터 항목에서 설정 변경 시
		function filterChange(obj, search, searchOption){
			switch($(obj).val()){
			case "newest" :
				$(".price-range").hide();
				location.href="/product/searchListDesc?search=" + search + "&searchOption=" + searchOption;
				break;
			case "oldest" :
				$(".price-range").hide();
				location.href="/product/searchListAsc?search=" + search + "&searchOption=" + searchOption;
				break;
			case "cheaper" :
				$(".price-range").hide();
				location.href="/product/searchListCheap?search=" + search + "&searchOption=" + searchOption;
				break;
			case "expensive" :
				$(".price-range").hide();
				location.href="/product/searchListExpen?search=" + search + "&searchOption=" + searchOption;
				break;
			case "setPrice" :
				$(".price-range").show();
				break;
			}
		}
		//가격설정 필터
		function priceFilter(obj, search, searchOption){
			let min = $("#minPrice").val();
			let max = $("#maxPrice").val();
			if(min === ""){
				min = '0';
			}
			if(max === ""){
				max ='0';
			}
			location.href="/product/searchListPrice?min=" + min + "&max=" + max + "&search=" + search + "&searchOption=" + searchOption;
		}
	
		//클릭 시 해당 상품 상세 페이지로 이동
		function clickProd(productNo) {
			location.href="/product/detail?no=" + productNo;
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
								$(obj).attr("onclick", "delWhishList(this, '" + memberNo + "', '" + productNo + "')");
								
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
		function delWhishList(obj, memberNo, productNo) {
			swal({
				title : "알림",
				text : "해당 상품을 찜하기 리스트에 삭제하시겠습니까?",
				icon : "warning",
				buttons : {
					cancel : {
						text : "취소",
						value : false,
						visible : true,
						closeModal : true
					},
					confirm : {
						text : "삭제",
						value : true,
						visible : true,
						closeModal : true
					}
				}
			}).then(function(val){
				if(val){ //삭제 버튼 클릭 시
					$.ajax({
						url : "/product/delWishList",
						data : {"memberNo" : memberNo, "productNo" : productNo},
						type : "get",
						success : function(res){
							if(res > 0){ //찜하기 성공
								swal({
									title : "성공",
									text : "찜하기 리스트에서 삭제되었습니다.",
									icon : "success"
								});
								
								//클릭시 스타일 변경
								$(obj).attr("class", "material-symbols-outlined");
								$(obj).attr("onclick", "addWishList(this, '" + memberNo + "', '" + productNo + "')");
								
							}else{ //찜하기 삭제 실패
								swal({
									title : "실패",
									text : "찜하기 리스트 삭제 중 오류가 발생했습니다.",
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
	</script>
</body>
</html>