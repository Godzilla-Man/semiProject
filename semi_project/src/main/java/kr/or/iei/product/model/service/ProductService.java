package kr.or.iei.product.model.service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import kr.or.iei.category.model.vo.Category;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.product.model.dao.ProductDao;
import kr.or.iei.product.model.vo.Product;
import kr.or.iei.product.model.vo.WishList;

public class ProductService {

    private ProductDao dao;
    
    public ProductService() {
    	dao = new ProductDao();
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

	public Category selectCategory(String category) {
		Connection conn = JDBCTemplate.getConnection();
		Category ctg = dao.selectCategory(conn, category);
		JDBCTemplate.close(conn);
		
		return ctg;
	}

	public ArrayList<Product> searchProdcutName(String productName) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchProductName(conn, productName);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	public ArrayList<Product> searchMemberNickname(String memberNickname) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productList = dao.searchMemberNickname(conn, memberNickname);
		JDBCTemplate.close(conn);
		
		return productList;
	}

	public ArrayList<Product> selectAllList() {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productAllList = dao.selectAllList(conn);
		JDBCTemplate.close(conn);
		
		return productAllList;
	}

	public ArrayList<Product> selectCategoryList(String category) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<Product> productCtgList = dao.selectCategoryList(conn, category);
		JDBCTemplate.close(conn);
		
		return productCtgList;
	}

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

	public ArrayList<WishList> selectMemberWishList(String memberNo) {
		Connection conn = JDBCTemplate.getConnection();
		ArrayList<WishList> memberWishList = dao.selectMemberWishList(conn, memberNo);
		JDBCTemplate.close(conn);
		
		return memberWishList;
	}

}
