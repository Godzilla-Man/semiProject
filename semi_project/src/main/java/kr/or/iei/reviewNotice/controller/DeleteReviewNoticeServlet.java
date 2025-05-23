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
import kr.or.iei.reviewNotice.model.service.ReviewNoticeService;

@WebServlet("/review/delete")
public class DeleteReviewNoticeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession();
    	Member loginMember = (Member) session.getAttribute("loginMember");
    	String stylePostNo = request.getParameter("stylePostNo");

    	if (loginMember == null) {
    		session.setAttribute("alertMsg", "로그인이 필요한 기능입니다.");
    		response.sendRedirect(request.getContextPath() + "/views/member/login.jsp");
    		return;
    	}
    	if (stylePostNo == null || stylePostNo.isEmpty()) {
    		session.setAttribute("alertMsg", "잘못된 요청입니다 (게시글 번호 누락).");
    		response.sendRedirect(request.getContextPath() + "/review/list");
    		return;
    	}

    	ReviewNoticeService rnService = new ReviewNoticeService();
    	String serverFileSavePath = getServletContext().getRealPath("/resources/upload/review");

    	int result = rnService.deletePost(stylePostNo, loginMember.getMemberNo(), serverFileSavePath);

    	RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
    	if (result > 0) {
    		request.setAttribute("title", "성공");
    		request.setAttribute("msg", "게시글이 삭제되었습니다.");
    		request.setAttribute("icon", "success");
    		request.setAttribute("loc", "/review/list");
    	} else if (result == -1) {
    		request.setAttribute("title", "실패");
    		request.setAttribute("msg", "게시글 삭제 권한이 없습니다.");
    		request.setAttribute("icon", "error");
    		request.setAttribute("loc", "/review/detail?stylePostNo=" + stylePostNo);
    	} else {
    		request.setAttribute("title", "실패");
    		request.setAttribute("msg", "게시글 삭제에 실패했습니다.");
    		request.setAttribute("icon", "error");
    		request.setAttribute("loc", "/review/detail?stylePostNo=" + stylePostNo);
    	}
    	view.forward(request, response);
    }
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	doGet(request, response);
    }
}