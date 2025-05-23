package kr.or.iei.reviewNotice.model.dao;

import static kr.or.iei.common.JDBCTemplate.*; // JDBCTemplate 경로에 맞게

import java.sql.Connection;
import java.sql.JDBCType;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.or.iei.file.model.vo.Files;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;
import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.category.model.vo.Category; 

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
            close(rs);
            close(pstmt);
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
            close(rs);
            close(pstmt);
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
            close(pstmt);
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
            close(rs);
            close(pstmt);
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
            close(rs);
            close(pstmt);
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
            close(pstmt);
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
            close(pstmt);
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
            close(pstmt);
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
            close(rs);
            close(pstmt);
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
            close(rs);
            close(pstmt);
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
            close(pstmt);
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
            close(rs);
            close(pstmt);
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
            close(pstmt);
        }
        return result;
    }

	public ArrayList<ReviewNotice> selectAllReviewList(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select s.style_post_no, s.post_title, f.file_path"
				+ " from tbl_style_post s left join (select style_post_no, min(file_no) keep (dense_rank first order by file_no) as file_no, min(file_path) keep (dense_rank first order by file_no) as file_path from tbl_file group by style_post_no) f"
				+ " on (s.style_post_no = f.style_post_no) order by s.post_date desc, f.file_no asc";
		
		ArrayList<ReviewNotice> reviewList = new ArrayList<ReviewNotice>();
		
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