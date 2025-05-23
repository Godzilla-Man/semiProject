<%@page import="kr.or.iei.product.model.service.ProductService"%>
<%@page import="kr.or.iei.member.model.vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	
	//메인 화면에서 서블릿을 거치지 않고 DB에 있는 정보 가져오기 위한 작업
	String memberNo = null;
	Member loginMember = null;
	session = request.getSession(false);
	if(session != null){
		loginMember = (Member) session.getAttribute("loginMember");
		
		if(loginMember != null){			
			memberNo = loginMember.getMemberNo();
		}
	}

	ProductService pService = new ProductService();
	int getWishCount = 0;
	int wishCount = 0;
	int salesCount = 0;
	int purchaseCount = 0;
	
	request.setAttribute("getWishCount", getWishCount);
	request.setAttribute("wishCount", wishCount);
	request.setAttribute("salesCount", salesCount);
	request.setAttribute("purchaseCount", purchaseCount);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/myPage.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<title>마이페이지</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<main class="contents myPage-container">
			<section class="section myPage-wrap">
				<div class="page-title">마이페이지</div>
					<form id="updateForm" 
					      action="/member/checkPw" 
					      method="post">
						<div class="info-wrap">
							<div class="info-wrap-left">
								<ul class="info-item info-item-left">
									<li class="memberNickname">${loginMember.memberNickname } 님</li>
									<li class="memberEamil">${loginMember.memberEmail }</li>
									<li class="memberRate">${loginMember.member_rate }</li>
								</ul>
							</div>
							<div class="info-wrap-center">
								<button type="submit" class="btn-primary info-item info-item-center">정보 수정</button>
							</div>
							<div class="info-wrap-right">
								<ul class="info-item info-item-right">
									<li>관심목록 0</li>
									<li>판매내역 0</li>
									<li>구매내역 0</li>
								</ul>
							</div>
						</div>
						<div class="list-wrap">
							<ul class="menu-wrap">
								<li class="tab-link current" id="default" data-tab="myPageWishList">
									<a href="#">관심목록</a>
								</li>
								<li class="tab-link" data-tab="myPageSalesList">
									<a href="#">판매내역</a>
								</li>
								<li class="tab-link" data-tab="myPagePurchaseList">
									<a href="#">구매내역</a>
								</li>
							</ul>
							<div class="tab-content"></div>
						</div>
					</form>
			</section>
		</main>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	<script>
		//관심목록/판매내역/구매내역 탭메뉴 기능
		const tabLink = $('.tab-link');
		const tabContent = $('.tab-content')
		
		$(tabLink).click(function() {
			let current = $(this).attr('data-tab');
			
			$(tabLink).removeClass('current');
			$(this).addClass('current');
			
			$.ajax({
				url : "/member/" + current,
				type : "get",
				dataType : "html",
				success : function(data){					//비동기 통신 성공 시, 호출 함수
					$(tabContent).html(data);
				},
				error : function(){							//비동기 통신 에러 시, 호출 함수
					console.log("ajax : error");
				}
				
			});
		});
		
		$('#default').click();
		
		
	</script>
</body>
</html>