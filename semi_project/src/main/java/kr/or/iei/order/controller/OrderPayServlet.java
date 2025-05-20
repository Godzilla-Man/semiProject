package kr.or.iei.order.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
		
		//2. 값 추출
		
		//[회원 정보 갖고오기]
		HttpSession session = request.getSession(); //로그인 세션 갖고 오기
		Member buyer = (Member) session.getAttribute("m"); // 세션에서 기존 구매자 로그인 정보 확인
		
		if(buyer == null) { // 세션에 구매자 정보가 없으면 가상 구매자 정보 생성(★테스트용이며 로그인&상품상세페이지 완료 되면 삭제할것!1)
			System.out.println("OrderPayServlet: 해당 서블릿의 구매자 로그인 세션에 정보가 없어, 테스트용 가상 구매자 정보 생성");
			buyer = new Member();
			// Member VO의 실제 필드명과 타입에 맞게 테스트 데이터 설정
			buyer.setMemberNo("2505200026"); // 예시: 가상 회원 번호 (실제 DB에 없어도 테스트 가능, 또는 DB에 테스트용 계정 만들어두고 사용)
            buyer.setMemberId("aaaaaaaa");
            buyer.setMemberNickname("사카유리메카");
            buyer.setMemberName("미카");           
            buyer.setMemberPhone("010-1111-1111");		
            buyer.setMemberAddr("[25952]강원특별자치도 삼척시 도계읍 심포남길 99, 123");
            
            session.setAttribute("m", buyer);
		} else {
			System.out.println("OrderPayServlet : 세션에서 구매자 정보 로드됨 - " + buyer.getMemberId());
		}
		
		//[상품 정보 갖고오기]
		String productNo = request.getParameter("productId");
		
		//3. 로직 -> 주문 상품의 상품 번호(productNo)와 일치하는 상품 조회
		OrderService orderservice = new OrderService();
		Product p = orderservice.selectOrderProduct(productNo);
			
		//3.1 에러 발생 시 안내페이지 생성
     	if (p == null) {	            
            // 사용자에게 보여줄 오류 메시지 설정
            request.setAttribute("errorTitle", "상품 정보 조회 실패");
            request.setAttribute("errorMessage", "요청하신 상품 ID('" + productNo + "')에 해당하는 상품 정보를 찾을 수 없거나, 현재 구매할 수 없는 상품입니다. 상품 ID를 다시 확인해주세요.");
            // 공통 에러 페이지로 포워딩 (이 JSP 파일은 직접 만드셔야 합니다)
            RequestDispatcher errorView = request.getRequestDispatcher("/WEB-INF/views/order/errorPage.jsp"); 
            errorView.forward(request, response);
            return; //
     	}
     		     	
    	//3.2 총 결제 예상 금액 계산
		int productPrice = p.getProductPrice(); // DB에서 조회한 상품 가격.
		String trdadeMethodCode = p.getTradeMethodCode(); //DB에서 조회한 택배 코드 
		
		int deliveryFee = 0;
		if("M1".equals(trdadeMethodCode)) { //M1 = 선불, M3 = 후불
			deliveryFee = 5000; // 일반 택배
		}else if ("M3".equals(trdadeMethodCode))
			deliveryFee = 0;
		
		int totalProductAmount = productPrice + deliveryFee;
		
		
		//3.3 ★주문 정보 객체 생성 및 값 설정(결제 준비(대기) 생성)
		Purchase readyOrder = new Purchase();  
		readyOrder.setProductNo(p.getProductNo());
		readyOrder.setBuyerMemberNo(buyer.getMemberNo());
		readyOrder.setSellerMemberNo(p.getMemberNo());
		readyOrder.setOrderAmount(totalProductAmount);
		readyOrder.setDeliveryFee(deliveryFee);
		readyOrder.setDeliveryAddr(buyer.getMemberAddr());
		readyOrder.setPurchaseStatusCode("PS00");
		readyOrder.setPgProvider(null);
		readyOrder.setPgTransactionId(null);
		
		//OrderService service2 = new OrderService();
		String generatedOrderId = orderservice.createOrderId(readyOrder);	
			
		//4. 결과 처리
		//4.1 이동할 JSP 페이지 지정
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/order/orderPay.jsp");
		
		//4.2 화면 구현에 필요한 데이터 등록
		request.setAttribute("product", p);
			
		//4.2.1 배송 방법 및 총 결제 상품 금액			
		request.setAttribute("totalProductAmount", totalProductAmount); // 총 상품 금액
		request.setAttribute("deliveryFee", deliveryFee); // 배송비
		
		//4.2.2 주문번호 전달
		request.setAttribute("orderId", generatedOrderId); // 생성된 주문번호(ORDER_NO) 전달
				
		//4.3 페이지 이동
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
