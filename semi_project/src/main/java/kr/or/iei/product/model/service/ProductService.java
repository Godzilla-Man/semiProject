package kr.or.iei.product.model.service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import kr.or.iei.comment.model.vo.Comment;
import kr.or.iei.admin.model.vo.ReportPost;
import kr.or.iei.category.model.vo.Category;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.dao.FileDao;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.order.model.vo.Purchase;
import kr.or.iei.product.model.dao.ProductDao;
import kr.or.iei.product.model.vo.Product;
import kr.or.iei.product.model.vo.SalesProduct;
import kr.or.iei.product.model.vo.WishList;

public class ProductService {

    private ProductDao dao;
    private FileDao fileDao;
    
    public ProductService() {
    	
    	dao = new ProductDao();
    	fileDao = new FileDao();
    }

    /**
     * 상품과 첨부파일을 함께 등록하는 서비스 메서드
     * 트랜잭션 처리 포함
     * @param p 상품 정보 객체
     * @param fileList 첨부파일 리스트
     * @return 성공 시 양수, 실패 시 0 이하
     */
    
    public int insertProduct(Product p, List<Files> fileList) {
        Connection conn = JDBCTemplate.getConnection();

        // 1. 상품 정보 먼저 등록 → 상품 번호 자동 생성됨
        int result1 = dao.insertProduct(conn, p); // insert 시 p 객체에 productNo 세팅될 것

        int result2 = 1; // 파일 없을 경우 대비: 기본값은 성공

        // 2. 파일이 있을 경우에만 파일 정보 insert 진행
        if (result1 > 0 && fileList != null && !fileList.isEmpty()) {
            // 각 파일에 상품 번호 세팅
            for (Files f : fileList) {
                f.setProductNo(p.getProductNo());
            }

            result2 = dao.insertFiles(conn, fileList);
        }

        // 3. 트랜잭션 처리 (둘 다 성공해야 커밋)
        if (result1 > 0 && result2 > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }

        JDBCTemplate.close(conn);

        // 4. 결과 반환
        return result1 * result2; // 둘 다 성공해야 양수, 아니면 0 또는 음수
    }

    /**
     * 상품 1개 상세 조회 서비스
     * @param productNo 조회할 상품 번호
     * @return 해당 상품 정보 (없으면 null)
     */
    
    public Product selectOneProduct(String productNo) {
        Connection conn = JDBCTemplate.getConnection();

        Product p = dao.selectOneProduct(conn, productNo);

        JDBCTemplate.close(conn);
        return p;
    }

    /**
     * 상품 이미지 파일 목록 조회 서비스
     *
     * @param productNo 조회할 상품 번호 (예: "P2405190001")
     * @return 해당 상품에 등록된 이미지 파일 목록 (List<Files>)
     */
    
    public List<Files> selectProductFiles(String productNo) {
        // 1. DB 연결 생성
        Connection conn = JDBCTemplate.getConnection();

        // 2. DAO를 통해 파일 목록 조회
        List<Files> fileList = dao.selectProductFiles(conn, productNo);

        // 3. 연결 해제
        JDBCTemplate.close(conn);

        // 4. 결과 반환
        return fileList;
    }

    /**
     * 특정 상품에 등록된 댓글 목록 조회 서비스
     *
     * @param productNo 댓글을 조회할 대상 상품 번호
     * @return          해당 상품의 댓글 리스트 (List<Comment>)
     */
    
    public List<Comment> selectProductComments(String productNo) {
        // 1. DB 연결 생성
        Connection conn = JDBCTemplate.getConnection();

        // 2. DAO 호출 → 상품 번호에 해당하는 댓글 리스트 조회
        List<Comment> list = dao.selectProductComments(conn, productNo);

        // 3. 연결 해제
        JDBCTemplate.close(conn);

        // 4. 결과 반환
        return list;
    }

