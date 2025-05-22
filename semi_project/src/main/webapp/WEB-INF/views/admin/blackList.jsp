<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>블랙 리스트 조회</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<div class="admin-page">
			<div class="admin-menu">
				<a href="/admin/adminPage">관리자 페이지</a>
				<a href="/admin/allMember">전체 회원 조회</a>
				<a href="/admin/report">신고 내역 조회</a>
				<a href="/admin/blackList">블랙 리스트 조회</a>
			</div>
			<table class="tbl-member">
				<tr>
					<th colspan="6">블랙&nbsp;&nbsp;&nbsp;&nbsp;리스트&nbsp;&nbsp;&nbsp;&nbsp;조회</th>
				</tr>
				<tr>
					<th>블랙 번호</th>
					<th>블랙 회원 번호</th>
					<th>블랙 사유</th>
					<th>블랙 일시</th>
				</tr>
				<c:forEach var="blackList" items="${blackList}">
				<tr>
					<th>${blackList.blackNo}</th>
					<td><a href="/admin/searchMember?memberNo=${blackList.blackMemberNo}">${blackList.blackMemberNo}</a></td>
					<td>${blackList.blackReason}</td>
					<td>${blackList.blackDate}</td>
				</tr>
				</c:forEach>
			</table>
		</div>
		
		<div class="fixed" style="right: 280px;">
			<div class="top" onclick="scrollToTop()">
				<span class="material-symbols-outlined">arrow_upward</span>
			</div>
		</div>
		
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>

	<script>
	 	//우측 하단 ↑ 버튼 클릭 시 상단으로 스크롤 이동
	    function scrollToTop() {
	        window.scrollTo({
	        top: 0,
	        behavior: 'smooth' // 부드럽게 스크롤
	        });
	    }
	</script>
</body>
</html>