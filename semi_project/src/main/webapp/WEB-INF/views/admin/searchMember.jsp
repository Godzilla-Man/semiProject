<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 조회</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<div class="admin-page">
			<table class="tbl-member">
				<tr>
					<th colspan="10">${member.memberNo} 조회</th>
				</tr>
				<tr>
					<th>신고 당한 횟수</th>
					<th>닉네임</th>
					<th>이름</th>
					<th>생년월일</th>
					<th>전화번호</th>
					<th>이메일</th>
					<th>주소</th>
					<th>가입일</th>
					<th>블랙 여부</th>
				</tr>
				<tr>
					<th>${member.reportedCount}</th>
					<td>${member.memberNickname}</td>
					<td>${member.memberName}</td>
					<td>${member.memberBirth}</td>
					<td>${member.memberPhone}</td>
					<td>${member.memberEmail}</td>
					<td>${member.memberAddr}</td>
					<td>${member.join_date}</td>
					<td>
						<c:choose>
							<c:when test="${member.blackCount gt 0}">O</c:when>
							<c:otherwise>X</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
		</div>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
</body>
</html>