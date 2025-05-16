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
 * Servlet implementation class LoginServlet
 */
@WebServlet("/member/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 인코딩 - 필터에서 처리
		//2. 클라이언트가 전송한 값 추출
		String loginId = request.getParameter("loginId");
		String loginPw = request.getParameter("loginPw");
		
		//3. 로직 처리 - 로그인
			//3.1 입력한 아이디/비밀번호와 일치하는 회원이 DB에 존재하는지
			//3.2 일치하는 회원의 컬럼 정보를 조회 - 정상로그인 후 마이페이지에서 부가적인 정보를 보여주기 위해
			//3.3 3.2에서 조회한 정보들은 로그아웃 전까지 어느 JSP로 이동하든 회원 정보를 사용할 수 있음.
		MemberService service = new MemberService();
		Member loginMember = service.memberLogin(loginId, loginPw);
		
		//4. 결과 처리
		RequestDispatcher view = null;
		
		if(loginMember == null) {
			//4.1 이동할 JSP 페이지 경로 지정
			view = request.getRequestDispatcher("/WEB-INF/view/common/msg.jsp");
			
			//4.2 화면 구현에 필요한 데이터 등록
			request.setAttribute("title", "알림");
			request.setAttribute("msg", "아이디 또는 비밀번호를 확인하세요");
			request.setAttribute("icon", "error");
			request.setAttribute("loc", "/member/loginFrm");
		} else {
			//4.1 이동할 JSP 페이지 경로 지정
			view = request.getRequestDispatcher("/index.jsp");
			
			//4.2 화면 구현에 필요한 데이터 등록
			HttpSession session = request.getSession();
			session.setAttribute("loginMember", loginMember);
			session.setMaxInactiveInterval(600);	//세션 만료시간(초) - 10분
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
