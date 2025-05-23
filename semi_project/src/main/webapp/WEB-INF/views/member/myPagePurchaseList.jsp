<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/myPage.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<title>Insert title here</title>
</head>
<body>
	<c:choose>
		<c:when test="${empty purchaseList}">
			<p style="text-align:center; padding: 40px 0;">구매 내역이 없습니다.</p>
		</c:when>
		<c:otherwise>
			<c:forEach var="item" items="${purchaseList}">
				
				<div class="purchase-item-header">
					<span class="purchase-date">
						<fmt:formatDate value="${item.dealDate}" pattern="yy년 MM월 dd일"/>
					</span>
					<%-- 주문 상태에 따라 다른 CSS 클래스 적용 --%>
					<span class="purchase-status status-${item.purchaseStatusCode}">
						${item.purchaseStatusName}
					</span>
					<%--상세 보기 링크 --%>
					<a href="${pageContext.request.contextPath}/order/detail?orderNo=${item.orderNo}" class="material-sybols-outlined">chevron_right</a>  
				</div>
				
				<div class="purchase-product-info">
					<div class="purchase-product-price"><fmt:formatNumber value="${item.orderAmount}" type="currency" currencyCode="KRW"/></div>
					<div class="purchase-product-name">${item.productName}</div>
					<div class="purchase-seller-info">판매자: ${item.sellerNickname}</div>												
				</div>
				
				<div class="purchase-actions">
					<%-- 상태에 따라 다른 버튼 표시 (예시) --%>
                          <c:if test="${item.purchaseStatusCode == 'PS01'}"> <%-- 결제완료 상태 --%>
                              <button type="button" class="btn-action" onclick="confirmCancelOrder('${item.orderNo}')">거래 취소</button>
                          </c:if>
                          <c:if test="${item.purchaseStatusCode == 'S05' || item.purchaseStatusCode == 'S06'}"> <%-- 배송중 또는 배송완료 --%>
                              <button type="button" class="btn-action dotted">배송 조회</button>
                          </c:if>
                          <c:if test="${item.purchaseStatusCode == 'S06'}"> <%-- 배송완료 상태 --%>
                              <button type="button" class="btn-action">구매 확정</button>
                              <button type="button" class="btn-action">리뷰 작성</button>
                          </c:if>
				</div>
				
			</c:forEach>
		</c:otherwise>
	</c:choose>
</body>
</html>