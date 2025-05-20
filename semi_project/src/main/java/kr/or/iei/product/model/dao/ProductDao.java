package kr.or.iei.product.model.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.product.model.vo.Product;

public class ProductDao {

    /**
     * 상품 등록 DAO 메서드
     * 상품 번호는 시퀀스 + 날짜 조합으로 직접 생성
     */
    public int insertProduct(Connection conn, Product p) {
        int result = 0;

        PreparedStatement pstmt = null;
        ResultSet rset = null;

        try {
            // 1. 상품번호 생성 (P + yymmdd + 시퀀스 4자리)
            String query1 = "SELECT 'P' || TO_CHAR(SYSDATE, 'YYMMDD') || LPAD(SEQ_PROD.NEXTVAL, 4, '0') FROM DUAL";
            pstmt = conn.prepareStatement(query1);
            rset = pstmt.executeQuery();
            if (rset.next()) {
                p.setProductNo(rset.getString(1)); // 상품 VO에 번호 설정
            }
            JDBCTemplate.close(pstmt);
            JDBCTemplate.close(rset);

            // 2. 상품 정보 INSERT
            String query2 = "INSERT INTO TBL_PROD (" +
            	    "PRODUCT_NO, MEMBER_NO, PRODUCT_NAME, PRODUCT_INTROD, PRODUCT_PRICE, " +
            	    "CATEGORY_CODE, TRADE_METHOD_CODE, STATUS_CODE, ENROLL_DATE, READ_COUNT, " +
            	    "PRICE_OFFER_YN" +
            	    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, DEFAULT, DEFAULT, ?)";
            pstmt = conn.prepareStatement(query2);
            pstmt.setString(1, p.getProductNo());
            pstmt.setString(2, p.getMemberNo());
            pstmt.setString(3, p.getProductName());
            pstmt.setString(4, p.getProductIntrod());
            pstmt.setInt(5, p.getProductPrice());
            pstmt.setString(6, p.getCategoryCode());
            pstmt.setString(7, p.getTradeMethodCode());
            pstmt.setString(8, "S01"); // 기본 상태코드: 판매중
            pstmt.setString(9, p.getPriceOfferYn());

            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result;
    }

