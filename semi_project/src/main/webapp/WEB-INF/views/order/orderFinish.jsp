<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>줍줍 - 결제 완료</title>
    
    <%-- Google Material Symbols 추가 --%>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="/resources/css/order.css">   
       
    
    <style>
        /* SweetAlert2 스타일 */
        .swal2-popup {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            border-radius: 12px !important; /* 기존 .section의 border-radius와 유사하게 */
        }
        .swal2-title {
            font-size: 20px !important;
            font-weight: bold !important;
            color: #333333 !important;
        }
        .swal2-html-container {
            font-size: 15px !important;
            color: #555555 !important;
        }
        .swal2-confirm { /* 확인 버튼 */
            background-color: #0064FF !important; /* 기본 버튼 색상 */
            border-radius: 8px !important;
            font-size: 16px !important;
            padding: 10px 20px !important;
        }
        .swal2-confirm:hover {
            background-color: #0052CC !important;
        }
        .swal2-cancel { /* 취소 버튼 */
            background-color: #FFFFFF !important;
            color: #888888 !important;
            border: 1.5px solid #DDDDDD !important;
            border-radius: 8px !important;
            font-size: 16px !important;
            padding: 10px 20px !important;
        }
        .swal2-cancel:hover {
            background-color: #f8f8f8 !important;
        }
        .swal2-icon.swal2-warning {
            /* 아이콘 크기를 font-size로 조절 (폰트 기반 아이콘일 경우) */
            font-size: 50px !important; /* 기본값은 보통 더 큽니다. 원하는 크기로 조절 */
            /* 또는 width/height로 직접 조절 (SVG 또는 특정 구조의 아이콘일 경우) */
            width: 50px !important;
            height: 50px !important;
            /* 아이콘 내부의 선 두께 등도 조절해야 할 수 있습니다. */
            border-width: 3px !important; /* 예시: 느낌표 선 두께 조절 */
            /* 필요에 따라 margin, padding 등도 조절하여 레이아웃을 맞춥니다. */
            margin-top: 10px !important;
            margin-bottom: 10px !important;
            
            border-color: #888888 !important;  /* 테두리 색 */
    		color: #888888 !important;         /* 아이콘 내부 색 */
        }

        /* 경고 아이콘 내부의 느낌표(!) 부분 크기 조절 (만약 별도 요소로 있다면) */
        .swal2-icon.swal2-warning .swal2-icon-content {
            font-size: 30px !important; /* 예시: 느낌표 자체의 크기 */
        }
       
    </style>
    
   
</head>
<body class="page-index3"> 
	<form action="#" method="post">

    <div class="container">
        <div class="header">
        
            <a href="${pageContext.request.contextPath}/" class="home-button-style">
                <span class="material-symbols-outlined">home</span>
            </a>
            
            <h1 class="page-title-centered">결제 완료</h1>
        </div>

        <div class="payment-flow-indicator">
            <span class="step">1. 주문</span>
            <span class="step">2. 결제</span>
            <span class="step current">3. 완료</span>
        </div>

        <div class="section order-thank-you-message">
            <h2>주문해주셔서 감사합니다.</h2>
            <p>고객님의 주문이 정상적으로 완료되었습니다.</p>
            <a href="${pageContext.request.contextPath}/" class="continueShopping-button-style">쇼핑 계속하기</a>
        </div>

        <div class="section order-completed-summary">
            <h3 class="summary-group-title">주문 내역</h3>
            <div class="info-row">
                <span class="label">주문상태</span>
                <span class="value order-status">결제완료</span>
            </div>

            <div class="info-row">
                <span class="label">주문번호</span>
                <span class="value order-number">${purchase.orderNo}</span>
            </div>

            <div class="info-row">
                <span class="label">주문일자</span>
                <span class="value order-date">${purchase.dealDate}</span>
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
            <button type="button" class="change-button-style" onclick="confirmCancelOrder('${purchase.orderNo}')">거래 취소</button>
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
                <div class="summary-item">
                    <span class="summary-label">줍줍 판매 수수료</span>
                    <span class="summary-value">무료 이벤트 진행 중</span>
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

	
    <!-- <script src="${pageContext.request.contextPath}/resources/js/sweetalert.min.js"></script> ★SWAL JS파일 상단에 두면 오류나서 여기에 둠!! --> 
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
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
            Swal.fire({
                title: '주문 취소 확인',
                text: "주문 취소를 진행하시겠습니까?",
                icon: 'warning', // 아이콘 타입 (warning, error, success, info, question)
                showCancelButton: true, // 취소 버튼 표시
                confirmButtonColor: '#0064FF', // 확인 버튼 색상 (프로젝트 주요 색상)
                cancelButtonColor: '#DDDDDD',   // 취소 버튼 색상
                confirmButtonText: '네, 취소할게요', // 확인 버튼 텍스트
                cancelButtonText: '아니요',     // 취소 버튼 텍스트
                reverseButtons: true // 버튼 순서 바꾸기 (취소-확인 순으로)
            }).then((result) => {
                if (result.isConfirmed) { // 사용자가 '확인' 버튼을 눌렀을 때
                    // 거래 취소 처리 서블릿으로 이동
                    location.href = "${pageContext.request.contextPath}/order/cancelOrder?orderId=" + orderNo;
                }
            });
        }
        
    </script>

	</form>
</body>
</html>