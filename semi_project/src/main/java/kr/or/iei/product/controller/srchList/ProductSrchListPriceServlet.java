package kr.or.iei.product.controller.srchList;

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
 * Servlet implementation class ProductSrchListPriceServlet
 */
@WebServlet("/product/searchListPrice")
public class ProductSrchListPriceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductSrchListPriceServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//값 추출
		String searchOption = request.getParameter("searchOption");
		String search = request.getParameter("search");
		String min = request.getParameter("min");
		String max = request.getParameter("max");

		String memberNo = null;
		Member loginMember = null;
		HttpSession session = request.getSession(false); //세션 있으면 존재, 없으면 null (로그인 되어 있으면 존재, 비로그인 시 null)
		if(session != null) {
			loginMember = (Member) session.getAttribute("loginMember");
			if(loginMember != null) {
				memberNo = loginMember.getMemberNo();
			}
		}

		//로직 - 검색한 상품명 또는 작성자와 같은지
		ProductService service = new ProductService();
		ArrayList<Product> productList = new ArrayList<>();
		if(searchOption.equals("productName")) { //상품명으로 검색시
			productList = service.searchProdcutNamePrice(search, memberNo, min, max);
		}else { //작성자로 검색 시
			productList = service.searchMemberNicknamePrice(search, memberNo, min, max);
		}

		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/srchList/productSrchListPrice.jsp");

		request.setAttribute("productList", productList);
		request.setAttribute("searchOption", searchOption);
		request.setAttribute("search", search);

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
