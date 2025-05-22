package kr.or.iei.notice.model.vo;

import java.util.List;

import kr.or.iei.file.model.vo.Files;
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
	
	private List<Files> fileList;
}
