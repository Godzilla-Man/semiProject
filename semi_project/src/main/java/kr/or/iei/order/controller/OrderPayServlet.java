package kr.or.iei.order.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.crypto.KeySelector.Purpose;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.order.model.service.OrderService;
import kr.or.iei.order.model.vo.Purchase;
import kr.or.iei.product.model.vo.Product;

/**
 * Servlet implementation class OrderPayServlet
 */
@WebServlet("/order/orderPay")
public class OrderPayServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrderPayServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 인코딩 설정 - 인코딩 필터로 설정 완료	
		
		//1.2 로그인 확인 로직
		HttpSession session = request.getSession(false); // 세션이 없으면 새로 생성하지 않음.
		Member loginMember = null;
		
		if(session != null) {
			loginMember = (Member) session.getAttribute("loginMember"); //"m"으로 세션에 저장된 Member 객체를 가져옴.
		}
		System.out.println("OrderPayServlet : 세션에서 구매자 정보 로드됨 - " + loginMember.getMemberId());
		
		
		// 2. 값 추출
		String orderIdFromRequest = request.getParameter("orderId"); // 마이페이지에서 주문 재시작
		String productIdFromRequest = request.getParameter("productId"); // 신규 주문건 처리

		OrderService orderservice = new OrderService();
		Product p = null; // 최종적으로 사용할 상품 객체 
		String generatedOrderId = null; // 최종적으로 사용할 주문 ID 
		int totalProductAmount = 0;   // 총 결제 예상 금액
		int deliveryFee = 0;      // 배송비

		if (orderIdFromRequest != null && !orderIdFromRequest.isEmpty()) { // orderId가 넘어온 경우 (마이페이지 "결제하기")
		    		    
		    Purchase existingPurchase = orderservice.getPurchaseDetails(orderIdFromRequest);

		    if (existingPurchase != null && loginMember.getMemberNo().equals(existingPurchase.getBuyerMemberNo())) {
		        p = orderservice.selectOrderProduct(existingPurchase.getProductNo()); // 상품 정보 가져오기

		        if (p != null) {
		            totalProductAmount = existingPurchase.getOrderAmount();
		            deliveryFee = existingPurchase.getDeliveryFee();
		            generatedOrderId = existingPurchase.getOrderNo(); // 기존 주문번호 사용
		        } else {
		            // 상품 정보를 못 가져온 경우 (예: 삭제된 상품)
		            System.out.println("OrderPayServlet : 기존 주문의 상품 정보를 찾을 수 없습니다. ProductNo: " + existingPurchase.getProductNo());		          
		        }
		    } else {
		        // 주문 정보가 없거나, 본인 주문이 아닌 경우
		        System.out.println("OrderPayServlet : 유효하지 않은 기존 주문 정보 접근. OrderId: " + orderIdFromRequest);		      
		    }

		} else if (productIdFromRequest != null && !productIdFromRequest.isEmpty()) {  // productId가 넘어온 경우 (신규 주문)
		   	    
		    p = orderservice.selectOrderProduct(productIdFromRequest);

		    if (p == null) { // 3.1 기존 상품 조회 실패 시 에러 처리 
		        request.setAttribute("errorTitle", "상품 정보 조회 실패");
		        request.setAttribute("errorMessage", "요청하신 상품 ID('" + productIdFromRequest + "')에 해당하는 상품 정보를 찾을 수 없거나, 현재 구매할 수 없는 상품입니다. 상품 ID를 다시 확인해주세요.");
		        RequestDispatcher errorView = request.getRequestDispatcher("/WEB-INF/views/order/errorPage.jsp");
		        errorView.forward(request, response);
		        return;
		    }

		    // 3.2 총 결제 예상 금액 계산 
		    int productPrice = p.getProductPrice();
		    String tradeMethodCode = p.getTradeMethodCode();
		    if ("M2".equals(tradeMethodCode)) {
		        deliveryFee = 5000;
		    }
		    totalProductAmount = productPrice + deliveryFee;

		    // 3.3 주문 정보 객체 생성 및 DB에 'PS00' 상태로 INSERT
		    Purchase readyOrder = new Purchase();
		    readyOrder.setProductNo(p.getProductNo());
		    readyOrder.setBuyerMemberNo(loginMember.getMemberNo());
		    readyOrder.setSellerMemberNo(p.getMemberNo());
		    readyOrder.setOrderAmount(totalProductAmount);
		    readyOrder.setDeliveryFee(deliveryFee);
		    readyOrder.setDeliveryAddr(loginMember.getMemberAddr());
		    readyOrder.setPurchaseStatusCode("PS00");

		    generatedOrderId = orderservice.createOrderId(readyOrder); // 생성된 주문번호		   
		} 

		// 4. 결과 처리 (JSP로 데이터 전달)
		request.setAttribute("product", p);
		request.setAttribute("loginMember", loginMember);
		request.setAttribute("totalProductAmount", totalProductAmount);
		request.setAttribute("deliveryFee", deliveryFee);
		request.setAttribute("orderId", generatedOrderId);

		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/order/orderPay.jsp");
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