    /**
     * 상품 판매자의 회원 정보 조회
     *
     * @param memberNo 판매자의 회원 번호
     * @return         판매자 정보가 담긴 Member 객체
     */
    public Member selectSellerInfo(String memberNo) {
        // 1. DB 연결
        Connection conn = JDBCTemplate.getConnection();

        // 2. DAO를 통해 판매자 정보 조회
        Member seller = dao.selectSellerInfo(conn, memberNo);

        // 3. 연결 해제
        JDBCTemplate.close(conn);

        // 4. 결과 반환
        return seller;
    }

    /**
     * 댓글 등록 서비스
     * 
     * @param c 등록할 댓글 객체 (productNo, memberNo, content 포함)
     * @return 등록 성공 여부 (1: 성공, 0: 실패)
     */
    
    public int insertComment(Comment c) {
        // 1. DB 연결 생성
        Connection conn = JDBCTemplate.getConnection();

        // 2. DAO 호출
        int result = dao.insertComment(conn, c);

        // 3. 트랜잭션 처리
        if (result > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }

        // 4. 연결 해제
        JDBCTemplate.close(conn);

        // 5. 결과 반환
        return result;
    }

    /**
     * 댓글 내용을 수정하는 서비스 메서드
     * @param c 수정할 댓글 객체 (댓글번호, 수정된 내용 포함)
     * @return 처리 결과 (1: 성공, 0: 실패)
     */
    public int updateComment(Comment c) {
        Connection conn = JDBCTemplate.getConnection();

        // DAO를 통해 댓글 수정 쿼리 수행
        int result = dao.updateComment(conn, c);

        // 트랜잭션 처리
        if (result > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }

        JDBCTemplate.close(conn);
        return result;
    }

	public int deleteComment(int commentNo) {
        Connection conn = JDBCTemplate.getConnection();

        // DAO를 통해 댓글 수정 쿼리 수행
        int result = dao.deleteComment(conn, commentNo);

        // 트랜잭션 처리
        if (result > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }

        JDBCTemplate.close(conn);
        return result;
    }
	
    // 찜 횟수 조회 메서드 추가
    public int getWishlistCount(String productNo) {
        Connection conn = JDBCTemplate.getConnection();
        int count = dao.selectWishlistCount(conn, productNo);
        JDBCTemplate.close(conn);
        return count;
    }

 // 찜 여부 확인 (이미 찜한 상태인지 여부를 확인)
    public boolean checkWishlist(String productNo, String memberNo) {
        Connection conn = JDBCTemplate.getConnection();
        boolean exists = new ProductDao().checkWishlist(conn, productNo, memberNo);
        JDBCTemplate.close(conn);
        return exists;
    }

    // 찜 추가 (TBL_WISHLIST 테이블에 새로운 찜 정보 삽입)
    public int addWishlist(String productNo, String memberNo) {
        Connection conn = JDBCTemplate.getConnection();
        int result = new ProductDao().insertWishlist(conn, productNo, memberNo);
        if (result > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }
        JDBCTemplate.close(conn);
        return result;
    }

    // 찜 해제 (TBL_WISHLIST 테이블에서 해당 찜 정보 삭제)
    public int removeWishlist(String productNo, String memberNo) {
        Connection conn = JDBCTemplate.getConnection();
        int result = new ProductDao().deleteWishlist(conn, productNo, memberNo);
        if (result > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }
        JDBCTemplate.close(conn);
        return result;
    }

    // 현재 판매자가 판매중인 상품 갯수 표시
    public int getSellingProductCount(String memberNo) {
        Connection conn = JDBCTemplate.getConnection();
        int count = dao.getSellingProductCount(conn, memberNo);
        JDBCTemplate.close(conn);
        return count;
    }

    // 조회수 증가
    public int increaseReadCount(String productNo) {
        Connection conn = JDBCTemplate.getConnection();
        int result = dao.increaseReadCount(conn, productNo);
        if (result > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }
        JDBCTemplate.close(conn);
        return result;
    }

    // 비슷한 ( 같은 소분류 카테고리 ) 제품 최근 등록 순으로 6개 출력
    public List<Product> selectRelatedProducts(String categoryCode, String currentProductNo) {
        Connection conn = JDBCTemplate.getConnection();
        List<Product> list = dao.selectRelatedProducts(conn, categoryCode, currentProductNo);
        JDBCTemplate.close(conn);
        return list;
    }

