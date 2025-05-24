package kr.or.iei.product.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.member.model.vo.Member;
import kr.or.iei.product.model.service.ProductService;

/**
 * Servlet implementation class ReactionToggleServlet
 */
@WebServlet("/reaction/toggle")
public class ReactionToggleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReactionToggleServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 로그인 회원 정보 가져오기
        Member loginMember = (Member) request.getSession().getAttribute("loginMember");

        if (loginMember == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);  // 로그인 안 됐을 경우 401
            return;
        }

        // 요청 파라미터 추출
        String targetMemberNo = request.getParameter("targetMemberNo");
        String reactionType = request.getParameter("reactionType");  // 'L' 또는 'D'

        // 파라미터 유효성 검사
        if (targetMemberNo == null || reactionType == null ||
            (!reactionType.equals("L") && !reactionType.equals("D"))) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String reactMemberNo = loginMember.getMemberNo();

        // 서비스 호출
        ProductService pService = new ProductService();

        // 기존 반응 여부 확인 후 토글 처리
        boolean hasReacted = pService.hasReaction(reactMemberNo, targetMemberNo, reactionType.charAt(0));

        int result = 0;
        if (hasReacted) {
            result = pService.deleteReaction(reactMemberNo, targetMemberNo, reactionType.charAt(0));
        } else {
            result = pService.insertReaction(reactMemberNo, targetMemberNo, reactionType.charAt(0));
        }

        // 최신 좋아요/싫어요 수 조회
        int likeCount = pService.countReactionsByMember(targetMemberNo, 'L');
        int dislikeCount = pService.countReactionsByMember(targetMemberNo, 'D');

        // JSON 형식으로 응답 반환
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{");
        out.print("\"success\":" + (result > 0));
        out.print(",\"likeCount\":" + likeCount);
        out.print(",\"dislikeCount\":" + dislikeCount);
        out.print("}");
        out.flush();
        out.close();
    }

}
