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
 * Servlet implementation class ProductAllList
 */
@WebServlet("/product/allListDesc")
public class ProductAllListDescServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductAllListDescServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
		ArrayList<Product> productList = service.selectAllListDesc(memberNo);
		
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/allList/productAllListDesc.jsp");
		
		request.setAttribute("productList", productList);
		
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
