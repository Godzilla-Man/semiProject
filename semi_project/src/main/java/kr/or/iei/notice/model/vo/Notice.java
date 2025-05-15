package kr.or.iei.notice.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class Notice {

	private String noticeNo;
	private String memberNo;
	private String noticeTitle;
	private String noticeContent;
	private String noticeEnrollDate;
	private int readCount;
}
