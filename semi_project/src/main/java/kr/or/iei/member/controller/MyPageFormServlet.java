package kr.or.iei.member.controller;

import java.io.IOException;
import java.util.List;

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

/**
 * Servlet implementation class MyPageServlet
 */
@WebServlet("/member/myPage")
public class MyPageFormServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MyPageFormServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 시작 : 로그인 세션 갖고 오는 공통 영역
		
		HttpSession session = request.getSession(false);
        Member loginMember = null;

        if (session != null) {
            loginMember = (Member) session.getAttribute("loginMember"); // 세션에서 로그인 정보 가져오기
        }

        if (loginMember == null) {
            // 로그인되지 않은 경우 로그인 페이지로
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='" + request.getContextPath() + "/member/loginFrm';</script>");
            return;
        }        
        // 종료 : 로그인 세션 갖고 오는 공통 영역

        // 구매내역 조회
        OrderService orderService = new OrderService();
        List<Purchase> purchaseList = orderService.getPurchaseListByBuyer(loginMember.getMemberNo());

        request.setAttribute("purchaseList", purchaseList); // 조회된 구매내역 리스트를 request에 저장
        // request.setAttribute("loginMember", loginMember); // JSP에서 이미 세션으로 접근 가능하지만, 명시적으로 넘겨도 됨

        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/member/myPage.jsp"); // 실제 마이페이지 JSP 경로
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
