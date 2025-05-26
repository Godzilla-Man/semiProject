
<%@page import="kr.or.iei.product.model.vo.Product"%>
<%@page import="kr.or.iei.reviewNotice.model.service.ReviewNoticeService"%>
<%@page import="kr.or.iei.reviewNotice.model.vo.ReviewNotice"%>

<%@page import="kr.or.iei.file.model.vo.Files"%>
<%@page import="java.util.List"%>
<%@page import="kr.or.iei.event.model.service.EventService"%>
<%@page import="kr.or.iei.member.model.vo.Member"%>

<%@page import="java.util.ArrayList"%>
<%@page import="kr.or.iei.product.model.service.ProductService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	// 로그인 정보 확인 (세션에서 추출)
	String memberNo = null;
	String memberId = null;
	Member loginMember = null;

	session = request.getSession(false);
	if (session != null) {
		loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember != null) {
			memberNo = loginMember.getMemberNo();
			memberId = loginMember.getMemberId(); // ← 관리자 여부 판단용
		}
	}

	// 상품 목록 조회 (관리자 분기 포함 구조)
	// 관리자일 경우 삭제된 상품(S99)도 조회됨, 일반 회원은 제외
	ProductService pService = new ProductService();
	ArrayList<Product> productList = pService.selectAllListDesc(memberNo, memberId);

	// 리뷰공지 목록 조회
	ReviewNoticeService rService = new ReviewNoticeService();    
	ArrayList<ReviewNotice> reviewList = rService.selectAllReviewList();

	// 이벤트 썸네일 파일 리스트 조회 (이벤트 1개당 1개 썸네일)
	EventService eService = new EventService();
	List<Files> fileList = eService.selectFirstEventFileList();

	// 뷰 페이지로 전달
	request.setAttribute("productList", productList);
	request.setAttribute("reviewList", reviewList);
	request.setAttribute("fileList", fileList);
%>



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
			<c:forEach var="file" items="${fileList}" varStatus="status">
	        <img src="${file.filePath}" alt="이벤트 이미지 ${status.index+1}" class="main-image" onclick="eventClick('${file.eventNo}')" style="width: 1000px; height: 400px; margin: 0 auto; display: block; cursor: pointer;">
	        </c:forEach>
	        <span><a href="/product/allListDesc">최신 등록 상품</a></span> <%-- 클릭 시 전체 상품 화면으로 이동 --%>
    		<div class="style-review-board">
				<div class="cards-container">
					<!-- reviewList가 request scope에 있는 경우 반복문으로 카드 출력 -->
					<c:choose>
						<c:when test="${empty productList}">
							<span style="display: block; width: 250px;">등록된 상품이 없습니다.</span>
						</c:when>
						<c:otherwise>
							<c:forEach var="prod" items="${productList}" begin="0" end="7">
							<div style="color: inherit; text-decoration: none;">
								<div class="card">
									<div class="image">
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
										<span class="image-price"><fmt:formatNumber value="${prod.productPrice}" type="number"/>원</span>
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
	        <span><a href="/review/list">스타일 후기</a></span>
			<div class="style-review-board">
				<div class="cards-container">
					<!-- reviewList가 request scope에 있는 경우 반복문으로 카드 출력 -->
					<c:choose>
						<c:when test="${empty reviewList}">
							<span style="display: block; width: 250px;">등록된 스타일 후기가 없습니다.</span>
						</c:when>
						<c:otherwise>
							<c:forEach var="review" items="${reviewList}" begin="0" end="7">
							<div style="color: inherit; text-decoration: none;">
								<div class="card">
									<div class="image">
										<img src="${review.filePath}" alt="${review.postTitle}" onclick="clickReview('${review.stylePostNo}')">
									</div>
									<div class="image-info">
										<span class="image-prod"><a href="/review/detail?stylePostNo=${review.stylePostNo}">${review.postTitle}</a></span>
									</div>
								</div>
							</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
        	<button onclick="styleReview()">+ 더보기</button>
    	</div>
    	
		<div class="fixed" style="right: 280px;">
			<%-- 로그인 시에만 판매 글을 올릴 수 있는 등록 버튼 표시 --%>
			<c:if test="${!empty sessionScope.loginMember}">
			<div class="post" onclick="productEnroll()" title="상품 등록">
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
	 	
	 	//이벤트 사진 클릭시 게시글로 이동
	 	function eventClick(eventNo){
	 		location.href="/event/view?eventNo=" + eventNo + "&updChk=true";
	 	}
	 	
		//첫 번째 더보기 클릭 시 전체 판매 상품 페이지로 이동
		function fullProduct() {
			location.href="/product/allListDesc";
		}
		//두 번째 더보기 클릭 시 스타일 후기 게시판으로 이동
		function styleReview() {
			location.href="/review/list";
		}
		//클릭 시 해당 상품 상세 페이지로 이동
		function clickProd(productNo) {
			location.href="/product/detail?no=" + productNo;
		}
	
		function clickReview(reviewNo){
			location.href="/review/detail?stylePostNo=" + reviewNo;
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