<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/resources/js/sweetalert.min.js"></script>
</head>
<body>
	<script>
		const title = "${title}"; //알림창 제목
		const msg = "${msg}"; //본문 메시지
		const icon = "${icon}"; //아이콘
		const loc = "${loc}"; //알림창 출력 후 요청 url
		const callback = "${callback}"; //알림창 출력 후 실행할 스크립트 함수
		
		swal({
			title : title,
			text : msg,
			icon : icon
		}).then(function(){
			if(callback != "" && callback != null){
				eval(callback); //eval : 문자열을 javascript 코드로 동작시켜주는 함수
			}
			
			if(loc != "" && loc != null){
				location.href = loc;
			}
		});
	</script>
</body>
</html>