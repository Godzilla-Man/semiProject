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
	
	public Notice() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Notice(String noticeNo, String memberNo, String noticeTitle, String noticeContent, String noticeEnrollDate,
			int readCount) {
		super();
		this.noticeNo = noticeNo;
		this.memberNo = memberNo;
		this.noticeTitle = noticeTitle;
		this.noticeContent = noticeContent;
		this.noticeEnrollDate = noticeEnrollDate;
		this.readCount = readCount;
	}

	public String getNoticeNo() {
		return noticeNo;
	}
	public void setNoticeNo(String noticeNo) {
		this.noticeNo = noticeNo;
	}
	public String getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(String memberNo) {
		this.memberNo = memberNo;
	}
	public String getNoticeTitle() {
		return noticeTitle;
	}
	public void setNoticeTitle(String noticeTitle) {
		this.noticeTitle = noticeTitle;
	}
	public String getNoticeContent() {
		return noticeContent;
	}
	public void setNoticeContent(String noticeContent) {
		this.noticeContent = noticeContent;
	}
	public String getNoticeEnrollDate() {
		return noticeEnrollDate;
	}
	public void setNoticeEnrollDate(String noticeEnrollDate) {
		this.noticeEnrollDate = noticeEnrollDate;
	}
	public int getReadCount() {
		return readCount;
	}
	public void setReadCount(int readCount) {
		this.readCount = readCount;
	}

	@Override
	public String toString() {
		return "Notice [noticeNo=" + noticeNo + ", memberNo=" + memberNo + ", noticeTitle=" + noticeTitle
				+ ", noticeContent=" + noticeContent + ", noticeEnrollDate=" + noticeEnrollDate + ", readCount="
				+ readCount + "]";
	}
	
}