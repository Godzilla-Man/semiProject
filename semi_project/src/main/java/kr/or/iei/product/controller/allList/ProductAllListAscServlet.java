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
 * Servlet implementation class ProductAllListDescServlet
 */
@WebServlet("/product/allListAsc")
public class ProductAllListAscServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String memberNo = null;
        String memberId = null;
        Member loginMember = null;

        // 로그인 정보 가져오기
        HttpSession session = request.getSession(false);
        if (session != null) {
            loginMember = (Member) session.getAttribute("loginMember");
            if (loginMember != null) {
                memberNo = loginMember.getMemberNo();
                memberId = loginMember.getMemberId(); //  관리자 여부 판단에 사용
            }
        }

	     // 로그인된 사용자의 memberId가 'admin'이면 관리자 권한으로 간주
	     // ProductService에서 내부적으로 관리자 여부에 따라 status_code 필터링 여부 결정
	     // 일반 회원 → 삭제 상품(S99) 제외 / 관리자 → 전체 조회
        // 상품 리스트 조회 (관리자 여부에 따라 삭제 상품 포함 여부 분기)
        ProductService service = new ProductService();
        ArrayList<Product> productList = service.selectAllListAsc(memberNo, memberId); //  수정된 호출

        request.setAttribute("productList", productList);
        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/allList/productAllListAsc.jsp");
        view.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
