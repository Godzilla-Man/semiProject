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
<title>판매 내역</title> 
</head>
<body>
    <c:choose>
        <c:when test="${empty salesList}">
            <p style="text-align:center; padding: 40px 0;">판매 내역이 없습니다.</p>
        </c:when>
        
        <c:otherwise>
            <c:forEach var="item" items="${salesList}"> 
            
                <div class="purchase-item"> 
                
                    <div class="purchase-item-header">
                        <span class="purchase-date">
                            <fmt:formatDate value="${item.enrollDate}" pattern="yy년 MM월 dd일"/> <!-- 상품 등록일 -->
                        </span>                        
                        <a href="${pageContext.request.contextPath}/product/detail?no=${item.productNo}" class="details-link"> 
                            상품 상세 보기 <span class="material-symbols-outlined">chevron_right</span>
                        </a>
                    </div>

                    <div class="purchase-item-content">
                    
                        <div class="purchase-product-image-container">                        
                            <img src="${item.thumbnailPath}" alt="${item.productName}" class="purchase-product-image-tag">
                        </div>
                        
                        <div class="purchase-product-details">                        	
                            <div class="purchase-status-wrapper">
                                 <%--
							        상품 자체의 상태를 표시할 조건:
							        1. 거래 상태(transactionStatusCode)가 없거나 (판매자가 올린 '판매중' 상품)
							        2. 또는 거래 상태가 '결제대기'(PS00)이거나
							        3. 또는 거래 상태가 '결제완료'(PS01)이거나 (요청하신 대로 '결제완료'시에는 상품 상태 노출)
							        4. 또는 거래 상태가 '취소완료'(PS04)일 때 (취소일 때는 상품 상태보다 거래 상태가 중요하므로, 아래에서 거래 상태만 표시)
							        위 경우가 아니라면 (즉, '배송중', '배송완료', '거래완료' 등) 상품 자체의 상태는 표시하지 않음.
							    --%>
							    <c:if test="${empty item.transactionStatusCode ||							    
							                   item.transactionStatusCode == 'PS00' ||
							                   item.transactionStatusCode == 'PS01' ||
							                   item.transactionStatusCode == 'PS04'}">
							        <%-- '취소완료'가 아닐 때만 상품 자체의 상태를 표시 (취소완료 시에는 아래 거래 상태만 표시) --%>
							        <c:if test="${item.transactionStatusCode != 'PS04'}">
							            <span class="purchase-status status-${item.productStatusCode}">
							                ${item.productStatusName}
							            </span>
							        </c:if>
							    </c:if>
								    
								<%-- 판매된 상품에 대한 실제 거래의 상태 --%>
								<c:if test="${not empty item.transactionStatusName}">
								
								    <%-- "취소완료" (PS04) 상태일 경우 --%>
								    <c:if test="${item.transactionStatusCode == 'PS04'}">
								        <span class="purchase-status status-cancelled" style="background-color: #dc3545; color:white;">
								            ${item.transactionStatusName} <%-- "취소완료" --%>
								        </span>
								    </c:if>
								
								    <%-- "결제완료" (PS01)가 아니고 "취소완료" (PS04)도 아닌 다른 거래 상태들만 표시 --%>
								    <c:if test="${item.transactionStatusCode != 'PS01' && item.transactionStatusCode != 'PS04'}">
								        <span class="purchase-status status-${item.transactionStatusCode}" style="margin-left: 5px; background-color: #6c757d;">
								            ${item.transactionStatusName} <%-- 예: 배송중, 배송완료, 거래완료, 결제대기 등 --%>
								        </span>
								    </c:if>
								
								</c:if>
                            </div>                        	
                            <div class="purchase-product-price"><fmt:formatNumber value="${item.productPrice}"/> 원</div> <%-- item.orderAmount -> item.productPrice (상품 원가) --%>
                            <div class="purchase-product-name">${item.productName}</div>
                            
                            <!-- 구매자 정보 숨김!! (구매자가 있는 경우(판매된 경우)에만 표시)   
                            <c:if test="${not empty item.buyerNickname}">  
                                <div class="purchase-seller-info">구매자: ${item.buyerNickname}</div>
                            </c:if>
                            -->
                            
                        </div>

                        <div class="purchase-actions">
                            <%-- 판매 내역에 맞는 버튼들로 변경 --%>
                            <%-- 예시: 상품 상태에 따른 버튼들 --%>
                            
                             <%-- 판매 내역에 맞는 버튼들로 변경 --%>
						    <%-- 발송 정보 입력 버튼: '결제완료'(PS01) 또는 '배송전'(PS03 - TBL_PROD_STATUS의 S03과 혼동 주의, 여기서는 거래상태 PS02가 있다면 그것으로) 이면서 '취소완료'(PS04)가 아닐 때 노출 --%>
						    <c:if test="${(item.transactionStatusCode == 'PS01' || item.transactionStatusCode == 'PS02' || item.transactionStatusCode == 'S03') && item.transactionStatusCode != 'PS04'}">
						        <button type="button" class="btn-action btn-enter-shipping" onclick="openShippingForm('${item.orderNo}', '${item.productNo}')">발송 정보 입력</button>
						    </c:if>
                            
                            <%-- S01: 판매중 상태일때 '상품 수정' 버튼 및 '판매 완료로 변경' 버튼 노출 기능 
                            <c:if test="${item.productStatusCode == 'S01'}"> 
                                <button type="button" class="btn-action" onclick="editProduct('${item.productNo}')">상품 수정</button>
                                <button type="button" class="btn-action dotted" onclick="markAsSold('${item.productNo}')">판매 완료로 변경</button> 
                            </c:if>
                           --%>
                            
                            <c:if test="${item.productStatusCode == 'S03'}"> <%-- S03: 판매완료 상태 (가정) --%>
                                <%-- 판매 완료된 상품에 대한 액션 (예: 구매자와의 채팅 내역 보기 등) --%>
                                <c:if test="${not empty item.orderNo}">
                                     <button type="button" class="btn-action" onclick="viewTransactionDetails('${item.orderNo}')">거래 내역 보기</button>
                                </c:if>
                            </c:if>

                            <%-- 만약 상품이 거래중(예: 배송중) 상태라면 관련 정보를 표시할 수 있습니다. --%>
                            <c:if test="${item.transactionStatusCode == 'S05'}"> <%-- S05: 배송중 (거래 상태 기준) --%>
                                <button type="button" class="btn-action dotted" onclick="trackDelivery('${item.orderNo}')">배송 조회 (판매자용)</button>
                            </c:if>
                             <c:if test="${item.transactionStatusCode == 'S06'}"> <%-- S06: 배송완료 (거래 상태 기준) --%>
                                <span style="font-size:13px; color: green;">배송완료</span>
                            </c:if>
                            
                            <%-- 필요에 따라 상품 숨김/삭제 등의 버튼 추가 가능 // 버전2에서 구현해야하며 현재는 상품 상세에서만 가능!! 
                            <button type="button" class="btn-action btn-delete-product" onclick="confirmDeleteProduct('${item.productNo}')" style="margin-top:5px;">상품 삭제</button>
                            --%>
                            
                        </div>
                                                
                    </div>                    
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    
    <%-- SweetAlert2 라이브러리는 이미 구매내역에서 사용했으므로 재사용 --%>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
    // 판매 내역 페이지에 필요한 JavaScript 함수들 정의
	
    //송장 번호 입력 폼
	function openShippingForm(orderNo, productNo) {
	    Swal.fire({
	        title: '발송 정보 입력',
	        width: '500px',
	        html: `
	            <div style="text-align: left; margin-bottom: 1rem;">
	                <label for="swal-delivery-company" class="swal-custom-label">택배사 선택</label>
	                <select id="swal-delivery-company" class="swal-custom-form-element">
	                    <option value="">택배사를 선택하세요</option>
	                    <option value="CJ">CJ대한통운</option> <%-- value를 코드로 변경 --%>
	                    <option value="POST">우체국택배</option> <%-- value를 코드로 변경 --%>
	                    <option value="HANJIN">한진택배</option> <%-- value를 코드로 변경 --%>
	                    <option value="LOTTE">롯데택배</option> <%-- value를 코드로 변경 --%>
	                    <option value="ROZEN">로젠택배</option> <%-- value를 코드로 변경 --%>
	                    <option value="ETC">기타 (직접입력)</option> <%-- '기타'에 대한 코드 정의 (예: ETC) --%>
	                </select>
	                <input type="text" id="swal-delivery-company-etc" class="swal-custom-form-element" placeholder="택배사명 직접 입력" style="display: none; margin-top: .5rem;">
	            </div>
	            <div style="text-align: left;">
	                <label for="swal-tracking-number" class="swal-custom-label">송장번호 입력</label>
	                <input type="text" id="swal-tracking-number" class="swal-custom-form-element" placeholder="송장번호를 입력하세요 ('-' 없이 숫자만)">
	            </div>
	        `,
	        confirmButtonText: '저장',
	        cancelButtonText: '취소',
	        showCancelButton: true,
	        focusConfirm: false,
	        didOpen: () => {
	            const deliveryCompanySelect = document.getElementById('swal-delivery-company');
	            const deliveryCompanyEtcInput = document.getElementById('swal-delivery-company-etc');
	            deliveryCompanySelect.addEventListener('change', function() {
	                if (this.value === 'ETC') { // '기타' 코드값으로 비교
	                    deliveryCompanyEtcInput.style.display = 'block';
	                    deliveryCompanyEtcInput.focus();
	                } else {
	                    deliveryCompanyEtcInput.style.display = 'none';
	                    deliveryCompanyEtcInput.value = '';
	                }
	            });
	        },
	        preConfirm: () => {
	            const deliveryCompanyCode = document.getElementById('swal-delivery-company').value;
	            let deliveryCompanyName = document.getElementById('swal-delivery-company').selectedOptions[0].text; // 선택된 옵션의 텍스트 (택배사명)
	            const trackingNumber = document.getElementById('swal-tracking-number').value;
	            const deliveryCompanyEtcName = document.getElementById('swal-delivery-company-etc').value;
	
	            if (deliveryCompanyCode === 'ETC') {
	                if (!deliveryCompanyEtcName) { // 기타인데 직접 입력 안한 경우
	                    Swal.showValidationMessage('기타 택배사명을 입력해주세요.');
	                    return false;
	                }
	                deliveryCompanyName = deliveryCompanyEtcName; // 직접 입력한 택배사명 사용
	            }
	
	            if (!deliveryCompanyCode) { // 코드가 선택되지 않은 경우 (기본 "택배사를 선택하세요" 옵션 등)
	                Swal.showValidationMessage('택배사를 선택해주세요.');
	                return false;
	            }
	            if (!trackingNumber) {
	                Swal.showValidationMessage('송장번호를 입력해주세요.');
	                return false;
	            }
	
	            console.log("preConfirm - deliveryCompanyCode:", deliveryCompanyCode);
	            console.log("preConfirm - deliveryCompanyName:", deliveryCompanyName);
	            console.log("preConfirm - trackingNumber:", trackingNumber);
	
	            return {
	                deliveryCompanyCode: deliveryCompanyCode,
	                deliveryCompanyName: deliveryCompanyName, // 기타 입력 시의 이름 포함
	                trackingNumber: trackingNumber
	            };
	        }
	    }).then((result) => {
	        if (result.isConfirmed) {
	            const shipmentData = result.value;
	            const params = new URLSearchParams(); // 이전 답변에서 수정한 대로 URLSearchParams 사용
	            params.append('orderNo', orderNo);
	            params.append('productNo', productNo);
	            params.append('deliveryCompanyCode', shipmentData.deliveryCompanyCode); // 택배사 코드 전송
	            params.append('deliveryCompanyName', shipmentData.deliveryCompanyName); // 택배사 명 전송
	            params.append('trackingNumber', shipmentData.trackingNumber);
	
	            fetch('${pageContext.request.contextPath}/order/saveShipmentInfo', {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/x-www-form-urlencoded'
	                },
	                body: params
	            })
	            .then(response => {
	                if (!response.ok) {
	                    return response.json().then(err => { throw new Error(err.message || '서버 응답 오류'); });
	                }
	                return response.json();
	            })
	            .then(data => {
	                if (data.success) {
	                    Swal.fire({
	                        title: '저장 완료!',
	                        text: data.message || '발송 정보가 성공적으로 저장되었습니다.',
	                        icon: 'success'
	                    }).then(() => {
	                        location.reload();
	                    });
	                } else {
	                    Swal.fire({
	                        title: '저장 실패',
	                        text: data.message || '발송 정보 저장 중 오류가 발생했습니다.',
	                        icon: 'error'
	                    });
	                }
	            })
	            .catch(error => {
	                console.error('Error saving shipment info:', error);
	                Swal.fire({
	                    title: '오류 발생',
	                    text: error.message || '발송 정보 저장 중 네트워크 또는 서버 오류가 발생했습니다.',
	                    icon: 'error'
	                });
	            });
	        }
	    });
	} 
    </script>
    
</body>
</html>