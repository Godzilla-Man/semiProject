package kr.or.iei.event.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.event.model.vo.Event;

public class EventDao {

	public ArrayList<Event> selectNoticeList(Connection conn, int start, int end) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		ArrayList<Event> list = new ArrayList<Event>();
		
		//목록 페이지에서는 일부 정보만 표기하기 위해 모든 컬럼 조회 X, 작성일 기준 내림차순 (가장 최신글이 상단에 보이도록)
		String query = "select event_no, (select member_nickname from tbl_member where member_no = member_no) event_writer ,event_title, event_enroll_date, read_count from (select rownum rnum, a.* from (select * from tbl_event a order by event_enroll_date desc) a) where rnum >= ? and rnum <= ?";
		
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

}
