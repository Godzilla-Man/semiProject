<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true" %> <%-- isErrorPage="true"는 선택사항 --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${not empty errorTitle ? errorTitle : "오류 발생"}</title> <%-- 서블릿에서 넘겨준 errorTitle 사용 --%>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .error-container { border: 1px solid #ccc; padding: 20px; background-color: #f9f9f9; }
    h1 { color: #cc0000; }
</style>
</head>
<body>
    <div class="error-container">
        <h1>${not empty errorTitle ? errorTitle : "요청 처리 중 오류가 발생했습니다."}</h1>
        <p>
            ${not empty errorMessage ? errorMessage : "불편을 드려 죄송합니다. 문제가 지속되면 관리자에게 문의해주세요."}
        </p>
        <p><a href="${pageContext.request.contextPath}/">메인 페이지로 돌아가기</a></p>
    </div>
</body>
</html>