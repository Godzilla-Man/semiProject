<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>줍줍 - 결제하기</title>
    <link rel="stylesheet" href="/resources/css/order.css">
    <script src="https://js.tosspayments.com/v1/payment-widget"></script>
</head>

<body class="page-index2"> <!-- index2 페이지 전용 클래스 추가 -->
	
	<form action="#" method="post">
    <div class="container">
        <div class="header">
            <a href="javascript:history.back();" class="back-button">&lt;</a>
            <h1 class="page-title-centered">결제하기</h1>
        </div>
       
        <div class="payment-flow-indicator">
            <span class="step">1. 주문</span>
            <span class="step current">2. 결제</span>
            <span class="step">3. 완료</span>
        </div>

        <div class="section order-summary-section">
            
            <div class="summary-group">
                <h3 class="summary-group-title">배송 방법</h3>                
                <c:if test="${product.tradeMethodCode  == 'M1'}">
                	<p>배송비 무료</p>
                </c:if>
                <c:if test="${product.tradeMethodCode  == 'M2'}">
                	<p>선불(일반 택배)</p>
                </c:if>                  
                <c:if test="${product.tradeMethodCode  == 'M3'}">
                	<p>착불(배송 기사님께 직접 결제)</p>
                </c:if>              
            </div>
            
            <div class="summary-group">
                <h3 class="summary-group-title">배송 정보</h3>
                
                <!-- 추후 회원 정보 연결하여 불러와야할 영역!!! -->
                <p>${loginMember.memberName}</p>
                <p>${loginMember.memberPhone}</p>
                
                <!-- 회원 정보 불러오고 주소 수정 기능 버튼 추가 삽입 필요! -->
                <p>${loginMember.memberAddr}</p>
            </div>
            
            <div class="summary-group">
                <h3 class="summary-group-title">주문상품 정보</h3>           
                <div class="product-details">
                    <div class="product-image-placeholder">
                    	<img src="${product.thumbnailPath}" style="width: 100px; height: 100px; object-fit: cover;"> <%-- 썸네일 이미지 --%>                        
                    </div>
                    <div class="product-text-details">
                        <div class="product-name">${product.productName}</div>
                        <div class="product-price"><fmt:formatNumber value="${product.productPrice}" type="number"/> 원</div>
                    </div>
                </div>
            </div>
        </div>
	
        <div class="section payment-method-selection">
            <h2 class="section-main-title">결제수단</h2>
            <div class="method-options">
                <label class="method-option selected" for="pay-toss">
                    <input type="radio" id="pay-toss" name="paymentMethod" value="toss" checked>
                    <img src="https://static.toss.im/logos/svg/logo-toss-pay.svg" alt="토스페이 로고" class="payment-logo toss-logo">
                    <span class="option-text">토스페이</span>
                </label>
            </div>
        </div>

        <div class="simplified-payment-summary">
            
            <h2 class="section-main-title">결제 정보</h2>            

            <div class="summary-item">
                <span class="summary-label">상품금액</span>
                <span class="summary-value"><fmt:formatNumber value="${product.productPrice}" type="number"/> 원</span>
            </div>

            <div class="summary-item">
                <span class="summary-label">배송비</span>
                <span class="summary-value">
                	<c:if test="${product.tradeMethodCode  == 'M1'}">
	                	<span>배송비 무료</span>
	                </c:if>                 
					<c:if test="${product.tradeMethodCode  == 'M2'}">
	                	<span>5,000 원</span>
	                </c:if>                
	                <c:if test="${product.tradeMethodCode  == 'M3'}">
	                	<span>0 원(착불)</span>
	                </c:if>
                </span>
            </div>

            <div class="summary-item">
                <span class="summary-label">줍줍 판매 수수료</span>
                <span class="summary-value">무료 이벤트 진행 중</span>
            </div>

            <hr class="summary-divider">

            <div class="summary-item total">
                <span class="summary-label total-label">총 결제금액</span>
                <span class="summary-amount total-amount"><fmt:formatNumber value="${totalProductAmount}" type="number"/>원</span>
            </div>
        </div>
       
        <div class="terms-header-inner">
            <label for="agree-all" class="agree-all-label">
                <input type="checkbox" id="agree-all" name="agreeAll">
                모든 약관에 동의합니다.
            </label>
        </div>
        
        <ul class="terms-list">
            <li>
                <label for="agreeTermFinancial" class="term-item-label">
                    <input type="checkbox" id="agreeTermFinancial" name="agreeTermFinancial" class="agree-individual" required>
                    줍줍 서비스 이용약관 동의 (필수)
                </label>
                <a href="/terms.jsp" class="view-term-link" target="_blank">보기</a>
            </li>
            <li>
                <label for="agreeTermPersonalInfo" class="term-item-label">
                    <input type="checkbox" id="agreeTermPersonalInfo" name="agreeTermPersonalInfo" class="agree-individual" required>
                    개인정보 수집 및 이용 동의 (필수)
                </label>
                <a href="/privacyPolicy.jsp" class="view-term-link" target="_blank">보기</a>
            </li>
            <li>
                <label for="agreeTermThirdParty" class="term-item-label">
                    <input type="checkbox" id="agreeTermThirdParty" name="agreeTermThirdParty" class="agree-individual" required>
                    개인정보 제3자 제공 동의 (필수)
                </label>
                <a href="/privacyThirdParty.jsp" class="view-term-link" target="_blank">보기</a>
            </li>
        </ul>            
        
        <div class="payment-notice-text">
            <p>
                (주)줍줍은 통신판매중개자이며, 통신판매의 당사자가 아닙니다. 전자상거래 등에서의 소비자보호에 관한 법률 등 관련 법령 및 
               (주)줍줍의 약관에 따라 상품, 상품정보, 거래에 관한 책임은 개별 판매자에게 귀속하고, (주)줍줍은 원칙적으로 회원간 거래에 대하여 책임을 지지 않습니다. 
                다만, (주)줍줍이 직접 판매하는 상품에 대한 책임은 (주)줍줍에게 귀속합니다.
            </p>    
        </div>

    </div>

    <div class="action-buttons-fixed">
        <button class="payment-button" type="submit" onclick="processTossPayment(); return false;"></button>
    </div>

    <script>
        // 약관 전체 동의/해제 
        const agreeAllCheckbox = document.getElementById('agree-all');
        const individualCheckboxes = document.querySelectorAll('.terms-list .agree-individual');

        if (agreeAllCheckbox && individualCheckboxes.length > 0) {
            agreeAllCheckbox.addEventListener('change', function() {
                individualCheckboxes.forEach(checkbox => {
                    checkbox.checked = this.checked;
                });
            });
        }
        if (individualCheckboxes.length > 0) {
            individualCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    if (!agreeAllCheckbox) return;

                    let allRequiredChecked = true;
                    let allAreChecked = true;
                    individualCheckboxes.forEach(cb => {
                        if (cb.required && !cb.checked) {
                            allRequiredChecked = false;
                        }
                        if (!cb.checked) {
                            allAreChecked = false;
                        }
                    });
                    if (!allRequiredChecked) {
                        agreeAllCheckbox.checked = false;
                    } else if (allAreChecked) {
                         agreeAllCheckbox.checked = true;
                    } else {
                        agreeAllCheckbox.checked = false;
                    }
                });
            });
        }

        // 최종 결제금액 버튼에 표시
        const paymentButton = document.querySelector('.payment-button');
        const finalAmountSpan = document.querySelector('.simplified-payment-summary .total-amount');
        if(paymentButton && finalAmountSpan) {
            const amountText = finalAmountSpan.textContent.replace(/[^0-9]/g, '');
            if (amountText) {
                 paymentButton.textContent = Number(amountText).toLocaleString() + '원 결제하기';
            }
        }

        // 토스페이 결제 처리 함수
        function processTossPayment() {
            // 약관 동의 확인
            let termsAgreed = true;
            if (individualCheckboxes.length > 0) {
                document.querySelectorAll('.terms-list .agree-individual[required]').forEach(checkbox => {
                    if (!checkbox.checked) {
                        termsAgreed = false;
                    }
                });
            } else if (agreeAllCheckbox && !agreeAllCheckbox.checked) { // 개별 약관 없이 전체동의만 있는 아주 예외적인 경우
                termsAgreed = false;
            }

            if (!termsAgreed) {
                alert('필수 약관에 모두 동의해주세요.');
                return;
            }
            
            //1. toss pay 객체 생성
            const tossPayments = TossPayments('test_ck_ma60RZblrqjQ7lgOoPb68wzYWBn1'); // 클라이언트 키로 초기화
            
            //2. 결제 요청에 필요한 정보 구성
            const amountToPay = parseFloat(finalAmountSpan.textContent.replace(/[^0-9]/g,'')); // 최종 결제 금액
            const orderName = "${product.productName}"; // 주문 상품명
            const orderId = "${orderId}"
            
            // 만약 orderId가 전달되지 않았거나 비어있다면, 결제 진행을 막습니다.
            if (!orderId) {
                alert('주문 번호가 유효하지 않습니다. 다시 시도해주세요.');
                return;
            }
            
        	// 구매자 이름 - 실제 구매자 정보로 대체해야 합니다.
            // 예: 세션에서 회원 이름을 가져오거나, 주문자 정보 입력 필드에서 값을 읽어옵니다.
            // 현재 JSP에는 하드코딩된 이름 "카와키타사이카"가 있으나, 동적으로 처리하는 것이 좋습니다.
            const customerName = document.querySelector('.summary-group p').textContent || '구매자이름'; // 임시로 첫번째 p 태그의 텍스트를 가져오거나 기본값 설정

            // 3. 결제창 호출
            tossPayments.requestPayment('카드', { // '카드' 외에 '가상계좌', '계좌이체', '휴대폰' 등 다른 결제수단 지정 가능
                amount: amountToPay,
                orderId: orderId,
                orderName: orderName,
                customerName: customerName, 
                // successUrl, failUrl은 현재창(window.location.origin) 기준으로 설정하거나, 전체 URL을 명시해야 합니다.
                // 실제 서비스에서는 이 URL에 해당하는 서블릿이나 컨트롤러를 구현하여 결제 성공/실패 로직을 처리해야 합니다.
                successUrl: window.location.origin + '/order/paySuccess?orderId=' + orderId, // 예시: 성공 시 이동할 URL (실제 프로젝트에 맞게 수정)
                failUrl: window.location.origin + '/order/payFail?orderId=' + orderId,     // 예시: 실패 시 이동할 URL (실제 프로젝트에 맞게 수정)
            })
            .catch(function (error) {
                if (error.code === 'USER_CANCEL') {
                    // 사용자가 결제를 취소한 경우
                    alert('결제가 취소되었습니다.');
                } else if (error.code === 'INVALID_CARD_COMPANY') {
                    // 유효하지 않은 카드 회사인 경우
                    alert('유효하지 않은 카드사 정보입니다.');
                } else {
                    // 기타 결제 실패 이유
                    alert('결제에 실패하였습니다. 오류 : ' + error.message);
                }
            });            
        }
      
    </script>
    </form>
</body>
</html>