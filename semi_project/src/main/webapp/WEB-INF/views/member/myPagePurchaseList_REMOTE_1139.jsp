<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/myPage.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<title>구매 내역</title>
</head>
<body>
    <c:choose>
    
        <c:when test="${empty purchaseList}">
            <p style="text-align:center; padding: 40px 0;">구매 내역이 없습니다.</p>
        </c:when>
        
        <c:otherwise>
            <c:forEach var="item" items="${purchaseList}">
            
                <div class="purchase-item"> <%-- 각 구매 건을 감싸는 컨테이너 --%>
                
                    <div class="purchase-item-header">
                        <span class="purchase-date">
                            <fmt:formatDate value="${item.dealDate}" pattern="yy년 MM월 dd일"/>
                        </span>
                        
                        <a href="${pageContext.request.contextPath}/product/detail?no=${item.productNo}" class="details-link">
                            상품 상세 보기 <span class="material-symbols-outlined">chevron_right</span>
                        </a>
                        
                        <!-- 버전2에서 구현 예정 
                        <a href="${pageContext.request.contextPath}/order/detail?orderNo=${item.orderNo}" class="details-link">
                            주문 상세 보기 <span class="material-symbols-outlined">chevron_right</span>
                        </a>
                         -->
                    </div>

                    <div class="purchase-item-content">
                    
                        <div class="purchase-product-image-container">                        
                            <img src="${item.thumbnailPath}" alt="${item.productName}" class="purchase-product-image-tag">
                        </div>
                        
                        <div class="purchase-product-details">                        	
                        	 <div class="purchase-status-wrapper"> 
                                <span class="purchase-status status-${item.purchaseStatusCode}"> <%-- image-overlay-status 클래스 제거 또는 수정 --%>
                                    ${item.purchaseStatusName}
                                </span>
                            </div>                        	
                            <div class="purchase-product-price"><fmt:formatNumber value="${item.orderAmount}"/> 원</div>
                            <div class="purchase-product-name">${item.productName}</div>
                            <!-- <div class="purchase-seller-info">판매자: ${item.sellerNickname}</div> *판매자 닉네임 노출 없앰. 깔끔하게 하려고!! -->
                        </div>

                        <div class="purchase-actions">
                            <%-- 상태에 따라 다른 버튼 표시 --%>
                            
                            <c:if test="${item.purchaseStatusCode == 'PS01'}"> <%-- 결제완료 --%>
                                <button type="button" class="btn-action" onclick="confirmCancelOrder('${item.orderNo}')">거래취소</button>
                            </c:if>
                            
                            <c:if test="${item.purchaseStatusCode == 'PS00'}"> <%-- 결제대기 --%>
                                <button type="button" class="btn-action btn-goToPay" onclick="goToPay('${item.orderNo}')">결제하기</button>
                            </c:if>                          
                            
                            <c:if test="${item.purchaseStatusCode == 'S05' || item.purchaseStatusCode == 'S06'}"> <%-- 배송중 또는 배송완료 --%>
                                <button type="button" class="btn-action dotted">배송 조회</button>
                            </c:if>
                            <c:if test="${item.purchaseStatusCode == 'PS06'}"> <%-- 배송완료 --%>
                                <button type="button" class="btn-action" onclick="confirmPurchase('${item.orderNo}')">구매 확정</button>                                
                            </c:if>
                            <c:if test="${item.purchaseStatusCode == 'PS07'}"> <%-- 거래완료 --%>
    						<button type="button" class="btn-action" onclick="goToWriteReview('${item.orderNo}')">리뷰 작성</button>
							</c:if>
                        </div>
                                                
                    </div>                    
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
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
    
    
    <!-- 결제 대기 상태 상품 결제 페이지로 토스 -->
    function goToPay(orderId) {
        
        location.href = "${pageContext.request.contextPath}/order/orderPay?orderId=" + orderId;

    }    
    
 	<!-- 구매 확정 버튼 JS -->
    function confirmPurchase(orderNo) {
	    Swal.fire({
	        title: '구매 확정',
	        text: "구매를 확정하시겠습니까? 확정 후에는 반품/교환이 어려울 수 있습니다.",
	        icon: 'question',
	        showCancelButton: true,
	        confirmButtonColor: '#28a745',
	        cancelButtonColor: '#6c757d',
	        confirmButtonText: '네, 확정합니다.',
	        cancelButtonText: '아니요'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            const params = new URLSearchParams();
	            params.append('orderNo', orderNo);
	
	            fetch('${pageContext.request.contextPath}/order/confirmPurchase', {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/x-www-form-urlencoded'
	                },
	                body: params
	            })
	            .then(response => {
	                if (!response.ok) { // HTTP 상태 코드가 200-299가 아니면 에러로 간주
	                    throw new Error('서버 응답 오류: ' + response.status);
	                }
	                return response.text(); // 서버 응답을 텍스트로 받음
	            })
	            .then(textResponse => {
	                // 서버에서 "success" 또는 "fail" 같은 간단한 문자열을 보낸다고 가정
	                if (textResponse.trim().toLowerCase() === "success") {
	                    Swal.fire({
	                        title: '구매 확정 완료!',
	                        text: '구매가 성공적으로 확정되었습니다.',
	                        icon: 'success'
	                    }).then(() => {
	                        location.reload();
	                    });
	                } else {
	                    // textResponse에 실패 메시지가 담겨 올 수도 있음
	                    Swal.fire({
	                        title: '구매 확정 실패',
	                        text: textResponse || '구매 확정 처리 중 오류가 발생했습니다.', // 서버가 보낸 메시지 또는 기본 메시지
	                        icon: 'error'
	                    });
	                }
	            })
	            .catch(error => {
	                console.error('Error confirming purchase:', error);
	                Swal.fire({
	                    title: '오류 발생',
	                    text: '구매 확정 처리 중 오류가 발생했습니다. (' + error.message + ')',
	                    icon: 'error'
	                });
	            });
	        }
	    });
	}
    
    <!-- 리뷰 남기러 가기 JS -->
    function goToWriteReview(orderNo) {
        location.href = "${pageContext.request.contextPath}/review/write?orderNo=" + orderNo;
    }
    </script>

</body>
</html>