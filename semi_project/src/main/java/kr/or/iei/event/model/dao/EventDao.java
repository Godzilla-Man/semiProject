package kr.or.iei.event.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.event.model.vo.Event;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.notice.model.vo.Notice;

public class EventDao {

	public ArrayList<Event> selectNoticeList(Connection conn, int start, int end) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		ArrayList<Event> list = new ArrayList<Event>();
		
		//목록 페이지에서는 일부 정보만 표기하기 위해 모든 컬럼 조회 X, 작성일 기준 내림차순 (가장 최신글이 상단에 보이도록)
		String query = "select event_no, (select member_nickname from tbl_member c where c.member_no = b.member_no) event_writer ,event_title, event_enroll_date, read_count from (select rownum rnum, a.* from (select * from tbl_event a order by event_enroll_date desc) a) b where rnum >= ? and rnum <= ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Event e = new Event();
				e.setEventNo(rset.getString("event_no")); //목록에서 클릭하면 상세보기로 이동하기 위해
				e.setMemberNo(rset.getString("event_writer"));
				e.setEventTitle(rset.getString("event_title"));
				e.setEventEnrollDate(rset.getString("event_enroll_date"));
				e.setReadCount(rset.getInt("read_count"));
				
				list.add(e);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return list;
	}

	public int selectTotalCount(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		int totCnt = 0;
		
		String query = "select count(*) as cnt from tbl_event";
		
		try {
			pstmt = conn.prepareStatement(query);

			rset = pstmt.executeQuery();
			
			rset.next();
			
			totCnt = rset.getInt("cnt");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return totCnt;
	}

	public String selectEventNo(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String eventNo = "";
		
		String query = "select 'E' || to_char(sysdate, 'yymmdd') || lpad(seq_event.nextval, 4, '0') event_no from dual";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				eventNo = rset.getString("event_no");
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return eventNo;
	}

	public int insertEvent(Connection conn, Event event) {
		PreparedStatement pstmt = null;
		
		int result = 0;
		
		String query = "insert into tbl_event values (?, ?, ?, ?, sysdate, default)";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, event.getEventNo());
			pstmt.setString(2, event.getMemberNo());
			pstmt.setString(3, event.getEventTitle());
			pstmt.setString(4, event.getEventContent());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}

	public int insertEventFile(Connection conn, Event event, List<Files> fileList) {
		PreparedStatement pstmt = null;
		
		int result = 0;
		
		String qeury = "insert into tbl_file values (seq_file.nextval, null, null, null, ?, ?, ?, sysdate)";
		
		try {
			pstmt = conn.prepareStatement(qeury);
			
			for(Files f : fileList) {			
				pstmt.setString(1, event.getEventNo());
				pstmt.setString(2, f.getFileName());
				pstmt.setString(3, f.getFilePath());
				result += pstmt.executeUpdate();
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}

	public Event selectOneEvent(Connection conn, String eventNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		Event event = null;
		
		String query = "select event_title, event_content, (select member_nickname from tbl_member b where b.member_no = a.member_no) as event_writer, event_enroll_date, read_count from tbl_event a where event_no = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, eventNo);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				event = new Event();
				event.setEventNo(eventNo);
				event.setEventTitle(rset.getString("event_title"));
				event.setEventContent(rset.getString("event_content"));
				event.setMemberNo(rset.getString("event_writer"));
				event.setEventEnrollDate(rset.getString("event_enroll_date"));
				event.setReadCount(rset.getInt("read_count"));
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return event;
	}

	public int updateReadCount(Connection conn, String eventNo) {
		PreparedStatement pstmt = null;
		
		int result = 0;
		
		String query = "update tbl_event set read_count = read_count + 1 where event_no = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, eventNo);
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}

	public List<Files> selectEventFileList(Connection conn, String eventNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		List<Files> fileList = new ArrayList<>();
		
		String query = "select file_no, file_name, file_path from tbl_file where event_no = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, eventNo);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Files file = new Files();
				file.setFileNo(rset.getInt("file_no"));
				file.setEventNo(eventNo);
				file.setFileName(rset.getString("file_name"));
				file.setFilePath(rset.getString("file_path"));
				
				fileList.add(file);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return fileList;
	}

	public int updateEvent(Connection conn, Event event) {
		PreparedStatement pstmt = null;
		
		String query = "update tbl_event set event_title = ?, event_content = ? where event_no = ?";
		
		int result = 0;
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, event.getEventTitle());
			pstmt.setString(2, event.getEventContent());
			pstmt.setString(3, event.getEventNo());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		return result;
	}

	public int deleteEventFile(Connection conn, Event event) {
		PreparedStatement pstmt = null;
		
		String query = "delete from tbl_file where event_no = ?";
		
		int result = 0;
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, event.getEventNo());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		return result;
	}

	public int deleteEvent(Connection conn, String eventNo) {
		PreparedStatement pstmt = null;
		
		String query = "delete from tbl_event where event_no = ?";
		
		int result = 0;
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, eventNo);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}

	public List<Files> selectFirstEventFileList(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		List<Files> fileList = new ArrayList<>();
		
		String query = "select file_no, file_name, file_path, event_no from tbl_file where event_no like '%' order by event_no desc";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {				
				for(int i=0; i<1; i++) {
					Files file = new Files();
					file.setFileNo(rset.getInt("file_no"));
					file.setFileName(rset.getString("file_name"));
					file.setFilePath(rset.getString("file_path"));
					file.setEventNo(rset.getString("event_no"));
					
					fileList.add(file);
				}
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return fileList;
	}
	
}
