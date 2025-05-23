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
 * Servlet implementation class ConfirmPurchaseServlet
 */
@WebServlet("/order/confirmPurchase")
public class ConfirmPurchaseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConfirmPurchaseServlet() {
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

        PrintWriter out = response.getWriter();       

        if (loginMember == null) {
            response.setContentType("text/plain"); // 일반 텍스트로 응답 타입 변경
            out.print("로그인이 필요한 서비스입니다.");
            out.flush();
            return;
        }       

        String orderNo = request.getParameter("orderNo");

        if (orderNo == null || orderNo.isEmpty()) {
            response.setContentType("text/plain");
            out.print("주문번호가 누락되었습니다.");
            out.flush();
            return;
        }

        OrderService orderService = new OrderService();
        boolean confirmResult = orderService.confirmPurchase(orderNo, loginMember.getMemberNo(), "PS07"); // 

        response.setContentType("text/plain"); // 일반 텍스트로 응답 타입 변경
        if (confirmResult) {
            out.print("success"); // 성공 시 "success" 문자열 전송
        } else {
            out.print("구매 확정 처리에 실패했습니다. (본인 주문이 아니거나, 이미 처리된 주문일 수 있습니다)"); // 실패 메시지 전송
        }
        out.flush();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
