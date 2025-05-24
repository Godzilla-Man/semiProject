package kr.or.iei.member.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.member.model.service.MemberService;

/**
 * Servlet implementation class IdDuplChkServlet
 */
@WebServlet("/nicknameDuplChk")
public class nicknameDuplChkServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public nicknameDuplChkServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 인코딩 - 필터

		//2. 값 추출 - 중복체크에 필요한 사용자 입력 아이디
		String memberNickname = request.getParameter("memberNickname");

		//3. 로직 - 아이디 중복체크
		MemberService service = new MemberService();
		int cnt = service.nicknameDuplChk(memberNickname);

		//4. 결과 처리
			//4.1 이동할 JSP 경로 지정
			//4.2 화면 구현에 필요한 데이터 등록
			//4.3 페이지 이동

		//4. 결과 처리(비동기 통신 ajax)
		response.getWriter().print(cnt); //응답 스트림을 통해 데이터를 응답
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
