<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/searchInfo.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<title>회원 정보 찾기</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<main class="contents searchInfo-container">
			<section class="section searchInfo-wrap">
				<div class="page-title">회원 정보 찾기</div>
				<form action="/member/searchInfo"
				      method="post" 
				      autocomplete="off">
					<div class="searchInfo-wrap">
						<ul class="menu-wrap">
							<li class="tab-link current" data-tab="tab-searchId">
								<a  href="#">아이디 찾기</a>
							</li>
							<li class="tab-link" data-tab="tab-searchPw">
								<a href="#">비밀번호 찾기</a>
							</li>
						</ul>
						<div class="content on" id="tab-searchId">
							<input type="radio" class="option-radio" id="namePhone" name="infoOption" value="namePhone" checked>
								<label for="namePhone">이름 + 전화번호로 찾기</label>
								<div class="content-item" id="item-namePhone">
									<div class="input-wrap input-wrap-name">
										<div class="input-item">
											<input type="text" id="srchId-name" name="searchId-name" placeholder="이름">
										</div>
									</div>
									
									<div class="input-wrap input-wrap-namePhone">
										<div class="input-item">
											<input type="text" id="searchId-phone" name="searchId-phone" placeholder="전화번호">
										</div>
									</div>
								</div>
							<input type="radio" class="option-radio" id="email" name="infoOption" value="email">
								<label for="email">이메일로 찾기</label>
								<div class="content-item" id="item-email">
									<div class="input-item">
							      	  	<input type="text" id="srchId-emailId" name="srchId-emailId" disabled>&nbsp;@&nbsp;
							      	  	<input type="text" id="srchId-emailDomain" name="srchId-emailDomain" disabled>
							      	  	<select class="select-domain" id="id-selectDomain" disabled>
							      	  		<option value="text" selected>직접입력</option>
							      	  		<option value="naver.com">naver.com</option>
							      	  		<option value="hanmail.net">hanmail.net</option>
							      	  		<option value="gmail.com">gmail.com</option>
							      	  		<option value="kakao.com">kakao.com</option>
					      	 		 	</select>
					      	 		 </div>
				     		 	  </div><br>
							<div class="searchId-button-box">
								<button type="submit" class="btn-primary" name="searchInfo" value="id">아이디 찾기</button>
							</div>
						</div>
						<div class="content" id="tab-searchPw">
							<div class="input-wrap input-warp-pw">
								<div class="input-item">
									<input type="text" id="memberId" name="memberId" placeholder="ID" maxlength="12">
								</div>
							</div>
							<div class="input-item">
					      	  	<input type="text" id="pwEmailId" name="pwEmailId" placeholder="EMAIL">&nbsp;@&nbsp;
					      	  	<input type="text" id="pwEmailDomain" name="pwEmailDomain">
					      	  	<select class="select-domain" id="pw-selectDomain">
					      	  		<option value="text" selected>직접입력</option>
					      	  		<option value="naver.com">naver.com</option>
					      	  		<option value="hanmail.net">hanmail.net</option>
					      	  		<option value="gmail.com">gmail.com</option>
					      	  		<option value="kakao.com">kakao.com</option>
			      				</select>
					      	</div><br>
							<div class="searchPw-button-box">
								<button type="submit" class="btn-primary" name="searchInfo" value="pw">비밀번호 찾기</button>
							</div>
						</div>
					</div>
				</form>
			</section>
		</main>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	<script>
		//아이디/비밀번호 찾기 탭메뉴 기능
		const tabLink = $('.tab-link');
		const content = $('.content');
		
		$(tabLink).click(function(e) {
			e.preventDefault();
			
			var current = $(this).attr('data-tab');
			
			$(tabLink).removeClass('current');
			$(content).removeClass('on');
			
			$(this).addClass('on');
			$(this).addClass('current');
			$('#' + current).addClass('on');
		});
		
		//이름+전화번호로 찾기/이메일로 찾기 라디오버튼 기능
		const optionRadio = $('.option-radio');
		const itemNamePhone = $('#item-namePhone');
		const itemEmail = $('#item-email');
		
		$(optionRadio).on('change', function(){
			var checkedRadio = $('.option-radio:checked');
			
			//이름+전화번호 선택시
			if($(checkedRadio).val() == 'namePhone') {
				$(itemNamePhone).find('input').attr('disabled', false)
				$(itemEmail).find('input').attr('disabled', true)
				$(itemEmail).find('select').attr('disabled', true)
			}
			//이메일 선택시
			if($(checkedRadio).val() == 'email') {
				$(itemNamePhone).find('input').attr('disabled', true)
				$(itemEmail).find('input').attr('disabled', false)
				$(itemEmail).find('select').attr('disabled', false)
			}
		});
		
		//이메일Domain selectbox 기능 (id찾기에서의 selectbox와 pw찾기에서의 selectbox구분)
		const idEmailDomain = $('#idEmailDomain');
		const pwEmailDomain = $('#pwEmailDomain');
		const idSelectDomain = $('#id-selectDomain');
		const pwSelectDomain = $('#pw-selectDomain');
		
		$(idSelectDomain).on('change', function(){
			if($(this).val() == 'text') {
				//도메인 직접입력 선택시
				$(idEmailDomain).attr('readonly', false);
				$(idEmailDomain).val('');
			} else {
				$(idEmailDomain).attr('readonly', true);
				$(idEmailDomain).val($(this).val());
			}
		});
		$(pwSelectDomain).on('change', function(){
			if($(this).val() == 'text') {
				//도메인 직접입력 선택시
				$(pwEmailDomain).attr('readonly', false);
				$(pwEmailDomain).val('');
			} else {
				$(pwEmailDomain).attr('readonly', true);
				$(pwEmailDomain).val($(this).val());
			}
		});
	</script>
</body>
</html>