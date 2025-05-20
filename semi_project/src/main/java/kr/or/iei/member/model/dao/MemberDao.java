package kr.or.iei.member.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

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
			
			System.out.println(member.toString());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}
	
	//ID 중복체크
	public int idDuplChk(Connection conn, String memberId) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		int cnt = 0;
		
		String query = "select count(*) cnt from tbl_member where member_id = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, memberId);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				cnt = rset.getInt("cnt");
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
	
	//닉네임 중복체크
	public int nicknameDuplChk(Connection conn, String memberNickname) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		int cnt = 0;
		
		String query = "select count(*) cnt from tbl_member where member_nickname = ?";
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, memberNickname);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				cnt = rset.getInt("cnt");
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
}
