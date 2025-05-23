package kr.or.iei.reviewNotice.model.service;

import static kr.or.iei.common.JDBCTemplate.*;

import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date; 

import kr.or.iei.file.model.vo.Files;
import kr.or.iei.reviewNotice.model.dao.ReviewNoticeDao;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;
import kr.or.iei.category.model.vo.Category;
import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.common.JDBCTemplate;

public class ReviewNoticeService {
    private ReviewNoticeDao reviewNoticeDao = new ReviewNoticeDao();

    public ArrayList<ReviewNotice> selectAllReview(String categoryCode) {
        Connection conn = JDBCTemplate.getConnection();
        ArrayList<ReviewNotice> reviewList = null;
        try {
            if (categoryCode != null && (categoryCode.equalsIgnoreCase("all") || categoryCode.isEmpty())) {
                categoryCode = null;
            }
            reviewList = reviewNoticeDao.selectAllReview(conn, categoryCode);
        } catch (SQLException e) {
            e.printStackTrace(); 
        } finally {
            JDBCTemplate.close(conn);
        }
        return reviewList; 
    }

    public ReviewNotice selectReviewDetail(String stylePostNo) {
        Connection conn = JDBCTemplate.getConnection();
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
            JDBCTemplate.close(conn);
        }
        return review;
    }

    public int insertComment(Comment comment) {
        Connection conn = JDBCTemplate.getConnection();
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
            JDBCTemplate.close(conn);
        }
        return result;
    }

    public int updateComment(int commentNo, String content, String memberNoInSession) {
        Connection conn = JDBCTemplate.getConnection();
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
            JDBCTemplate.close(conn);
        }
        return result;
    }

    public int deleteComment(int commentNo, String memberNoInSession) {
        Connection conn = JDBCTemplate.getConnection();
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
            JDBCTemplate.close(conn);
        }
        return result;
    }

    public int insertReviewNotice(ReviewNotice reviewNotice, ArrayList<Files> fileInfoList) {
        Connection conn = JDBCTemplate.getConnection();
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
                JDBCTemplate.commit(conn);
            } else {
                JDBCTemplate.rollback(conn); 
            }
        } catch (SQLException e) { 
            JDBCTemplate.rollback(conn); 
            e.printStackTrace(); 
            result = 0; 
        } finally {
            JDBCTemplate.close(conn);
        }
        return result; 
    }
    /**
     * 게시글 삭제 처리 서비스
     */
    public int deletePost(String stylePostNo, String loginMemberNo, String serverFileSavePath) {
        Connection conn = JDBCTemplate.getConnection();
        int result = 0;
        try {
            String actualAuthorMemberNo = reviewNoticeDao.getAuthorMemberNoByPostNo(conn, stylePostNo);
            if (actualAuthorMemberNo == null) {
                JDBCTemplate.close(conn);
                return 0; // 게시글 또는 주문 정보 없음 (실패)
            }
            if (!actualAuthorMemberNo.equals(loginMemberNo)) {
                JDBCTemplate.close(conn);
                return -1; // 권한 없음
            }

            ArrayList<Files> filesToDelete = reviewNoticeDao.getFilesForPost(conn, stylePostNo);
            result = reviewNoticeDao.deletePost(conn, stylePostNo); // DB에서 게시글 삭제

            if (result > 0) { // DB 게시글 삭제 성공 시
                JDBCTemplate.commit(conn);
                // 서버에 저장된 물리적 파일 삭제
                if (filesToDelete != null) {
                    for (Files fileInfo : filesToDelete) {
                        File physicalFile = new File(serverFileSavePath + File.separator + fileInfo.getFilePath()); // 서버저장명
                        if (physicalFile.exists()) {
                            if(!physicalFile.delete()){
                                System.err.println("Service: deletePost - 물리적 파일 삭제 실패: " + physicalFile.getAbsolutePath());
                            }
                        }
                    }
                }
            } else { // DB 게시글 삭제 실패
                JDBCTemplate.rollback(conn);
            }
        } catch (Exception e) {
            System.err.println("Service: deletePost 오류 발생 - " + e.getMessage());
            JDBCTemplate.rollback(conn);
            result = 0;
        } finally {
            JDBCTemplate.close(conn);
        }
        return result;
    }

    /**
     * 게시글 수정을 위한 기존 게시글 정보 조회 서비스 (상세보기 시에도 활용 가능)
     * @param stylePostNo 수정/조회할 게시글 번호
     * @param loginMemberNo 현재 로그인한 사용자의 회원 번호 (수정 시 권한 확인용, 조회시는 null 또는 무시 가능)
     * @return ReviewNotice 객체 (첨부파일 목록 포함), 없거나 권한(수정시) 없으면 null 반환
     */
    public ReviewNotice getPostForDetailOrEdit(String stylePostNo, String loginMemberNo) { // 메소드 명 변경 고려
        Connection conn = JDBCTemplate.getConnection();
        // DAO는 게시글정보(postDate는 String으로 변환됨)와 파일리스트를 가져옴
        ReviewNotice review = reviewNoticeDao.getReviewNoticeDetailForEditForm(conn, stylePostNo);

        if (review != null) { // 게시글 정보가 존재하면
            // 실제 작성자(주문자)의 memberNo를 조회
            String actualAuthorMemberNo = reviewNoticeDao.getAuthorMemberNoByPostNo(conn, stylePostNo);
            if (actualAuthorMemberNo != null) {
                 review.setMemberNo(actualAuthorMemberNo); // VO에 실제 작성자 memberNo 설정 (화면 표시 및 수정 권한 비교용)
            } else {
                // 주문 정보가 없거나 stylePostNo에 해당하는 주문자를 찾을 수 없는 경우 (데이터 정합성 문제 가능성)
                // 이 경우 수정/삭제 권한 판단이 불가하므로 review 객체를 null로 처리하거나, memberNo를 비워둘 수 있음
                // 여기서는 review 객체는 유지하되, memberNo가 없는 상태로 반환 (JSP에서 memberNo null 체크 필요)
                System.err.println("Service: getPostForDetailOrEdit - stylePostNo ["+stylePostNo+"]에 대한 주문자 정보를 찾을 수 없음.");
            }

            // 만약 loginMemberNo가 제공되었고 (즉, 수정폼을 위한 호출이고),
            // 조회된 실제 작성자와 로그인 사용자가 다르면 null 반환 (수정 권한 없음)
            if (loginMemberNo != null && (actualAuthorMemberNo == null || !actualAuthorMemberNo.equals(loginMemberNo))) {
                JDBCTemplate.close(conn);
                return null; // 수정 권한 없음
            }
        }
        // review가 처음부터 null이었거나 (게시글 없음), 위에서 권한 문제로 null이 된 경우 그대로 반환
        JDBCTemplate.close(conn);
        return review;
    }


    /**
     * 게시글 정보 수정 처리 서비스 (텍스트 정보 및 파일 변경 포함)
     */
    public int updatePost(ReviewNotice reviewData, ArrayList<Files> newFilesList, ArrayList<Integer> fileNosToDelete, String serverFileSavePath) {
        Connection conn = JDBCTemplate.getConnection();
        int result = 0;
        try {
            // reviewData.getMemberNo()는 현재 로그인한 사용자의 memberNo
            String actualAuthorMemberNo = reviewNoticeDao.getAuthorMemberNoByPostNo(conn, reviewData.getStylePostNo());
            if (actualAuthorMemberNo == null) { // 게시글 또는 연결된 주문 정보 없음
                JDBCTemplate.close(conn);
                return 0; // 실패
            }
            if (!actualAuthorMemberNo.equals(reviewData.getMemberNo())) { // 권한 없음
                JDBCTemplate.close(conn);
                return -1;
            }

            result = reviewNoticeDao.updatePostTextData(conn, reviewData); // 텍스트 정보 업데이트

            if (result > 0) {
                // 1. 기존 파일 중 삭제 요청된 파일 처리
                if (fileNosToDelete != null && !fileNosToDelete.isEmpty()) {
                    // 물리적 파일 삭제를 위해, 삭제할 파일들의 서버 저장명 정보가 필요.
                    ArrayList<Files> filesToRemoveDetails = new ArrayList<>();
                    for (Integer fileNo : fileNosToDelete) {
                        // 각 fileNo에 해당하는 파일의 상세 정보(특히 서버 저장명: filePath)를 조회하는 DAO 메소드 필요
                        // Files fDetail = reviewNoticeDao.getFileDetailByFileNo(conn, fileNo); // 예시
                        // if (fDetail != null && fDetail.getStylePostNo().equals(reviewData.getStylePostNo())) {
                        //    filesToRemoveDetails.add(fDetail);
                        // }
                    }
                    // DB에서 파일 레코드 삭제
                    reviewNoticeDao.deleteFilesByFileNos(conn, fileNosToDelete, reviewData.getStylePostNo());

                    // 서버에서 물리적 파일 삭제 (filesToRemoveDetails 리스트가 채워졌다고 가정)
                    for (Files fileInfo : filesToRemoveDetails) {
                        File physicalFile = new File(serverFileSavePath + File.separator + fileInfo.getFilePath()); // 서버 저장명
                        if (physicalFile.exists()) {
                            if(!physicalFile.delete()){
                                System.err.println("Service: updatePost - 물리적 파일 삭제 실패: " + physicalFile.getAbsolutePath());
                            }
                        }
                    }
                }

                // 2. 새로 추가된 파일들 DB에 저장 (newFilesList는 0 또는 1개의 요소를 가짐 - 현재 JSP 기준)
                if (newFilesList != null && !newFilesList.isEmpty()) {
                    reviewNoticeDao.insertPostFiles(conn, reviewData.getStylePostNo(), newFilesList);
                }
                JDBCTemplate.commit(conn);
            } else { // 텍스트 정보 업데이트 실패
                JDBCTemplate.rollback(conn);
            }
        } catch (Exception e) {
            System.err.println("Service: updatePost 오류 발생 - " + e.getMessage());
            JDBCTemplate.rollback(conn);
            result = 0;
        } finally {
            JDBCTemplate.close(conn);
        }
        return result;
    }
    
    /**
     * 카테고리별 (또는 전체) 스타일 후기 게시물 목록을 조회 (페이징 처리)
     */
    public ArrayList<ReviewNotice> getReviewListByCategory(String categoryCode, int currentPage, int recordCountPerPage) {
        Connection conn = JDBCTemplate.getConnection();
        int start = currentPage * recordCountPerPage - (recordCountPerPage - 1);
        int end = currentPage * recordCountPerPage;
        ArrayList<ReviewNotice> list = reviewNoticeDao.selectReviewListByCategory(conn, categoryCode, start, end);
        JDBCTemplate.close(conn);
        return list;
    }

    /**
     * 페이징 처리를 위한 카테고리별 전체 게시물 수 조회
     */
    public int getTotalReviewCountByCategory(String categoryCode) {
        Connection conn = JDBCTemplate.getConnection();
        int totalCount = reviewNoticeDao.selectTotalReviewCountByCategory(conn, categoryCode);
        JDBCTemplate.close(conn);
        return totalCount;
    }

	public Category selectCategory(String stylePostNo) {
		Connection conn = JDBCTemplate.getConnection();
		Category category = reviewNoticeDao.selectReviewListByCategory(conn, stylePostNo);
		JDBCTemplate.close(conn);
		return category;
	}
    public ArrayList<ReviewNotice> selectAllReviewList() {
    	Connection conn = JDBCTemplate.getConnection();
    	ArrayList<ReviewNotice> reviewList = reviewNoticeDao.selectAllReviewList(conn);
    	JDBCTemplate.close(conn);
    	return reviewList;
    }
}