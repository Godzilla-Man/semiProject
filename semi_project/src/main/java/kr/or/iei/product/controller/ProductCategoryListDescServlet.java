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

/**
 * Servlet implementation class ProductCategoryListServlet
 */
@WebServlet("/product/categoryListDesc")
public class ProductCategoryListDescServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductCategoryListDescServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String category = request.getParameter("ctg");
		
		String memberNo = null;
		Member loginMember = null;
		HttpSession session = request.getSession(false); //세션 있으면 존재, 없으면 null (로그인 되어 있으면 존재, 비로그인 시 null)
		if(session != null) {
			loginMember = (Member) session.getAttribute("loginMember");
			if(loginMember != null) {
				memberNo = loginMember.getMemberNo();				
			}
		}
		
		ProductService service = new ProductService();
		Category ctg = service.selectCategory(category); //카테고리명 가져오기
		ArrayList<Product> productCtgList = service.selectCategoryList(category, memberNo); //카테고리랑 일치하는 상품 리스트 가져오기
		
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/productCategoryList.jsp");
		
		request.setAttribute("ctg", ctg);
		request.setAttribute("productList", productCtgList);
		
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
