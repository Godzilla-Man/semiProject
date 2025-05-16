package kr.or.iei.event.model.service;

import java.sql.Connection;
import java.util.ArrayList;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.common.ListData;
import kr.or.iei.event.model.dao.EventDao;
import kr.or.iei.event.model.vo.Event;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.notice.model.vo.Notice;

public class EventService {
	
	private EventDao dao;
	
	public EventService() {
		dao = new EventDao();
	}

	public ListData<Event> selectEventList(int reqPage) {
		Connection conn = JDBCTemplate.getConnection();
		
		//한 페이지에 보여줄 게시글의 갯수
		int viewNoticeCnt = 10;
		
		//시작 행 번호(start)와 끝 행 번호(end)를 요청 페이지 번호(reqPage)에 따라 연산
		
		/*
		 * reqPage == 1 -> start == 1, end == 10
		 * reqPage == 2 -> start == 11, end == 20
		 * reqPage == 3 -> start == 21, end == 30
		 */
		
		int end = reqPage * viewNoticeCnt;
		int start = end - viewNoticeCnt + 1;
		
		ArrayList<Event> list = dao.selectNoticeList(conn, start, end);

		//페이지네이션 작업 < 1 2 3 4 5 >
		
		//전체 게시글 갯수 조회 (totCnt)
		int totCnt = dao.selectTotalCount(conn);
		
		//전체 페이지 갯수 (totPage)
		int totPage = 0;
		if(totCnt % viewNoticeCnt > 0) { //전체 게시글 갯수를 한 페이지에 보여줄 게시글의 갯수로 나눴을 때 나머지가 0보다 크면
			totPage = totCnt / viewNoticeCnt + 1;
		}else { //전체 게시글 갯수를 한 페이지에 보여줄 게시글의 갯수로 나눴을 때 나머지가 0이면
			totPage = totCnt / viewNoticeCnt;
		}
		
		//페이지네이션 사이즈 1 2 3 4 5
		int pageNaviSize = 5;
		
		//페이지네이션의 시작 번호 (1,2,3,4,5 그룹이면 1, 6,7,8,9,10 그룹이면 6, 11,12,13,14,15 그룹이면 11)
		int pageNo = ((reqPage-1) / pageNaviSize) * pageNaviSize + 1;
		
		//페이지 하단에 보여줄 페이지네이션 HTML 코드 작성
		String pageNavi = "<ul class='pagination circle-style'>";
		
		//이전 버튼
		if(pageNo != 1) {
			pageNavi += "<li>";
			pageNavi += "<a class='page-item' href='/event/list?reqPage=" + (pageNo - 1) + "'>";
			pageNavi += "<span class='material-icons'>chevron_left</span>";
			pageNavi += "</a></li>";
		}
		
		for(int i=0; i<pageNaviSize; i++) {
			pageNavi += "<li>";
			
			//페이지 번호 작성 중 사용자가 요청한 페이지일 때 클래스를 다르ㅔ 지정하여 시각적인 효과
			if(pageNo == reqPage) {
				pageNavi += "<a class='page-item active-page' href='/event/list?reqPage=" + pageNo + "'>";
			}else {
				pageNavi += "<a class='page-item' href='/event/list?reqPage=" + pageNo + "'>";
			}
			
			pageNavi += pageNo; //시작태그와 종료태그 사이에 작성되는 값
			pageNavi += "</a></li>";
			pageNo++;
			
			//설정한 pageNaviSize만큼 항상 그리지 않고 마지막 페이지 그렸으면 더 이상 생성하지 않도록 처리
			//ex) 총 게시글 갯수가 130개면 13개 페이지가 그려옂야 함 근데 pageNaviSize만큼 반복문 시작하면 11,12,13,14,15까지 모두 그려진다 13까지만 그리고 반복문 종료
			if(pageNo > totPage) {
				break;
			}
		}
		
		//다음 버튼
		if(pageNo <= totPage) {
			pageNavi += "<li>";
			pageNavi += "<a class='page-item' href='/event/list?reqPage=" + pageNo + "'>";
			pageNavi += "<span class='material-icons'>chevron_right</span>";
			pageNavi += "</a></li>";
		}
		
		pageNavi += "</ul>";
		
		/*
		 * 서블릿으로 리턴해야되는 값 -> 게시글 리스트(list)와 페이지 하단에 보여줄 페이지네이션 (pageNavi)
		 * 자바에서 메소드는 하나의 값만을 리턴할 수 있음 -> 두 개의 값을 저장할 수 있는 객체 ListData 생성
		 */
		ListData<Event> listData = new ListData<Event>();
		listData.setList(list);
		listData.setPageNavi(pageNavi);
		
		JDBCTemplate.close(conn);
		
		return listData;
	}

