package kr.or.iei.notice.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.file.model.vo.Files;
import kr.or.iei.notice.model.service.NoticeService;

/**
 * Servlet implementation class NoticeDeleteServlet
 */
@WebServlet("/notice/delete")
public class NoticeDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeDeleteServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String noticeNo = request.getParameter("noticeNo");
		
		//로직 - 게시글 삭제
		NoticeService service = new NoticeService();
		ArrayList<Files> delFileList = service.deleteNotice(noticeNo);
		
		//4. 결과 처리
		//4.1 이동할 페이지 경로
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
		
		//4.2 화면 구현에 필요한 데이터 등록 및 서버에서 파일 삭제
		if(delFileList != null) {
			request.setAttribute("title", "성공");
			request.setAttribute("msg", "게시글이 삭제되었습니다.");
			request.setAttribute("icon", "success");
			request.setAttribute("loc", "/notice/list?reqPage=1");
			
			String rootPath = request.getSession().getServletContext().getRealPath("/"); //webapp 폴더 경로
			for(int i=0; i<delFileList.size(); i++) {
				Files delFile = delFileList.get(i); //삭제 대상 파일
				
				String writeDate = delFile.getFilePath().substring(0, 8); //0~7번 인덱스 값 추출
				String savePath = rootPath + "resources/upload/" + writeDate + "/"; //파일 저장 경로
				
				File file = new File(savePath + delFile.getFilePath());
				file.delete();
			}
		} else {
			request.setAttribute("title", "실패");
			request.setAttribute("msg", "게시글 삭제 중 오류가 발생했습니다.");
			request.setAttribute("icon", "error");
			request.setAttribute("loc", "/notice/list?reqPage=1");
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
