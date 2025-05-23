package kr.or.iei.reviewNotice.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.reviewNotice.model.service.ReviewNoticeService;

@WebServlet("/review/commentInsert")
public class InsertCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String stylePostNo = request.getParameter("stylePostNo");
        if (stylePostNo != null && !stylePostNo.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/review/detail?stylePostNo=" + stylePostNo + "&error=잘못된 접근입니다.");
        } else {
            response.sendRedirect(request.getContextPath() + "/review/list");
        }
    }

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String stylePostNo = request.getParameter("stylePostNo"); // 리다이렉션에 필요

        if (session == null || session.getAttribute("loginMember") == null) {
            String redirectUrl = request.getContextPath();
            if (stylePostNo != null && !stylePostNo.isEmpty()) {
                redirectUrl += "/review/detail?stylePostNo=" + stylePostNo + "&commentError=loginRequired";
            } else {
                redirectUrl += "/member/login.jsp"; // 실제 로그인 페이지로
            }
            response.sendRedirect(redirectUrl);
            return;
        }
        Member loginMember = (Member) session.getAttribute("loginMember");

        String content = request.getParameter("commentContent");
        String productNo = request.getParameter("productNo"); // 선택적

        Comment comment = new Comment();
        comment.setStylePostNo(stylePostNo);
        comment.setMemberNo(loginMember.getMemberNo());
        comment.setContent(content);
        if(productNo != null && !productNo.isEmpty()) {
            comment.setProductNo(productNo);
        }

        ReviewNoticeService service = new ReviewNoticeService();
        int result = service.insertComment(comment);

        response.sendRedirect(request.getContextPath() + "/review/detail?stylePostNo=" + stylePostNo /*+ queryResult*/);
    }
}