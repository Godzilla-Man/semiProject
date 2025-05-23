package kr.or.iei.member.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.Member;

/**
 * Servlet implementation class updateFromServlet
 */
@WebServlet("/member/update")
public class updateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public updateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 인코딩 - 필터에서 처리
		//2. 클라이언트가 전송한 값 추출
		String memberNo = request.getParameter("memberNo");
		String memberPw = request.getParameter("memberPw");
		String memberPhone = request.getParameter("memberPhone");
		//주소는 우편번호/주소/상세주소/참고항목으로 나눠져있음
		String addr_postcode = request.getParameter("addr_postcode");
		String addr_address = request.getParameter("addr_address");
		String addr_detailAddress = request.getParameter("addr_detailAddress");
		String addr_extraAddress = request.getParameter("addr_extraAddress");
		//이메일은 아이디/도메인으로 나눠져있음
		String memberEmailId = request.getParameter("memberEmailId");
		String memberEmailDomain = request.getParameter("memberEmailDomain");

		//3. 로직 처리
		//나눠져있는 주소 합치기
		String memberAddr = "[" + addr_postcode + "]" + addr_address + "," + addr_detailAddress + addr_extraAddress;
		//나눠져있는 이메일 합치기
		String memberEmail = memberEmailId + "@" + memberEmailDomain;

		Member member = new Member();
		member.setMemberNo(memberNo);
		member.setMemberPw(memberPw);
		member.setMemberPhone(memberPhone);
		member.setMemberAddr(memberAddr);
		member.setMemberEmail(memberEmail);

		MemberService service = new MemberService();
		int result = service.updateMember(member);

		//4. 결과 처리
			//4.1 이동할 JSP 페이지 경로 지정
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");

		if(result > 0) {

			request.setAttribute("title", "알림");
			request.setAttribute("msg", "회원정보가 수정되었습니다.");
			request.setAttribute("icon", "success");
			request.setAttribute("loc", "/member/myPage");

			HttpSession session = request.getSession(false); //세션 있으면 존재하는 세션. 없으면 null 반환
			if(session != null) {
				Member loginMember = (Member) session.getAttribute("loginMember"); //로그인 했을 때, 등록한 회원 정보

				//세션 정보 업데이트
				if(memberPw == "") {
					loginMember.setMemberPhone(memberPhone);
					loginMember.setMemberAddr(memberAddr);
					loginMember.setMemberEmail(memberEmail);
				} else {
					loginMember.setMemberPw(memberPw);
					loginMember.setMemberPhone(memberPhone);
					loginMember.setMemberAddr(memberAddr);
					loginMember.setMemberEmail(memberEmail);
				}

			}
		}else {
			request.setAttribute("title", "알림");
			request.setAttribute("msg", "회원 정보 수정 중, 오류가 발생하였습니다.");
			request.setAttribute("icon", "error");
			request.setAttribute("loc", "/member/myPage");
		}

			//4.2 화면 구현에 필요한 데이터 등록
			//4.3 페이지 이동
		view.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
