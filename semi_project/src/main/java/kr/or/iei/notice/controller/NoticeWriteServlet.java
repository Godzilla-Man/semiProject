package kr.or.iei.notice.controller;

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
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.notice.model.service.NoticeService;
import kr.or.iei.notice.model.vo.Notice;

/**
 * Servlet implementation class NoticeWriteServlet
 */
@WebServlet("/notice/write")
public class NoticeWriteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeWriteServlet() {
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
		String noticeWriter = mRequest.getParameter("noticeWriter"); //회원 번호
		String noticeTitle = mRequest.getParameter("noticeTitle"); //게시글 제목
		String noticeContent = mRequest.getParameter("noticeContent"); //게시글 내용
		
		//input type이 file인 태그가 여러개일때 처리 코드
		Enumeration<String> files = mRequest.getFileNames();
		
		//여러개의 input type이 file인 요소가 존재할 경우 해당 파일을 저장할 리스트 생성
		ArrayList<Files> fileList = new ArrayList<Files>();
		
		while(files.hasMoreElements()) {
			String name = files.nextElement();
			
			String fileName = mRequest.getOriginalFileName(name); //사용자가 업로드한 파일명
			String filePath = mRequest.getFilesystemName(name); //변경된 파일명
			
			if(filePath != null) { //input type이 file인 요소들 중 업로드 된 요소만 처리하기 위함
				Files file = new Files();
				file.setFileName(fileName);
				file.setFilePath(filePath);
				
				fileList.add(file);
			}
		}
		
		//3. 로직
		Notice notice = new Notice();
		notice.setMemberNo(noticeWriter);
		notice.setNoticeTitle(noticeTitle);
		notice.setNoticeContent(noticeContent);
		
		NoticeService service = new NoticeService();
		int result = service.insertNotice(notice, fileList);
		
		//4. 결과처리
		//4.1 이동할 페이지 경로
		RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
		
		//4.2 화면 구현에 필요한 데이터 등록
		if(result > 0) {
			request.setAttribute("title", "성공");
			request.setAttribute("msg", "게시글이 작성되었습니다.");
			request.setAttribute("icon", "success");
		}else {
			request.setAttribute("title", "실패");
			request.setAttribute("msg", "게시글 작성 중 오류가 발생했습니다.");
			request.setAttribute("icon", "error");
		}
		
		request.setAttribute("loc", "/notice/list?reqPage=1");
		
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
