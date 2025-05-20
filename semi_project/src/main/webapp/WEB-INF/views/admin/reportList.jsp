<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고 내역 조회</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<div class="admin-page">
			<table class="tbl-member">
				<tr>
					<th colspan="7">신고&nbsp;&nbsp;&nbsp;&nbsp;내역&nbsp;&nbsp;&nbsp;&nbsp;조회</th>
				</tr>
				<tr>
					<th>신고 번호</th>
					<th>신고 상품</th>
					<th>상품 등록 회원</th>
					<th>신고한 회원</th>
					<th>신고 사유</th>
					<th>신고 일시</th>
					<th>블랙 처리</th>
				</tr>
				<c:forEach var="report" items="${reportList}">
				<tr>
					<th>${report.reportNo}</th>
					<td>${report.productNo}</td>
					<td><a href="/admin/searchMember?memberNo=${report.productMemberNo}">${report.productMemberNo}</a></td>
					<td><a href="/admin/searchMember?memberNo=${report.reportedMemberNo}">${report.reportedMemberNo}</a></td>
					<td>${report.reportReason}</td>
					<td>${report.reportDate}</td>
					<td><button onclick="insertBlackList('${report.productMemberNo}', '${report.reportNo}')">블랙 처리</button></td>
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
	 	
		function insertBlackList(memberNo, reportNo){
			swal({
				title : "알림",
				text : "해당 회원을 블랙 처리 하시겠습니까?",
				icon : "warning",
				buttons : {
					cancel : {
						text : "취소", 
						value : false,
						visible : true,
						closeModal : true
					},
					confirm : {
						text : "확인",
						value : true,
						visible : true,
						closeModal : true
					}
				}
			}).then(function(val){
				if(val){ //확인 버튼 클릭 시
					$.ajax({
						url : "/admin/searchBlackList",
						data : {"memberNo" : memberNo},
						type : "get",
						success : function(res){
							if(res > 0){
								swal({
									title : "알림",
									text : "이미 블랙 처리된 회원입니다.",
									icon : "error"
									
								});
							}else {
								let popupWidth = 500;
								let popupHeight = 330;
								
								let top = screen.availHeight / 2 - popupHeight / 2; //사용 가능 높이 / 2 - 팝업 높이 / 2
								let left = screen.availWidth / 2 - popupWidth / 2; //사용 가능 넓이 / 2 - 팝업 넓이 / 2
								
								window.open("/admin/insertBlackListFrm?reportNo=" + reportNo, "insertBlackListFrm", "width=" + popupWidth + ", height=" + popupHeight + ", top=" + top + ", left=" + left);
							}
						},
						error : function(){
							console.log("ajax 통신 오류");
						}
					});
				}
			});
		}
	</script>
</body>
</html>