package kr.or.iei.product.controller.ctgList;

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

@WebServlet("/product/categoryListCheap")
public class ProductCtgListCheapServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ProductCtgListCheapServlet() {
        super();
    }

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 파라미터 추출
        String category = request.getParameter("ctg");

        // 2. 로그인 회원 정보 추출
        HttpSession session = request.getSession(false);
        Member loginMember = null;
        String memberNo = null;
        String memberId = null;

        if (session != null) {
            loginMember = (Member) session.getAttribute("loginMember");
            if (loginMember != null) {
                memberNo = loginMember.getMemberNo();
                memberId = loginMember.getMemberId();
            }
        }

        // 3. 관리자 여부 판단
        boolean isAdmin = "admin".equals(memberId);

        // 4. 서비스 호출
        ProductService service = new ProductService();
        Category ctg = service.selectCategory(category);  // 카테고리명 조회
        ArrayList<Product> productCtgList = service.selectCategoryListCheap(category, memberNo, isAdmin); // 상품 리스트 조회

        // 5. 결과 전달 및 JSP 이동
        request.setAttribute("ctg", ctg);
        request.setAttribute("productList", productCtgList);

        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/product/ctgList/productCtgListCheap.jsp");
        view.forward(request, response);
    }

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
