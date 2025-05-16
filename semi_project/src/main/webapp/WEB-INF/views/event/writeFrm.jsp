<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/noticeWrite.css">
<title>이벤트</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	    <div class="write-notice">
	        <div class="write-title">이벤트</div>
	        <form action="/event/write" method="post" enctype="multipart/form-data">
	        	<input type="hidden" name="eventWriter" value="${loginMember.memberNo}">
	            <table class="write-tbl">
	                <tr>
	                    <th>제목</th>
	                    <td>
	                        <input type="text" name="eventTitle">
	                    </td>
	                </tr>
	                <tr>
	                    <th style="width: 20%;">내용</th>
	                    <td style="width: 80%;">
	                        <textarea name="eventContent"></textarea>
	                    </td>
	                </tr>
	                <tr>
	                    <th>첨부파일</th>
	                    <td>
	                        <input type="file" name="eventFile" multiple>
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="2">
	                        <button type="submit">작성</button>
	                    </td>
	                </tr>
	            </table>
	        </form>
	    </div>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
</body>
</html>