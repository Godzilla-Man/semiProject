<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
	    <div class="view-wrap">
	        <div class="notice-header">
	            <div class="notice-title"><a href="/event/list?reqPage=1">이벤트</a></div>
	            <c:if test="${loginMember.memberId eq 'admin'}">
	            <div class="div-btn">
	                <a class="write-btn" href="/event/updateFrm?eventNo=${event.eventNo}">수정</a>
	                <button class="del-btn" onclick="deleteEvent('${event.eventNo}')">삭제</button>
	            </div>
				</c:if>
	        </div>
	        <div class="notice-view">
	            <table>
	                <tr>
	                    <th style="width: 10%; font-size: 20px; border-right: 1px solid black; border-top: 1px solid black;">제 목</th>
	                    <td colspan="5" style="width: 80%; font-size: 20px; padding-left: 10px; border-top: 1px solid black;">${event.eventTitle}</td>
	                </tr>
	                <tr>
	                    <th style="width: 10%; border-right: 1px solid black;">작성자</th>
	                    <td style="width: 35%; border-right: 1px solid black; padding-left: 10px;">${event.memberNo}</td>
	                    <th style="width: 10%; border-right: 1px solid black;">작성일</th>
	                    <td style="width: 30%; border-right: 1px solid black; padding-left: 10px;">${event.eventEnrollDate}</td>
	                    <th style="width: 10%; border-right: 1px solid black;">조회수</th>
	                    <td style="width: 5%; padding-left: 10px;">${event.readCount}</td>
	                </tr>
	                <tr>
	                    <td colspan="6" style="border-bottom: none;">
	                    	<div style="height: 400px;">
		                        <img src="/">
								${event.eventContent}
	                    	</div>
	                    </td>
	                </tr>
	            </table>
	        </div>
	        <%-- 클릭하면 다음글, 이전글로 넘어가는 div
	        	 추후 구현 가능하면 시도
	        <div>
	            <div class="next-notice">
	                <span>다음글 ↑</span>
	                <span><a href="#">제목 : ㅇㅇ</a></span>
	            </div>
	            <div class="next-notice">
	                <span>이전글 ↓</span>
	                <span><a href="#">제목 : ㅇㅇ</a></span>
	            </div>
	        </div>
	        --%>
	    </div>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	
	<script>
	//게시글 삭제
	function deleteEvent(eventNo){
		swal({
			title : "삭제",
			text : "게시글을 삭제하시겠습니까?",
			icon : "warning",
			buttons : {
				cancel : {
					text : "취소",
					value : false,
					visible : true,
					closeModal : true
				},
				confirm : {
					text : "삭제",
					value : true,
					visible : true,
					closeModal : true
				}
			}
		}).then(function(val){
			if(val){
				location.href = "/event/delete?eventNo=" + eventNo;
			}
		});
	}
	</script>
</body>
</html>