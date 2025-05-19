package kr.or.iei.product.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.Product;

/**
 * Servlet implementation class ProductSearchListServlet
 */
@WebServlet("/product/searchList")
public class ProductSearchListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductSearchListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//값 추출
		String searchOption = request.getParameter("searchOption");
		String search = request.getParameter("search");
		
		//로직 - 검색한 상품명 또는 작성자와 같은지
		ProductService service = new ProductService();
		ArrayList<Product> productList = new ArrayList<Product>();
		if(searchOption.equals("productName")) { //상품명으로 검색시
			productList = service.searchProdcutName(search);
		}else { //작성자로 검색 시
			productList = service.searchMemberNickname(search);
		}
		
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/productSearchList.jsp");
		
		request.setAttribute("productList", productList);
		request.setAttribute("search", search);
		
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
