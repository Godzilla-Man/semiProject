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
 * Servlet implementation class PayFailServlet
 */
@WebServlet("/order/payFail")
public class PayFailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PayFailServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 인코딩 설정 (필터로 처리)
		
		//2. 값 추출(토스에서 실패 시 전달하는 파라미터)
		String errorCode = request.getParameter("code"); //오류 코드
		String errorMessage = request.getParameter("message"); //오류 메시지
		String orderId = request.getParameter("orderId"); //주문 번호
		
		//2.1 
		if(orderId == null) {
			request.setAttribute("errorTitle",  "주문 정보 누락");
			request.setAttribute("errorMessage", "실패한 주문 정보를 특정 불가.");
			RequestDispatcher errorView = request.getRequestDispatcher("/WEB-INF/views/order/errorPage.jsp");
			errorView.forward(request, response);
            return;
		}
		
		// 3. 비즈니스 로직 (주문 정보를 가져와서 화면에 일부 표시 가능)
        // 결제 실패 시, TBL_PURCHASE의 주문 상태는 'PS00'(결제대기)로 남아있게 됩니다.
        // 추가적인 상태 업데이트(예: 'PS99' 결제실패)는 필요에 따라 구현할 수 있습니다.
        OrderService orderService = new OrderService();
        Purchase purchase = orderService.getPurchaseDetails(orderId); // DB에서 해당 주문 정보 조회
        Product product = null;
        if(purchase != null) {
        	product = orderService.selectOrderProduct(purchase.getProductNo()); // 관련 상품 정보 조회
        }

        // 4. 결과 처리 (JSP 페이지로 데이터 전달)
        request.setAttribute("errorCode", errorCode);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("orderId", orderId);
        request.setAttribute("purchase", purchase); // 조회된 구매 정보 (있을 경우)
        request.setAttribute("product", product);   // 조회된 상품 정보 (있을 경우)

        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/order/orderFail.jsp");
        view.forward(request, response);
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
