package kr.or.iei.member.model.service;

import java.sql.Connection;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.member.model.dao.MemberDao;
import kr.or.iei.member.model.vo.Member;

public class MemberService {

	private MemberDao dao;
	
	public MemberService() {
		dao = new MemberDao();
	}
	
	//회원가입
	public int memberJoin(Member member) {
		Connection conn = JDBCTemplate.getConnection();
		int result = dao.memberJoin(conn, member);
		
		if(result > 0) {
			JDBCTemplate.commit(conn);
		} else {
			JDBCTemplate.rollback(conn);
		}
		
		JDBCTemplate.close(conn);
		
		return result;
	}
	
	//ID 중복체크
	public int idDuplChk(String memberId) {
		Connection conn = JDBCTemplate.getConnection();
		int cnt = dao.idDuplChk(conn, memberId);
		JDBCTemplate.close(conn);
		return cnt;
	}
	
	//닉네임 중복체크
	public int nicknameDuplChk(String memberNickname) {
		Connection conn = JDBCTemplate.getConnection();
		int cnt = dao.nicknameDuplChk(conn, memberNickname);
		JDBCTemplate.close(conn);
		return cnt;
	}

	//로그인
	public Member memberLogin(String loginId, String loginPw) {
		Connection conn = JDBCTemplate.getConnection();
		Member loginMember = dao.memberLogin(conn, loginId, loginPw);
		JDBCTemplate.close(conn);
		
		return loginMember;
	}
}
