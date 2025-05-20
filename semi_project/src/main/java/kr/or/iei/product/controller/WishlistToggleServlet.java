package kr.or.iei.product.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.member.model.vo.Member;

@WebServlet("/wishlist/toggle")
public class WishlistToggleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 찜하기 토글 처리 (로그인 필수)
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 세션에서 로그인 정보 확인
		HttpSession session = request.getSession(false);
		Member loginMember = (Member) session.getAttribute("loginMember");

		// 로그인하지 않은 경우 로그인 페이지로 이동
		if (loginMember == null) {
			response.sendRedirect("/member/login");
			return;
		}

		// 파라미터 추출
		String productNo = request.getParameter("productNo");
		String memberNo = loginMember.getMemberNo(); // form에서 넘기지 않아도 세션에서 가져옴

		// 찜 여부 확인 후 insert 또는 delete
		ProductService service = new ProductService();
		boolean isWished = service.checkWishlist(productNo, memberNo);

		int result = 0;
		if (isWished) {
			result = service.removeWishlist(productNo, memberNo);
		} else {
			result = service.addWishlist(productNo, memberNo);
		}

		// 처리 후 다시 상세 페이지로 이동
		response.sendRedirect("/product/detail?no=" + productNo);
	}
}
