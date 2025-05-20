package kr.or.iei.comment.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.product.model.service.ProductService;

@WebServlet("/product/insertComment")
public class InsertCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public InsertCommentServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // POST 요청도 doGet으로 위임
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 인코딩: 필터에서 처리됨
        //  로그인 여부 체크
        HttpSession session = request.getSession(false);
        Member loginMember = (session != null) ? (Member) session.getAttribute("loginMember") : null;

        if (loginMember == null) {
            // 로그인 안 된 경우: 댓글 작성 차단
            response.sendRedirect("/member/loginFrm"); // 혹은 alert 후 리다이렉트
            return;
        }

        // 2. 클라이언트 전송값 추출
        String productNo = request.getParameter("productRef");          // 상품 번호
        // [수정] memberNo를 세션의 로그인 객체에서 직접 추출 (보안상 안전)
        String memberNo = loginMember.getMemberNo();                    // 작성자 번호 (세션에서 추출)
        String content = request.getParameter("commentContent");        // 댓글 내용
        String parentNoParam = request.getParameter("parentCommentNo");	// 대댓글 내용

        // 3. 로직 처리
        Comment c = new Comment();
        c.setProductNo(productNo);
        c.setMemberNo(memberNo);  // [수정] 세션에서 가져온 memberNo 값 주입
        c.setContent(content);
        // 3-1. 대댓글일 경우 부모 댓글 번호 설정 (null 가능)
        if (parentNoParam != null && !parentNoParam.trim().equals("")) {
            try {
                c.setParentCommentNo(Integer.parseInt(parentNoParam));
            } catch (NumberFormatException e) {
                e.printStackTrace(); // 예외 발생 시 무시
            }
        }

        // 4. 로직 처리: 댓글 등록 (ProductService로 전달)
        int result = new ProductService().insertComment(c);

        // 5. 결과 처리
        if (result > 0) {
            // 등록 성공 → 해당 상품 상세 페이지로 이동
            response.sendRedirect(request.getContextPath() + "/product/detail?no=" + productNo);
        } else {
            // 등록 실패 → 에러 페이지로 이동
            request.setAttribute("msg", "댓글 등록에 실패했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
        }
    }
}
