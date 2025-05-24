package kr.or.iei.product.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.admin.model.vo.ReportPost;
import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.Product;

@WebServlet("/product/detail")
public class ProductDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 인코딩 처리
		// GET 요청이므로 별도 인코딩 없음 (필터에서 처리됨)

		// 2. 클라이언트가 전송한 값 추출
		String productNo = request.getParameter("no");
		String from = request.getParameter("from"); // 찜하기에서 왔는지 확인하는 파라미터

		// 잘못된 접근 처리
		if (productNo == null || productNo.trim().isEmpty()) {
		    response.sendRedirect("/error.jsp");
		    return;
		}

		// 3. 로직 처리
		ProductService service = new ProductService();

		   // ⭐ 찜하기에서 온 요청이 아닌 경우에만 조회수 증가
	    if (from == null || !from.equals("wishlist")) {
		// (1) 상품 기본 정보 조회
		service.increaseReadCount(productNo);
	    }

		Product product = service.selectOneProduct(productNo);

		// 상품이 존재하지 않을 경우 오류 처리
		if (product == null) {
		    request.setAttribute("msg", "존재하지 않는 상품입니다.");
		    request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
		    return;
		}

		// (2) 삭제된 상품 접근 제한
		HttpSession session = request.getSession(false);
		Member loginMember = (session != null) ? (Member) session.getAttribute("loginMember") : null;

		if ("S99".equals(product.getStatusCode())) {
		    if (loginMember == null || !"admin".equals(loginMember.getMemberId())) {
		        request.setAttribute("msg", "삭제된 상품입니다.");
		        request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
		        return;
		    }
		}

		// (3) 상태 코드 → 상태명 매핑
		String statusName;
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

		// (4) 기타 상품 관련 정보 조회
		List<Files> fileList = service.selectProductFiles(productNo);
		List<Comment> commentList = service.selectProductComments(productNo);
		Member seller = service.selectSellerInfo(product.getMemberNo());
		int sellingCount = service.getSellingProductCount(product.getMemberNo());
		int wishlistCount = service.getWishlistCount(productNo);

		// (5) 관련 상품 리스트 - 일반 사용자/관리자 분기
		String categoryCode = product.getCategoryCode();
		String currentProductNo = product.getProductNo();
		List<Product> relatedProducts;

		if (loginMember != null && "admin".equals(loginMember.getMemberId())) {
		    // 관리자일 경우 삭제 상품 포함 전체 조회
		    relatedProducts = service.selectRelatedProductsAdmin(categoryCode, currentProductNo);
		} else {
		    // 일반 사용자는 S99 제외 조회
		    relatedProducts = service.selectRelatedProducts(categoryCode, currentProductNo);
		}

		//  (6) 신고 사유 리스트 조회
		List<ReportPost> reportReasonList = service.getReportReasonList();
		request.setAttribute("reportReasonList", reportReasonList);

		// 4. 결과 처리
		product.setProductStatus(statusName);
		product.setWishlistCount(wishlistCount);

		// JSP로 전달할 속성 등록
		request.setAttribute("product", product);
		request.setAttribute("fileList", fileList);
		request.setAttribute("commentList", commentList);
		request.setAttribute("seller", seller);
		request.setAttribute("sellingCount", sellingCount);
		request.setAttribute("relatedProducts", relatedProducts);

		// 5. 포워딩
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/productDetail.jsp");
		view.forward(request, response);

	}
}
