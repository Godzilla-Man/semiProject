package kr.or.iei.product.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.Product;
import kr.or.iei.file.model.vo.Files;


@WebServlet("/product/edit")
public class ProductEditServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 0. 수정 버튼을 누르면 기존의 내용이 작성되어 있는 '등록 폼'으로 돌아가는 서블릿
		// 1. 상품 번호 추출
		String productNo = request.getParameter("no");

		if (productNo == null || productNo.trim().isEmpty()) {
			response.sendRedirect("/error.jsp");
			return;
		}

		// 2. 기존 상품 정보 조회
		ProductService service = new ProductService();
		Product product = service.selectOneProduct(productNo);
		List<Files> fileList = service.selectProductFiles(productNo);

		// 3. 유효성 검사
		if (product == null) {
			request.setAttribute("msg", "해당 상품이 존재하지 않습니다.");
			request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
			return;
		}

		// 4. JSP로 데이터 전달 및 이동
		request.setAttribute("product", product);
		request.setAttribute("fileList", fileList);
		request.setAttribute("editMode", true); // JSP에서 '수정모드' 표시 여부 분기용

		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/productEnroll.jsp");
		view.forward(request, response);
	}
}
