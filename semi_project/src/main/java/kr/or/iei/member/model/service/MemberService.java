package kr.or.iei.member.model.service;

import java.sql.Connection;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.member.model.Dao.MemberDao;
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

	//로그인
	public Member memberLogin(String loginId, String loginPw) {
		Connection conn = JDBCTemplate.getConnection();
		Member loginMember = dao.memberLogin(conn, loginId, loginPw);
		JDBCTemplate.close(conn);
		
		return loginMember;
	}
}
