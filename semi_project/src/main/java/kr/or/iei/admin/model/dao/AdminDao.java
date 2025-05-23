package kr.or.iei.admin.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.or.iei.admin.model.vo.BlackList;
import kr.or.iei.admin.model.vo.ReportPost;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.member.model.vo.Member;

public class AdminDao {

	//전체 회원 조회
	public ArrayList<Member> selectAllMember(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String query = "select member_no, member_id, member_nickname, member_name, to_char(member_birth, 'yyyy-mm-dd') as member_birth, member_phone, member_addr, member_email, to_char(join_date, 'yyyy-mm-dd') as join_date from tbl_member order by join_date desc";

		ArrayList<Member> memberList = new ArrayList<>();

		try {
			pstmt = conn.prepareStatement(query);

			rset = pstmt.executeQuery();

			while(rset.next()) {
				Member m = new Member();
				m.setMemberNo(rset.getString("member_no"));
				m.setMemberId(rset.getString("member_id"));
				m.setMemberNickname(rset.getString("member_nickname"));
				m.setMemberName(rset.getString("member_name"));
				m.setMemberBirth(rset.getString("member_birth"));
				m.setMemberPhone(rset.getString("member_phone"));
				m.setMemberAddr(rset.getString("member_addr"));
				m.setMemberEmail(rset.getString("member_email"));
				m.setJoin_date(rset.getString("join_date"));

				memberList.add(m);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}

		return memberList;
	}

	// 전체 신고 리스트 조회
	public ArrayList<ReportPost> selectReportPost(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String query = "SELECT a.report_no, b.report_reason AS report_reason, a.reported_member_no, "
		             + "a.product_no AS product_no, c.member_no AS product_member_no, "
		             + "TO_CHAR(a.report_date, 'yyyy-mm-dd') AS report_date, "
		             + "a.report_detail "
		             + "FROM tbl_report_post a "
		             + "JOIN tbl_report b ON (a.report_code = b.report_code) "
		             + "JOIN tbl_prod c ON (a.product_no = c.product_no) order by a.report_date desc";

		ArrayList<ReportPost> reportList = new ArrayList<>();

		try {
			pstmt = conn.prepareStatement(query);
			rset = pstmt.executeQuery();

			while (rset.next()) {
				ReportPost r = new ReportPost();
				r.setReportNo(rset.getInt("report_no"));
				r.setReportReason(rset.getString("report_reason"));
				r.setReportedMemberNo(rset.getString("reported_member_no"));
				r.setProductNo(rset.getString("product_no"));
				r.setReportDate(rset.getString("report_date"));
				r.setProductMemberNo(rset.getString("product_member_no"));
				r.setReportDetail(rset.getString("report_detail"));

				reportList.add(r);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}

		return reportList;
	}


	//회원 한 명 조회
	public Member searchOneMember(Connection conn, String memberNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String qeury = "select member_no, member_id, member_nickname, member_name, to_char(member_birth, 'yyyy-mm-dd') as member_birth, member_phone, member_addr, member_email, to_char(join_date, 'yyyy-mm-dd') as join_date from tbl_member where member_no = ?";

		Member member = null;

		try {
			pstmt = conn.prepareStatement(qeury);

			pstmt.setString(1, memberNo);

			rset = pstmt.executeQuery();

			if(rset.next()) {
				member = new Member();
				member.setMemberNo(rset.getString("member_no"));
				member.setMemberId(rset.getString("member_id"));
				member.setMemberNickname(rset.getString("member_nickname"));
				member.setMemberName(rset.getString("member_name"));
				member.setMemberBirth(rset.getString("member_birth"));
				member.setMemberPhone(rset.getString("member_phone"));
				member.setMemberAddr(rset.getString("member_addr"));
				member.setMemberEmail(rset.getString("member_email"));
				member.setJoin_date(rset.getString("join_date"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}

		return member;
	}

	//신고당한 횟수
	public int searchReportedCount(Connection conn, String memberNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String qeury = "select count(*) as reported_count from tbl_member a join tbl_prod b on (a.member_no = b.member_no) join tbl_report_post c on (b.product_no = c.product_no) where a.member_no = ?";

		int cnt = 0;

		try {
			pstmt = conn.prepareStatement(qeury);

			pstmt.setString(1, memberNo);

			rset = pstmt.executeQuery();

			if(rset.next()) {
				cnt = rset.getInt("reported_count");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}

		return cnt;
	}

	//블랙 리스트 조회
	public ArrayList<BlackList> selectBlackList(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String query = "select a.black_no as black_no, c.member_no as black_member_no, a.black_reason as black_reason, to_char(a.black_date, 'yyyy-mm-dd') as black_date from tbl_blacklist a join tbl_report_post b on (a.report_no = b.report_no) join tbl_prod c on (b.product_no = c.product_no) order by black_date desc";

		ArrayList<BlackList> blackList = new ArrayList<>();

		try {
			pstmt = conn.prepareStatement(query);

			rset = pstmt.executeQuery();

			while(rset.next()) {
				BlackList b = new BlackList();
				b.setBlackNo(rset.getInt("black_no"));
				b.setBlackMemberNo(rset.getString("black_member_no"));
				b.setBlackReason(rset.getString("black_reason"));
				b.setBlackDate(rset.getString("black_date"));

				blackList.add(b);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}

		return blackList;
	}

	//블랙 여부
	public int searchMemberBlack(Connection conn, String memberNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String query = "select count(*) as black_count from tbl_blacklist a join tbl_report_post b on (a.report_no = b.report_no) join tbl_prod c on (b.product_no = c.product_no) where member_no = ?";

		int blackCnt = 0;

		try {
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, memberNo);

			rset = pstmt.executeQuery();

			if(rset.next()) {
				blackCnt = rset.getInt("black_count");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}

		return blackCnt;
	}

	//블랙 회원 등록
	public int insertBlackList(Connection conn, int reportNo, String blackReason) {
		PreparedStatement pstmt = null;

		String query = "insert into tbl_blacklist values (seq_black.nextval, ?, ?, sysdate)";

		int result = 0;

		try {
			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, reportNo);
			pstmt.setString(2, blackReason);

			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}

		return result;
	}

	//오늘 가입한 회원 조회
	public int countTodayMember(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String query = "select count(*) as count from tbl_member where trunc(join_date) = trunc(sysdate)";

		int mCnt = 0;

		try {
			pstmt = conn.prepareStatement(query);

			rset = pstmt.executeQuery();

			if(rset.next()) {
				mCnt = rset.getInt("count");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		return mCnt;
	}

	//오늘 신고들어온 횟수
	public int countTodayReport(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String query = "select count(*) as count from tbl_report_post where trunc(report_date) = trunc(sysdate)";

		int rCnt = 0;

		try {
			pstmt = conn.prepareStatement(query);

			rset = pstmt.executeQuery();

			if(rset.next()) {
				rCnt = rset.getInt("count");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		return rCnt;
	}

	public int countTodayBlack(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String query = "select count(*) as count from tbl_blacklist where trunc(black_date) = trunc(sysdate)";

		int bCnt = 0;

		try {
			pstmt = conn.prepareStatement(query);

			rset = pstmt.executeQuery();

			if(rset.next()) {
				bCnt = rset.getInt("count");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		return bCnt;
	}

	public int insertReport(Connection conn, ReportPost report) {
		int result = 0;
		PreparedStatement pstmt = null;

		String query = "INSERT INTO TBL_REPORT_POST "
		             + "(REPORT_NO, REPORT_CODE, REPORTED_MEMBER_NO, PRODUCT_NO, REPORT_DETAIL, REPORT_DATE) "
		             + "VALUES (SEQ_REPORT.NEXTVAL, ?, ?, ?, ?, SYSDATE)";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, report.getReportCode());
			pstmt.setString(2, report.getReportedMemberNo());
			pstmt.setString(3, report.getProductNo());
			pstmt.setString(4, report.getReportDetail());

			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}

		return result;
	}

	// 특정 회원이 특정 상품을 신고한 적이 있는지 확인
	public boolean hasReported(Connection conn, String memberNo, String productNo) {
	    boolean result = false;
	    PreparedStatement pstmt = null;
	    ResultSet rset = null;

	    String query = "SELECT COUNT(*) FROM TBL_REPORT_POST WHERE REPORTED_MEMBER_NO = ? AND PRODUCT_NO = ?";

	    try {
	        pstmt = conn.prepareStatement(query);
	        pstmt.setString(1, memberNo);
	        pstmt.setString(2, productNo);
	        rset = pstmt.executeQuery();

	        if (rset.next() && rset.getInt(1) > 0) {
	            result = true;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        JDBCTemplate.close(rset);
	        JDBCTemplate.close(pstmt);
	    }

	    return result;
	}

}
