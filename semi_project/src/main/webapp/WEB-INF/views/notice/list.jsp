<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	    <div class="notice-wrap">
	        <div class="page-header">
	            <div class="page-title">공지사항</div>
	            <div>
					<a class="btn-point write-btn" href="#">글쓰기</a>
				</div>
	        </div>
	        <div class="list-content">
	            <table class="tbl-list">
	                <tr>
	                    <th style="width:55%;">제목</th>
	                    <th style="width:15%;">작성자</th>
	                    <th style="width:20%;">작성일</th>
	                    <th style="width:10%;">조회수</th>
	                </tr>
	                <tr>
	                    <td>공지사항1</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	                <tr>
	                    <td>공지사항2</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	                <tr>
	                    <td>공지사항3</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	                <tr>
	                    <td>공지사항4</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	                <tr>
	                    <td>공지사항5</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	                <tr>
	                    <td>공지사항6</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	                <tr>
	                    <td>공지사항7</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	                <tr>
	                    <td>공지사항8</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	                <tr>
	                    <td>공지사항9</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	                <tr>
	                    <td>공지사항10</td>
	                    <td>관리자</td>
	                    <td>2025.05.14</td>
	                    <td>0</td>
	                </tr>
	            </table>
	        </div>
	        <div id="pageNavi">${pageNavi}</div>
	    </div>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
</body>
</html>