    // 상품 논리 삭제: 상태코드를 'S99'로 변경
    public int markProductAsDeleted(String productNo) {
        Connection conn = JDBCTemplate.getConnection();

        // statusCode를 'S99'로 설정 (삭제 상태)
        int result = new ProductDao().updateProductStatus(conn, productNo, "S99");

        if (result > 0) {
            JDBCTemplate.commit(conn);  // 성공 시 커밋
        } else {
            JDBCTemplate.rollback(conn);  // 실패 시 롤백
        }

        JDBCTemplate.close(conn);
        return result;
    }
    
 /* 
    @Deprecated
    // 상품 수정 후 DB에 재등록 메서드
    // 상품 수정 시 기존 이미지 삭제 후 새로 업로드된 이미지로 대체
    // 파일이 없는 경우에도 기존 이미지 삭제만 수행됨
    
    public int updateProduct(Product p, List<Files> fileList) {
        Connection conn = JDBCTemplate.getConnection();

        // 1. 상품 기본 정보 업데이트
        int result1 = dao.updateProduct(conn, p);

        // 2. 기존 파일 삭제
        int result2 = dao.deleteFilesByProductNo(conn, p.getProductNo());

        // 3. 새 파일 등록 (파일이 있을 경우)
        int result3 = 1;
        if (fileList != null && !fileList.isEmpty()) {
            for (Files f : fileList) {
                f.setProductNo(p.getProductNo());
            }
            result3 = dao.insertFiles(conn, fileList);
        }

        // 4. 트랜잭션 처리
        if (result1 > 0 && result2 >= 0 && result3 > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }

        JDBCTemplate.close(conn);
        return result1 * result3;
    }
*/
    
    
    // 사진 수정시, 기존 사진들 다 삭제후 새로운 사진만 업로드.
    public int updateProductWithFreshFiles(Product p, List<Files> fileList) {
        Connection conn = JDBCTemplate.getConnection();

        // 1. 상품 기본 정보 업데이트
        int result1 = dao.updateProduct(conn, p);

        // 2. 기존 파일 모두 삭제
        int result2 = dao.deleteFilesByProductNo(conn, p.getProductNo());

        // 3. 새 파일들 DB에 등록
        int result3 = 1; // 파일이 없을 경우 성공 상태 유지
        if (fileList != null && !fileList.isEmpty()) {
            for (Files f : fileList) {
                f.setProductNo(p.getProductNo()); // 상품 번호 설정
            }
            result3 = dao.insertFiles(conn, fileList);
        }

        // 4. 트랜잭션 처리
        if (result1 > 0 && result2 >= 0 && result3 > 0) {
            JDBCTemplate.commit(conn);
        } else {
            JDBCTemplate.rollback(conn);
        }

        JDBCTemplate.close(conn);
        return result1 * result3; // 하나라도 실패하면 0 이하
    }

    public Category selectCategory(String categoryCode) {
        Connection conn = JDBCTemplate.getConnection();
        Category ctg = dao.selectCategory(conn, categoryCode);
        JDBCTemplate.close(conn);
        return ctg;
    }

