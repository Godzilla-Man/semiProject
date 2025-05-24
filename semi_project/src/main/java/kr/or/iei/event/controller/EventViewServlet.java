package kr.or.iei.event.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.event.model.service.EventService;
import kr.or.iei.event.model.vo.Event;
import kr.or.iei.file.model.vo.Files;

/**
 * Servlet implementation class EventViewServlet
 */
@WebServlet("/event/view")
public class EventViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventViewServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//값 추출 - 게시글 번호
		String eventNo = request.getParameter("eventNo");
		boolean updChk = Boolean.valueOf(request.getParameter("updChk")); //조회수 업데이트 여부

		//로직
		EventService service = new EventService();
		//상세 정보
		Event event = service.selectOneEvent(eventNo, updChk);
		//파일 정보
		List<Files> fileList = service.selectEventFileList(eventNo);

		//결과 처리
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/event/view.jsp");

		//4.2 화면 구현에 필요한 데이터 등록
		request.setAttribute("event", event);
		request.setAttribute("fileList", fileList);

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
