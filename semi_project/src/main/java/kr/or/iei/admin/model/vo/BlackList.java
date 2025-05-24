package kr.or.iei.admin.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class BlackList {

	private int blackNo;			//블랙 번호
	private int reportNo;			//신고 번호
	private String blackReason;		//블랙 사유
	private String blackDate;		//블랙 일시

	private String blackMemberNo;	//블랙 회원 번호
}