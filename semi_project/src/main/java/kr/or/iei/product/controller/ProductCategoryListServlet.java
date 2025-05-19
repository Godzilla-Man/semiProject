package kr.or.iei.product.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.category.model.vo.Category;
import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.Product;

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
		
		ProductService service = new ProductService();
		Category ctg = service.selectCategory(category);
		ArrayList<Product> productCtgList = service.selectCategoryList(category);
		
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
