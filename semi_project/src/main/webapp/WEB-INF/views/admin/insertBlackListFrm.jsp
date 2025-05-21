<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>블랙 리스트 등록</title>
<link rel="stylesheet" href="/resources/css/default.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> <!-- jquery 연결 url -->
<script src="/resources/js/sweetalert.min.js"></script>
</head>
<body>
	<div class="black-wrap">
		<table>
			<tr>
				<th style="width:20%;">신고 번호</th>
				<td style="width:80;"><input type="text" name="${reportNo}" value="${reportNo}" readonly></td>
			</tr>
			<tr>
				<th>블랙 사유</th>
				<td>
					<textarea id="blackReason"></textarea>
				</td>
			</tr>
			<tr>
				<th colspan="2">
					<button type="button" class="btn-secondary md" onclick="closePop()">취소</button>
					<button type="button" class="btn-primary md" onclick="inserBlacktList('${reportNo}')">등록</button>
				</th>
			</tr>
		</table>
	</div>
	
	<script>
		function closePop() {
			self.close();
		}
		
		function inserBlacktList(reportNo){
			let param = {};
			
			param.reportNo = reportNo;
			param.blackReason = $("#blackReason").val();
			
			$.ajax({
				url : "/admin/insertBlackList",
				data : param,
				type : "get",
				success : function(res){
					if(res > 0){
						swal({
							title : "성공",
							text : "블랙 리스트에 추가되었습니다.",
							icon : "success"
						}).then(function(){
							closePop();
						});
					}else{
						swal({
							title : "실패",
							text : "블랙 리스트 추가 중 오류가 발생했습니다.",
							icon : "error"
						});
					}
				},
				error : function(){
					console.log("ajax 통신 오류");
				}
			});
		}
	</script>
</body>
</html>