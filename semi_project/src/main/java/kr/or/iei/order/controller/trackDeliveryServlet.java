package kr.or.iei.order.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.order.model.service.OrderService;
import kr.or.iei.order.model.vo.Purchase;

/**
 * Servlet implementation class trackDelivery
 */
@WebServlet("/order/trackDelivery")
public class trackDeliveryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public trackDeliveryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 인코딩 설정 - 필터 처리

        // 2. 값 추출
        String orderNo = request.getParameter("orderNo");

        // 3. 비즈니스 로직 처리 (Service -> Dao -> DB)
        OrderService orderService = new OrderService();
        // Purchase 객체에 택배사명과 송장번호를 담아오는 메소드 호출 (OrderService에 추가 필요)
        Purchase purchaseInfo = orderService.getDeliveryInfo(orderNo);

        // 4. 결과 응답 (텍스트로)
        response.setContentType("text/plain;charset=utf-8");
        PrintWriter out = response.getWriter();

        if (purchaseInfo != null && purchaseInfo.getTrackingNumber() != null && !purchaseInfo.getTrackingNumber().isEmpty()) {
            // 정보가 있으면 "택배사명 / 송장번호" 형식으로 출력
            String company = (purchaseInfo.getDeliveryCompanyName() != null) ? purchaseInfo.getDeliveryCompanyName() : "정보없음";
            
            System.out.println("TrackDeliveryServlet: Sending = " + company + " / " + purchaseInfo.getTrackingNumber());
            
            out.print(company + " / " + purchaseInfo.getTrackingNumber());
        } else {
            // 정보가 없으면 준비중 메시지 출력
        	System.out.println("TrackDeliveryServlet: Sending = 배송 준비중입니다.");
            out.print("배송 준비중입니다.");
        }

        out.flush();
        out.close();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
