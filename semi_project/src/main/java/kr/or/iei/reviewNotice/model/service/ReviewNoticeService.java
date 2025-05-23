package kr.or.iei.reviewNotice.model.service;

import static kr.or.iei.common.JDBCTemplate.*;

import java.sql.Connection;
import java.sql.JDBCType;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date; 

import kr.or.iei.file.model.vo.Files;
import kr.or.iei.reviewNotice.model.dao.ReviewNoticeDao;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;
import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.common.JDBCTemplate;

public class ReviewNoticeService {
    private ReviewNoticeDao reviewNoticeDao = new ReviewNoticeDao();

    public ArrayList<ReviewNotice> selectAllReview(String categoryCode) {
        Connection conn = getConnection();
        ArrayList<ReviewNotice> reviewList = null;
        try {
            if (categoryCode != null && (categoryCode.equalsIgnoreCase("all") || categoryCode.isEmpty())) {
                categoryCode = null;
            }
            reviewList = reviewNoticeDao.selectAllReview(conn, categoryCode);
        } catch (SQLException e) {
            e.printStackTrace(); 
        } finally {
            close(conn);
        }
        return reviewList; 
    }

    public ReviewNotice selectReviewDetail(String stylePostNo) {
        Connection conn = getConnection();
        ReviewNotice review = null;
        try {
            int result = reviewNoticeDao.increaseReadCount(conn, stylePostNo);
            if (result > 0) {
                commit(conn); 
            }
            review = reviewNoticeDao.selectReviewNoticeDetail(conn, stylePostNo); 
            if (review != null) {
                review.setFileList(reviewNoticeDao.selectFileList(conn, stylePostNo));
                review.setCommentList(reviewNoticeDao.selectCommentList(conn, stylePostNo));
            } else {
                 if (result > 0) { 
                    rollback(conn); 
                }
            }
        } catch (SQLException e) { 
            rollback(conn); 
            e.printStackTrace();
        } finally {
            close(conn);
        }
        return review;
    }

    public int insertComment(Comment comment) {
        Connection conn = getConnection();
        int result = 0;
        try {
            result = reviewNoticeDao.insertComment(conn, comment);
            if (result > 0) {
                commit(conn);
            } else {
                rollback(conn);
            }
        } catch (SQLException e) {
            rollback(conn);
            e.printStackTrace();
        } finally {
            close(conn);
        }
        return result;
    }

    public int updateComment(int commentNo, String content, String memberNoInSession) {
        Connection conn = getConnection();
        int result = 0;
        try {
            Comment originalComment = reviewNoticeDao.selectOneComment(conn, commentNo);
            if (originalComment != null && originalComment.getMemberNo().equals(memberNoInSession)) {
                result = reviewNoticeDao.updateComment(conn, commentNo, content);
                if (result > 0) {
                    commit(conn);
                } else {
                    rollback(conn);
                }
            } else {
                result = -1; 
            }
        } catch (SQLException e) {
            rollback(conn);
            e.printStackTrace();
        } finally {
            close(conn);
        }
        return result;
    }

    public int deleteComment(int commentNo, String memberNoInSession) {
        Connection conn = getConnection();
        int result = 0;
        try {
            Comment originalComment = reviewNoticeDao.selectOneComment(conn, commentNo);
             if (originalComment != null && originalComment.getMemberNo().equals(memberNoInSession)) {
                result = reviewNoticeDao.deleteComment(conn, commentNo);
                if (result > 0) {
                    commit(conn);
                } else {
                    rollback(conn);
                }
            } else {
                result = -1; 
            }
        } catch (SQLException e) {
            rollback(conn);
            e.printStackTrace();
        } finally {
            close(conn);
        }
        return result;
    }

    public int insertReviewNotice(ReviewNotice reviewNotice, ArrayList<Files> fileInfoList) {
        Connection conn = getConnection();
        int result = 0; 
        String generatedStylePostNo = null;
        try {
            int sequenceNumber = reviewNoticeDao.getNextStyleSequence(conn);
            if (sequenceNumber == 0) { 
                rollback(conn);
                return 0;
            }
            SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
            String currentDate = sdf.format(new Date()); 
            generatedStylePostNo = "S" + currentDate + String.format("%04d", sequenceNumber);
            reviewNotice.setStylePostNo(generatedStylePostNo); 

            int postInsertResult = reviewNoticeDao.insertReviewNotice(conn, reviewNotice);
            if (postInsertResult > 0) { 
                if (fileInfoList != null && !fileInfoList.isEmpty()) {
                    boolean allFilesSaved = true;
                    for (Files fileVo : fileInfoList) { 
                        int nextFileNo = reviewNoticeDao.getNextFileNo(conn);
                        if (nextFileNo == 0 && fileInfoList.indexOf(fileVo) == 0) { 
                            allFilesSaved = false; 
                            break;
                        }
                        fileVo.setFileNo(nextFileNo); 
                        fileVo.setStylePostNo(generatedStylePostNo); 
                        int fileInsertResult = reviewNoticeDao.insertFile(conn, fileVo);
                        if (fileInsertResult == 0) {
                            allFilesSaved = false; 
                            break; 
                        }
                    }
                    result = allFilesSaved ? 1 : 0; 
                } else {
                    result = 1; 
                }
            } else {
                result = 0; 
            }

            if (result == 1) {
                commit(conn);
            } else {
                rollback(conn); 
            }
        } catch (SQLException e) { 
            rollback(conn); 
            e.printStackTrace(); 
            result = 0; 
        } finally {
            close(conn);
        }
        return result; 
    }
    
    public ArrayList<ReviewNotice> selectAllReviewList() {
    	Connection conn = JDBCTemplate.getConnection();
    	ArrayList<ReviewNotice> reviewList = reviewNoticeDao.selectAllReviewList(conn);
    	JDBCTemplate.close(conn);
    	return reviewList;
    }
}