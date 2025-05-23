package kr.or.iei.product.controller.allList;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.Product;

/**
 * Servlet implementation class ProductAllListPriceServlet
 */
@WebServlet("/product/allListPrice")
public class ProductAllListPriceServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String min = request.getParameter("min");
		String max = request.getParameter("max");

		HttpSession session = request.getSession(false);
		String memberNo = null;
		String memberId = null;

		if (session != null) {
			Member loginMember = (Member) session.getAttribute("loginMember");
			if (loginMember != null) {
				memberNo = loginMember.getMemberNo();
				memberId = loginMember.getMemberId();
			}
		}

		ProductService service = new ProductService();
		ArrayList<Product> productList = service.selectAllListPrice(memberNo, min, max, memberId);

		request.setAttribute("productList", productList);
		request.getRequestDispatcher("/WEB-INF/views/product/allList/productAllListPrice.jsp").forward(request, response);
	}
}
