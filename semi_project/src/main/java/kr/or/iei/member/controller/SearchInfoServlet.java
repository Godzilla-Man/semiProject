package kr.or.iei.member.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.member.model.service.MemberService;

/**
 * Servlet implementation class SearchInfoServlet
 */
@WebServlet("/member/searchInfo")
public class SearchInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public SearchInfoServlet() {
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
		String infoOption = request.getParameter("infoOption");
		String srchIdName = request.getParameter("srchId-name");
		String srchIdPhone = request.getParameter("srchId-phone");
		String srchIdEmailId = request.getParameter("srchId-emailId");
		String srchIdEmailDomain = request.getParameter("srchId-emailDomain");
		String srchPwId = request.getParameter("srchPw-id");
		String srchPwEmailId = request.getParameter("srchPw-emailId");
		String srchPwEmailDomain = request.getParameter("srchPw-emailDomain");

		String searchInfo = request.getParameter("searchInfo");	// "id" or "pw"

		//3. 로직 처리
			//3.1 입력한 이름+전화번호 혹은 이메일이 DB에 존재하는지
			//3.2 찾으려는정보(ID/PW)에 따라 일치하는 회원의 아이디 혹은 비밀번호 정보 조회
		MemberService service = new MemberService();
		String result = "";
		String srchIdEmail = srchIdEmailId + "@" + srchIdEmailDomain;
		String srchPwEmail = srchPwEmailId + "@" + srchPwEmailDomain;

		if(searchInfo.equals("id")) {
			//아이디 찾기
			if(infoOption.equals("namePhone")) {
				//이름+전화번호로 찾기
				result = service.searchId(srchIdName, srchIdPhone);
			} else {
				//이메일로 찾기
				result = service.searchId(srchIdEmail);
			}
		} else {
			//비밀번호 찾기
			result = service.searchPw(srchPwId, srchPwEmail);
		}

		//4. 결과 처리
			//4.1 이동할 JSP 페이지 경로 지정
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
			//4.2 화면 구현에 필요한 데이터 등록
		if(!result.isEmpty()) {
			if(searchInfo.equals("id")) {
				request.setAttribute("title", "아이디 찾기 성공");
				request.setAttribute("msg", "아이디는 \\\"" + result + "\\\"입니다.");
				request.setAttribute("icon", "success");
				request.setAttribute("loc", "/member/loginFrm");
			} else {
				request.setAttribute("title", "비밀번호 찾기 성공");
				request.setAttribute("msg", "비밀번호는 \\\"" + result + "\\\"입니다.");
				request.setAttribute("icon", "success");
				request.setAttribute("loc", "/member/loginFrm");
			}
		} else {
			if(searchInfo.equals("id")) {
				request.setAttribute("title", "아이디 찾기 실패");
				request.setAttribute("msg", "일치하는 회원이 없습니다.");
				request.setAttribute("icon", "error");
				request.setAttribute("loc", "/member/searchInfoFrm");
			} else {
				request.setAttribute("title", "비밀번호 찾기 실패");
				request.setAttribute("msg", "일치하는 회원이 없습니다.");
				request.setAttribute("icon", "error");
				request.setAttribute("loc", "/member/searchInfoFrm");
			}
		}
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
