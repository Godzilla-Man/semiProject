package kr.or.iei.comment.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.product.model.service.ProductService;

@WebServlet("/product/updateComment")
public class UpdateCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateCommentServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // POST 요청도 doGet으로 위임
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 인코딩
        request.setCharacterEncoding("UTF-8");

        // 2. 요청값 추출
        int commentNo = Integer.parseInt(request.getParameter("commentNo"));
        String productNo = request.getParameter("productNo");
        String content = request.getParameter("commentContent");

        // 3. 객체 생성 및 값 설정
        Comment c = new Comment();
        c.setCommentNo(commentNo);
        c.setContent(content);

        // 4. 로직 처리
        int result = new ProductService().updateComment(c);

        
        // 5. 결과 처리
        if (result > 0) {
            // 수정 성공 → 해당 상품 상세 페이지로 이동
            response.sendRedirect(request.getContextPath() + "/product/detail?no=" + productNo);
        } else {
            // 수정 실패 → 에러 페이지 이동
            request.setAttribute("msg", "댓글 수정에 실패했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
        }
    }
    
}
