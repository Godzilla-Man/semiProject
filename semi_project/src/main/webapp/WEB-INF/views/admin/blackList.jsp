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
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
</body>
</html>