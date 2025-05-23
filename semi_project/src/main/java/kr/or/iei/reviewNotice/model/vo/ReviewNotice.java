package kr.or.iei.reviewNotice.model.vo;

import java.sql.Date; // java.sql.Date 임포트: DB의 DATE 타입과 매핑
import java.util.ArrayList;

import kr.or.iei.category.model.vo.Category;
import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.member.model.vo.Member;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class ReviewNotice {
	// 게시글 기본 정보 (TBL_STYLE_POST 테이블의 컬럼과 동일)
	private String stylePostNo; // 게시글 번호 (PK)
	private String postTitle; // 게시글 제목
	private String postContent; // 게시글 내용
	private String orderNo; // 관련 주문 번호 (FK: TBL_PURCHASE)
	private String postDate; // 게시글 작성일 (java.sql.Date로 변경)
	private int readCount; // 조회수

    
    private String memberNickname; // 게시글 작성자의 닉네임 (TBL_MEMBER에서 가져올 정보)
    private String memberNo;
    
    private String categoryCode;
    private String categoryName;
    
	private ArrayList<Files> fileList; // 게시글에 첨부된 파일 목록
	
	private ArrayList<Comment> commentList; // 게시글에 달린 댓글 목록
	
	private ArrayList<Category> categoryList;
	
	private ArrayList<Member> memberList;
	
	private String filePath;
}