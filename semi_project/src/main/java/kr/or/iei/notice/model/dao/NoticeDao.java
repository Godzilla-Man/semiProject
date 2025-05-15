package kr.or.iei.notice.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.notice.model.vo.Notice;

public class NoticeDao {
	
	public ArrayList<Notice> selectNoticeList(Connection conn, int start, int end) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		ArrayList<Notice> list = new ArrayList<Notice>();
		
		//목록 페이지에서는 일부 정보만 표기하기 위해 모든 컬럼 조회 X, 작성일 기준 내림차순 (가장 최신글이 상단에 보이도록)
		String query = "select notice_no, (select member_nickname from tbl_member where member_no = member_no) notice_writer ,notice_title, notice_enroll_date, read_count from (select rownum rnum, a.* from (select * from tbl_notice a order by notice_enroll_date desc) a) where rnum >= ? and rnum <= ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Notice n = new Notice();
				n.setNoticeNo(rset.getString("notice_no")); //목록에서 클릭하면 상세보기로 이동하기 위해
				n.setMemberNo(rset.getString("notice_writer"));
				n.setNoticeTitle(rset.getString("notice_title"));
				n.setNoticeEnrollDate(rset.getString("notice_enroll_date"));
				n.setReadCount(rset.getInt("read_count"));
				
				list.add(n);
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
		
		String query = "select count(*) as cnt from tbl_notice";
		
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
	
	public String selectNoticeNo(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String noticeNo = "";
		
		String query = "select 'N' || to_char(sysdate, 'yymmdd') || lpad(seq_notice.nextval, 4, '0') notice_no from dual";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				noticeNo = rset.getString("notice_no");
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return noticeNo;
	}
	
	public int insertNotice(Connection conn, Notice notice) {
		PreparedStatement pstmt = null;
		
		int result = 0;
		
		String query = "insert into tbl_notice values (?, ?, ?, ?, sysdate, default)";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, notice.getNoticeNo());
			pstmt.setString(2, notice.getMemberNo());
			pstmt.setString(3, notice.getNoticeTitle());
			pstmt.setString(4, notice.getNoticeContent());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}
	
	public int insertNoticeFile(Connection conn, Files file) {
		PreparedStatement pstmt = null;
		
		int result = 0;
		
		String qeury = "insert into tbl_file values (seq_file.nextval, null, null, ?, null, ?, ?, sysdate)";
		
		try {
			pstmt = conn.prepareStatement(qeury);
			
			pstmt.setString(1, file.getNoticeNo());
			pstmt.setString(2, file.getFileName());
			pstmt.setString(3, file.getFilePath());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}
}
