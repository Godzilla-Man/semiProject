package kr.or.iei.notice.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.notice.model.vo.Notice;

public class NoticeDao {

	public ArrayList<Notice> selectNoticeList(Connection conn, int start, int end) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		ArrayList<Notice> list = new ArrayList<>();

		//목록 페이지에서는 일부 정보만 표기하기 위해 모든 컬럼 조회 X, 작성일 기준 내림차순 (가장 최신글이 상단에 보이도록)
		String query = "select notice_no, (select member_nickname from tbl_member c where c.member_no = b.member_no) notice_writer ,notice_title, notice_enroll_date, read_count from (select rownum rnum, a.* from (select * from tbl_notice a order by notice_enroll_date desc) a) b where rnum >= ? and rnum <= ?";

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

	public int insertNoticeFile(Connection conn, Notice notice, List<Files> fileList) {
		PreparedStatement pstmt = null;

		int result = 0;

		String qeury = "insert into tbl_file values (seq_file.nextval, null, null, ?, null, ?, ?, sysdate)";

		try {
			pstmt = conn.prepareStatement(qeury);

			for(Files f : fileList) {
				pstmt.setString(1, notice.getNoticeNo());
				pstmt.setString(2, f.getFileName());
				pstmt.setString(3, f.getFilePath());
				result += pstmt.executeUpdate(); //한 건씩 처리
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}

		return result;
	}

	public Notice selectOneNotice(Connection conn, String noticeNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		Notice notice = null;

		String query = "select notice_title, notice_content, (select member_nickname from tbl_member b where b.member_no = a.member_no) as notice_writer, notice_enroll_date, read_count from tbl_notice a where a.notice_no = ?";

		try {
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, noticeNo);

			rset = pstmt.executeQuery();

			if(rset.next()) {
				notice = new Notice();
				notice.setNoticeNo(noticeNo);
				notice.setNoticeTitle(rset.getString("notice_title"));
				notice.setNoticeContent(rset.getString("notice_content"));
				notice.setMemberNo(rset.getString("notice_writer"));
				notice.setNoticeEnrollDate(rset.getString("notice_enroll_date"));
				notice.setReadCount(rset.getInt("read_count"));
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}

		return notice;
	}

	public int updateReadCount(Connection conn, String noticeNo) {
		PreparedStatement pstmt = null;

		int result = 0;

		String query = "update tbl_notice set read_count = read_count + 1 where notice_no = ?";

		try {
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, noticeNo);

			result = pstmt.executeUpdate();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}

		return result;
	}

	public List<Files> selectNoticeFileList(Connection conn, String noticeNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		List<Files> fileList = new ArrayList<>();

		String query = "select file_no, file_name, file_path from tbl_file where notice_no = ? order by file_no";

		try {
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, noticeNo);

			rset = pstmt.executeQuery();

			while(rset.next()) {
				Files file = new Files();
				file.setFileNo(rset.getInt("file_no"));
				file.setNoticeNo(noticeNo);
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

	public int updateNotice(Connection conn, Notice notice) {
		PreparedStatement pstmt = null;

		String query = "update tbl_notice set notice_title = ?, notice_content = ? where notice_no = ?";

		int result = 0;

		try {
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, notice.getNoticeTitle());
			pstmt.setString(2, notice.getNoticeContent());
			pstmt.setString(3, notice.getNoticeNo());

			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}

		return result;
	}

	public int deleteNoticeFile(Connection conn, Notice notice) {
		PreparedStatement pstmt = null;

		String query = "delete from tbl_file where notice_no = ?";

		int result = 0;

		try {
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, notice.getNoticeNo());

			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}

		return result;
	}

	public int deleteNotice(Connection conn, String noticeNo) {
		PreparedStatement pstmt = null;

		String query = "delete from tbl_notice where notice_no = ?";

		int result = 0;

		try {
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, noticeNo);

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
