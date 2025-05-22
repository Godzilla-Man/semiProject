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
import kr.or.iei.product.model.vo.Product;

/**
 * Servlet implementation class OrderStartServlet
 */
@WebServlet("/order/orderStart")
public class OrderStartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrderStartServlet() {
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
		
		if (loginMember == null) {
            // 로그인하지 않은 경우, 로그인 페이지로 리다이렉트           
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='" + request.getContextPath() + "/member/loginFrm';</script>");
            return; // 서블릿 실행 종료
        }
		
		
		//2. 값 추출
		String productId = request.getParameter("productId");
		//String deliveryMethod = request.getParameter("deliveryMethod"); // 배송비 포함 최종 결제 금액 계산.    
		
		//3. 로직 -> 주문 상품의 상품번호(prodcutId)와 일지하는 상품 조회
		OrderService service = new OrderService();
		Product p = service.selectOrderProduct(productId);
		
			//3.1 에러 발생 시 안내페이지 생성
	     	if (p == null) {	            
	            // 사용자에게 보여줄 오류 메시지 설정
	            request.setAttribute("errorTitle", "상품 정보 조회 실패");
	            request.setAttribute("errorMessage", "요청하신 상품 ID('" + productId + "')에 해당하는 상품 정보를 찾을 수 없거나, 현재 구매할 수 없는 상품입니다. 상품 ID를 다시 확인해주세요.");
	            // 공통 에러 페이지로 포워딩 (이 JSP 파일은 직접 만드셔야 합니다)
	            RequestDispatcher errorView = request.getRequestDispatcher("/WEB-INF/views/order/errorPage.jsp"); 
	            errorView.forward(request, response);
	            return; //
	        }
		
			//2.1 총 결제 예상 금액 계산
			int productPrice = p.getProductPrice(); // DB에서 조회한 상품 가격.
			String trdadeMethodCode = p.getTradeMethodCode(); //DB에서 조회한 택배 코드 
			
			int deliveryFee = 0;
			if("M2".equals(trdadeMethodCode)) { //M1 = 배송비 무료, M2 = 배송비 5,000원 발생 M3 = 후불
				deliveryFee = 5000; // 일반 택배
			}
			
			int totalProductAmount = productPrice + deliveryFee;
			
		//4. 결과 처리
		//4.1 이동할 JSP 페이지 지정
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/order/orderStart.jsp");
		
		//4.2 화면 구현에 필요한 데이터 등록
		request.setAttribute("product", p);
			
			//4.3 배송 방법 및 총 결제 상품 금액			
			request.setAttribute("totalProductAmount", totalProductAmount); // 총 상품 금액
			request.setAttribute("deliveryFee", deliveryFee); // 배송비
		
		//4.3 페이지 이동
		view.forward(request, response);  
		
		
		
		/* 아래 버전은 테스트 주문 페이지에서 orderStart.jsp까지 잘 넘아기지지는지 간단 테스트
		  
		[단순 버전]
		//2. 값 추출
		String productId = request.getParameter("productId");
        String productName = request.getParameter("productName");
        int productPrice = Integer.parseInt(request.getParameter("productPrice"));
        String deliveryMethod = request.getParameter("deliveryMethod");        
		
        //3. 로직
        Product product = new Product();
        product.setProductNo(productId);
        product.setProductName(productName);
        product.setProductPrice(productPrice);
        product.setTradeMethodCode(deliveryMethod);
        
        	//3.1 총 결제 예상 금액 계산
        	int deliveryFee = 0;
        	if("M1".equals(deliveryMethod)) { //M1 = 선불, M3 = 후불
        		deliveryFee = 5000; // 일반 택배
        	}else if ("M3".equals(deliveryMethod))
        		deliveryFee = 0;
        	
        	int totalProductAmount = productPrice + deliveryFee;
        
        
        //3.2 결과값 전송
    	request.setAttribute("product", product); // 상품 '전체' 정보        
        request.setAttribute("deliveryMethod", deliveryMethod); // 선택된 배송 방법        
        request.setAttribute("deliveryFee", deliveryFee); // 배송비
        request.setAttribute("totalProductAmount", totalProductAmount); // 총 상품 금액
        
    	//4. 결과 처리(포워딩)
        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/order/orderStart.jsp");
        view.forward(request, response);        	
        
        */
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
