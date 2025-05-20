<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<style>
.main-menu>li:nth-child(4) {
	font-weight: bold;
}
</style>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	    <div class="write-notice">
	        <div class="write-title">공지사항 수정</div>
	        <form action="/notice/update" method="post" enctype="multipart/form-data">
	        	<input type="hidden" name="noticeNo" value="${notice.noticeNo}">
	            <table class="write-tbl">
	                <tr>
	                    <th>제목</th>
	                    <td>
	                        <input type="text" name="noticeTitle" value="${notice.noticeTitle}">
	                    </td>
	                </tr>
	                <tr>
	                    <th style="width: 20%;">내용</th>
	                    <td style="width: 80%;">
	                        <textarea name="noticeContent">${notice.noticeContent}</textarea>
	                    </td>
	                </tr>
	                <tr>
	                    <th>첨부파일</th>
	                    <td>
	                        <input type="file" name="noticeFile" multiple>
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="2">
	                        <button type="submit">수정</button>
	                    </td>
	                </tr>
	            </table>
	        </form>
	    </div>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
</body>
</html>