	//상품명으로 검색 시 최신순 상품 리스트
	public ArrayList<Product> searchProdcutNameDesc(String productName, String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchProductNameDesc(conn, productName, memberNo);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	//작성자 닉네임으로 검색 시 최신순 상품 리스트
	public ArrayList<Product> searchMemberNicknameDesc(String memberNickname, String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchMemberNicknameDesc(conn, memberNickname, memberNo);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	// 최신순 전체 상품 리스트 조회 (삭제상품 포함 여부 분기)
	public ArrayList<Product> selectAllListDesc(String memberNo, String memberId) {
	    Connection conn = JDBCTemplate.getConnection();

	    // memberId가 "admin"일 경우 삭제상품도 포함
	    boolean isAdmin = "admin".equals(memberId);

	    ArrayList<Product> list = dao.selectAllListDesc(conn, memberNo, isAdmin);

	    JDBCTemplate.close(conn);
	    return list;
	}


	//카테고리별 상품 리스트
	public ArrayList<Product> selectCategoryListDesc(String categoryCode, String memberNo, boolean isAdmin) {
	    Connection conn = JDBCTemplate.getConnection();
	    ArrayList<Product> list = dao.selectCategoryListDesc(conn, categoryCode, memberNo, isAdmin); // 오버로딩된 DAO 메서드 호출
	    JDBCTemplate.close(conn);
	    return list;
	}


	//찜하기 등록
	public int addWishList(String memberNo, String productNo) {
		Connection conn = JDBCTemplate.getConnection();
		//내가 등록한 상품인지
		int result = -2;
		Product prod = dao.selectMyProd(conn, memberNo, productNo);
		
		if(prod == null) { //내가 등록한 상품이 아님
			//내가 찜한 리스트에 존재하는지
			result = -1;
			WishList wishList = dao.selectWishList(conn, memberNo, productNo);
			
			if(wishList == null) { //리스트에 존재X	
				result = 0;
				//찜하기 리스트에 추가
				result = dao.addWishList(conn, memberNo, productNo);
				if(result > 0) {
					JDBCTemplate.commit(conn);
				}else {
					JDBCTemplate.rollback(conn);
				}
			}
		}
		
		return result; //-2 : 내가 등록한 상품, -1 : 이미 찜한 상품, 0 : 리스트에 추가 실패, 1 : 리스트에 추가 성공
	}

	//오래된순 전체 상품 리스트
	public ArrayList<Product> selectAllListAsc(String memberNo, String memberId) {
	    Connection conn = JDBCTemplate.getConnection();

	    // admin 여부 판단
	    boolean isAdmin = "admin".equals(memberId);

	    // 관리자 여부에 따라 삭제상품 필터 분기
	    ArrayList<Product> list = dao.selectAllListAsc(conn, memberNo, isAdmin);

	    JDBCTemplate.close(conn);
	    return list;
	}

	//찜하기 삭제
	public int delWishList(String memberNo, String productNo) {
		Connection conn = JDBCTemplate.getConnection();
		int result = dao.delWishList(conn, memberNo, productNo);
		JDBCTemplate.close(conn);
		
		return result;
	}
	
	//최저가순 전체 상품 리스트
	public ArrayList<Product> selectAllListCheap(String memberNo, String memberId) {
	    Connection conn = JDBCTemplate.getConnection();

	    boolean isAdmin = "admin".equals(memberId);  //  관리자 여부 판단
	    ArrayList<Product> list = dao.selectAllListCheap(conn, memberNo, isAdmin);

	    JDBCTemplate.close(conn);
	    return list;
	}

	//최고가순 전체 상품 리스트
	public ArrayList<Product> selectAllListExpen(String memberNo, String memberId) {
	    Connection conn = JDBCTemplate.getConnection();

	    boolean isAdmin = "admin".equals(memberId);  // 관리자 여부 판단

	    ArrayList<Product> list;
	    if (isAdmin) {
	        list = dao.selectAllListExpen(conn, memberNo);  // 기존 방식
	    } else {
	        list = dao.selectAllListExpen(conn, memberNo, false);  // 삭제 필터링
	    }

	    JDBCTemplate.close(conn);
	    return list;
	}


	//가격설정 전체 상품 리스트
	public ArrayList<Product> selectAllListPrice(String memberNo, String min, String max, String memberId) {
		Connection conn = JDBCTemplate.getConnection();
		boolean isAdmin = "admin".equals(memberId);
		ArrayList<Product> list = dao.selectAllListPrice(conn, memberNo, min, max, isAdmin);
		JDBCTemplate.close(conn);
		return list;
	}


	// 카테고리별 오래된순 상품 리스트
	public ArrayList<Product> selectCategoryListAsc(String categoryCode, String memberNo, boolean isAdmin) {
	    Connection conn = JDBCTemplate.getConnection();
	    ArrayList<Product> list = dao.selectCategoryListAsc(conn, categoryCode, memberNo, isAdmin);  // ✅ 오버로딩된 메서드 호출
	    JDBCTemplate.close(conn);
	    return list;
	}

	//카테고리별 최저가순 상품 리스트
	public ArrayList<Product> selectCategoryListCheap(String categoryCode, String memberNo, boolean isAdmin) {
	    Connection conn = JDBCTemplate.getConnection();
	    ArrayList<Product> list = dao.selectCategoryListCheap(conn, categoryCode, memberNo, isAdmin); // 오버로딩 메서드 호출
	    JDBCTemplate.close(conn);
	    return list;
	}

	//카테고리별 최고가순 상품 리스트
	public ArrayList<Product> selectCategoryListExpen(String categoryCode, String memberNo, boolean isAdmin) {
	    Connection conn = JDBCTemplate.getConnection();
	    ArrayList<Product> list = dao.selectCategoryListExpen(conn, categoryCode, memberNo, isAdmin); // 오버로딩된 DAO 호출
	    JDBCTemplate.close(conn);
	    return list;
	}

	//카테고리별 가격설정 상품 리스트
	public ArrayList<Product> selectCategoryListPrice(String category, String memberNo, String min, String max, String memberId) {
	    Connection conn = JDBCTemplate.getConnection();
	    boolean isAdmin = "admin".equals(memberId);
	    ArrayList<Product> list = dao.selectCategoryListPrice(conn, category, memberNo, min, max, isAdmin);
	    JDBCTemplate.close(conn);
	    return list;
	}


	//상품명으로 검색 시 오래된순 상품 리스트
	public ArrayList<Product> searchProdcutNameAsc(String productName, String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchProductNameAsc(conn, productName, memberNo);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	//작성자 닉네임으로 검색 시 오래된순 상품 리스트
	public ArrayList<Product> searchMemberNicknameAsc(String memberNickname, String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchMemberNicknameAsc(conn, memberNickname, memberNo);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	//상품명으로 검색 시 최저가순 상품 리스트
	public ArrayList<Product> searchProdcutNameCheap(String productName, String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchProductNameCheap(conn, productName, memberNo);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	//작성자 닉네임으로 검색 시 최저가순 상품 리스트
	public ArrayList<Product> searchMemberNicknameCheap(String memberNickname, String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchMemberNicknameCheap(conn, memberNickname, memberNo);
		JDBCTemplate.close(conn);
		
		return productList;
	}
	
	//상품명으로 검색 시 최고가순 상품 리스트
	public ArrayList<Product> searchProdcutNameExpen(String productName, String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchProductNameExpen(conn, productName, memberNo);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	//작성자 닉네임으로 검색 시 최고가순 상품 리스트
	public ArrayList<Product> searchMemberNicknameExpen(String memberNickname, String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchMemberNicknameExpen(conn, memberNickname, memberNo);
		JDBCTemplate.close(conn);
		
		return productList;
	}
	
	//상품명으로 검색 시 가격설정 상품 리스트
	public ArrayList<Product> searchProdcutNamePrice(String productName, String memberNo, String min, String max) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchProductNamePrice(conn, productName, memberNo, min, max);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	//작성자 닉네임으로 검색 시 가격설정 상품 리스트
	public ArrayList<Product> searchMemberNicknamePrice(String memberNickname, String memberNo, String min, String max) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchMemberNicknamePrice(conn, memberNickname, memberNo, min, max);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	// 현재 판매중인 상품 연동
	public List<Product> selectSellingProductByMember(String memberNo) {
	    Connection conn = JDBCTemplate.getConnection();
	    List<Product> list = new ProductDao().selectSellingProductByMember(conn, memberNo);
	    JDBCTemplate.close(conn);
	    return list;
	}

	// 특정 판매자의 거래 완료(S07 상태) 상품 수를 조회하는 서비스 메서드
	public int countCompletedSalesByMember(String memberNo) {
	    Connection conn = JDBCTemplate.getConnection();

	    // DAO 메서드 호출하여 거래 완료 수 조회
	    int count = dao.countCompletedSalesByMember(conn, memberNo);

	    JDBCTemplate.close(conn);
	    return count;
	}

	//특정 회원(판매자)의 좋아요 또는 싫어요 개수를 조회하는 서비스 메서드
	public int countReactionsByMember(String memberNo, char type) {
	    Connection conn = JDBCTemplate.getConnection();
	    
	    // DAO 메서드 호출하여 반응 수 조회
	    int count = dao.countReactionsByMember(conn, memberNo, type);
	    
	    JDBCTemplate.close(conn);
	    return count;
	}

	// 해당 회원이 특정 대상에게 특정 반응을 이미 했는지 확인
	public boolean hasReaction(String reactMemberNo, String targetMemberNo, char type) {
	    Connection conn = JDBCTemplate.getConnection();
	    boolean exists = dao.hasReaction(conn, reactMemberNo, targetMemberNo, type);
	    JDBCTemplate.close(conn);
	    return exists;
	}

	//반응 기록을 새로 추가 (좋아요 또는 싫어요)
	public int insertReaction(String reactMemberNo, String targetMemberNo, char type) {
	    Connection conn = JDBCTemplate.getConnection();
	    int result = dao.insertReaction(conn, reactMemberNo, targetMemberNo, type);

	    if (result > 0) {
	        JDBCTemplate.commit(conn);
	    } else {
	        JDBCTemplate.rollback(conn);
	    }

	    JDBCTemplate.close(conn);
	    return result;
	}

		//기존 반응 기록을 삭제 (좋아요 또는 싫어요 취소)
	public int deleteReaction(String reactMemberNo, String targetMemberNo, char type) {
	    Connection conn = JDBCTemplate.getConnection();
	    int result = dao.deleteReaction(conn, reactMemberNo, targetMemberNo, type);

	    if (result > 0) {
	        JDBCTemplate.commit(conn);
	    } else {
	        JDBCTemplate.rollback(conn);
	    }

	    JDBCTemplate.close(conn);
	    return result;
	}
	
	 
	// ★동주★ 판매 내역 정보를 추출하기 위한 service 메소드!! 시작
	public List<SalesProduct> getMySalesList(String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		List<SalesProduct> salesList = dao.getMySaleList(conn, memberNo);	
		
		for (SalesProduct sp : salesList) {
            if (sp.getProductNo() != null && !sp.getProductNo().isEmpty()) {                
                String thumbnailPath = fileDao.selectThumbnail(conn, sp.getProductNo());
                sp.setThumbnailPath(thumbnailPath); // SalesProduct VO에 썸네일 경로 설정
            }
        }
		
		JDBCTemplate.close(conn);
		return salesList;		
	}
	// ★동주★ 판매 내역 정보를 추출하기 위한 service 메소드!! 끝

	// 일반 사용자에게 상품 목록 출력 메서드
	public List<Product> selectVisibleRelatedProducts(String categoryCode, String currentProductNo) {
	    Connection conn = JDBCTemplate.getConnection();
	    List<Product> list = dao.selectVisibleProducts(conn, categoryCode, currentProductNo);
	    JDBCTemplate.close(conn);
	    return list;
	}

	public List<Product> selectRelatedProductsAdmin(String categoryCode, String productNo) {
	    Connection conn = JDBCTemplate.getConnection();
	    List<Product> list = new ProductDao().selectRelatedProductsAdmin(conn, categoryCode, productNo);
	    JDBCTemplate.close(conn);
	    return list;
	}
	
	// 신고사유 리스트 불러오기
	public List<ReportPost> getReportReasonList() {
	    Connection conn = JDBCTemplate.getConnection();
	    List<ReportPost> list = dao.selectReportReasonList(conn);
	    JDBCTemplate.close(conn);
	    return list;
	}

	public ArrayList<Product> selectMemberWishList(String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.selectMemberWishList(conn, memberNo);
		JDBCTemplate.close(conn);
		
		return productList;
	}

}




