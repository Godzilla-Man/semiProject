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
                        <a href="${pageContext.request.contextPath}/order/detail?orderNo=${item.orderNo}" class="details-link">
                            주문 상세 보기 <span class="material-symbols-outlined">chevron_right</span>
                        </a>
                    </div>

                    <div class="purchase-item-content">
                    
                        <div class="purchase-product-image-container">                        
                            <img src="${item.thumbnailPath}" alt="${item.productName}" class="purchase-product-image-tag">
                        </div>
                        
                        <div class="purchase-product-details">                        	
                        	 <div class="purchase-status-wrapper"> <%-- 상태를 감싸는 div 추가 (선택적, 스타일링 용이) --%>
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
                            
                            <c:if test="${item.purchaseStatusCode == 'PS01'}"> <%-- 결제완료 상태 --%>
                                <button type="button" class="btn-action" onclick="confirmCancelOrder('${item.orderNo}')">거래취소</button>
                            </c:if>
                            
                            <c:if test="${item.purchaseStatusCode == 'PS00'}"> <%-- 결제대기 상태 --%>
                                <button type="button" class="btn-action btn-goToPay" onclick="goToPay('${item.orderNo}')">결제하기</button>
                            </c:if>                          
                            
                            <c:if test="${item.purchaseStatusCode == 'S05' || item.purchaseStatusCode == 'S06'}"> <%-- 배송중 또는 배송완료 --%>
                                <button type="button" class="btn-action dotted">배송 조회</button>
                            </c:if>
                            <c:if test="${item.purchaseStatusCode == 'S06'}"> <%-- 배송완료 상태 --%>
                                <button type="button" class="btn-action">구매 확정</button>
                                <button type="button" class="btn-action">리뷰 작성</button>
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
    </script>

</body>
</html>