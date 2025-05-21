<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="/resources/css/checkPw.css">
<title>비밀번호 확인</title>
</head>
<body>
<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<main class="contents checkPw-container">
			<section class="section checkPw-wrap">
				<div class="page-title">비밀번호 확인</div>
				<form action="/member/update"
				      method="post" 
				      autocomplete="off"
				      onsubmit="return validateForm()">
					<div class="input-wrap">
						<div class="input-msg">
							<p>${loginMember.memberName } 님의 회원정보를 안전하게 보하기 위해<br>
							비밀번호를 한번 더 확인해 주세요.</p>
						</div>
						<div class="input-item">
							<input type="text" id="checkPw" name="checkPw" maxlength="20">
						</div>
						<div class="checkPw-button-box">
							<button type="submit" class="btn-primary">확 인</button>
						</div>
					</div>
				</form>
			</section>
		</main>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	<script>
	function validateForm() {
		const checkPw = $('#checkPw');
		
		if($(checkPw).val() != ${loginMember.memberPw }) {
			swal({
				title : '실패',
				text : 비밀번호가 일치하지 않습니다.,
				icon : 'warning'
			});
		
			return false;
		}
	}
	</script>
</body>
</html>