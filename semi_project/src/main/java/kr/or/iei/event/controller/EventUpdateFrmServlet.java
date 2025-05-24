package kr.or.iei.event.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.event.model.service.EventService;
import kr.or.iei.event.model.vo.Event;

/**
 * Servlet implementation class EventUpdateFrmServlet
 */
@WebServlet("/event/updateFrm")
public class EventUpdateFrmServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventUpdateFrmServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//값 추출
		String eventNo = request.getParameter("eventNo");

		//로직 - 게시글 1개 정보 조회
		EventService service = new EventService();
		Event event = service.selectOneEvent(eventNo, false);

		//결과 처리
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/event/updateFrm.jsp");

		request.setAttribute("event", event);

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
