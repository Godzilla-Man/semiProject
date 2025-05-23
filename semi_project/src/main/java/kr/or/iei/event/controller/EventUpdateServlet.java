package kr.or.iei.event.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import kr.or.iei.event.model.service.EventService;
import kr.or.iei.event.model.vo.Event;
import kr.or.iei.file.model.vo.Files;

/**
 * Servlet implementation class EventUpdateServlet
 */
@WebServlet("/event/update")
@MultipartConfig(
	    maxFileSize = 1024 * 1024 * 10, // 10MB
	    maxRequestSize = 1024 * 1024 * 50, // 50MB
	    fileSizeThreshold = 1024 * 1024 * 1 // 1MB 이상은 디스크에 저장
	)
public class EventUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventUpdateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String eventNo = request.getParameter("eventNo"); //회원 번호
		String eventTitle = request.getParameter("eventTitle"); //게시글 제목
		String eventContent = request.getParameter("eventContent"); //게시글 내용

		 // 파일 저장 경로 (서버 내 실제 경로)
        String uploadPath = getServletContext().getRealPath("/resources/upload/event");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}

        // 업로드된 이미지 파일 리스트 수집
        List<Files> fileList = new ArrayList<>();
        for (Part part : request.getParts()) {
            if (part.getName().equals("eventFile") && part.getSize() > 0) {
            	String originName = part.getSubmittedFileName().replaceAll("[^a-zA-Z0-9._-]", "_");


                // 중복 방지를 위한 새로운 파일명 생성 (ex: timestamp_파일명)
                String newFileName = System.currentTimeMillis() + "_" + originName;
                part.write(uploadPath + "/" + newFileName);

                // 파일 객체 생성
                Files file = new Files();
                file.setFileName(originName);
                file.setFilePath("/resources/upload/event/" + newFileName);
                fileList.add(file);
            }
        }

		//로직
		Event event = new Event();
		event.setEventNo(eventNo);
		event.setEventTitle(eventTitle);
		event.setEventContent(eventContent);

		EventService service = new EventService();
		int result = service.updateEvent(event, fileList);

		//결과 처리
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");

		if(result > 0) {
			request.setAttribute("title", "성공");
			request.setAttribute("msg", "게시글이 수정되엇습니다.");
			request.setAttribute("icon", "success");
			request.setAttribute("loc", "/event/view?eventNo=" + eventNo + "&updChk=false");
		}else {
			request.setAttribute("title", "실패");
			request.setAttribute("msg", "게시글 수정 중 오류가 발생했습니다.");
			request.setAttribute("icon", "error");
			request.setAttribute("loc", "/event/updateFrm?eventNo=" + eventNo);
		}

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
