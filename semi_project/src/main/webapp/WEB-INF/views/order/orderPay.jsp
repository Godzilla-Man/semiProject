<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>줍줍 - 결제하기</title>
    <link rel="stylesheet" href="order_style.css">
</head>
<body class="page-index2"> <!-- index2 페이지 전용 클래스 추가 -->
    <div class="container">
        <div class="header">
            <a href="order_start.html" class="back-button">&lt;</a>
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
                <p>선불(일반 택배)</p>
            </div>
            <div class="summary-group">
                <h3 class="summary-group-title">배송 정보</h3>
                <p>카와키타사이카</p>
                <p>010-1234-5678</p>
                <p>(12345) 서울시 줍줍구 줍줍로 123, 101동 101호</p>
            </div>
            <div class="summary-group">
                <h3 class="summary-group-title">주문상품 정보</h3>           
                <div class="product-details">
                    <div class="product-image-placeholder">
                        <span>상품 이미지</span>
                    </div>
                    <div class="product-text-details">
                        <div class="product-name">나이키 반팔 티셔츠</div>
                        <div class="product-price">500,000 원</div>
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
                <span class="summary-value">500,000원</span>
            </div>

            <div class="summary-item">
                <span class="summary-label">배송비</span>
                <span class="summary-value">5,000원</span>
            </div>

            <div class="summary-item">
                <span class="summary-label">줍줍 판매 수수료</span>
                <span class="summary-value">무료 이벤트 진행 중</span>
            </div>

            <hr class="summary-divider">

            <div class="summary-item total">
                <span class="summary-label total-label">총 결제금액</span>
                <span class="summary-amount total-amount">505,000원</span>
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
                <a href="#" class="view-term-link">보기</a>
            </li>
            <li>
                <label for="agreeTermPersonalInfo" class="term-item-label">
                    <input type="checkbox" id="agreeTermPersonalInfo" name="agreeTermPersonalInfo" class="agree-individual" required>
                    개인정보 수집 및 이용 동의 (필수)
                </label>
                <a href="#" class="view-term-link">보기</a>
            </li>
            <li>
                <label for="agreeTermThirdParty" class="term-item-label">
                    <input type="checkbox" id="agreeTermThirdParty" name="agreeTermThirdParty" class="agree-individual" required>
                    개인정보 제3자 제공 동의 (필수)
                </label>
                <a href="#" class="view-term-link">보기</a>
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
            alert('토스페이 API 연동이 필요합니다.\n' + paymentButton.textContent + ' 요청됨 (가상)');
        }

        // 결제 수단 선택
        const paymentOptions = document.querySelectorAll('.payment-method-selection .method-option');
        paymentOptions.forEach(option => {
            option.addEventListener('click', function() {
                document.querySelector('.payment-method-selection .method-option.selected')?.classList.remove('selected');
                this.classList.add('selected');
                const radioInput = this.querySelector('input[type="radio"]');
                if (radioInput) {
                    radioInput.checked = true;
                }
            });
        });
    </script>
</body>
</html>