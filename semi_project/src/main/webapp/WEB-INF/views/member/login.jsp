<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/login.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<title>로그인</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<main class="content login-container">
			<section class="section login-wrap">
				<div class="page-title">로그인</div>
				<form action="/member/login" 
				      method="post" 
				      autocomplete="off" 
				      onsubmit="return validateForm()">
					<div class="input-wrap input-wrap-id">
						<div class="input-title">
							<label for="loginId">아이디</label>
						</div>
						<div class="input-item">
							<input type="text" id="loginId" name="loginId" placeholder="ID">
						</div>
					</div>
					
					<div class="input-wrap input-wrap-pw">
						<div class="input-title">
							<label for="loginPw">비밀번호</label>
						</div>
						<div class="input-item">
							<input type="password" id="loginPw" name="loginPw" placeholder="PASSWORD">
						</div>
					</div>
					
					<div class="login-button-box">
						<button type="submit" class="btn-primary lg">로그인</button>
					</div>
					
					<div class="member-link-box">
						<a href="/member/searchInfoFrm">아이디/비밀번호 찾기</a>
						<a href="/member/joinFrm">회원가입</a>
					</div>
				</form>
			</section>
		</main>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	<script>
		function validateForm(){
			if($('#loginId').val().length < 1){
				swal({
					title : "알림",
					text : "아이디를 입력하세요",
					icon : "warning"
				});
				
				return false;
			}
			
			if($('#loginPw').val().length < 1){
				swal({
					title : "알림",
					text : "비밀번호를 입력하세요",
					icon : "warning"
				});
				
				return false;
			}
			

	</script>
</body>
</html>