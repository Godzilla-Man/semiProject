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

	public ArrayList<Member> selectAllMember(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select * from tbl_member";
		
		ArrayList<Member> memberList = new ArrayList<Member>();
		
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

	public ArrayList<ReportPost> selectReportPost(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select report_no, b.report_reason as report_reason, reported_member_no, a.product_no as product_no, c.member_no as product_member_no, report_date from tbl_report_post a join tbl_report b on (a.report_code = b.report_code) join tbl_prod c on (a.product_no = c.product_no)";
		
		ArrayList<ReportPost> reportList = new ArrayList<ReportPost>();
		
		try {
			pstmt = conn.prepareStatement(query);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				ReportPost r = new ReportPost();
				r.setReportNo(rset.getInt("report_no"));
				r.setReportReason(rset.getString("report_reason"));
				r.setReportedMemberNo(rset.getString("reported_member_no"));
				r.setProductNo(rset.getString("product_no"));
				r.setReportDate(rset.getString("report_date"));
				r.setProductMemberNo(rset.getString("product_member_no"));
				
				reportList.add(r);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return reportList;
	}

	public Member searchOneMember(Connection conn, String memberNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String qeury = "select * from tbl_member where member_no = ?";
		
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

	public ArrayList<BlackList> selectBlackList(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select a.black_no as black_no, c.member_no as black_member_no, a.black_reason as black_reason, a.black_date as black_date from tbl_blacklist a join tbl_report_post b on (a.report_no = b.report_no) join tbl_prod c on (b.product_no = c.product_no)";
		
		ArrayList<BlackList> blackList = new ArrayList<BlackList>();
		
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

}
