<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/notice.css">
<title>이벤트</title>
<style>
.main-menu>li:nth-child(3) {
	font-weight: bold;
}
</style>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	    <div class="notice-wrap">
			<div class="page-header">
				<div class="page-title">이벤트</div>
				<c:if test="${loginMember.memberId eq 'admin'}">
				<div>
					<a class="btn-point write-btn" href="#">글쓰기</a>
				</div>
				</c:if>
			</div>
			<div class="list-content">
				<table class="tbl-list">
					<tr>
						<th style="width:55%;">제목</th>
						<th style="width:15%;">작성자</th>
						<th style="width:20%;">작성일</th>
						<th style="width:10%;">조회수</th>
					</tr>
					<c:forEach var="event" items="${eventList}">
					<tr>
						<td>${event.eventTitle}</td>
						<td>${event.memberNo}</td>
						<td>${event.eventEnrollDate}</td>
						<td>${event.readCount}</td>
					</tr>
					</c:forEach>
				</table>
			</div>
			<div id="pageNavi">${pageNavi}</div>
	   	</div>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
</body>
</html>