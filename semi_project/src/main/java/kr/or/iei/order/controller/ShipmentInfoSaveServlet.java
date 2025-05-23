package kr.or.iei.order.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.order.model.service.OrderService;

/**
 * Servlet implementation class ShipmentInfoSaveServlet
 */
@WebServlet("/order/saveShipmentInfo")
public class ShipmentInfoSaveServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShipmentInfoSaveServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 인코딩 (필터에서 처리)

        // 2. 로그인 확인
        HttpSession session = request.getSession(false);
        Member loginMember = null;
        if (session != null) {
            loginMember = (Member) session.getAttribute("loginMember");
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        String jsonResponse;

        if (loginMember == null) {
            jsonResponse = gson.toJson(new ShipmentResponse(false, "로그인이 필요한 서비스입니다."));
            out.print(jsonResponse);
            out.flush();
            return;
        }

        // 3. 요청 파라미터 추출
        String orderNo = request.getParameter("orderNo");
        String productNo = request.getParameter("productNo");
        String deliveryCompanyCode = request.getParameter("deliveryCompanyCode"); // 택배사 코드
        String deliveryCompanyName = request.getParameter("deliveryCompanyName"); // 택배사 명
        String trackingNumber = request.getParameter("trackingNumber");

        // 디버깅 로그
        System.out.println("[ShipmentInfoSaveServlet] Received orderNo: " + orderNo);
        System.out.println("[ShipmentInfoSaveServlet] Received deliveryCompanyCode: " + deliveryCompanyCode);
        System.out.println("[ShipmentInfoSaveServlet] Received deliveryCompanyName: " + deliveryCompanyName);
        System.out.println("[ShipmentInfoSaveServlet] Received trackingNumber: " + trackingNumber);


        // 4. 유효성 검사
        // "기타" 선택 시 deliveryCompanyCode는 "ETC" 같은 값으로 오고, deliveryCompanyName에 실제 이름이 올 것임.
        // 일반 택배사 선택 시 deliveryCompanyCode에 코드가, deliveryCompanyName에 해당 이름이 올 것임.
        // 택배사 코드 또는 이름 둘 중 하나는 유효해야 함 (상황에 맞게 로직 조정)
        if (orderNo == null || orderNo.isEmpty() ||
            ((deliveryCompanyCode == null || deliveryCompanyCode.isEmpty()) && (deliveryCompanyName == null || deliveryCompanyName.isEmpty())) || // 코드 또는 이름 둘 중 하나는 있어야 함
            trackingNumber == null || trackingNumber.isEmpty()) {
            jsonResponse = gson.toJson(new ShipmentResponse(false, "필수 정보(주문번호, 택배사, 송장번호)가 누락되었습니다."));
            out.print(jsonResponse);
            out.flush();
            return;
        }
        
        // "기타" 코드를 받고 이름이 없을 경우, 또는 코드가 없고 이름만 있는 경우 등의 처리
        // 여기서는 deliveryCompanyName을 우선적으로 사용하고, 코드는 참조용으로 사용한다고 가정
        // 또는 TBL_PURCHASE에 code와 name을 둘 다 저장할 수 있음

        // 5. 로직 처리
        OrderService orderService = new OrderService();
        // 서비스 메소드 시그니처도 변경 필요
        boolean saveResult = orderService.saveShipmentInfo(orderNo, loginMember.getMemberNo(), deliveryCompanyCode, deliveryCompanyName, trackingNumber);

        // 6. 결과 응답
        if (saveResult) {
            jsonResponse = gson.toJson(new ShipmentResponse(true, "발송 정보가 성공적으로 저장되었습니다."));
        } else {
            jsonResponse = gson.toJson(new ShipmentResponse(false, "발송 정보 저장에 실패했습니다. (판매자 정보 불일치, 처리된 주문 또는 DB 오류)"));
        }
        out.print(jsonResponse);
        out.flush();
    }

    // JSON 응답 내부 클래스는 동일
    private static class ShipmentResponse {
        boolean success;
        String message;
        public ShipmentResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