    // 여러개의 첨부 파일을 DB에 저장하는 DAO 메서드
    // 첨부파일 리스트를 반복문으로 저장
    public int insertFiles(Connection conn, List<Files> fileList) {
        int result = 0;
        PreparedStatement pstmt = null;

        String query = "INSERT INTO TBL_FILE (FILE_NO, PRODUCT_NO, STYLE_POST_NO, NOTICE_NO, EVENT_NO, FILE_NAME, FILE_PATH, UPLOAD_DATE) "
                     + "VALUES (SEQ_FILE.NEXTVAL, ?, NULL, NULL, NULL, ?, ?, DEFAULT)";

        try {
            pstmt = conn.prepareStatement(query);

            for (Files f : fileList) {
                pstmt.setString(1, f.getProductNo());  // 상품 번호
                pstmt.setString(2, f.getFileName());   // 원본 파일명
                pstmt.setString(3, f.getFilePath());   // 저장된 경로
                result += pstmt.executeUpdate();       // 한 건씩 처리
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result;
    }

    
    /**
     * 특정 상품 번호에 해당하는 상품 1개의 상세 정보를 조회하는 메서드
     *
     * @param conn       DB 연결 객체 (Service 에서 전달)
     * @param productNo  조회할 상품 번호 (예: "P2405190001")
     * @return           조회된 상품 정보를 담은 Product 객체 (존재하지 않으면 null)
     */
    
    public Product selectOneProduct(Connection conn, String productNo) {
        Product p = null;

        PreparedStatement pstmt = null;
        ResultSet rset = null;

        // 상품 테이블에서 특정 상품 번호에 해당하는 행을 조회
        String query = "SELECT * FROM TBL_PROD WHERE PRODUCT_NO = ?";

        try {
        	// 1. SQL 준비 및 파라미터 바인딩
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo);

            // 2. 쿼리 실행 및 결과 처리
            rset = pstmt.executeQuery();

         // 3. 결과가 존재하면 Product 객체에 값 저장
            if (rset.next()) {
                p = new Product();
                p.setProductNo(rset.getString("PRODUCT_NO"));
                p.setMemberNo(rset.getString("MEMBER_NO"));
                p.setProductName(rset.getString("PRODUCT_NAME"));
                p.setProductIntrod(rset.getString("PRODUCT_INTROD"));
                p.setProductPrice(rset.getInt("PRODUCT_PRICE"));
                p.setCategoryCode(rset.getString("CATEGORY_CODE"));
                p.setTradeMethodCode(rset.getString("TRADE_METHOD_CODE"));
                p.setStatusCode(rset.getString("STATUS_CODE"));
                p.setEnrollDate(rset.getDate("ENROLL_DATE"));
                p.setReadCount(rset.getInt("READ_COUNT"));
                p.setPriceOfferYn(rset.getString("PRICE_OFFER_YN"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

     // 최종 결과 반환 (없으면 null)
        return p;
    }

    /**
     * 특정 상품 번호에 등록된 이미지 파일 목록을 조회하는 메서드
     *
     * @param conn      DB 연결 객체 (Service에서 전달)
     * @param productNo 상품 번호 (예: "P2405190001")
     * @return          이미지 파일 정보가 담긴 Files 객체 리스트
     */
    
    /**
     * 특정 상품 번호에 등록된 이미지 파일 목록을 조회하는 메서드
     *
     * @param conn      DB 연결 객체
     * @param productNo 조회할 상품 번호
     * @return          해당 상품의 이미지 파일 목록 (List<Files>)
     */
    public List<Files> selectProductFiles(Connection conn, String productNo) {
        List<Files> list = new ArrayList<>();

        PreparedStatement pstmt = null;
        ResultSet rset = null;

        // 상품 이미지만 조회 (상품 번호로 필터링, TYPE 컬럼은 사용하지 않음)
        String query = "SELECT * FROM TBL_FILE WHERE PRODUCT_NO = ? ORDER BY FILE_NO";

        try {
            // 1. SQL 준비 및 파라미터 바인딩
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo);

            // 2. 쿼리 실행
            rset = pstmt.executeQuery();

            // 3. 결과 처리
            while (rset.next()) {
                Files f = new Files();
                f.setFileNo(rset.getInt("FILE_NO"));                   // 파일 번호
                f.setProductNo(rset.getString("PRODUCT_NO"));          // 상품 번호 (참조)
                f.setStylePostNo(rset.getString("STYLE_POST_NO"));     // 스타일 게시물 번호 (null 가능)
                f.setNoticeNo(rset.getString("NOTICE_NO"));            // 공지사항 번호 (null 가능)
                f.setEventNo(rset.getString("EVENT_NO"));              // 이벤트 번호 (null 가능)
                f.setFileName(rset.getString("FILE_NAME"));            // 실제 파일명
                f.setFilePath(rset.getString("FILE_PATH"));            // 저장 경로
                f.setUploadDate(rset.getString("UPLOAD_DATE"));        // 업로드 날짜 (String으로 저장됨)

                // 리스트 보여주기
                list.add(f);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return list;
    }

    /**
     * 특정 상품에 등록된 댓글 목록을 조회하는 메서드
     * 
     * @param conn      DB 연결 객체
     * @param productNo 댓글을 조회할 상품 번호
     * @return          댓글 정보 리스트 (List<Comment>)
     */
    
    public List<Comment> selectProductComments(Connection conn, String productNo) {
        List<Comment> list = new ArrayList<>();

        PreparedStatement pstmt = null;
        ResultSet rset = null;

        String query = "SELECT C.COMMENT_NO, C.MEMBER_NO, C.PRODUCT_NO, C.STYLE_POST_NO, " +
                       "C.CONTENT, C.CREATED_DATE, C.PARENT_COMMENT_NO, M.MEMBER_NICKNAME " +
                       "FROM TBL_COMMENT C " +
                       "JOIN TBL_MEMBER M ON C.MEMBER_NO = M.MEMBER_NO " +
                       "WHERE UPPER(C.PRODUCT_NO) = UPPER(?) " +
                       "ORDER BY C.CREATED_DATE ASC";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo.trim());
            rset = pstmt.executeQuery();

            while (rset.next()) {
                Comment c = new Comment();

                c.setCommentNo(rset.getInt("COMMENT_NO"));
                c.setMemberNo(rset.getString("MEMBER_NO"));
                c.setProductNo(rset.getString("PRODUCT_NO"));
                c.setStylePostNo(rset.getString("STYLE_POST_NO")); // null 허용
                c.setContent(rset.getString("CONTENT"));
                c.setCreatedDate(rset.getDate("CREATED_DATE"));
                c.setMemberNickname(rset.getString("MEMBER_NICKNAME"));

                // parent_comment_no 안전 처리 (null 체크 먼저 수행)
                Object parent = rset.getObject("PARENT_COMMENT_NO");
                if (parent != null) {
                    if (parent instanceof BigDecimal) {
                        c.setParentCommentNo(((BigDecimal) parent).intValue());
                    } else if (parent instanceof Integer) {
                        c.setParentCommentNo((Integer) parent);
                    } else {
                        System.out.println("❗ 알 수 없는 타입: " + parent.getClass());
                        c.setParentCommentNo(null);
                    }
                } else {
                    c.setParentCommentNo(null);
                }

                list.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return list;
    }






    /**
     * 판매자 회원 번호를 기준으로 회원 정보를 조회하는 메서드
     *
     * @param conn      DB 연결 객체
     * @param memberNo  판매자의 회원 번호
     * @return          조회된 판매자 정보 (Member 객체), 없으면 null
     */
    public Member selectSellerInfo(Connection conn, String memberNo) {
        Member m = null;

        PreparedStatement pstmt = null;
        ResultSet rset = null;

        // 회원 번호를 기준으로 회원 정보를 1건 조회
        String query = "SELECT * FROM TBL_MEMBER WHERE MEMBER_NO = ?";

        try {
            // 1. SQL 준비 및 바인딩
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, memberNo);

            // 2. 쿼리 실행
            rset = pstmt.executeQuery();

            // 3. 결과 처리 (존재 시 Member 객체 생성)
            if (rset.next()) {
                m = new Member();
                m.setMemberNo(rset.getString("MEMBER_NO"));             // 회원 번호
                m.setMemberId(rset.getString("MEMBER_ID"));             // 아이디
                m.setMemberPw(rset.getString("MEMBER_PW"));             // 비밀번호
                m.setMemberNickname(rset.getString("MEMBER_NICKNAME")); // 닉네임
                m.setMemberName(rset.getString("MEMBER_NAME"));         // 이름
                m.setMemberBirth(rset.getString("MEMBER_BIRTH"));       // 생년월일
                m.setMemberPhone(rset.getString("MEMBER_PHONE"));       // 전화번호
                m.setMemberAddr(rset.getString("MEMBER_ADDR"));         // 주소
                m.setMemberEmail(rset.getString("MEMBER_EMAIL"));       // 이메일
                m.setJoin_date(rset.getString("JOIN_DATE"));            // 가입일
                m.setMember_rate(rset.getString("MEMBER_RATE"));        // 평점
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // 리소스 정리
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return m;
    }

    /**
     * 댓글 등록 DAO 메서드
     *
     * @param conn DB 연결 객체
     * @param c    등록할 댓글 정보 (productNo, memberNo, content 포함)
     * @return     실행 결과 (성공: 1, 실패: 0)
     */
    public int insertComment(Connection conn, Comment c) {
        int result = 0;
        PreparedStatement pstmt = null;

        // 댓글 등록 쿼리 (댓글 번호는 시퀀스 사용, 작성일은 SYSDATE 기본값)
        // 대댓글까지 고려한 INSERT SQL (parentCommentNo는 null 가능)
        String query = "INSERT INTO TBL_COMMENT "
                     + "(COMMENT_NO, MEMBER_NO, PRODUCT_NO, CONTENT, CREATED_DATE, PARENT_COMMENT_NO) "
                     + "VALUES (SEQ_COMMENT.NEXTVAL, ?, ?, ?, SYSDATE, ?)";


        try {
            // 1. SQL 준비 및 파라미터 설정
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, c.getMemberNo());   // 작성자 회원 번호
            pstmt.setString(2, c.getProductNo());  // 상품 번호
            pstmt.setString(3, c.getContent());    // 댓글 내용

            // 부모댓글번호가 null 이면 setNull, 있으면 setInt
            if (c.getParentCommentNo() != null) {
                pstmt.setInt(4, c.getParentCommentNo());
            } else {
                pstmt.setNull(4, java.sql.Types.INTEGER);
            }

            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
        	
        	// 자원 해제
            JDBCTemplate.close(pstmt);
        }

        return result;
    }

    // 댓글 삭제 메서드
    public int deleteComment(Connection conn, int commentNo) {
        PreparedStatement pstmt = null;
        int result = 0;
        String query = "DELETE FROM tbl_comment WHERE comment_no = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, commentNo);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result;
    }

    /**
     * 댓글 번호를 기준으로 댓글 내용을 수정하는 DAO 메서드
     * @param conn DB 연결 객체
     * @param c 수정할 댓글 객체 (댓글번호, 수정된 내용 포함)
     * @return 처리 결과 (1: 성공, 0: 실패)
     */
    public int updateComment(Connection conn, Comment c) {
        PreparedStatement pstmt = null;
        int result = 0;

        String query = "UPDATE tbl_comment SET content = ? WHERE comment_no = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, c.getContent());
            pstmt.setInt(2, c.getCommentNo());

            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result;
  
    }

    public int selectWishlistCount(Connection conn, String productNo) {
        int count = 0;
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        String query = "SELECT COUNT(*) FROM TBL_WISHLIST WHERE PRODUCT_NO = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo);
            rset = pstmt.executeQuery();
            if (rset.next()) {
                count = rset.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return count;
    }
    
 // 찜 여부 확인 (해당 회원이 해당 상품을 이미 찜했는지 조회)
    public boolean checkWishlist(Connection conn, String productNo, String memberNo) {
        boolean exists = false;
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        String query = "SELECT COUNT(*) FROM TBL_WISHLIST WHERE PRODUCT_NO = ? AND MEMBER_NO = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo);
            pstmt.setString(2, memberNo);
            rset = pstmt.executeQuery();
            if (rset.next()) {
                exists = rset.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return exists;
    }

    // 찜 추가 (TBL_WISHLIST 테이블에 데이터 삽입)
    public int insertWishlist(Connection conn, String productNo, String memberNo) {
        int result = 0;
        PreparedStatement pstmt = null;
        String query = "INSERT INTO TBL_WISHLIST (WISHLIST_NO, PRODUCT_NO, MEMBER_NO, WISHLIST_DATE) " +
                       "VALUES (SEQ_WISHLIST.NEXTVAL, ?, ?, SYSDATE)";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo);
            pstmt.setString(2, memberNo);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result;
    }

    // 찜 해제 (TBL_WISHLIST 테이블에서 데이터 삭제)
    public int deleteWishlist(Connection conn, String productNo, String memberNo) {
        int result = 0;
        PreparedStatement pstmt = null;
        String query = "DELETE FROM TBL_WISHLIST WHERE PRODUCT_NO = ? AND MEMBER_NO = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo);
            pstmt.setString(2, memberNo);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result;
    }

    // 현재 판매자가 판매중인 상품 갯수 표시
    public int getSellingProductCount(Connection conn, String memberNo) {
        int count = 0;
        PreparedStatement pstmt = null;
        ResultSet rset = null;

        String query = "SELECT COUNT(*) FROM TBL_PROD WHERE MEMBER_NO = ? AND STATUS_CODE = 'S01'";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, memberNo);
            rset = pstmt.executeQuery();
            if (rset.next()) {
                count = rset.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return count;
    }

    // 조회수 증가 
    public int increaseReadCount(Connection conn, String productNo) {
        int result = 0;
        PreparedStatement pstmt = null;

        String query = "UPDATE TBL_PROD SET READ_COUNT = READ_COUNT + 1 WHERE PRODUCT_NO = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result;
    }

    // 같은 소분류 CATEGORY_CODE를 가진 상품 중, 현재 상품(PRODUCT_NO)과 다른 최근 등록 상품을 6개까지 조회함.
    public List<Product> selectRelatedProducts(Connection conn, String categoryCode, String currentProductNo) {
        List<Product> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rset = null;

        String query =
        	    "SELECT * FROM ( " +
        	    "    SELECT P.PRODUCT_NO, P.PRODUCT_NAME, P.PRODUCT_PRICE, " +
        	    "           F.FILE_PATH " +
        	    "    FROM TBL_PROD P " +
        	    "    LEFT JOIN ( " +
        	    "        SELECT PRODUCT_NO, MIN(FILE_NO) KEEP (DENSE_RANK FIRST ORDER BY FILE_NO) AS FILE_NO, " +
        	    "               MIN(FILE_PATH) KEEP (DENSE_RANK FIRST ORDER BY FILE_NO) AS FILE_PATH " +
        	    "        FROM TBL_FILE " +
        	    "        GROUP BY PRODUCT_NO " +
        	    "    ) F ON P.PRODUCT_NO = F.PRODUCT_NO " +
        	    "    WHERE P.CATEGORY_CODE = ? AND P.PRODUCT_NO != ? " +
        	    "    ORDER BY P.ENROLL_DATE DESC " +
        	    ") WHERE ROWNUM <= 6";


        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, categoryCode);
            pstmt.setString(2, currentProductNo);
            rset = pstmt.executeQuery();

            while (rset.next()) {
                Product p = new Product();
                p.setProductNo(rset.getString("PRODUCT_NO"));
                p.setProductName(rset.getString("PRODUCT_NAME"));
                p.setProductPrice(rset.getInt("PRODUCT_PRICE"));
                p.setThumbnailPath(rset.getString("FILE_PATH")); // 대표 이미지 경로

                list.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }

        return list;
    }
/*
    ※ updateProductStatus(conn, productNo, statusCode)
    - 상품 번호에 해당하는 레코드의 상태코드를 주어진 값으로 갱신
    - 'S99' 전달 시 논리적 삭제 처리 (실제 삭제는 하지 않음)
    - 다양한 상태코드 업데이트에도 재사용 가능하도록 설계

  ※ 실패 시 0 반환, 성공 시 1 반환 (JDBCTemplate로 연결/해제 처리 포함)
  */
    
    public int updateProductStatus(Connection conn, String productNo, String statusCode) {
        PreparedStatement pstmt = null;
        int result = 0;

        String query = "UPDATE TBL_PROD SET STATUS_CODE = ? WHERE PRODUCT_NO = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, statusCode);    // 변경할 상태코드 (예: 'S99')
            pstmt.setString(2, productNo);     // 대상 상품 번호
            result = pstmt.executeUpdate();    // 실행 결과 행 수 반환
        } catch (SQLException e) {
            e.printStackTrace();               // 예외 발생 시 스택 추적 출력
        } finally {
            JDBCTemplate.close(pstmt);         // 자원 해제
        }

        return result;
    }

    // 상품 수정 후 재등록 메서드.
    public int updateProduct(Connection conn, Product p) {
        PreparedStatement pstmt = null;
        int result = 0;

        String query = "UPDATE TBL_PROD "
                     + "SET PRODUCT_NAME = ?, "
                     + "    PRODUCT_INTROD = ?, "
                     + "    PRODUCT_PRICE = ?, "
                     + "    CATEGORY_CODE = ?, "
                     + "    TRADE_METHOD_CODE = ?, "
                     + "    PRICE_OFFER_YN = ? "
                     + "WHERE PRODUCT_NO = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, p.getProductName());
            pstmt.setString(2, p.getProductIntrod());
            pstmt.setInt(3, p.getProductPrice());
            pstmt.setString(4, p.getCategoryCode());
            pstmt.setString(5, p.getTradeMethodCode());
            pstmt.setString(6, p.getPriceOfferYn());
            pstmt.setString(7, p.getProductNo());

            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result;
    }

    // 상품 번호 기준으로 기존 파일 전체 삭제
    public int deleteFilesByProductNo(Connection conn, String productNo) {
        PreparedStatement pstmt = null;
        int result = 0;
        String query = "DELETE FROM TBL_FILE WHERE PRODUCT_NO = ?";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(pstmt);
        }

        return result;
    }


}
   

    
