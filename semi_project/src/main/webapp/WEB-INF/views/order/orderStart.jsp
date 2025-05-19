<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 
<!DOCTYPE html>
<html>

<head>	
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>줍줍 - 주문 확인</title>
    <link rel="stylesheet" href="/resources/css/order.css">    
</head>

<body>

	<form action="/order/orderPay" method="post">	
    <div class="container">
        <div class="header">
            <a href="javascript:history.back();" class="back-button">&lt;</a>
            <h1 class="page-title-centered">주문 정보 확인</h1>
        </div>

        <div class="payment-flow-indicator">
            <span class="step current">1. 주문</span>
            <span class="step">2. 결제</span>
            <span class="step">3. 완료</span>
        </div>		
		
        <div class="section product-info-section">
            <p class="section-title">주문 상품 정보</p>
            <div class="product-details">
                <div class="product-image-placeholder">
                    <span>상품 이미지</span> <%-- 상품 이미지: <img src="${product.imagePath}" alt="${product.name}"> --%>
                </div>
                <div class="product-text-details">
                    <div class="product-name">${product.productName}</div> <!-- 상품명 정보 로드 -->
                    <div class="product-price"><fmt:formatNumber value="${product.productPrice}" type="number"/> 원<!-- 상품가격 정보 로드 -->
                    </div>
                </div>
            </div>
        </div>

        <div class="section transaction-method-section">
            <p class="section-title">배송 방법(선택 불가)</p>
            <div class="method-options">
            	            
              	<%-- 선불 택배 옵션 (M1) --%>
                <label class="method-option <c:if test="${product.tradeMethodCode != 'M1'}">disabled-option</c:if>">
                    <input type="radio" name="displayedDeliveryMethod" value="M1" 
                           <c:if test="${product.tradeMethodCode == 'M1'}">checked</c:if> 
                           disabled> <%-- 모든 옵션의 라디오 버튼은 disabled로 변경 불가 명시 --%>
                    <span class="option-text">선불</span> 
                    <c:if test="${product.tradeMethodCode  == 'M1'}">
                        <span class="option-price"><fmt:formatNumber value="${deliveryFee}" type="number"/>원</span>
                    </c:if>
                    <c:if test="${product.tradeMethodCode != 'M1'}"><%-- M1이 선택되지 않았을 때(흐리게) --%>
                        <span class="option-price"><fmt:formatNumber value="${deliveryFee}" type="number"/>원</span>
                    </c:if>
                </label>

                <%-- 착불 택배 옵션 (M3) --%>
                <label class="method-option <c:if test="${product.tradeMethodCode != 'M3'}">disabled-option</c:if>">
                    <input type="radio" name="displayedDeliveryMethod" value="M3" 
                           <c:if test="${product.tradeMethodCode == 'M3'}">checked</c:if> 
                           disabled> <%-- 모든 옵션의 라디오 버튼은 disabled로 변경 불가 명시 --%>
                    <span class="option-text">착불</span>
                    <c:if test="${product.tradeMethodCode == 'M3'}">
                        <span class="option-description">배송 기사님께 직접 결제</span>            
                    </c:if>
                    <c:if test="${product.tradeMethodCode != 'M3'}"><%-- M3가 선택되지 않았을 때(흐리게) --%>                        
                        <span class="option-description">배송 기사님께 직접 결제</span>
                    </c:if>
                </label>                
                
            </div>
        </div>

        <div class="payment-summary">
            <span class="summary-label">결제 예상 금액</span>
            <span class="summary-amount"><fmt:formatNumber value="${totalProductAmount}" type="number"/>원</span>
        </div>                
        
        <button type="submit" class="next-button">다음</button>
    </div>    
    </form>    
</body>

</html>