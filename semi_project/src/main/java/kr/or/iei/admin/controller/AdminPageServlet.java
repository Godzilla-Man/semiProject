package kr.or.iei.admin.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.admin.model.service.AdminServcie;

/**
 * Servlet implementation class AdminPageServlet
 */
@WebServlet("/admin/adminPage")
public class AdminPageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminPageServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AdminServcie service = new AdminServcie();
		int mCnt = service.countTodayMember(); //오늘 가입한 회원 수
		int rCnt = service.countTodayReport(); //오늘 들어온 신고 건수
		int bCnt = service.countTodayBlack(); //오늘 처리된 블랙 회원 수
		
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/admin/adminPage.jsp");
		
		request.setAttribute("mCnt", mCnt);
		request.setAttribute("rCnt", rCnt);
		request.setAttribute("bCnt", bCnt);
		
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
