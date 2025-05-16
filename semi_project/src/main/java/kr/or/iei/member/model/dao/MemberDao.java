package kr.or.iei.member.model.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.member.model.vo.Member;

public class MemberDao {

	//회원가입
	public int memberJoin(Connection conn, Member member) {
		PreparedStatement pstmt = null;
		
		int result = 0;
		
		String query = "insert into tbl_member values (to_char(sysdate, 'yymmdd') || lpad(seq_member.nextval, 4, '0'), ?, ?, ?, ?, ?, ?, ?, ?, sysdate, default)";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, member.getMemberId());
			pstmt.setString(2, member.getMemberPw());
			pstmt.setString(3, member.getMemberNickname());
			pstmt.setString(4, member.getMemberName());
			pstmt.setString(5, member.getMemberBirth());
			pstmt.setString(6, member.getMemberPhone());
			pstmt.setString(7, member.getMemberAddr());
			pstmt.setString(8, member.getMemberEmail());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}

	//로그인
	public Member memberLogin(Connection conn, String loginId, String loginPw) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		Member loginMember = null;
		
		String query = "select * from tbl_member where member_id = ? and member_pw = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, loginId);
			pstmt.setString(2, loginPw);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				loginMember = new Member();
				
				loginMember.setMemberId(loginId);
				loginMember.setMemberPw(loginPw);
				loginMember.setMemberNo(rset.getString("member_no"));
				loginMember.setMemberNickname(rset.getString("member_nickname"));
				loginMember.setMemberName(rset.getString("member_name"));
				loginMember.setMemberBirth(rset.getString("member_birth"));
				loginMember.setMemberPhone(rset.getString("member_phone"));
				loginMember.setMemberAddr(rset.getString("member_addr"));
				loginMember.setMemberEmail(rset.getString("member_email"));
				loginMember.setJoin_date(rset.getString("join_date"));
				loginMember.setMember_rate(rset.getString("member_rate"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return loginMember;
	}
}