	public int insertEvent(Event event, ArrayList<Files> fileList) {
		Connection conn = JDBCTemplate.getConnection();
		
		/*
		 * 현재 기능은 등록 == insert
		 * 대상 테이블은 tbl_event(이벤트), tbl_file(파일)
		 * 	- 부모 테이블 : tbl_event
		 * 	- 자식 테이블 : tbl_file
		 * 
		 * 부모 테이블의 데이터가 존재해야 자식 테이블에 insert가 가능
		 * 즉, tbl_event에 insert가 먼저 수행되어야 함
		 * 
		 * 1) 게시글 번호 조회 select Query
		 * 
		 * 2) tbl_event의 insert Query
		 * insert into tbl_event values (?, ?, ?, ?, sysdate, default);
		 * 
		 * 3) tbl_file의 insert Query
		 * insert into tbl_file values (seq_file.nextval, null, null, null, ?, ?, ?, sysdate);
		 */
		
		//1) 게시글 번호 조회. 아래 2)와 3)에서 동일한 게시글 번호를 공유해야 하므로 선조회
		String eventNo = dao.selectEventNo(conn);
		
		event.setEventNo(eventNo);
		
		//2) tbl_notice에 insert(게시글 정보 선등록)
		int result = dao.insertEvent(conn, event);
		
		if(result > 0) {
			for(Files file : fileList) {
				file.setEventNo(eventNo); //1)에서 조회한 게시글 번호
				
				//3) tbl_file에 insert(게시글에 대한 파일 등록)
				result = dao.insertEventFile(conn, file);
				
				//파일 정보 등록 중 정상 수행되지 않았을 경우 모두 롤백처리하고 메소드 종료
				if(result < 1) {
					JDBCTemplate.rollback(conn);
					JDBCTemplate.close(conn);
					return 0;
				}
			}
			
			JDBCTemplate.commit(conn);
		}else {
			JDBCTemplate.rollback(conn);
		}
		JDBCTemplate.close(conn);
		
		return result;
	}

	public Event selectOneEvent(String eventNo, boolean updChk) {
		Connection conn = JDBCTemplate.getConnection();
		
		/*
		 * 게시글 상세 조회
		 * 
		 * 1) 게시글 정보 조회
		 * 2) 게시글 조회수 업데이트
		 * 3) 게시글에 대한 파일 정보 조회
		 */
		
		//1) 게시글 정보 조회
		Event event = dao.selectOneEvent(conn, eventNo);
		
		if(event != null) {
			//2) 게시글 조회수 업데이트
			int result = 0;
			
			/*
			 * updChk == true : 상세보기 이동 시 호출
			 * updChk == false : 수정하기로 이동 시 호출
			 */
			if(updChk) {
				result = dao.updateReadCount(conn, eventNo);				
			}
			
			if(result > 0 || !updChk) {
				JDBCTemplate.commit(conn);
				
				//3) 게시글에 대한 파일 정보 조회
				ArrayList<Files> fileList = dao.selectEventFileList(conn, eventNo);
				event.setFileList(fileList);
				
			}else {
				JDBCTemplate.rollback(conn);
			}
		}
		
		JDBCTemplate.close(conn);
		
		return event;
	}
}
