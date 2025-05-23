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
 * Servlet implementation class OrderCancelServlet
 */
@WebServlet("/order/cancelOrder")
public class OrderCancelServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrderCancelServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 인코딩(필터)

		//※ 공통 시작
		//2. 로그인 확인
		HttpSession session = request.getSession(false);
		Member loginMember = null;
		if(session != null) {
			loginMember = (Member) session.getAttribute("loginMember");
		}

		if (loginMember == null) {
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='" + request.getContextPath() + "/member/loginFrm';</script>");
            return;
        }

		//3. 값 추출
		String orderId = request.getParameter("orderId");

		if (orderId == null || orderId.isEmpty()) {
            request.setAttribute("errorTitle", "잘못된 요청");
            request.setAttribute("errorMessage", "주문 번호가 전달되지 않았습니다.");
            RequestDispatcher errorView = request.getRequestDispatcher("/WEB-INF/views/order/errorPage.jsp");
            errorView.forward(request, response);
            return;
        }
		//※ 공통 종료

		//4. 로직 - 주문 취소 처리
		OrderService orderService = new OrderService();
		boolean cancelResult = orderService.OrderCancel(orderId, loginMember.getMemberNo());

		if (cancelResult) {
            // 취소 성공 시, 취소된 주문 정보 및 상품 정보를 다시 조회하여 JSP에 전달
            Purchase canceledPurchase = orderService.getPurchaseDetails(orderId); // 주문 상태가 변경된 Purchase 객체
            Product product = null;
            if (canceledPurchase != null) {
                product = orderService.selectOrderProduct(canceledPurchase.getProductNo());

                /*
                Purchase VO 또는 Product VO에 판매자 닉네임, 주문 상태명 등을 담는 로직 추가 필요
                예: canceledPurchase.setPurchaseStatusName(orderService.getPurchaseStatusName(canceledPurchase.getPurchaseStatusCode()));
                예: product.setSellerNickname(orderService.getSellerNickname(product.getMemberNo()));
                */

            }

            request.setAttribute("purchase", canceledPurchase);
            request.setAttribute("product", product);
            request.setAttribute("pageTitle", "거래 취소 내역"); // 페이지 제목 변경
            request.setAttribute("message", "고객님의 주문이 정상적으로 취소되었습니다."); // 안내 메시지 변경

            // orderCancelComplete.jsp (또는 orderFinish.jsp를 재활용하되, 내용을 동적으로 변경)
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/order/orderCancelFinish.jsp");
            view.forward(request, response);
        } else {
            // 취소 실패 처리
            request.setAttribute("errorTitle", "거래 취소 실패");
            request.setAttribute("errorMessage", "거래 취소 중 오류가 발생했습니다. 이미 배송이 시작되었거나 취소할 수 없는 상태일 수 있습니다. 고객센터로 문의해주세요.");
            RequestDispatcher errorView = request.getRequestDispatcher("/WEB-INF/views/order/errorPage.jsp");
            errorView.forward(request, response);
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
