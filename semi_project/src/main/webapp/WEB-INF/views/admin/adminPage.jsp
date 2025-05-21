<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리 페이지</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<div class="admin-page">
			<div class="admin-page-sub">
				<span>관리 페이지</span>
				<div>
					<div class="search-member">
						<a href="/admin/allMember">전체 회원 조회</a>
						<div class="count">
							<span>금일 가입 회원</span>
							<div>${mCnt}명</div>
						</div>
					</div>
					<div class="search-report">
						<a href="/admin/report">신고 내역 조회</a>
						<div class="count">
							<span>금일 신고 건수</span>
							<div>${rCnt}건</div>
						</div>
					</div>
					<div class="search-black">
						<a href="/admin/blackList">블랙 회원 조회</a>
						<div class="count">
							<span>금일 블랙 건수</span>
							<div>${bCnt}건</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
</body>
</html>