package kr.or.iei.reviewNotice.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.or.iei.category.model.vo.Category;
import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;

public class ReviewNoticeDao {

    /**
     * 스타일 게시글 전체 또는 카테고리별 목록 조회 DAO
     * - 썸네일 조회를 LEFT JOIN과 ROW_NUMBER()를 사용하는 방식으로 변경
     * @param conn Connection 객체
     * @param categoryCode 필터링할 부모 카테고리 코드 (예: "A1"). Null 또는 "all"이면 전체 조회.
     * @return ArrayList<ReviewNotice> 조회된 게시글 목록
     * @throws SQLException SQL 예외 발생 시
     */
    public ArrayList<ReviewNotice> selectAllReview(Connection conn, String categoryCode) throws SQLException {
        ArrayList<ReviewNotice> reviewList = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder();

        sql.append("SELECT ");
        sql.append("    SP.STYLE_POST_NO, ");         // 스타일 게시글 번호
        sql.append("    SP.POST_TITLE, ");            // 게시글 제목
        sql.append("    SP.ORDER_NO, ");              // 관련 주문 번호
        sql.append("    SP.POST_DATE, ");             // 게시글 작성일
        sql.append("    SP.READ_COUNT, ");            // 조회수
        sql.append("    M.MEMBER_NICKNAME, ");       // 주문자(구매자) 닉네임
        sql.append("    F_THUMB.FILE_PATH AS THUMBNAIL_PATH "); // 썸네일 파일 경로
        sql.append("FROM TBL_STYLE_POST SP ");
        sql.append("LEFT JOIN TBL_PURCHASE PU ON SP.ORDER_NO = PU.ORDER_NO "); // 주문 테이블과 조인
        sql.append("LEFT JOIN TBL_MEMBER M ON PU.BUYER_MEMBER_NO = M.MEMBER_NO "); // 회원 테이블과 조인 (구매자 정보)

        // 썸네일 파일을 위한 LEFT JOIN (ROW_NUMBER 사용)
        sql.append("LEFT JOIN ( ");
        sql.append("    SELECT ");
        sql.append("        TEMP.STYLE_POST_NO, ");
        sql.append("        TEMP.FILE_PATH ");
        sql.append("    FROM ( ");
        sql.append("        SELECT ");
        sql.append("            TF.STYLE_POST_NO, ");
        sql.append("            TF.FILE_PATH, ");
        sql.append("            TF.FILE_NO, "); // 정렬을 위해 FILE_NO 포함
        sql.append("            ROW_NUMBER() OVER (PARTITION BY TF.STYLE_POST_NO ORDER BY TF.FILE_NO ASC) as RN ");
        sql.append("        FROM TBL_FILE TF ");
        sql.append("    ) TEMP ");
        sql.append("    WHERE TEMP.RN = 1 "); // 각 게시글 당 첫번째 파일
        sql.append(") F_THUMB ON SP.STYLE_POST_NO = F_THUMB.STYLE_POST_NO ");

        // 카테고리 필터링 조건 추가
        if (categoryCode != null && !categoryCode.isEmpty() && !categoryCode.equalsIgnoreCase("all")) {
            sql.append("JOIN TBL_PROD P ON PU.PRODUCT_NO = P.PRODUCT_NO "); // 상품 테이블과 조인
            sql.append("JOIN TBL_PROD_CATEGORY PC ON P.CATEGORY_CODE = PC.CATEGORY_CODE "); // 상품 카테고리 테이블과 조인
            sql.append("WHERE PC.PAR_CATEGORY_CODE = ? "); // 부모 카테고리 코드로 필터링
        }

        sql.append("ORDER BY SP.POST_DATE DESC"); // 최신글 순으로 정렬

        try {
            pstmt = conn.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (categoryCode != null && !categoryCode.isEmpty() && !categoryCode.equalsIgnoreCase("all")) {
                pstmt.setString(paramIndex++, categoryCode); // 파라미터 바인딩
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                ReviewNotice rn = new ReviewNotice();
                rn.setStylePostNo(rs.getString("STYLE_POST_NO"));
                rn.setPostTitle(rs.getString("POST_TITLE"));
                rn.setOrderNo(rs.getString("ORDER_NO"));
                rn.setPostDate(rs.getString("POST_DATE"));
                rn.setReadCount(rs.getInt("READ_COUNT"));
                rn.setMemberNickname(rs.getString("MEMBER_NICKNAME"));

                // 썸네일 정보 설정
                String thumbnailPath = rs.getString("THUMBNAIL_PATH");
                if (thumbnailPath != null && !thumbnailPath.isEmpty()) {
                    Files thumbnailFile = new Files();
                    thumbnailFile.setFilePath(thumbnailPath);
                    ArrayList<Files> fileList = new ArrayList<>();
                    fileList.add(thumbnailFile);
                    rn.setFileList(fileList); // ReviewNotice VO의 fileList에 썸네일 파일 추가
                }
                reviewList.add(rn);
            }
        } finally {
            JDBCTemplate.close(rs);
            JDBCTemplate.close(pstmt);
        }
        return reviewList;
    }

