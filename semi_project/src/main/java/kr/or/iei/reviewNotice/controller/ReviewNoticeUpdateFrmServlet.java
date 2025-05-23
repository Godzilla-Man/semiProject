package kr.or.iei.reviewNotice.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.reviewNotice.model.service.ReviewNoticeService;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;

@WebServlet("/review/editFrm") // 사용자가 제공한 detail.jsp의 수정 링크 경로와 일치
public class ReviewNoticeUpdateFrmServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Member loginMember = (Member) session.getAttribute("loginMember");
        String stylePostNo = request.getParameter("stylePostNo");

        if (loginMember == null) {
            session.setAttribute("alertMsg", "로그인이 필요한 기능입니다.");
            // 중요: redirect 시 contextPath 포함
            response.sendRedirect(request.getContextPath() + "/views/member/login.jsp");
            return;
        }
        if (stylePostNo == null || stylePostNo.isEmpty()) {
            session.setAttribute("alertMsg", "잘못된 접근입니다. (게시글 번호 누락)");
            // 중요: redirect 시 contextPath 포함 및 .do 등 서블릿 매핑 일치
            response.sendRedirect(request.getContextPath() + "/review/list");
            return;
        }

        ReviewNoticeService rnService = new ReviewNoticeService();
        ReviewNotice review = rnService.getPostForDetailOrEdit(stylePostNo, loginMember.getMemberNo());

        if (review == null) {
            session.setAttribute("alertMsg", "수정 권한이 없거나 존재하지 않는 게시글입니다.");
            response.sendRedirect(request.getContextPath() + "/review/list");
        } else {
            request.setAttribute("review", review);
            // 중요: 포워딩하는 JSP 파일 경로 확인
            request.getRequestDispatcher("/WEB-INF/views/reviewnotice/reviewUpdateFrm.jsp").forward(request, response);
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	doGet(request, response);
    }
}