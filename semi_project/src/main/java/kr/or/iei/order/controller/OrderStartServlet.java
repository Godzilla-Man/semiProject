package kr.or.iei.order.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		//1. 인코딩 설정 - 필터에서 진행
		
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
    	request.setAttribute("product", product); // 상품 정보        
        request.setAttribute("deliveryMethod", deliveryMethod); // 선택된 배송 방법        
        request.setAttribute("deliveryFee", deliveryFee); // 배송비
        request.setAttribute("totalProductAmount", totalProductAmount); // 총 상품 금액
        
    	//4. 결과 처리
        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/order/orderStart.jsp");
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
