<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="/resources/css/join.css">
<title>회원가입</title>
</head>
<body>
	<div class="wrap">
		<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
		<main class="content">
			<section class="section join-wrap">
				<div class="page-title"><h1>회원가입</h1></div>
				<form action='/member/join' <%-- 요청 URL  --%>
				      method='post'         <%-- 전송방식 --%>
				      autocomplete="off"   <%-- 자동완성기능 해제 --%>
				      onsubmit="return validateForm()"> <%-- submit 클릭 시, 동작할 함수  --%>
				      
				      <div class="input-wrap">
					      <div class="input-title">
					      	<label for="memberId">아이디</label>
					      </div>
					      <div class="input-item input-memberId">
					      	<input type="text" id="memberId" name="memberId" placeholder="영어, 숫자 6~12글자" maxlength="12">
					      </div>
					      <p id="idMessage" class="input-msg"></p>
				      </div>
				      
				      <div class="input-wrap">
				      	  <div class="input-title">
				      	  	<label for="memberPw">비밀번호</label>
				      	  </div>
				      	  <div class="input-item input-memberPw">
				      	  	<input type="password" id="memberPw" name="memberPw" placeholder="영어, 숫자, 특수문자(!,@,#,$) 8~20글자" maxlength="20">
				      	  </div>
				      </div>
				      
				      <div class="input-wrap">
				      	  <div class="input-title">
				      	  	<label for="memberPwRe">비밀번호 확인</label>
				      	  </div>
				      	  <div class="input-item input-memberPwRe">
				      	  	<input type="password" id="memberPwRe" maxlength="20">
				      	  </div>
				      	  <p id="pwMessage" class="input-msg"></p>
				      </div>
				      
				      <div class="input-wrap">
					      <div class="input-title">
					      	<label for="memberNickname">닉네임</label>
					      </div>
					      <div class="input-item input-memberNickname">
					      	<input type="text" id="memberNickname" name="memberNickname" placeholder="한글 2~12글자" maxlength="12">
					      </div>
					      <p id="nicknameMessage" class="input-msg"></p>
				      </div>
				      
				      <div class="input-wrap">
				      	  <div class="input-title">
				      	  	<label for="memberName">이름</label>
				      	  </div>
				      	  <div class="input-item input-memberName">
				      	  	<input type="text" id="memberName" name="memberName" placeholder="한글 2~5글자" maxlength="5">
				      	  </div>
				      	  <p id="nameMessage" class="input-msg"></p>
				      </div>
				      
				      <div class="input-wrap">
				      	  <div class="input-title">
				      	  	<label for="memberBirth">생년월일</label>
				      	  </div>
				      	  <div class="input-item select-item">
				      	  	<select class="birth-select" id="birthYear" name="birthYear"></select>
				      	  	<select class="birth-select" id="birthMonth" name="birthMonth"></select>
				      	  	<select class="birth-select" id="birthDay" name="birthDay"></select>
				      	  </div>
				      	  <p id="birthMessage" class="input-msg"></p>
				      </div>
				      
				      <div class="input-wrap">
				      	  <div class="input-title">
				      	  	<label for="memberPhone">전화번호</label>
				      	  </div>
				      	  <div class="input-item input-memberPhone">
				      	  	<input type="text" id="memberPhone" name="memberPhone" placeholder="전화번호 (010-0000-0000)" maxlength="13">
				      	  </div>
				      	  <p id="phoneMessage" class="input-msg"></p>
				      </div>
				      
				      <div class="input-wrap">
				      	  <div class="input-title">
				      	  	<label for="memberAddr">주소</label>
				      	  </div>
				      	  <div class="input-item input-addr addr-postcode">
				      	  	<input type="text" id="addr_postcode" name="addr_postcode"  placeholder="우편번호" readonly>
							<input type="button" class="button-addr" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">
						  </div>
						  <div class="input-item input-addr addr-basic">
							<input type="text" id="addr_address" name="addr_address" placeholder="주소" readonly>
						  </div>
						  <div class="input-item input-addr addr-detail">
							<input type="text" id="addr_detailAddress" name="addr_detailAddress" placeholder="상세주소">
						  </div>
						  <div class="input-item input-addr addr-extra">
							<input type="text" id="addr_extraAddress" name="addr_extraAddress" placeholder="참고항목" readonly>
				      	  </div>
				      	  <p id="addrMessage" class="input-msg"></p>
				      </div>
				      
				       <div class="input-wrap">
				      	  <div class="input-title">
				      	  	<label for="memberEmail">이메일</label>
				      	  </div>
				      	  <div class="input-item input-email">
				      	  	<input type="text" id="memberEmailId" name="memberEmailId">&nbsp;@&nbsp;
				      	  	<input type="text" id="memberEmailDomain" name="memberEmailDomain">
				      	  	<select class="select-domain" id="selectDomain">
				      	  		<option value="text" selected>직접입력</option>
				      	  		<option value="naver.com">naver.com</option>
				      	  		<option value="hanmail.net">hanmail.net</option>
				      	  		<option value="gmail.com">gmail.com</option>
				      	  		<option value="kakao.com">kakao.com</option>
				      	  	</select>
				      	  </div>
				      	  <p id="emailMessage" class="input-msg"></p>
				      </div>
				      
				      <div class="join-button-box">
				      	 <button type="submit" class="btn-primary lg">회원가입</button>
				      </div>
		        </form>
			</section>
		</main>
		
		<div class="fixed" style="right: 280px;">
			<div class="top" onclick="scrollToTop()">
				<span class="material-symbols-outlined">arrow_upward</span>
			</div>
		</div>
		
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</div>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
 	//우측 하단 ↑ 버튼 클릭 시 상단으로 스크롤 이동
    function scrollToTop() {
        window.scrollTo({
        top: 0,
        behavior: 'smooth' // 부드럽게 스크롤
        });
    }
	$(document).ready(function(){
		//selectbox 현재시간기준으로 값 설정
	    var now = new Date();
	    var year = now.getFullYear();
	    var month = (now.getMonth() + 1) > 9 ? ''+(now.getMonth() + 1) : '0'+(now.getMonth() + 1); 
	    var day = (now.getDate()) > 9 ? ''+(now.getDate()) : '0'+(now.getDate());  
	    
	    //년도 selectbox              
	    for(var i = 1900 ; i <= year ; i++) {
	        $('#birthYear').append('<option value="' + i + '">' + i + '년</option>');    
	    }

	    // 월별 selectbox           
	    for(var i=1; i <= 12; i++) {
	        var mm = i > 9 ? i : "0"+i ;            
	        $('#birthMonth').append('<option value="' + mm + '">' + mm + '월</option>');    
	    }
	    
	    // 일별 selectbox
	    for(var i=1; i <= 31; i++) {
	        var dd = i > 9 ? i : "0"+i ;            
	        $('#birthDay').append('<option value="' + dd + '">' + dd+ '일</option>');    
	    }
	    $("#birthYear  > option[value="+year+"]").attr("selected", "true");        
	    $("#birthMonth  > option[value="+month+"]").attr("selected", "true");    
	    $("#birthDay  > option[value="+day+"]").attr("selected", "true");         
	})
	
	//이메일Domain selectbox 세팅
	const memberEmailDomain = $('#memberEmailDomain');
	const selectDomain = $('#selectDomain');
	
	$(selectDomain).on('change', function(){
		if($(this).val() == 'text') {
			//도메인 직접입력 선택시
			$(memberEmailDomain).attr('readonly', false);
			$(memberEmailDomain).val('');
		} else {
			$(memberEmailDomain).attr('readonly', true);
			$(memberEmailDomain).val($(this).val());
		}
	});
	
	//다음 주소 API 사용
	function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("addr_extraAddress").value = extraAddr;
                
                } else {
                    document.getElementById("addr_extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('addr_postcode').value = data.zonecode;
                document.getElementById("addr_address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("addr_detailAddress").focus();
            }
        }).open();
    }
	
	/*
		유효성 검사
	*/
	//사용자 입력값 유효성 검증 결과를 저장할 객체
	//사용자가 값을 입력할때마다 검증하여, 만족할 경우 true로 만족하지 못할 경우 false로 변경
	//최종적으로 회원가입 버튼 클릭 시, 아래 객체의 모든 속성이 true인지 검사할 것임.
	const checkObj = {
		"memberId"	: false,
		"memberPw"  : false,
		"memberPwRe": false,
		"memberNickname" : false,
		"memberName": false,
		"memberBirth" : false,
		"memberPhone": false,
		"memberAddress" : false,
		"memberEmail":false,
		"idDuplChk" : false, //아이디 중복체크 여부(true면 중복X, false면 중복O)
		"nicknameDuplChk" : false //닉네임 중복체크 여부(true면 중복X, false면 중복O)
	};
	
	/*
		아이디 검사
	*/
	const memberId = $('#memberId'); //jquery 방식으로 HTML 요소 선택 (id 속성 값이 'memberId'인 요소)
	const idMessage = $('#idMessage'); //입력 ID 유효성 검증 결과 메시지를 보여줄 요소
	const inputMemberId = $('.input-memberId');
	
	//아이디 유효성 체크 - 입력되는동안(keyin) 체크
	//id를 입력할 수 있는 요소에, input (key 관련, mouse 관련, 붙여넣기) 이벤트 발생 시 동작할 핸들러 함수 작성
	$(memberId).on('input', function(){
		checkObj.idDuplChk = false; //아이디 입력시마다, 중복체크 값 false로 변경하여 다시 중복체크 할 수 있도록
		
		//아래 코드 작성하지 않으면, 클래스를 추가해주기만 하기 때문에 두 클래스가 공존할 수 있음.
		$(idMessage).removeClass('valid');
		$(idMessage).removeClass('invalid');
		$(inputMemberId).removeClass('valid');
		$(inputMemberId).removeClass('invalid');
		
		
		//아이디 정규표현식 = 영어, 숫자 6~12글자
		const regExp = /^[a-zA-Z0-9]{6,12}$/;
		
		//정규표현식.test(검사할문자열)   => 만족하면 true, 만족하지 않으면 false 반환
		if(regExp.test($(this).val())){
			//사용자가 입력한 ID가 정규표현식에 만족하는 경우
			$(idMessage).text('');
			$(idMessage).addClass('valid');
			$(inputMemberId).addClass('valid');
			checkObj.memberId = true;
		}else{
			//사용자가 입력한 ID가 정규표현식에 만족하지 않는 경우
			$(idMessage).text("영어, 숫자 6~12글자 사이로 입력하세요.");
			$(idMessage).addClass('invalid');
			$(inputMemberId).addClass('invalid');
			checkObj.memberId = false;
		}
	});
	
	//아이디 중복체크 - 포커스벗어날때 체크
	$(memberId).on('blur', function(){
		$(idMessage).removeClass('valid');
		$(idMessage).removeClass('invalid');
		
		if(checkObj.memberId){
			$(inputMemberId).removeClass('valid');
			$(inputMemberId).removeClass('invalid');
			
			//유효성 검사 결과 true인 경우
			$.ajax({
				url : "/idDuplChk",							//요청 URL
				data : { 'memberId' : $(memberId).val() },	//서버로 전송할 데이터
				type : "get",								//데이터 전송 방식
				success : function(res){					//비동기 통신 성공 시, 호출 함수
					if(res == 0){ //중복 X  == 회원가입 가능
						$(idMessage).text('');
						$(idMessage).addClass('valid');
						$(inputMemberId).addClass('valid');
						checkObj.idDuplChk = true;
					}else{
						$(idMessage).text('이미 사용중인 ID입니다.');
						$(idMessage).addClass('invalid');
						$(inputMemberId).addClass('invalid');
						checkObj.idDuplChk = false;
					}
				},
				error : function(){							//비동기 통신 에러 시, 호출 함수
					
				}
			});
		}
	});
	
	/*
		비밀번호 검사
	*/
	//비밀번호 유효성 검사
	const memberPw = $('#memberPw');
	const pwMessage = $('#pwMessage');
	const inputMemberPw = $('.input-memberPw');
	const memberPwRe = $('#memberPwRe');
	const inputMemberPwRe = $('.input-memberPwRe');
	
	$(memberPw).on('input', function(){
		$(pwMessage).removeClass('invalid');
		$(pwMessage).removeClass('valid');
		$(inputMemberPw).removeClass('valid');
		$(inputMemberPw).removeClass('invalid');
		
		const regExp = /^[a-zA-Z0-9!@#$]{8,20}$/; //영어, 숫자, 특수문자 (!@#$) 8~20글자
		
		if(regExp.test($(memberPw).val())){
			checkObj.memberPw = true;
			
			//비밀번호 확인값이 입력이 되었을 때
			if($(memberPwRe).val().length > 0){
				checkPw(); //비밀번호와 확인값 일치하는지 체크
			}else{				
				$(pwMessage).text('');
				$(pwMessage).addClass('valid');
				$(inputMemberPw).addClass('valid');
			}
			
		}else{
			checkObj.memberPw = false;
			$(pwMessage).text('비밀번호 형식이 유효하지 않습니다.');
			$(pwMessage).addClass('invalid');
			$(inputMemberPw).addClass('invalid');
			
		}
	});
	
	//비밀번호 확인 유효성 검사
	$(memberPwRe).on('input', checkPw);
	
	function checkPw(){
		$(pwMessage).removeClass('invalid');
		$(pwMessage).removeClass('valid');
		$(inputMemberPwRe).removeClass('valid');
		$(inputMemberPwRe).removeClass('invalid');
		
		//입력한 비밀번호와 값이 같은지만 검증
		if($(memberPw).val() == $(memberPwRe).val()){
			$(pwMessage).text('');
			$(pwMessage).addClass('valid');
			$(inputMemberPwRe).addClass('valid');
			
			checkObj.memberPwRe = true;
		}else{
			$(pwMessage).text('비밀번호가 일치하지 않습니다.');
			$(pwMessage).addClass('invalid');
			$(inputMemberPwRe).addClass('invalid');
			
			checkObj.memberPwRe = false;
		}
	}
	
	/*
		닉네임 검사
	*/
	const memberNickname = $('#memberNickname');
	const nicknameMessage = $('#nicknameMessage');
	const inputMemberNickname = $('.input-memberNickname');
	
	//닉네임 유효성 검사
	$(memberNickname).on('input', function(){
		$(nicknameMessage).removeClass('invalid');
		$(nicknameMessage).removeClass('valid');
		$(inputMemberNickname).removeClass('valid');
		$(inputMemberNickname).removeClass('invalid');
		
		const regExp = /^[가-힣]{2,12}$/;  
		
		if(regExp.test($(this).val())){
			$(nicknameMessage).text('');
			$(nicknameMessage).addClass('valid');
			$(inputMemberNickname).addClass('valid');
			checkObj.memberNickname = true;
		}else{
			$(nicknameMessage).text('이름 형식이 유효하지 않습니다.');
			$(nicknameMessage).addClass('invalid');
			$(inputMemberNickname).addClass('invalid');
			checkObj.memberNickname = false;
		}
	});
	
	//닉네임 중복체크 - 포커스벗어날때 체크
	$(memberNickname).on('blur', function(){
		$(nicknameMessage).removeClass('valid');
		$(nicknameMessage).removeClass('invalid');
		
		if(checkObj.memberNickname){
			$(inputMemberNickname).removeClass('valid');
			$(inputMemberNickname).removeClass('invalid');
			//유효성 검사 결과 true인 경우
			$.ajax({
				url : "/nicknameDuplChk",								//요청 URL
				data : { 'memberNickname' : $(memberNickname).val() },	//서버로 전송할 데이터
				type : "get",											//데이터 전송 방식
				success : function(res){								//비동기 통신 성공 시, 호출 함수
					if(res == 0){ //중복 X  == 회원가입 가능
						$(nicknameMessage).text('');
						$(nicknameMessage).addClass('valid');
						$(inputMemberNickname).addClass('valid');
						checkObj.nicknameDuplChk = true;
					}else{
						$(nicknameMessage).text('이미 사용중인 닉네임입니다.');
						$(nicknameMessage).addClass('invalid');
						$(inputMemberNickname).addClass('invalid');
						checkObj.nicknameDuplChk = false;
					}
				},
				error : function(){							//비동기 통신 에러 시, 호출 함수
				}
			});
		}
	});
	
	/*
		이름 검사
	*/
	//이름 유효성 검사
	const memberName = $('#memberName');
	const nameMessage = $('#nameMessage');
	const inputMemberName = $('.input-memberName');
	
	$(memberName).on('input', function(){
		$(nameMessage).removeClass('invalid');
		$(nameMessage).removeClass('valid');
		$(inputMemberName).removeClass('valid');
		$(inputMemberName).removeClass('invalid');
		
		const regExp = /^[가-힣]{2,10}$/;  
		
		if(regExp.test($(this).val())){
			$(nameMessage).text('');
			$(nameMessage).addClass('valid');
			$(inputMemberName).addClass('valid');
			checkObj.memberName = true;
		}else{
			$(nameMessage).text('이름 형식이 유효하지 않습니다.');
			$(nameMessage).addClass('invalid');
			$(inputMemberName).addClass('invalid');
			checkObj.memberName = false;
		}
	});
	
	/*
		생년월일 검사
		 - 기본값인 현재시간과 동일하면 형식에 맞지 않다고 판단
	*/
	const birthSelect = $('.birth-select');
	const birthYear = $('#birthYear');
	const birthMonth = $('#birthMonth');
	const birthDay = $('#birthDay');
	const birthMessage = $('#birthMessage');
	
	$(birthSelect).on('change', function(){
		$(birthMessage).removeClass('invalid');
		$(birthMessage).removeClass('valid');
		$(birthSelect).removeClass('valid');
		$(birthSelect).removeClass('invalid');
		
		var now = new Date();
	    var year = now.getFullYear();
	    var month = (now.getMonth() + 1) > 9 ? ''+(now.getMonth() + 1) : '0'+(now.getMonth() + 1); 
	    var day = (now.getDate()) > 9 ? ''+(now.getDate()) : '0'+(now.getDate()); 
	    
		if($(birthYear).val() == year && $(birthMonth).val() == month && $(birthDay).val() == day) {
			$(birthMessage).text('생년월일 형식이 올바르지 않습니다.');
			$(birthMessage).addClass('invalid');
			$(birthSelect).addClass('invalid');
			checkObj.memberBirth = false;
		} else {
			$(birthMessage).text('');
			$(birthMessage).addClass('valid');
			$(birthSelect).addClass('valid');
			checkObj.memberBirth = true;
		}
		
	});
	
	/*
		전화번호 검사
	*/
	//전화번호 유효성 검사
	const memberPhone = $('#memberPhone');
	const phoneMessage = $('#phoneMessage');
	const inputMemberPhone = $('.input-memberPhone');
	
	$(memberPhone).on('input', function(){
		$(phoneMessage).removeClass('invalid');
		$(phoneMessage).removeClass('valid');
		$(inputMemberPhone).removeClass('valid');
		$(inputMemberPhone).removeClass('invalid');
		
		const regExp = /^010-\d{3,4}-\d{4}/;
		
		if(regExp.test($(this).val())){
			$(phoneMessage).text('');
			$(phoneMessage).addClass('valid');
			$(inputMemberPhone).addClass('valid');
			checkObj.memberPhone = true;
		}else{
			$(phoneMessage).text('전화번호 형식이 올바르지 않습니다.');
			$(phoneMessage).addClass('invalid');
			$(inputMemberPhone).addClass('invalid');
			checkObj.memberPhone = false;
		}
	});
	
	/*
		주소 검사
	*/
	const addrPostcode = $('#addr_postcode');
	const addrDetailAddress = $('#addr_detailAddress');
	const addrMessage = $('#addrMessage');
	const inputAddr = $('.input-addr');
	
	$(addrDetailAddress).on('input', function(){
		$(addrMessage).removeClass('invalid');
		$(addrMessage).removeClass('valid');
		$(inputAddr).removeClass('valid');
		$(inputAddr).removeClass('invalid');
		
		if($(addrPostcode).val() == '' || $(addrDetailAddress).val() == '') {
			$(addrMessage).text('주소 형식이 올바르지 않습니다.');
			$(addrMessage).addClass('invalid');
			$(inputAddr).addClass('invalid');
			checkObj.memberAddress = false;	
		} else {
			$(addrMessage).text('');
			$(addrMessage).addClass('valid');
			$(inputAddr).addClass('valid');
			checkObj.memberAddress = true;	
		}
	});
	
	/*
		이메일 검사
	*/
	const memberEmailId = $('#memberEmailId');
	const emailMessage = $('#emailMessage');
	const inputEmail = $('.input-email');
	
	//이메일ID 유효성 검사
	$(memberEmailId).on('input', function(){
		$(emailMessage).removeClass('invalid');
		$(emailMessage).removeClass('valid');
		$(inputEmail).removeClass('invalid');
		$(inputEmail).removeClass('valid');
		
		const regExp = /^[0-9a-zA-Z]([-_]?[0-9a-zA-Z])*$/;
		
		if(regExp.test($(this).val())){
			$(emailMessage).text('');
			$(emailMessage).addClass('valid');
			$(inputEmail).addClass('valid');
			checkObj.memberEmail = true;
		}else{
			$(emailMessage).text('이메일 형식이 올바르지 않습니다.');
			$(emailMessage).addClass('invalid');
			$(inputEmail).addClass('invalid');
			checkObj.memberEmail = false;		
		}
	});
	
	//이메일Domain 유효성 검사
	$(memberEmailDomain).on('input', function(){
		$(emailMessage).removeClass('invalid');
		$(emailMessage).removeClass('valid');
		$(inputEmail).removeClass('invalid');
		$(inputEmail).removeClass('valid');
		
		const regExp = /^[a-zA-Z]([-_.]?[0-9a-zA-Z])+(\.[a-z]{2,3})$/;
		
		if(regExp.test($(this).val())){
			$(emailMessage).text('');
			$(emailMessage).addClass('valid');
			$(inputEmail).addClass('valid');
			checkObj.memberEmail = true;
		}else{
			$(emailMessage).text('이메일 형식이 올바르지 않습니다.');
			$(emailMessage).addClass('invalid');
			$(inputEmail).addClass('invalid');
			checkObj.memberEmail = false;
		}
	});
	
	function validateForm(){
		/*
		회원가입 버튼 클릭 시, checkObj의 모든 속성에 접근하여
		true인지 검증
		*/
		
		let str = "";
		
		for(let key in checkObj){ //key 변수에 객체의 각 속성명이 순차적으로 할당됨.
			//checkObj.key //checkObj에서 key라는 속성을 찾으려고 함.
			
			if(!checkObj[key]){ //반복 접근중인 속성의 값이 하나라도 false이면, submit 제어
				switch(key){
					case "memberId" : str = "아이디 형식"; break;
					case "memberPw" : str = "비밀번호 형식"; break;
					case "memberPwRe" : str = "비밀번호 확인 형식"; break;
					case "memberNickname" : str = "닉네임 형식"; break;
					case "memberName" : str = "이름 형식"; break;
					case "memberBirth" : str = "생년월일 형식"; break;
					case "memberPhone" : str = "전화번호 형식"; break;
					case "memberAddress" : str = "주소 형식"; break;
					case "memberEmail" : str = "이메일 형식"; break;
				}
				
				if(key != 'idDuplChk'){
					if(key != 'nicknameDuplChk'){
						str += "이 유효하지 않습니다.";					
					} else {
						str = "이미 사용중인 닉네임입니다.";
					}
				}else{
					str = "이미 사용중인 ID입니다.";
				}
				
				swal({
					title : '회원가입 실패',
					text : str,
					icon : 'warning'
				});
				
				
				
				return false; //submit 동작 제어
			}
		}
	}
	
	</script>
</body>
</html>