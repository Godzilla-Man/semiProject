package kr.or.iei.event.model.vo;

import java.util.List;

import kr.or.iei.file.model.vo.Files;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class Event {

	private String eventNo;
	private String memberNo;
	private String eventTitle;
	private String eventContent;
	private String eventEnrollDate;
	private int readCount;

	private List<Files> fileList;
}
