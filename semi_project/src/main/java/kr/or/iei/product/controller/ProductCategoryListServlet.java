package kr.or.iei.product.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.category.model.vo.Category;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.Product;
import kr.or.iei.product.model.vo.WishList;

/**
 * Servlet implementation class ProductCategoryListServlet
 */
@WebServlet("/product/categoryList")
public class ProductCategoryListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductCategoryListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String category = request.getParameter("ctg");
		
		HttpSession session = request.getSession(false); //세션 객체가 존재하면 존재하는 객체 반환, 없으면 null 반환
		
		ProductService service = new ProductService();
		Category ctg = service.selectCategory(category); //카테고리명 가져오기
		ArrayList<Product> productCtgList = service.selectCategoryList(category); //카테고리랑 일치하는 상품 리스트 가져오기
		ArrayList<WishList> memberWishList = new ArrayList<WishList>(); //밑에서 실행항 로그인한 회원의 찜 리스트 가져오기 미리 선언
		
		if(session != null) { //로그인한 상태
			Member loginMember = (Member) session.getAttribute("loginMember"); //로그인 회원 정보
			String memberNo = loginMember.getMemberNo(); //로그인한 회원 번호
			memberWishList = service.selectMemberWishList(memberNo); //로그인한 회원의 찜 리스트 가져오기			
		}
		
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/productCategoryList.jsp");
		
		request.setAttribute("ctg", ctg);
		request.setAttribute("productList", productCtgList);
		request.setAttribute("memberWishList", memberWishList);
		
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
