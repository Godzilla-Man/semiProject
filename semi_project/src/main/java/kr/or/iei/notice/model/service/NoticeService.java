package kr.or.iei.notice.model.service;

import java.sql.Connection;
import java.util.ArrayList;

import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.notice.model.dao.NoticeDao;
import kr.or.iei.notice.model.vo.Notice;

public class NoticeService {

	NoticeDao dao;
	
	public ArrayList<Notice> selectAllList() {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Notice> noticeList = dao.selectAllList(conn);
		JDBCTemplate.close(conn);
		
		return noticeList;
	}

}
