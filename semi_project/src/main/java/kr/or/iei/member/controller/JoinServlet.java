package kr.or.iei.member.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.member.model.service.MemberService;
import kr.or.iei.member.model.vo.Member;

/**
 * Servlet implementation class JoinServlet
 */
@WebServlet("/member/join")
public class JoinServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public JoinServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 인코딩 - 필터에서 처리
		//2. 클라이언트가 전송한 값 추출
		String memberId = request.getParameter("memberId");
		String memberPw = request.getParameter("memberPw");
		String memberNickname = request.getParameter("memberNickname");
		String memberName = request.getParameter("memberName");
		//생년월일은 년/월/일로 나눠져있음
		String birthYear = request.getParameter("birthYear");
		String birthMonth = request.getParameter("birthMonth");
		String birthDay = request.getParameter("birthDay");
		String memberPhone = request.getParameter("memberPhone");
		//주소는 우편번호/주소/상세주소/참고항목으로 나눠져있음
		String addr_postcode = request.getParameter("addr_postcode");
		String addr_address = request.getParameter("addr_address");
		String addr_detailAddress = request.getParameter("addr_detailAddress");
		String addr_extraAddress = request.getParameter("addr_extraAddress");
		//이메일은 아이디/도메인으로 나눠져있음
		String memberEmailId = request.getParameter("memberEmailId");
		String memberEmailDomain = request.getParameter("memberEmailDomain");
		
		//3. 로직 처리 - 회원가입
		//나눠져있는 생년월일 합치기
		String memberBirth = birthYear + birthMonth + birthDay;
		//나눠져있는 주소 합치기
		String memberAddr = "[" + addr_postcode + "]" + addr_address + ", " + addr_detailAddress + addr_extraAddress;
		//나눠져있는 이메일 합치기
		String memberEmail = memberEmailId + "@" + memberEmailDomain;
		
		Member member = new Member();
		member.setMemberId(memberId);
		member.setMemberPw(memberPw);
		member.setMemberNickname(memberNickname);
		member.setMemberName(memberName);
		member.setMemberBirth(memberBirth);
		member.setMemberPhone(memberPhone);
		member.setMemberAddr(memberAddr);
		member.setMemberEmail(memberEmail);
		
		MemberService service = new MemberService();
		int result = service.memberJoin(member);
		
		//4. 결과 처리
			//4.1 이동할 JSP 페이지 경로 지정
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
			//4.2 화면 구현에 필요한 데이터 등록
		if(result > 0) {
			request.setAttribute("title", "성공");
			request.setAttribute("msg", "회원가입이 완료되었습니다.");
			request.setAttribute("icon", "success");
			request.setAttribute("loc", "/member/loginFrm");
		} else {
			request.setAttribute("title", "실패");
			request.setAttribute("msg", "회원가입 중, 오류가 발생하였습니다.");
			request.setAttribute("icon", "error");
			request.setAttribute("loc", "/member/joinFrm");
		}
			//4.3 페이지 이동
		view.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
