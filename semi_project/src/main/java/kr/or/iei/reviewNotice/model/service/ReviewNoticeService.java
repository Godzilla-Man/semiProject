package kr.or.iei.reviewNotice.model.service;

import java.sql.Connection;
import java.util.ArrayList;

import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.reviewNotice.model.dao.ReviewNoticeDao;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;

public class ReviewNoticeService {

    private ReviewNoticeDao dao = new ReviewNoticeDao();


    public ReviewNotice selectOneReview(String stylePostNo, boolean updChk) {
        Connection conn = JDBCTemplate.getConnection();
        ReviewNotice reviewnotice = dao.selectOneReviewNotice(conn, stylePostNo);
        JDBCTemplate.close(conn);
        return reviewnotice;
    }

    public int insertReviewPost(ReviewNotice rn, ArrayList<Files> fileList, String gender, String middle, String small, String commentFlag) {
        Connection conn = JDBCTemplate.getConnection();

        int result = dao.insertReview(conn, rn, gender, middle, small, commentFlag);
        if (result > 0 && fileList != null) {
            for (Files file : fileList) {
                result += dao.insertFile(conn, file);
            }
        }

        if (result > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }

        JDBCTemplate.close(conn);
        return result;
    }

	public ReviewNotice selectReviewDetail(String stylePostNo) {
		Connection conn = JDBCTemplate.getConnection();

        // 게시글 조회
        ReviewNotice review = dao.selectReviewDetail(conn, stylePostNo);

        if (review != null) {
            // 첨부 이미지 목록
            ArrayList<Files> fileList = dao.selectFileList(conn, stylePostNo);
            review.setFileList(fileList);

            // 댓글 목록
            ArrayList<Comment> commentList = dao.selectCommentList(conn, stylePostNo);
            review.setCommentList(commentList);
        }

        JDBCTemplate.close(conn);
        return review;
    }

	public ArrayList<ReviewNotice> selectAllReview() {
		Connection conn = JDBCTemplate.getConnection();
        ArrayList<ReviewNotice> reviewList = dao.selectAllReview(conn);
        JDBCTemplate.close(conn);
        return reviewList;
    }
}
