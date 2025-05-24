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
import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.SalesProduct;


@WebServlet("/member/myPageSalesList")
public class myPageSalesListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public myPageSalesListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
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

        // 판매내역 조회
        ProductService productService = new ProductService();
        List<SalesProduct> salesList = productService.getMySalesList(loginMember.getMemberNo());

     // 4. 결과 처리: JSP로 데이터 전달
        request.setAttribute("salesList", salesList);

        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/member/myPageSalesList.jsp"); // 판매 내역을 표시할 JSP
        view.forward(request, response);


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
