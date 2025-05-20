package kr.or.iei.comment.model.vo;

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
 * 댓글(Comment) VO 클래스
 * 상품 상세페이지 및 스타일 후기 게시글의 댓글 데이터를 표현하는 객체
 */

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Comment {

    private int commentNo;             // 댓글 번호 (기본키)
    private String memberNo;           // 작성자 회원 번호
    private String productNo;          // 상품 번호
    private String stylePostNo;        // 스타일 후기 게시글 번호 (선택사항)
    private String content;            // 댓글 내용
    private Date createdDate;          // 작성일자
    private String memberNickname;     // 작성자 닉네임 (조인 결과)
    private Integer parentCommentNo;   // 부모 댓글 번호 (null이면 일반 댓글, 값이 있으면 대댓글)
}