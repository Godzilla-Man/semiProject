package kr.or.iei.member.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Member {

	private String memberNo;		//회원 번호
	private String memberId;		//회원 아이디
	private String memberPw;		//회원 비밀번호
	private String memberNickname;	//회원 닉네임
	private String memberName;		//회원 이름
	private String memberBirth;		//회원 생년월일
	private String memberPhone;		//회원 전화번호
	private String memberAddr;		//회원 주소
	private String memberEmail;		//회원 이메일
	private String join_date;		//가입일
	private String member_rate;		//회원 평점
	
	private String wishProductNo;	//찜한 상품 번호
	private int reportedCount;	//신고당한 횟수
	private int blackCount;		//블랙 여부 확인
	private String profileImgPath;	//프로필사진
}