    /**
     * 스타일 게시글 상세 조회 DAO
     * ReviewNotice VO의 memberNo, memberNickname, categoryCode, categoryList 필드를 채웁니다.
     * TBL_PURCHASE의 구매자 회원번호 컬럼으로 BUYER_MEMBER_NO 사용.
     * @param conn Connection 객체
     * @param stylePostNo 조회할 게시글 번호 (String)
     * @return ReviewNotice 조회된 게시글 상세 정보 (없으면 null)
     * @throws SQLException SQL 예외 발생 시
     */
    public ReviewNotice selectReviewNoticeDetail(Connection conn, String stylePostNo) throws SQLException {
        ReviewNotice reviewNotice = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
            "SELECT " +
            "    SP.STYLE_POST_NO, " +
            "    SP.POST_TITLE, " +
            "    SP.POST_CONTENT, " +
            "    SP.ORDER_NO, " +
            "    to_char(SP.POST_DATE, 'yyyy-mm-dd hh24:mi') as post_date, " +
            "    SP.READ_COUNT, " +
            "    M.MEMBER_NO, " +                     // 주문자(MEMBER) 회원번호
            "    M.MEMBER_NICKNAME, " +              // 주문자(MEMBER) 닉네임
            "    PC.CATEGORY_CODE, " +               // 주문 상품의 카테고리 코드
            "    PC.CATEGORY_NAME AS PROD_CATEGORY_NAME, " + // 주문 상품의 카테고리 이름
            "    PC.PAR_CATEGORY_CODE AS PROD_PAR_CATEGORY_CODE " + // 주문 상품의 부모 카테고리 코드
            "FROM TBL_STYLE_POST SP " +
            "LEFT JOIN TBL_PURCHASE PU ON SP.ORDER_NO = PU.ORDER_NO " +
            "LEFT JOIN TBL_MEMBER M ON PU.BUYER_MEMBER_NO = M.MEMBER_NO " + // BUYER_MEMBER_NO 사용
            "LEFT JOIN TBL_PROD P ON PU.PRODUCT_NO = P.PRODUCT_NO " +
            "LEFT JOIN TBL_PROD_CATEGORY PC ON P.CATEGORY_CODE = PC.CATEGORY_CODE " +
            "WHERE SP.STYLE_POST_NO = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stylePostNo);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                reviewNotice = new ReviewNotice();
                reviewNotice.setStylePostNo(rs.getString("STYLE_POST_NO"));
                reviewNotice.setPostTitle(rs.getString("POST_TITLE"));
                reviewNotice.setPostContent(rs.getString("POST_CONTENT"));
                reviewNotice.setOrderNo(rs.getString("ORDER_NO"));
                reviewNotice.setPostDate(rs.getString("POST_DATE"));
                reviewNotice.setReadCount(rs.getInt("READ_COUNT"));

                // "참조" 정보 설정 (주문자)
                reviewNotice.setMemberNo(rs.getString("MEMBER_NO"));
                reviewNotice.setMemberNickname(rs.getString("MEMBER_NICKNAME"));

                // "참조" 정보 설정 (상품 카테고리)
                reviewNotice.setCategoryCode(rs.getString("CATEGORY_CODE")); // ReviewNotice VO의 categoryCode 필드

                // ReviewNotice VO의 categoryList 필드에 상품 카테고리 정보를 Category 객체로 담아 설정
                String prodCategoryCode = rs.getString("CATEGORY_CODE");
                String prodCategoryName = rs.getString("PROD_CATEGORY_NAME");
                String prodParCategoryCode = rs.getString("PROD_PAR_CATEGORY_CODE");

                if (prodCategoryCode != null) { // 상품에 카테고리 정보가 있을 경우
                    Category category = new Category();
                    category.setCategoryCode(prodCategoryCode);
                    category.setCategoryName(prodCategoryName);
                    category.setParCategoryCode(prodParCategoryCode);

                    ArrayList<Category> categoryList = new ArrayList<>();
                    categoryList.add(category);
                    reviewNotice.setCategoryList(categoryList);
                }
            }
        } finally {
            JDBCTemplate.close(rs);
            JDBCTemplate.close(pstmt);
        }
        return reviewNotice;
    }

    public int increaseReadCount(Connection conn, String stylePostNo) throws SQLException {
        PreparedStatement pstmt = null;
        int result = 0;
        String sql =
            "UPDATE TBL_STYLE_POST " +
            "SET READ_COUNT = READ_COUNT + 1 " +
            "WHERE STYLE_POST_NO = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stylePostNo);
            result = pstmt.executeUpdate();
        } finally {
        	JDBCTemplate.close(pstmt);
        }
        return result;
    }

    public ArrayList<Files> selectFileList(Connection conn, String stylePostNo) throws SQLException {
        ArrayList<Files> fileList = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql =
            "SELECT " +
            "    FILE_NO, PRODUCT_NO, STYLE_POST_NO, NOTICE_NO, EVENT_NO, " +
            "    FILE_NAME, FILE_PATH, UPLOAD_DATE " +
            "FROM TBL_FILE " +
            "WHERE STYLE_POST_NO = ? " +
            "ORDER BY FILE_NO ASC";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stylePostNo);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Files file = new Files();
                file.setFileNo(rs.getInt("FILE_NO"));
                file.setProductNo(rs.getString("PRODUCT_NO"));
                file.setStylePostNo(rs.getString("STYLE_POST_NO"));
                file.setNoticeNo(rs.getString("NOTICE_NO"));
                file.setEventNo(rs.getString("EVENT_NO"));
                file.setFileName(rs.getString("FILE_NAME"));
                file.setFilePath(rs.getString("FILE_PATH"));
                file.setUploadDate(rs.getString("UPLOAD_DATE")); // Files VO의 uploadDate는 String
                fileList.add(file);
            }
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return fileList;
    }

    public ArrayList<Comment> selectCommentList(Connection conn, String stylePostNo) throws SQLException {
        ArrayList<Comment> commentList = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql =
            "SELECT " +
            "    C.COMMENT_NO, C.MEMBER_NO, C.PRODUCT_NO, C.STYLE_POST_NO, " +
            "    C.CONTENT, C.CREATED_DATE, M.MEMBER_NICKNAME " +
            "FROM TBL_COMMENT C " +
            "JOIN TBL_MEMBER M ON (C.MEMBER_NO = M.MEMBER_NO) " +
            "WHERE C.STYLE_POST_NO = ? " +
            "ORDER BY C.CREATED_DATE ASC"; // 댓글 생성 시간순
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stylePostNo);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Comment c = new Comment();
                c.setCommentNo(rs.getInt("COMMENT_NO"));
                c.setMemberNo(rs.getString("MEMBER_NO"));
                c.setProductNo(rs.getString("PRODUCT_NO"));
                c.setStylePostNo(rs.getString("STYLE_POST_NO"));
                c.setContent(rs.getString("CONTENT"));
                c.setCreatedDate(rs.getDate("CREATED_DATE"));
                c.setMemberNickname(rs.getString("MEMBER_NICKNAME"));
                commentList.add(c);
            }
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return commentList;
    }

    public int insertComment(Connection conn, Comment comment) throws SQLException {
        PreparedStatement pstmt = null;
        int result = 0;
        String sql =
            "INSERT INTO TBL_COMMENT ( " +
            "    COMMENT_NO, MEMBER_NO, PRODUCT_NO, STYLE_POST_NO, CONTENT, CREATED_DATE " +
            ") VALUES ( " +
            "    SEQ_COMMENT.NEXTVAL, ?, ?, ?, ?, SYSDATE " +
            ")";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, comment.getMemberNo());
            pstmt.setString(2, comment.getProductNo());
            pstmt.setString(3, comment.getStylePostNo());
            pstmt.setString(4, comment.getContent());
            result = pstmt.executeUpdate();
        } finally {
        	JDBCTemplate.close(pstmt);
        }
        return result;
    }

    public int updateComment(Connection conn, int commentNo, String content) throws SQLException {
        PreparedStatement pstmt = null;
        int result = 0;
        String sql =
            "UPDATE TBL_COMMENT " +
            "SET CONTENT = ?, CREATED_DATE = SYSDATE " + // 수정일도 현재 시간으로 갱신
            "WHERE COMMENT_NO = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, content);
            pstmt.setInt(2, commentNo);
            result = pstmt.executeUpdate();
        } finally {
        	JDBCTemplate.close(pstmt);
        }
        return result;
    }

    public int deleteComment(Connection conn, int commentNo) throws SQLException {
        PreparedStatement pstmt = null;
        int result = 0;
        String sql =
            "DELETE FROM TBL_COMMENT " +
            "WHERE COMMENT_NO = ?"; // 물리적 삭제
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentNo);
            result = pstmt.executeUpdate();
        } finally {
        	JDBCTemplate.close(pstmt);
        }
        return result;
    }

    public Comment selectOneComment(Connection conn, int commentNo) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Comment comment = null;
        String sql =
            "SELECT MEMBER_NO " + // 작성자 확인을 위해 MEMBER_NO만 조회
            "FROM TBL_COMMENT " +
            "WHERE COMMENT_NO = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentNo);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                comment = new Comment();
                comment.setCommentNo(commentNo);
                comment.setMemberNo(rs.getString("MEMBER_NO"));
            }
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return comment;
    }

    public int getNextStyleSequence(Connection conn) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int nextSeqVal = 0;
        String sql = "SELECT SEQ_STYLE.NEXTVAL FROM DUAL";
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                nextSeqVal = rs.getInt(1);
            }
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return nextSeqVal;
    }

    public int insertReviewNotice(Connection conn, ReviewNotice reviewNotice) throws SQLException {
        PreparedStatement pstmt = null;
        int result = 0;
        String sql =
            "INSERT INTO TBL_STYLE_POST ( " +
            "    STYLE_POST_NO, POST_TITLE, POST_CONTENT, ORDER_NO, POST_DATE, READ_COUNT " +
            ") VALUES ( " +
            "    ?, ?, ?, ?, SYSDATE, 0 " + // POST_DATE는 SYSDATE, READ_COUNT는 0으로 기본값 설정
            ")";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reviewNotice.getStylePostNo());
            pstmt.setString(2, reviewNotice.getPostTitle());
            pstmt.setString(3, reviewNotice.getPostContent());
            pstmt.setString(4, reviewNotice.getOrderNo()); // 주문 번호
            result = pstmt.executeUpdate();
        } finally {
        	JDBCTemplate.close(pstmt);
        }
        return result;
    }

    public int getNextFileNo(Connection conn) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int nextFileNo = 1;
        String sql = "SELECT MAX(FILE_NO) AS MAX_NO FROM TBL_FILE"; // MAX 값 조회
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                Object maxNoObj = rs.getObject("MAX_NO"); // NULL 가능성 체크
                if (maxNoObj != null) {
                    nextFileNo = ((Number) maxNoObj).intValue() + 1;
                }
                // 테이블이 비어있으면 maxNoObj가 null이고, nextFileNo는 초기값 1 유지
            }
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return nextFileNo;
    }

    public int insertFile(Connection conn, Files file) throws SQLException {
        PreparedStatement pstmt = null;
        int result = 0;
        String sql =
            "INSERT INTO TBL_FILE ( " +
            "    FILE_NO, PRODUCT_NO, STYLE_POST_NO, NOTICE_NO, EVENT_NO, " +
            "    FILE_NAME, FILE_PATH, UPLOAD_DATE " +
            ") VALUES ( " +
            "    ?, ?, ?, ?, ?, ?, ?, SYSDATE " +
            ")";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, file.getFileNo());          // 서비스에서 채번한 파일 번호
            pstmt.setString(2, file.getProductNo());    // 관련 상품 번호 (nullable)
            pstmt.setString(3, file.getStylePostNo());  // 현재 게시글 번호
            pstmt.setString(4, file.getNoticeNo());     // 관련 공지 번호 (nullable)
            pstmt.setString(5, file.getEventNo());      // 관련 이벤트 번호 (nullable)
            pstmt.setString(6, file.getFileName());     // 원본 파일명
            pstmt.setString(7, file.getFilePath());     // 서버 저장 경로
            result = pstmt.executeUpdate();
        } finally {
        	JDBCTemplate.close(pstmt);
        }
        return result;
    }
    /**
     * 게시글 번호(stylePostNo)를 사용하여 해당 게시글을 주문한 회원의 번호(MEMBER_NO)를 조회합니다.
     * TBL_STYLE_POST와 TBL_PURCHASE 테이블을 조인하여 실제 글 작성자(주문자)를 찾습니다.
     * @param conn Connection 객체
     * @param stylePostNo 조회할 게시글 번호
     * @return 조회된 주문자(작성자)의 회원 번호, 정보가 없으면 null 반환
     */
    public String getAuthorMemberNoByPostNo(Connection conn, String stylePostNo) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String authorMemberNo = null;
        String sql = "SELECT P.buyer_MEMBER_NO " +
                     "FROM TBL_STYLE_POST SP " +
                     "JOIN TBL_PURCHASE P ON SP.ORDER_NO = P.ORDER_NO " +
                     "WHERE SP.STYLE_POST_NO = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stylePostNo);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                authorMemberNo = rs.getString("buyer_MEMBER_NO");
            }
        } catch (SQLException e) {
            System.err.println("DAO: getAuthorMemberNoByPostNo 오류 발생 - " + e.getMessage());
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return authorMemberNo;
    }

    /**
     * 게시글을 DB에서 삭제합니다. (Service 단에서 권한 확인 후 호출됨)
     * TBL_FILE, TBL_COMMENT의 STYLE_POST_NO에 ON DELETE CASCADE가 설정되어 관련 레코드는 자동 삭제됩니다.
     * @param conn Connection 객체
     * @param stylePostNo 삭제할 게시글 번호
     * @return 삭제 성공 시 1, 실패 시 0 반환
     */
    public int deletePost(Connection conn, String stylePostNo) {
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = "DELETE FROM TBL_STYLE_POST WHERE STYLE_POST_NO = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stylePostNo);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("DAO: deletePost 오류 발생 - " + e.getMessage());
        } finally {
        	JDBCTemplate.close(pstmt);
        }
        return result;
    }

    /**
     * 게시글의 텍스트 정보(제목, 내용, 주문번호)를 수정합니다.
     * POST_DATE는 SYSDATE로 현재 시간으로 업데이트 됩니다.
     * TBL_STYLE_POST에 CATEGORY_CODE 컬럼이 없으므로, 카테고리는 여기서 수정하지 않습니다.
     * @param conn Connection 객체
     * @param review 수정할 내용이 담긴 ReviewNotice 객체 (stylePostNo 필수 포함)
     * @return 수정 성공 시 1, 실패 시 0 반환
     */
    public int updatePostTextData(Connection conn, ReviewNotice review) {
        PreparedStatement pstmt = null;
        int result = 0;
        String sql = "UPDATE TBL_STYLE_POST SET POST_TITLE = ?, POST_CONTENT = ?, ORDER_NO = ?, POST_DATE = SYSDATE " +
                     "WHERE STYLE_POST_NO = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, review.getPostTitle());
            pstmt.setString(2, review.getPostContent());
            pstmt.setString(3, review.getOrderNo());
            pstmt.setString(4, review.getStylePostNo());
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("DAO: updatePostTextData 오류 발생 - " + e.getMessage());
        } finally {
        	JDBCTemplate.close(pstmt);
        }
        return result;
    }

    /**
     * 특정 게시글에 첨부된 파일 목록을 조회합니다.
     * @param conn Connection 객체
     * @param stylePostNo 게시글 번호
     * @return 해당 게시글의 Files 객체 ArrayList 반환
     */
    public ArrayList<Files> getFilesForPost(Connection conn, String stylePostNo) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<Files> fileList = new ArrayList<>();
        // TBL_FILE.FILE_NAME: 사용자가 업로드한 원본 파일명
        // TBL_FILE.FILE_PATH: 서버에 저장된 고유 (변경될 수 있는) 파일명
        // TBL_FILE.UPLOAD_DATE: TO_CHAR로 변환하여 String으로 가져옴 (Files VO의 uploadDate가 String이므로)
        String sql = "SELECT FILE_NO, STYLE_POST_NO, FILE_NAME, FILE_PATH, TO_CHAR(UPLOAD_DATE, 'YYYY-MM-DD HH24:MI') AS UPLOAD_DATE_STR " +
                     "FROM TBL_FILE WHERE STYLE_POST_NO = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stylePostNo);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Files file = new Files();
                file.setFileNo(rs.getInt("FILE_NO"));
                file.setStylePostNo(rs.getString("STYLE_POST_NO"));
                file.setFileName(rs.getString("FILE_NAME")); // 원본 파일명
                file.setFilePath(rs.getString("FILE_PATH")); // 서버 저장 파일명
                file.setUploadDate(rs.getString("UPLOAD_DATE_STR")); // 변환된 문자열 날짜
                fileList.add(file);
            }
        } catch (SQLException e) {
            System.err.println("DAO: getFilesForPost 오류 발생 - " + e.getMessage());
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return fileList;
    }

    /**
     * 파일 번호(FILE_NO) 목록을 기반으로 TBL_FILE 테이블에서 파일 레코드를 삭제합니다.
     * 게시글 수정 시 기존 파일 중 일부를 삭제할 때 사용됩니다.
     * @param conn Connection 객체
     * @param fileNosToDelete 삭제할 파일의 FILE_NO를 담은 ArrayList
     * @param stylePostNo 해당 파일들이 속한 게시글 번호 (삭제 조건에 포함하여 안정성 증대)
     * @return 삭제된 레코드 수의 총합 반환
     */
    public int deleteFilesByFileNos(Connection conn, ArrayList<Integer> fileNosToDelete, String stylePostNo) {
        PreparedStatement pstmt = null;
        int totalDeleted = 0;
        String sql = "DELETE FROM TBL_FILE WHERE FILE_NO = ? AND STYLE_POST_NO = ?";
        try {
            for (Integer fileNo : fileNosToDelete) {
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, fileNo);
                pstmt.setString(2, stylePostNo);
                totalDeleted += pstmt.executeUpdate();
                JDBCTemplate.close(pstmt);
            }
        } catch (SQLException e) {
            System.err.println("DAO: deleteFilesByFileNos 오류 발생 - " + e.getMessage());
        }
        return totalDeleted;
    }

    /**
     * 게시글에 새로 첨부된 파일 정보를 TBL_FILE 테이블에 추가합니다.
     * FILE_NO는 SEQ_FILE_NO 시퀀스를 사용하여 자동 생성됩니다. UPLOAD_DATE는 SYSDATE로 자동 입력됩니다.
     * @param conn Connection 객체
     * @param stylePostNo 파일이 첨부될 게시글 번호
     * @param newFilesList 추가할 파일 정보(Files 객체)를 담은 ArrayList
     * @return 성공적으로 DB에 추가된 파일 레코드 수 반환
     */
    public int insertPostFiles(Connection conn, String stylePostNo, ArrayList<Files> newFilesList) {
        PreparedStatement pstmt = null;
        int totalInserted = 0;
        String sql = "INSERT INTO TBL_FILE (FILE_NO, STYLE_POST_NO, FILE_NAME, FILE_PATH, UPLOAD_DATE) " +
                     "VALUES (SEQ_FILE_NO.NEXTVAL, ?, ?, ?, SYSDATE)";
        try {
            for (Files file : newFilesList) {
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, stylePostNo);
                pstmt.setString(2, file.getFileName()); // 원본 파일명
                pstmt.setString(3, file.getFilePath()); // 서버 저장 파일명
                totalInserted += pstmt.executeUpdate();

                JDBCTemplate.close(pstmt);
            }
        } catch (SQLException e) {
            System.err.println("DAO: insertPostFiles 오류 발생 - " + e.getMessage());
        }
        return totalInserted;
    }

    /**
     * 게시글 수정을 위해 게시글의 기본 정보와 해당 게시글의 첨부파일 목록을 함께 조회합니다.
     * POST_DATE는 'YYYY-MM-DD HH24:MI' 형식의 문자열로 변환하여 가져옵니다.
     * @param conn Connection 객체
     * @param stylePostNo 조회할 게시글 번호
     * @return 게시글 정보(파일 목록 포함)를 담은 ReviewNotice 객체, 없으면 null 반환
     */
    public ReviewNotice getReviewNoticeDetailForEditForm(Connection conn, String stylePostNo) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ReviewNotice review = null;
        String sql = "SELECT STYLE_POST_NO, POST_TITLE, POST_CONTENT, ORDER_NO, " +
                     "TO_CHAR(POST_DATE, 'YYYY-MM-DD HH24:MI') AS POST_DATE_STR, READ_COUNT " +
                     "FROM TBL_STYLE_POST " +
                     "WHERE STYLE_POST_NO = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stylePostNo);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                review = new ReviewNotice();
                review.setStylePostNo(rs.getString("STYLE_POST_NO"));
                review.setPostTitle(rs.getString("POST_TITLE"));
                review.setPostContent(rs.getString("POST_CONTENT"));
                review.setOrderNo(rs.getString("ORDER_NO"));
                review.setPostDate(rs.getString("POST_DATE_STR")); // 문자열로 변환된 날짜
                review.setReadCount(rs.getInt("READ_COUNT"));
                review.setFileList(getFilesForPost(conn, stylePostNo)); // 첨부파일 목록 설정
            }
        } catch (SQLException e) {
            System.err.println("DAO: getReviewNoticeDetailForEditForm 오류 발생 - " + e.getMessage());
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return review;
    }
    /**
     * 스타일 게시글 전체 또는 카테고리별 목록 조회 DAO (페이징 처리 추가)
     * POST_DATE, 썸네일 파일의 UPLOAD_DATE는 'YYYY-MM-DD HH24:MI' 형식의 문자열로 가져옵니다.
     * @param conn Connection 객체
     * @param categoryCode 필터링할 상품의 카테고리 코드 (예: "A1"). Null 또는 "all"이면 전체 조회.
     * @param start 페이징 시작 rownum
     * @param end 페이징 끝 rownum
     * @return ArrayList<ReviewNotice> 조회된 게시글 목록
     */
    public ArrayList<ReviewNotice> selectReviewListByCategory(Connection conn, String categoryCode, int start, int end) {
        ArrayList<ReviewNotice> reviewList = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM ( ");
        sql.append("    SELECT ROWNUM AS RNUM, R.* FROM ( ");
        sql.append("        SELECT ");
        sql.append("            SP.STYLE_POST_NO, SP.POST_TITLE, TO_CHAR(SP.POST_DATE, 'YYYY-MM-DD HH24:MI') AS POST_DATE_STR, ");
        sql.append("            SP.READ_COUNT, SP.ORDER_NO, ");
        sql.append("            M.MEMBER_NICKNAME, ");
        // 썸네일 파일의 FILE_PATH (웹 상대 경로 전체) 와 원본 파일명(FILE_NAME)을 가져옵니다.
        sql.append("            F_THUMB.FILE_PATH AS THUMBNAIL_FILE_PATH, F_THUMB.FILE_NAME AS THUMBNAIL_ORIGINAL_NAME ");
        sql.append("        FROM TBL_STYLE_POST SP ");
        sql.append("        JOIN TBL_PURCHASE PU ON SP.ORDER_NO = PU.ORDER_NO "); // 주문 테이블과 INNER JOIN (주문 없는 후기는 없다고 가정)
        sql.append("        LEFT JOIN TBL_MEMBER M ON PU.BUYER_MEMBER_NO = M.MEMBER_NO "); // 회원 테이블 (구매자 닉네임)
        sql.append("        LEFT JOIN ( "); // 썸네일 파일을 위한 서브쿼리
        sql.append("            SELECT TEMP.STYLE_POST_NO, TEMP.FILE_PATH, TEMP.FILE_NAME ");
        sql.append("            FROM ( ");
        sql.append("                SELECT TF.STYLE_POST_NO, TF.FILE_PATH, TF.FILE_NAME, ");
        sql.append("                       ROW_NUMBER() OVER (PARTITION BY TF.STYLE_POST_NO ORDER BY TF.FILE_NO ASC) as RN ");
        sql.append("                FROM TBL_FILE TF ");
        sql.append("            ) TEMP ");
        sql.append("            WHERE TEMP.RN = 1 "); // 각 게시글 당 첫번째 파일(FILE_NO 기준)
        sql.append("        ) F_THUMB ON SP.STYLE_POST_NO = F_THUMB.STYLE_POST_NO ");

        if (categoryCode != null && !categoryCode.isEmpty() && !categoryCode.equalsIgnoreCase("all")) {
            // 카테고리 필터링을 위해 TBL_PROD 조인
            sql.append("    JOIN TBL_PROD P_FILTER ON PU.PRODUCT_NO = P_FILTER.PRODUCT_NO ");
            sql.append("    JOIN TBL_PROD_CATEGORY PC ON P_FILTER.CATEGORY_CODE = PC.CATEGORY_CODE ");
            sql.append("    JOIN TBL_PROD_CATEGORY PPC ON PPC.CATEGORY_CODE = PC.PAR_CATEGORY_CODE ");
            sql.append("    WHERE PPC.PAR_CATEGORY_CODE = ? "); // 상품의 카테고리 코드로 필터링
        }
        sql.append("        ORDER BY SP.POST_DATE DESC ");
        sql.append("    ) R ");
        sql.append(") WHERE RNUM BETWEEN ? AND ? ");

        try {
            pstmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            if (categoryCode != null && !categoryCode.isEmpty() && !categoryCode.equalsIgnoreCase("all")) {
                pstmt.setString(paramIndex++, categoryCode);
            }
            pstmt.setInt(paramIndex++, start);
            pstmt.setInt(paramIndex++, end);

            rs = pstmt.executeQuery();
            while (rs.next()) {
                ReviewNotice rn = new ReviewNotice();
                rn.setStylePostNo(rs.getString("STYLE_POST_NO"));
                rn.setPostTitle(rs.getString("POST_TITLE"));
                rn.setOrderNo(rs.getString("ORDER_NO"));
                rn.setPostDate(rs.getString("POST_DATE_STR")); // TO_CHAR로 변환된 문자열 날짜
                rn.setReadCount(rs.getInt("READ_COUNT"));
                rn.setMemberNickname(rs.getString("MEMBER_NICKNAME"));

                String thumbnailPath = rs.getString("THUMBNAIL_FILE_PATH");
                if (thumbnailPath != null && !thumbnailPath.isEmpty()) {
                    Files thumbnailFile = new Files();
                    thumbnailFile.setFilePath(thumbnailPath); // 웹 상대 경로 전체
                    thumbnailFile.setFileName(rs.getString("THUMBNAIL_ORIGINAL_NAME")); // 원본 파일명
                    ArrayList<Files> fileList = new ArrayList<>();
                    fileList.add(thumbnailFile);
                    rn.setFileList(fileList);
                }
                reviewList.add(rn);
            }
        } catch (SQLException e) {
            System.err.println("DAO: selectReviewListByCategory 오류 - " + e.getMessage());
            e.printStackTrace(); // 개발 중 상세 오류 확인
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return reviewList;
    }

    /**
     * 페이징 처리를 위한 카테고리별 (또는 전체) 총 게시물 수 조회
     */
    public int selectTotalReviewCountByCategory(Connection conn, String categoryCode) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int totalCount = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS CNT FROM TBL_STYLE_POST SP ");
        sql.append("JOIN TBL_PURCHASE PU ON SP.ORDER_NO = PU.ORDER_NO ");

        if (categoryCode != null && !categoryCode.isEmpty() && !categoryCode.equalsIgnoreCase("all")) {
            sql.append("JOIN TBL_PROD P_FILTER ON PU.PRODUCT_NO = P_FILTER.PRODUCT_NO ");
            sql.append("WHERE P_FILTER.CATEGORY_CODE = ? ");
        }

        try {
            pstmt = conn.prepareStatement(sql.toString());
            if (categoryCode != null && !categoryCode.isEmpty() && !categoryCode.equalsIgnoreCase("all")) {
                pstmt.setString(1, categoryCode);
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                totalCount = rs.getInt("CNT");
            }
        } catch (SQLException e) {
            System.err.println("DAO: selectTotalReviewCountByCategory 오류 - " + e.getMessage());
            e.printStackTrace();
        } finally {
        	JDBCTemplate.close(rs);
        	JDBCTemplate.close(pstmt);
        }
        return totalCount;
    }

	public Category selectReviewListByCategory(Connection conn, String stylePostNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Category category = null;
		String sql = "select s.category_code as category_code, s.category_name as small_ctg_name, m.category_name as mid_ctg_name, l.category_name as lar_ctg_name  \r\n"
				+ "from tbl_style_post sp join tbl_purchase pur on sp.order_no = pur.order_no join tbl_prod prod on pur.product_no = prod.product_no join tbl_prod_category s on prod.category_code = s.category_code\r\n"
				+ "join tbl_prod_category m on s.par_category_code = m.category_code join tbl_prod_category l on m.par_category_code = l.category_code where sp.style_post_no = ?";

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, stylePostNo);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				category = new Category();
				category.setCategoryCode(rs.getString("category_code"));
				category.setCategoryName(rs.getString("small_ctg_name"));
				category.setMidCategoryName(rs.getString("mid_ctg_name"));
				category.setLarCategoryName(rs.getString("lar_ctg_name"));

			}
 		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rs);
			JDBCTemplate.close(pstmt);
		}
		return category;
	}
	public ArrayList<ReviewNotice> selectAllReviewList(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String query = "select s.style_post_no, s.post_title, f.file_path"
				+ " from tbl_style_post s left join (select style_post_no, min(file_no) keep (dense_rank first order by file_no) as file_no, min(file_path) keep (dense_rank first order by file_no) as file_path from tbl_file group by style_post_no) f"
				+ " on (s.style_post_no = f.style_post_no) order by s.post_date desc, f.file_no asc";

		ArrayList<ReviewNotice> reviewList = new ArrayList<>();

		try {
			pstmt = conn.prepareStatement(query);

			rset = pstmt.executeQuery();

			while(rset.next()) {
				ReviewNotice r = new ReviewNotice();
				r.setStylePostNo(rset.getString("style_post_no"));
				r.setPostTitle(rset.getString("post_title"));
				r.setFilePath(rset.getString("file_path"));

				reviewList.add(r);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}

		return reviewList;
	}
}