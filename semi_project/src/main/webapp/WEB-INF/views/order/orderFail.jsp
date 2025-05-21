<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>줍줍 - 결제 실패</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/order.css">
    <style>
        .fail-icon {
            font-size: 50px;
            color: #D9534F; /* 빨간색 */
            text-align: center;
            margin-top: 20px;
        }
        .error-details {
            background-color: #f2dede; /* 오류 메시지 배경색 */
            border: 1px solid #ebccd1;
            color: #a94442; /* 오류 메시지 글자색 */
            padding: 15px;
            margin-top: 20px;
            border-radius: 4px;
            text-align: left;
        }
        .error-details p {
            margin: 5px 0;
        }
        .button-group {
            margin-top: 30px;
            text-align: center;
        }
        .button-group .action-button {
            background-color: #f0ad4e; /* 버튼 기본색 */
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none; /* 링크 밑줄 제거 */
            margin: 0 10px;
        }
        .button-group .action-button.primary {
            background-color: #337ab7; /* 주요 버튼색 */
        }
    </style>
</head>
<body>
	<form action="#" method="post">
    <div class="container">
        <div class="header">
             <%-- <a href="${pageContext.request.contextPath}/" class="back-button">&lt;</a> --%>
            <h1 class="page-title-centered">결제 실패</h1>
        </div>

        <div class="payment-flow-indicator">
            <span class="step">1. 주문</span>
            <span class="step">2. 결제</span>
            <span class="step current">3. 완료 (실패)</span>
        </div>

        <div class="fail-icon">
            ✘
        </div>
        <h2 style="text-align:center; margin-top:10px;">결제에 실패하였습니다.</h2>
		
		<c:if test="${not empty errorMessage or not empty errorCode or not empty requestScope.errorMessage}">
	        <div class="error-details">
	            <h4>오류 정보:</h4>
	            <c:if test="${not empty orderId}">
	            	<p><strong>주문번호:</strong> ${orderId}</p>
	            </c:if>
	            <c:if test="${not empty errorCode}">
	            	<p><strong>오류 코드:</strong> ${errorCode}</p>
	            </c:if>
	            <c:if test="${not empty errorMessage}">
	            	<p><strong>오류 메시지:</strong> ${errorMessage}</p>
	            </c:if>
                 <c:if test="${not empty requestScope.errorMessage and empty errorMessage}"> <%-- PaymentSuccessServlet에서 내부 오류로 fail로 왔을 경우 --%>
                    <p><strong>오류 메시지:</strong> ${requestScope.errorMessage}</p>
                </c:if>
	        </div>
        </c:if>
        
        <c:if test="${purchase != null && product != null}">
	        <div class="section product-info-section" style="margin-top: 20px;">
	            <p class="section-title">주문 시도 상품 정보</p>
	            <div class="product-details">
	                <div class="product-image-placeholder">
	                    <span>상품 이미지</span> <%-- 실제 이미지 표시 로직 필요 --%>
	                </div>
	                <div class="product-text-details">
	                    <div class="product-name">${product.productName}</div>
	                    <div class="product-price"><fmt:formatNumber value="${product.productPrice}" type="number"/> 원</div>                    
	                </div>
	            </div>
	        </div>
        </c:if>

        <div class="payment-notice-text" style="margin-top:20px; text-align:left;">
            <p>결제 정보를 다시 확인하시거나 다른 결제 수단을 이용해보세요.</p>
            <p>문제가 지속될 경우 고객센터로 문의해주시기 바랍니다.</p>
        </div>

        <div class="button-group">
            <%--
                "다시 결제하기" 버튼은 사용자를 이전 결제 페이지(orderPay.jsp)로 안내합니다.
                orderPay.jsp가 orderId를 받아서 기존 주문 정보를 로드하고,
                해당 주문의 상품 ID(productId)로 상품 정보를 다시 조회하여 화면을 구성하도록
                OrderPayServlet 수정이 필요할 수 있습니다.
                현재 OrderPayServlet은 productId를 기본으로 받습니다.
                아래는 현재 OrderPayServlet의 동작을 고려한 링크입니다.
            --%>
            <c:if test="${product != null}">
                 <a href="javascript:history.go(-2);" class="action-button primary">다시 결제하기</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/" class="action-button">메인으로 가기</a>
        </div>
    </div>
    </form>
</body>
</html>