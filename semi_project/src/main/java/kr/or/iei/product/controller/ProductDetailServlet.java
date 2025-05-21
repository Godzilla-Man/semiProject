package kr.or.iei.product.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.Product;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.member.model.vo.Member;

@WebServlet("/product/detail")
public class ProductDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {


		// 1. 인코딩 처리
		// GET 요청이므로 별도 인코딩 없음 (필터에서 처리됨)

		// 2. 클라이언트가 전송한 값 추출
		String productNo = request.getParameter("no");

		// 잘못된 접근 처리
		if (productNo == null || productNo.trim().isEmpty()) {
			response.sendRedirect("/error.jsp");
			return;
		}

		// 3. 로직 처리 (서비스 호출)
		ProductService service = new ProductService();

		// (1) 상품 기본 정보
		service.increaseReadCount(productNo);
		Product product = service.selectOneProduct(productNo);

		// 상품이 존재하지 않을 경우 오류 처리
		if (product == null) {
			request.setAttribute("msg", "존재하지 않는 상품입니다.");
			request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
			return;
		}
		
		/* 삭제된 상품 접근 제한
		 * 상품 상태코드(statusCode)가 'S99'이면 논리적으로 삭제된 상태이므로,
		 * 로그인한 사용자가 admin이 아닌 경우 접근을 차단한다.
		 */
		HttpSession session = request.getSession(false);
		Member loginMember = (session != null) ? (Member)session.getAttribute("loginMember") : null;

		if ("S99".equals(product.getStatusCode())) {
		    if (loginMember == null || !"admin".equals(loginMember.getMemberId())) {
		        request.setAttribute("msg", "삭제된 상품입니다.");
		        request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
		        return;
		    }
		}
		
		/* 상품 상태코드(statusCode)에 따라 사용자에게 보여줄 상태명(productStatus) 설정 */
		String statusName = "";
		switch (product.getStatusCode()) {
		    case "S01": statusName = "판매중"; break;
		    case "S02": statusName = "결제완료"; break;
		    case "S03": statusName = "배송전"; break;
		    case "S04": statusName = "배송준비"; break;
		    case "S05": statusName = "배송중"; break;
		    case "S06": statusName = "배송완료"; break;
		    case "S07": statusName = "거래완료"; break;
		    case "S08": statusName = "환불신청"; break;
		    case "S09": statusName = "환불완료"; break;
		    case "S10": statusName = "거래실패"; break;
		    case "S11": statusName = "취소신청"; break;
		    case "S12": statusName = "취소완료"; break;
		    case "S99": statusName = "삭제됨"; break;
		    default: statusName = "판매중"; break;
		}
		
		List<Files> fileList = service.selectProductFiles(productNo);
		List<Comment> commentList = service.selectProductComments(productNo);
		String sellerNo = product.getMemberNo();
		Member seller = service.selectSellerInfo(sellerNo);
		int sellingCount = service.getSellingProductCount(product.getMemberNo());
		int wishlistCount = service.getWishlistCount(productNo);
		String categoryCode = product.getCategoryCode();
		String currentProductNo = product.getProductNo();
		List<Product> relatedProducts = service.selectRelatedProducts(categoryCode, currentProductNo);
		
		// 4. 결과 처리
		// 4.1 이동할 JSP 페이지 경로 지정
		// 4.2 화면 구현에 필요한 데이터 등록
		
		product.setProductStatus(statusName);
		request.setAttribute("product", product);
		request.setAttribute("fileList", fileList);
		product.setWishlistCount(wishlistCount);
		request.setAttribute("commentList", commentList);
		request.setAttribute("seller", seller);
		request.setAttribute("sellingCount", sellingCount);
		request.setAttribute("product", product);
		request.setAttribute("relatedProducts", relatedProducts);

		
		// 포워딩
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/productDetail.jsp");
		view.forward(request, response);
	}
}
