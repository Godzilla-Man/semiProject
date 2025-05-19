package kr.or.iei.reviewNotice.model.vo;

import java.util.ArrayList;

import kr.or.iei.category.model.vo.Category;
import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.file.model.vo.Files;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data

public class ReviewNotice {
	private String stylePostNo;
	private String postTitle;
	private String postContent;
	private String orderNo;
	private String postDate;
	private int readCount;

	// 첨부파일 리스트 추가
	private ArrayList<Files> fileList;
	
	// 카테고리 리스트 추가
	private ArrayList<Category> categoryList;
	
	// 댓글기능 리스트 추가
	private ArrayList<Comment> commentList;
}