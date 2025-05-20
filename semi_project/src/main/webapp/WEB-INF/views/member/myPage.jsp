<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
								<li class="tab-link current" data-tab="tab-wishList">
									<a href="#">관심목록</a>
								</li>
								<li class="tab-link" data-tab="tab-salesList">
									<a href="#">판매내역</a>
								</li>
								<li class="tab-link" data-tab="tab-purchaseList">
									<a href="#">구매내역</a>
								</li>
							</ul>
							<div class="content on" id="tab-wishList">
								관심목록입니다.
							</div>
							<div class="content" id="tab-salesList">
								판매내역입니다.
							</div>
							<div class="content" id="tab-purchaseList">
								구매내역입니다.
							</div>
						</div>
					</form>
			</section>
		</main>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	<script>
		//관심목록/판매내역/구매내역 탭메뉴 기능
		const tabLink = $('.tab-link');
		const content = $('.content');
		
		$(tabLink).click(function(e) {
			e.preventDefault();
			
			var current = $(this).attr('data-tab');
			
			$(tabLink).removeClass('current');
			$(content).removeClass('on');
			
			$(this).addClass('on');
			$(this).addClass('current');
			$('#' + current).addClass('on');
		});
	</script>
</body>
</html>