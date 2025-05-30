<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>줍줍 - 주문 상세 내역</title>
    <%-- Google Material Symbols 추가 --%>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="/resources/css/order.css">
</head>

<body class="page-index3"> 
	<form action="#" method="post">

    <div class="container">
        <div class="header">
                
            <a href="${pageContext.request.contextPath}/" class="home-button-style">
                <span class="material-symbols-outlined">home</span>
            </a>

            <h1 class="page-title-centered">주문 상세 내역</h1>
        </div>
		
		<!-- 주문 취소 완료 페이지여서 해당 페이지에는 상단 제목 없음  
        <div class="payment-flow-indicator">
            <span class="step">1. 주문</span>
            <span class="step">2. 결제</span>
            <span class="step current">3. 완료</span>
        </div>
        -->

        <div class="section order-thank-you-message">
            <h2>주문 취소 완료</h2>
            <p>고객님의 주문이 정상적으로 취소되었습니다.</p>
            <a href="${pageContext.request.contextPath}/" class="continueShopping-button-style">다른 상품 보러가기</a>
        </div>

        <div class="section order-completed-summary">
            <h3 class="summary-group-title">주문 취소 내역</h3>
            <div class="info-row">
                <span class="label">주문상태</span>
                <span class="value order-status">취소완료</span>
            </div>

            <div class="info-row">
                <span class="label">주문번호</span>
                <span class="value order-number">${purchase.orderNo}</span>
            </div>

            <div class="info-row">
                <span class="label">주문일자</span>
                <span class="value order-date"><fmt:formatDate value="${purchase.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
            </div>

            <div class="info-row">
                <span class="label">판매자</span>
                <span class="value order-seller">${product.sellerNickname}</span> <!-- 판매자 셀러 정보 노출!! -->
            </div>

            <hr class="content-divider"> 
         
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

        <div class="section payment-info-completed"> 
            <h2 class="section-main-title">결제 정보</h2>
            <div class="simplified-payment-summary no-box-styling">
                
                <div class="summary-item"> 
                    <span class="summary-label">결제수단</span>
                    <span class="summary-value">${purchase.pgProvider}</span>
                </div>                
                
                <div class="summary-item">
                    <span class="summary-label">상품금액</span>
                    <span class="summary-value"><fmt:formatNumber value="${product.productPrice}" type="number"/> 원</span>
                </div>
                <div class="summary-item">
                    <span class="summary-label">배송비</span>
                    <span class="summary-value"><fmt:formatNumber value="${purchase.deliveryFee}" type="number"/> 원</span>
                </div>                       
           
                <hr class="summary-divider">

                <div class="summary-item total">
                    <span class="summary-label total-label">총 결제금액</span>
                    <span class="summary-amount total-amount"><fmt:formatNumber value="${purchase.orderAmount}" type="number"/> 원</span>
                </div>
              
            </div>
        </div>   
        

        <div class="faq-section">
            <h2 class="section-main-title">자주 묻는 질문</h2>
            <div class="faq-list">
                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>배송은 언제 시작되나요?</span>
                        <span class="faq-icon"></span>
                    </button>
                    <div class="faq-answer">
                        <p>판매자 분께서 판매 내역 확인 및 발송 후 일반적으로 영업일 2-3일 내외로 발송됩니다. 7일간 판매자분의 응답이 없으면 자동 환불 처리 돼요.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>줍줍 판매 및 구매 수수료는 어떻게 되나요?</span>
                        <span class="faq-icon"></span>
                    </button>
                    <div class="faq-answer">
                        <p>현재 줍줍에서는 판매 및 구매 수수료 모두 무료 이벤트를 진행 중입니다. 많은 이용 부탁드립니다.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>실수로 배송완료 전에 구매 확정을 먼저 눌렀어요.</span>
                        <span class="faq-icon"></span>
                    </button>
                    <div class="faq-answer">
                        <p>해당의 경우는 줍줍 고객센터로 문의 부탁드립니다.(고객센터 : 1588-2424)</p>
                    </div>
                </div>
                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>거래 중 분쟁이 발생했어요.</span>
                        <span class="faq-icon"></span>
                    </button>
                    <div class="faq-answer">
                        <p>기본적으로 판매자와 구매자분간에 원만한 합의 바랍니다. 이외에 자세한 분쟁 상황에 대해서는 변호사를 선임해드리고 있습니다.(김앤장 법율 사무소 자매 결연 진행 중)</p>
                    </div>
                </div>
                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>구매한 상품을 결제 취소 하고 싶어요.</span>
                        <span class="faq-icon"></span>
                    </button>
                    <div class="faq-answer">
                        <p>판매자분께서 배송 시작전 결제 취소가 가능합니다. 결제 취소 신중하게 고려 후 배송 시작전 빠르게 결제 취소 바랍니다.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>토스 페이로만 결제가 가능한가요?</span>
                        <span class="faq-icon"></span>
                    </button>
                    <div class="faq-answer">
                        <p>현재는 토스페이 안견 결제 서비스만 제공해드리고 있습니다. 추후 빠른 시일내에 다른 결제 서비스도 제공해드릴 수 있도록 노력하겠습니다.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>판매자가 너무 열받게 하는데요.</span>
                        <span class="faq-icon"></span>
                    </button>
                    <div class="faq-answer">
                        <p>구매자분과 판매자분간의 분쟁이 안 끝날 시, '야차룰' 대결 중개 서비스를 별도 진행하고 있습니다. 상대측과 야차룰이 필요하신 경우 고객센터로 연락 바랍니다.(고객센터 : 1588-2424)</p>
                    </div>
                </div>
            </div>
        </div>


        <div class="payment-notice-text">
            <p>
                (주)줍줍은 통신판매중개자이며, 통신판매의 당사자가 아닙니다. 전자상거래 등에서의 소비자보호에 관한 법률 등 관련 법령 및
                (주)줍줍의 약관에 따라 상품, 상품정보, 거래에 관한 책임은 개별 판매자에게 귀속하고, (주)줍줍은 원칙적으로 회원간 거래에 대하여 책임을 지지 않습니다.
                다만, (주)줍줍이 직접 판매하는 상품에 대한 책임은 (주)줍줍에게 귀속합니다.
            </p>
        </div>
    </div>


    
    <script>
    	<!-- FAQ JS -->
        document.addEventListener('DOMContentLoaded', function () {
            const faqItems = document.querySelectorAll('.faq-item');

            faqItems.forEach(item => {
                const questionButton = item.querySelector('.faq-question');
                const answerDiv = item.querySelector('.faq-answer');
                const icon = questionButton.querySelector('.faq-icon');

                questionButton.addEventListener('click', () => {
                    const isOpen = answerDiv.classList.contains('open');

                    if (isOpen) {
                        answerDiv.classList.remove('open');
                        questionButton.classList.remove('active');
                        icon.classList.remove('open');
                    } else {
                        answerDiv.classList.add('open');
                        questionButton.classList.add('active');
                        icon.classList.add('open');
                    }
                });
            });
        });
        
        
        <!-- 주문 취소 버튼 JS -->
        function confirmCancelOrder(orderNo) {
            if (confirm("정말 거래를 취소하시겠습니까? 취소 후에는 복구할 수 없습니다.")) {
                // 거래 취소 처리 서블릿으로 이동
                location.href = "${pageContext.request.contextPath}/order/cancelOrder?orderId=" + orderNo;
            }
        }
    </script>

	</form>
</body>
</html>