package kr.or.iei.product.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.product.model.service.ProductService;

/*
  ※ 이 서블릿은 상품 삭제 요청을 받아 실제 DB에서 DELETE 하지 않고,
상품의 상태코드(STATUS_CODE)를 'S99'로 업데이트함으로써 논리적 삭제 처리합니다.

- 'productNo'는 상품 식별자이며, 클라이언트의 form에서 전달됨
- 삭제 성공 시 상품 목록(/product/list)으로 이동
- 삭제 실패 시 공통 에러 페이지(/common/error.jsp)로 이동

 상태코드 'S99'는 사전에 '삭제됨'을 의미하도록 정의돼 있어야 함
*/

@WebServlet("/product/delete")
public class ProductDeleteServlet extends HttpServlet {

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");

    // 1. 클라이언트가 보낸 상품 번호 추출
    String productNo = request.getParameter("productNo");

    // 2. 상품 상태를 'S99(삭제됨)'으로 변경 요청
    ProductService service = new ProductService();
    int result = service.markProductAsDeleted(productNo);  // 논리 삭제 처리

    // 3. 처리 결과에 따라 이동
    if (result > 0) {
      // 삭제 성공 시 상품 목록 페이지로 리다이렉트
    	String contextPath = request.getContextPath();
    	response.sendRedirect(contextPath + "/");			// 상품 삭제 성공 시 메인 페이지(index.jsp)로 이동, contextPath는 /market 등 프로젝트 루트 경로 보장, "/"는 index.jsp를 의미함
    } else {
      // 실패 시 에러 페이지로 이동
      request.setAttribute("msg", "상품 삭제에 실패했습니다.");
      request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
    }
  }
}
