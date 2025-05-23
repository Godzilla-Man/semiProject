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
 * Servlet implementation class ProductAllListCheaServlet
 */
@WebServlet("/product/allListCheap")
public class ProductAllListCheapServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ProductAllListCheapServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String memberNo = null;
        String memberId = null;

        HttpSession session = request.getSession(false);
        if (session != null) {
            Member loginMember = (Member) session.getAttribute("loginMember");
            if (loginMember != null) {
                memberNo = loginMember.getMemberNo();
                memberId = loginMember.getMemberId();  // ✅ 관리자 여부 판단용
            }
        }

        ProductService service = new ProductService();
        ArrayList<Product> productList = service.selectAllListCheap(memberNo, memberId);  // ✅ 변경된 호출 방식

        request.setAttribute("productList", productList);
        request.getRequestDispatcher("/WEB-INF/views/product/allList/productAllListCheap.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
