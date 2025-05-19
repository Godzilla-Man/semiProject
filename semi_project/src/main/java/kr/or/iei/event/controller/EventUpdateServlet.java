package kr.or.iei.event.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;

import kr.or.iei.common.KhRenamePolicy;
import kr.or.iei.event.model.service.EventService;
import kr.or.iei.event.model.vo.Event;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.notice.model.service.NoticeService;
import kr.or.iei.notice.model.vo.Notice;

/**
 * Servlet implementation class EventUpdateServlet
 */
@WebServlet("/event/update")
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
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//값 추출 - 파일 업로드 시 기존 HttpServletRequest 객체로 추출하던 방식 사용 x
		
		//오늘 날짜(yyMMdd) 폴더 생성을 위한 String 변수
		String toDay = new SimpleDateFormat("yyyyMMdd").format(new Date()); //20250509
		
		//C드라이브부터 webapp 폴더까지 경로
		String rootPath = request.getSession().getServletContext().getRealPath("/");
		
		//실제 파일 저장 경로 지정
		String savePath = rootPath + "resources/upload/" + toDay + "/";
		
		//업로드 파일의 최대 크기 지정
		int maxSize = 1024 * 1024 * 100; //100 Mega Byte
		
		File dir = new File(savePath);
		if(!dir.exists()) { //오늘 날짜 폴더가 존재하지 않으면
			dir.mkdirs(); //오늘 날짜 폴더 생성
		}
		
		MultipartRequest mRequest = new MultipartRequest(request, savePath, maxSize, "UTF-8", new KhRenamePolicy()); //request, 파일경로, 최대크기, 언어, 파일명 중복 방지를 위한 명명규칙
		
		//MultipartRequest 객체로 값 추출
		String eventNo = mRequest.getParameter("eventNo"); //게시글 번호
		String eventTitle = mRequest.getParameter("eventTitle"); //게시글 제목
		String eventContent = mRequest.getParameter("eventContent"); //게시글 내용
		
		//input type이 file인 태그가 여러개일때 처리 코드
		Enumeration<String> files = mRequest.getFileNames();
		
		//여러개의 input type이 file인 요소가 존재할 경우 해당 파일을 저장할 리스트 생성
		ArrayList<Files> addFileList = new ArrayList<Files>();
		
		while(files.hasMoreElements()) {
			String name = files.nextElement();
			
			String fileName = mRequest.getOriginalFileName(name); //사용자가 업로드한 파일명
			String filePath = mRequest.getFilesystemName(name); //변경된 파일명
			
			if(filePath != null) { //input type이 file인 요소들 중 업로드 된 요소만 처리하기 위함
				Files file = new Files();
				file.setFileName(fileName);
				file.setFilePath(filePath);
				
				addFileList.add(file);
			}
		}
		
		//로직
		Event event = new Event();
		event.setEventNo(eventNo);
		event.setEventTitle(eventTitle);
		event.setEventContent(eventContent);
		
		String [] delFileNoList = mRequest.getParameterValues("delFileNo"); //삭제 대상 파일 정보
		
		EventService service = new EventService();
		ArrayList<Files> delFileList = service.updateEvent(event, addFileList, delFileNoList); 
		
		//결과 처리
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
		
		if(delFileList != null) {
			for(int i=0; i<delFileList.size(); i++) {
				Files delFile = delFileList.get(i);
				
				String writeDate = delFile.getFilePath().substring(0, 8); //삭제 파일이 위치한 폴더명
				String delSavePath = rootPath + "resources/upload/" + writeDate + "/" + delFile.getFilePath();
				
				File file = new File(delSavePath);
				if(file.exists()) {
					file.delete();
				}
			}
			
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
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
