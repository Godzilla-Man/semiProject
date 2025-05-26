<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
			<div class="admin-menu">
				<a href="/admin/adminPage">관리 페이지</a>
				<a href="/admin/allMember">전체 회원 조회</a>
				<a href="/admin/report">신고 내역 조회</a>
				<a href="/admin/blackList">블랙 리스트 조회</a>
			</div>
			<table class="tbl-member">
				<tr>
					<th colspan="8">신고&nbsp;&nbsp;&nbsp;&nbsp;내역&nbsp;&nbsp;&nbsp;&nbsp;조회</th>
				</tr>
				<tr>
					<th>신고 번호</th>
					<th>신고 상품</th>
					<th>상품 등록 회원</th>
					<th>신고한 회원</th>
					<th>신고 사유</th>
					<th>신고 내용</th>
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
<td><button type="button" style="white-space:nowrap;" data-detail="${fn:escapeXml(report.reportDetail)}" onclick="openReasonModal(this)">사유 확인</button></td>

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
	
	<!-- 신고 내용 확인용 모달 추가 -->
	<!-- 신고내용 확인용 모달 레이아웃: 기본은 숨김 처리 -->
	<div id="reportDetailModal" class="modal-overlay" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; z-index:10000;">
	  <div style="background:#fff; border-radius:8px; padding:24px; width:400px; max-width:90%; position:relative;">
	    <h3 style="margin-bottom:16px;">신고 내용</h3>
	    <!-- 신고 상세내용이 표시될 영역 -->
	    <div id="reportDetailContent" style="white-space:pre-wrap; font-size:14px; color:#333;"></div>
	    <div style="margin-top:20px; text-align:right;">
	      <button onclick="closeReportDetail()" style="padding:6px 14px;">닫기</button>
	    </div>
	  </div>
	</div>

<script>
  //  신고 내용 모달 열기 함수
		function openReasonModal(btnElement) {
		  if (!btnElement || !btnElement.dataset) {
		    console.error("버튼 요소가 올바르게 전달되지 않았습니다.");
		    return;
		  }
		
		  const detailText = btnElement.dataset.detail || "(신고 내용이 없습니다)";
		  const modal = document.getElementById("reportDetailModal");
		  const content = document.getElementById("reportDetailContent");
		
		  content.textContent = detailText;
		  modal.style.display = "flex";
		}


  //  모달 닫기 함수
  function closeReportDetail() {
    document.getElementById("reportDetailModal").style.display = "none";
  }
</script>
	
	
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