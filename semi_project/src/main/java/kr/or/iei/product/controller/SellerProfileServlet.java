package kr.or.iei.product.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.Product;

@WebServlet("/product/seller")
public class SellerProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public SellerProfileServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String memberNo = request.getParameter("memberNo");
	    if (memberNo == null || memberNo.trim().isEmpty()) {
	        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "memberNo 파라미터가 누락되었습니다.");
	        return;
	    }

	    // 판매자 정보 실제 DB 연동
	    MemberService mService = new MemberService();
	    Member seller = mService.selectMemberByNo(memberNo);

	    if (seller == null) {
	        response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 판매자 정보를 찾을 수 없습니다.");
	        return;
	    }

	    request.setAttribute("seller", seller);

	    // 현재 판매중인 상품 목록 연동
	    ProductService pService = new ProductService();
	    List<Product> productList = pService.selectSellingProductByMember(memberNo);
	    request.setAttribute("productList", productList);
	    request.setAttribute("productCount", productList.size());

	    // 판매 완료(S07) 상품 개수 조회 추가
	    int salesCount = pService.countCompletedSalesByMember(memberNo);
	    request.setAttribute("salesCount", salesCount);
	    
	    // 좋아요 및 싫어요 개수 조회
	    int likeCount = pService.countReactionsByMember(memberNo, 'L');  // 'L' = Like
	    int dislikeCount = pService.countReactionsByMember(memberNo, 'D');  // 'D' = Dislike
	    request.setAttribute("likeCount", likeCount);
	    request.setAttribute("dislikeCount", dislikeCount);
	    
	    // 결과 조회
	    RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/sellerProfile.jsp");
	    view.forward(request, response);
	    

	    
	}
}
