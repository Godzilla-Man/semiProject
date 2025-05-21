package kr.or.iei.notice.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.oreilly.servlet.MultipartRequest;

import kr.or.iei.common.KhRenamePolicy;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.notice.model.service.NoticeService;
import kr.or.iei.notice.model.vo.Notice;

/**
 * Servlet implementation class NoticeUpdateServlet
 */
@WebServlet("/notice/update")
@MultipartConfig(
	    maxFileSize = 1024 * 1024 * 10, // 10MB
	    maxRequestSize = 1024 * 1024 * 50, // 50MB
	    fileSizeThreshold = 1024 * 1024 * 1 // 1MB 이상은 디스크에 저장
	)
public class NoticeUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeUpdateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String noticeNo = request.getParameter("noticeNo"); //게시글 번호
		String noticeTitle = request.getParameter("noticeTitle"); //게시글 제목
		String noticeContent = request.getParameter("noticeContent"); //게시글 내용

		// 파일 저장 경로 (서버 내 실제 경로)
        String uploadPath = getServletContext().getRealPath("/resources/upload/notice");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();
		
        // 업로드된 이미지 파일 리스트 수집
        List<Files> fileList = new ArrayList<>();
        for (Part part : request.getParts()) {
            if (part.getName().equals("noticeFile") && part.getSize() > 0) {
            	String originName = part.getSubmittedFileName().replaceAll("[^a-zA-Z0-9._-]", "_");


                // 중복 방지를 위한 새로운 파일명 생성 (ex: timestamp_파일명)
                String newFileName = System.currentTimeMillis() + "_" + originName;
                part.write(uploadPath + "/" + newFileName);

                // 파일 객체 생성
                Files file = new Files();
                file.setFileName(originName);
                file.setFilePath("/resources/upload/notice/" + newFileName);
                fileList.add(file);
            }
        }
		
		//로직
		Notice notice = new Notice();
		notice.setNoticeNo(noticeNo);
		notice.setNoticeTitle(noticeTitle);
		notice.setNoticeContent(noticeContent);
		
		NoticeService service = new NoticeService();
		int result = service.updateNotice(notice, fileList); 
		
		//결과 처리
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
		
		if(result > 0) {
			request.setAttribute("title", "성공");
			request.setAttribute("msg", "게시글이 수정되엇습니다.");
			request.setAttribute("icon", "success");
			request.setAttribute("loc", "/notice/view?noticeNo=" + noticeNo + "&updChk=false");
		}else {
			request.setAttribute("title", "실패");
			request.setAttribute("msg", "게시글 수정 중 오류가 발생했습니다.");
			request.setAttribute("icon", "error");
			request.setAttribute("loc", "/notice/updateFrm?noticeNo=" + noticeNo);
		}
		
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
