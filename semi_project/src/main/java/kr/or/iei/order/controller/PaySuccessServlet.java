package kr.or.iei.order.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.order.model.service.OrderService;
import kr.or.iei.order.model.vo.Purchase;
import kr.or.iei.product.model.vo.Product;

/**
 * Servlet implementation class PaySuccessServlet
 */
@WebServlet("/order/paySuccess")
public class PaySuccessServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public PaySuccessServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 인코딩 설정 - 필터 처리

		//2. 값 추출(토스페이먼츠에서 성공 시 전달하는 파라미터)
		String paymentKey = request.getParameter("paymentKey"); // PG사 거래키
        String orderId = request.getParameter("orderId");       // 우리 시스템의 주문번호
        String amountStr = request.getParameter("amount");      // 실제 결제된 금액

        int amount = 0;
        amount = Integer.parseInt(amountStr);

        //3. 비지니스 로직 호출
        OrderService orderService = new OrderService();
        Purchase purchase = orderService.processSuccessPay(orderId, paymentKey, "TossPayments", amount);

        if (purchase != null) {
        	
        	// ✨ --- 다른 '결제대기' 주문 취소 로직 추가 --- ✨
            if (purchase.getBuyerMemberNo() != null && !purchase.getBuyerMemberNo().isEmpty() &&
                purchase.getProductNo() != null && !purchase.getProductNo().isEmpty()) {
                
                boolean cancelResult = orderService.cancelOtherPendingOrders(
                                            purchase.getBuyerMemberNo(),
                                            purchase.getProductNo(),
                                            orderId // 현재 성공한 주문 번호 (이 주문은 취소 대상에서 제외)
                                        );
                if (cancelResult) {
                    System.out.println("PaySuccessServlet: 주문[" + orderId + "] 외 상품[" + purchase.getProductNo() + "]의 다른 결제대기 주문 정리 완료.");
                } else {
                    System.out.println("PaySuccessServlet: 주문[" + orderId + "] 외 상품[" + purchase.getProductNo() + "]의 다른 결제대기 주문이 없거나 정리 중 오류 발생.");
                }
            } else {
                System.out.println("PaySuccessServlet: 다른 결제대기 주문 정리를 위한 정보(구매자번호 또는 상품번호)가 부족합니다.");
            }
            // ✨ --- 로직 추가 완료 --- ✨   	
        	
            // 결제 및 주문 처리 성공 
            Product product = orderService.selectOrderProduct(purchase.getProductNo()); // 상품 정보 조회
            
            request.setAttribute("purchase", purchase); // 처리된 구매 정보
            request.setAttribute("product", product);   // 관련 상품 정보

            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/order/orderFinish.jsp");
            view.forward(request, response);
        } else {
            // 결제는 PG사에서 성공했을 수 있으나, 우리 시스템 내부 처리 중 오류 발생
            // (예: DB 업데이트 실패, 금액 불일치 등)
            // OrderService.processSuccessfulPayment 내부에서 이미 롤백 처리됨
            request.setAttribute("orderId", orderId);
            request.setAttribute("errorTitle", "결제 처리 오류");
            request.setAttribute("errorMessage", "결제는 승인되었으나 주문 처리 중 오류가 발생했습니다. 관리자에게 문의하거나 잠시 후 주문 내역을 확인해주세요. (주문번호: " + orderId + ")");
            
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/order/orderFail.jsp"); // 실패 페이지로 안내
            view.forward(request, response);
        }

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
