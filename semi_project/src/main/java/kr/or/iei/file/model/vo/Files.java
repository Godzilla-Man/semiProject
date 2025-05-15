package kr.or.iei.file.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class Files {

	private int fileNo;
	private String productNo;
	private String stylePostNo;
	private String noticeNo;
	private String eventNo;
	private String fileName;
	private String filePath;
	private String uploadDate;
}
