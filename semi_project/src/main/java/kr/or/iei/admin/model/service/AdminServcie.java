package kr.or.iei.admin.model.service;

import java.sql.Connection;
import java.util.ArrayList;

import kr.or.iei.admin.model.dao.AdminDao;
import kr.or.iei.admin.model.vo.BlackList;
import kr.or.iei.admin.model.vo.ReportPost;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.member.model.vo.Member;

public class AdminServcie {
	
	private AdminDao dao;
	
	public AdminServcie() {
		dao = new AdminDao();
	}

	public ArrayList<Member> selectAllMember() {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Member> memberList = dao.selectAllMember(conn);
		JDBCTemplate.close(conn);
		
		return memberList;
	}

	public ArrayList<ReportPost> selectReportPost() {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<ReportPost> reportList = dao.selectReportPost(conn);
		JDBCTemplate.close(conn);
		
		return reportList;
	}

	public Member searchOneMember(String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		
		//회원 정보 가져오기
		Member member = dao.searchOneMember(conn, memberNo);
		
		//회원의 신고당한 횟수 가져오기
		int cnt = dao.searchReportedCount(conn, memberNo);
		
		//회원이 블랙 리스트에 있는지 확인
		int blackCnt = dao.searchMemberBlack(conn, memberNo);
		
		//회원 정보에 신고당한 횟수, 블랙 여부 set
		member.setReportedCount(cnt);
		member.setBlackCount(blackCnt);
		
		JDBCTemplate.close(conn);
		
		return member;
	}

	public ArrayList<BlackList> selectBlackList() {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<BlackList> blackList = dao.selectBlackList(conn);
		JDBCTemplate.close(conn);
		
		return blackList;
	}

	public int searchBlackList(String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		int blackCnt = dao.searchMemberBlack(conn, memberNo);
		JDBCTemplate.close(conn);
		
		return blackCnt;
	}

	public int insertBlackList(int reportNo, String blackReason) {
		Connection conn = JDBCTemplate.getConnection();
		int result = dao.insertBlackList(conn, reportNo, blackReason);
		if(result > 0) {
			JDBCTemplate.commit(conn);
		}else {
			JDBCTemplate.rollback(conn);
		}
		JDBCTemplate.close(conn);
		
		return result;
	}

	public int countTodayMember() {
		Connection conn = JDBCTemplate.getConnection();
		int mCnt = dao.countTodayMember(conn);
		JDBCTemplate.close(conn);
		
		return mCnt;
	}

	public int countTodayReport() {
		Connection conn = JDBCTemplate.getConnection();
		int rCnt = dao.countTodayReport(conn);
		JDBCTemplate.close(conn);
		
		return rCnt;
	}

	public int countTodayBlack() {
		Connection conn = JDBCTemplate.getConnection();
		int bCnt = dao.countTodayBlack(conn);
		JDBCTemplate.close(conn);
		
		return bCnt;
	}
}
