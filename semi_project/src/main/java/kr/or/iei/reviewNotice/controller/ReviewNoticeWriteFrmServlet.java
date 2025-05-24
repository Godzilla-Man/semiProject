package kr.or.iei.reviewNotice.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.member.model.vo.Member;

@WebServlet("/review/writeFrm")
public class ReviewNoticeWriteFrmServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Member loginMember = null;
        if (session != null) {
            loginMember = (Member) session.getAttribute("loginMember");
        }

        if (loginMember == null) {
            request.setAttribute("msg", "로그인 후 게시글을 작성할 수 있습니다.");
            request.setAttribute("loc", request.getContextPath() + "/member/login.jsp"); // 실제 로그인 페이지 경로로 수정
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
            view.forward(request, response);
            return;
        }
        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/reviewnotice/reviewWrite.jsp");
        view.forward(request, response);
    }

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}