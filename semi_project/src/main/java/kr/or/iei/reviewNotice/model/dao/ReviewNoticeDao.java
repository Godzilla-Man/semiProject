/* DAO - ReviewNoticeDao.java */
package kr.or.iei.reviewNotice.model.dao;

import java.sql.*;
import java.util.*;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;
import kr.or.iei.category.model.vo.Category;
import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.vo.Files;

public class ReviewNoticeDao {


    public ReviewNotice selectOneReviewNotice(Connection conn, String stylePostNo) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        ReviewNotice rn = null;

        String query = "SELECT * FROM TBL_STYLE_POST WHERE STYLE_POST_NO = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, stylePostNo);
            rset = pstmt.executeQuery();

            if (rset.next()) {
                rn = new ReviewNotice();
                rn.setStylePostNo(rset.getString("style_post_no"));
                rn.setPostTitle(rset.getString("post_title"));
                rn.setPostContent(rset.getString("post_content"));
                rn.setOrderNo(rset.getString("order_no"));
                rn.setPostDate(rset.getString("post_date"));
                rn.setReadCount(rset.getInt("read_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return rn;
    }

    public int insertReview(Connection conn, ReviewNotice rn, String gender, String middle, String small, String commentFlag) {
        int result = 0;
        PreparedStatement pstmt = null;
        String query = "INSERT INTO TBL_STYLE_POST VALUES(SEQ_REVIEW_NO.NEXTVAL, ?, ?, DEFAULT, ?, DEFAULT, ?, ?, ?, ?)";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, rn.getPostTitle());
            pstmt.setString(2, rn.getPostContent());
            pstmt.setString(3, rn.getOrderNo());
            pstmt.setString(4, gender);
            pstmt.setString(5, middle);
            pstmt.setString(6, small);
            pstmt.setString(7, commentFlag);

            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }
        return result;
    }

    public int insertFile(Connection conn, Files file) {
        int result = 0;
        PreparedStatement pstmt = null;
        String query = "INSERT INTO TBL_FILE (FILE_NO, FILE_NAME, FILE_PATH, STYLE_POST_NO) VALUES (SEQ_FILE_NO.NEXTVAL, ?, ?, SEQ_REVIEW_NO.CURRVAL)";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, file.getFileName());
            pstmt.setString(2, file.getFilePath());
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }
        return result;
    }

	public ReviewNotice selectReviewDetail(Connection conn, String stylePostNo) {
		ReviewNotice review = null;
        String query = "SELECT * FROM TBL_STYLE_POST WHERE STYLE_POST_NO = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, stylePostNo);
            ResultSet rset = pstmt.executeQuery();

            if (rset.next()) {
                review = new ReviewNotice();
                review.setStylePostNo(rset.getString("STYLE_POST_NO"));
                review.setPostTitle(rset.getString("POST_TITLE"));
                review.setPostContent(rset.getString("POST_CONTENT"));
                review.setPostDate(rset.getString("POST_DATE"));
                review.setReadCount(rset.getInt("READ_COUNT"));
                review.setOrderNo(rset.getString("ORDER_NO"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return review;
    }

	public ArrayList<Files> selectFileList(Connection conn, String stylePostNo) {
		ArrayList<Files> fileList = new ArrayList<>();
        String query = "SELECT * FROM TBL_FILE WHERE STYLE_POST_NO = ? ORDER BY FILE_NO ASC";

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, stylePostNo);
            ResultSet rset = pstmt.executeQuery();

            while (rset.next()) {
                Files file = new Files();
                file.setFileNo(rset.getInt("FILE_NO"));
                file.setProductNo(rset.getString("PRODUCT_NO"));
                file.setFileName(rset.getString("FILE_NAME"));
                file.setFilePath(rset.getString("FILE_PATH"));
                file.setStylePostNo(rset.getString("STYLE_POST_NO"));
                fileList.add(file);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fileList;
    }

	public ArrayList<Comment> selectCommentList(Connection conn, String stylePostNo) {
		ArrayList<Comment> commentList = new ArrayList<>();
        String query = "SELECT * FROM TBL_COMMENT WHERE STYLE_POST_NO = ? ORDER BY CREATE_DATE ASC";

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, stylePostNo);
            ResultSet rset = pstmt.executeQuery();

            while (rset.next()) {
                Comment comment = new Comment();
                comment.setCommentNo(rset.getInt("COMMENT_NO"));
                comment.setMemberNo(rset.getString("MEMBER_NO"));
                comment.setProductNo(rset.getString("PRODUCT_NO"));
                comment.setStylePostNo(rset.getString("STYLE_POST_NO"));
                comment.setContent(rset.getString("CONTENT"));
                comment.setCreatedDate(rset.getDate("CREATED_DATE"));
                commentList.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return commentList;
    }

	public ArrayList<ReviewNotice> selectAllReview(Connection conn) {
		ArrayList<ReviewNotice> list = new ArrayList<>();
        String query = "SELECT STYLE_POST_NO, POST_TITLE, POST_CONTENT, ORDER_NO, POST_DATE, READ_COUNT "
                     + "FROM TBL_STYLE_POST "
                     + "ORDER BY POST_DATE DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rset = pstmt.executeQuery()) {

            while (rset.next()) {
                ReviewNotice review = new ReviewNotice();
                review.setStylePostNo(rset.getString("STYLE_POST_NO"));
                review.setPostTitle(rset.getString("POST_TITLE"));
                review.setPostContent(rset.getString("POST_CONTENT"));
                review.setOrderNo(rset.getString("ORDER_NO"));
                review.setPostDate(rset.getString("POST_DATE"));
                review.setReadCount(rset.getInt("READ_COUNT"));

                list.add(review);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
}
