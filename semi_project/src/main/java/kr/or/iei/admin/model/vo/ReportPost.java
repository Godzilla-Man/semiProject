package kr.or.iei.admin.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class ReportPost {

	private int reportNo;
	private String reportCode;
	private String reportedMemberNo;
	private String productNo;
	private String reportDate;
	
	private String reportReason;
	private String productMemberNo;
}
