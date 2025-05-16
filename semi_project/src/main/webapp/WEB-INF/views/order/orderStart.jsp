<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>	
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>줍줍 - 주문 확인</title>
    <link rel="stylesheet" href="/resources/css/order.css">    
</head>

<body>
    <div class="container">
        <div class="header">
            <a href="#" class="back-button">&lt;</a>
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
                    <div class="product-name">나이키 반팔 티셔츠</div> <!-- 상품명 정보 로드 -->
                    <div class="product-price">500,000 원</div> <!-- 상품가격 정보 로드 -->
                </div>
            </div>
        </div>

        <div class="section transaction-method-section">
            <p class="section-title">배송 방법(선택 불가)</p>
            <div class="method-options">
                <label class="method-option"> <!-- 배송 방법 정보 로드 -->
                    <input type="radio" name="transactionMethod" value="prepaid" checked>
                    <span class="option-text">선불</span> 
                    <span class="option-price">5,000원</span>                    
                </label>
                <label class="method-option">
                    <input type="radio" name="transactionMethod" value="postpaid">
                    <span class="option-text">착불</span>
                    <span class="option-description">배송 기사님께 직접 결제</span>
                </label>
            </div>
        </div>

        <div class="payment-summary">
            <span class="summary-label">결제 예상 금액</span>
            <span class="summary-amount">505,000원</span>
        </div>

        <button class="next-button">다음</button>
    </div>
</body>

</html>