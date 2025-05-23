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

@WebServlet("/review/commentDelete")
public class DeleteCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String stylePostNo = request.getParameter("stylePostNo");
        if (stylePostNo != null && !stylePostNo.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/review/detail?stylePostNo=" + stylePostNo + "&error=잘못된 접근입니다.");
        } else {
            response.sendRedirect(request.getContextPath() + "/review/list");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String stylePostNo = request.getParameter("stylePostNo");

        if (session == null || session.getAttribute("loginMember") == null) {
            String redirectUrl = request.getContextPath();
            if (stylePostNo != null && !stylePostNo.isEmpty()) {
                redirectUrl += "/review/detail?stylePostNo=" + stylePostNo + "&commentError=loginRequired";
            } else {
                redirectUrl += "/member/login.jsp";
            }
            response.sendRedirect(redirectUrl);
            return;
        }
        Member loginMember = (Member)session.getAttribute("loginMember");

        int commentNo = 0;
        try {
            commentNo = Integer.parseInt(request.getParameter("commentNo"));
        } catch (NumberFormatException e) {
             response.sendRedirect(request.getContextPath() + "/review/detail?stylePostNo=" + stylePostNo + "&commentError=invalidCommentNo");
            return;
        }

        ReviewNoticeService service = new ReviewNoticeService();
        int result = service.deleteComment(commentNo, loginMember.getMemberNo());

        response.sendRedirect(request.getContextPath() + "/review/detail?stylePostNo=" + stylePostNo /*+ queryResult*/);
    }
}