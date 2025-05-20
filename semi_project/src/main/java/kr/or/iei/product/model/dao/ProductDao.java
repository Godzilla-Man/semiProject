package kr.or.iei.product.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.or.iei.category.model.vo.Category;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.vo.Files;
import kr.or.iei.product.model.vo.Product;
import kr.or.iei.product.model.vo.WishList;

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
            String query2 = "INSERT INTO TBL_PROD VALUES (?, ?, ?, ?, ?, ?, ?, ?, DEFAULT, DEFAULT)";
            pstmt = conn.prepareStatement(query2);
            pstmt.setString(1, p.getProductNo());
            pstmt.setString(2, p.getMemberNo());
            pstmt.setString(3, p.getProductName());
            pstmt.setString(4, p.getProductIntrod());
            pstmt.setInt(5, p.getProductPrice());
            pstmt.setString(6, p.getCategoryCode());
            pstmt.setString(7, p.getTradeMethodCode());
            pstmt.setString(8, "S01"); // 기본 상태코드: 판매중

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

	public Category selectCategory(Connection conn, String category) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select s.category_name as small_ctg_name, m.category_name as mid_ctg_name, l.category_name as lar_ctg_name from tbl_prod_category s join tbl_prod_category m on (s.par_category_code = m.category_code) join tbl_prod_category l on(m.par_category_code = l.category_code) where s.category_code = ?";
		
		Category ctg = null;
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, category);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				ctg = new Category();
				ctg.setCategoryName(rset.getString("small_ctg_name"));
				ctg.setMidCategoryName(rset.getString("mid_ctg_name"));
				ctg.setLarCategoryName(rset.getString("lar_ctg_name"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return ctg;
	}

	public ArrayList<Product> searchProductName(Connection conn, String productName) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select product_no, product_name, product_price from tbl_prod where product_name like ?";
		
		ArrayList<Product> productList = new ArrayList<Product>();
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, "%" + productName + "%");
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Product p = new Product();
				p.setProductNo(rset.getString("product_no"));
				p.setProductName(rset.getString("product_name"));
				p.setProductPrice(rset.getInt("product_price"));
				
				productList.add(p);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return productList;
	}

	public ArrayList<Product> searchMemberNickname(Connection conn, String memberNickname) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select product_no, product_name, product_price from tbl_prod where member_no = (select member_no from tbl_member where member_nickname = ?)";
		
		ArrayList<Product> productList = new ArrayList<Product>();
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, memberNickname);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Product p = new Product();
				p.setProductNo(rset.getString("product_no"));
				p.setProductName(rset.getString("product_name"));
				p.setProductPrice(rset.getInt("product_price"));
				
				productList.add(p);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return productList;
	}

	public ArrayList<Product> selectAllListDesc(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String qeury = "select * from tbl_prod order by enroll_date desc";
		
		ArrayList<Product> productList = new ArrayList<Product>();
		
		try {
			pstmt = conn.prepareStatement(qeury);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Product p = new Product();
				p.setProductNo(rset.getString("product_no"));
				p.setProductName(rset.getString("product_name"));
				p.setProductPrice(rset.getInt("product_price"));
				
				productList.add(p);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return productList;
	}

	public ArrayList<Product> selectCategoryList(Connection conn, String category) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select product_no, product_name, product_price from tbl_prod where category_code = ?";
		
		ArrayList<Product> productCtgList = new ArrayList<Product>();
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, category);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Product p = new Product();
				p.setProductNo(rset.getString("product_no"));
				p.setProductName(rset.getString("product_name"));
				p.setProductPrice(rset.getInt("product_price"));
				
				productCtgList.add(p);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return productCtgList;
	}

	public int addWishList(Connection conn, String memberNo, String productNo) {
		PreparedStatement pstmt = null;
		
		String query = "insert into tbl_wishlist values (seq_wishlist.nextval, ?, ?, sysdate)";
		
		int result = 0;
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, productNo);
			pstmt.setString(2, memberNo);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}

	public WishList selectWishList(Connection conn, String memberNo, String productNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select * from tbl_wishlist where product_no = ? and member_no = ?";
		
		WishList wishList = null;
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, productNo);
			pstmt.setString(2, memberNo);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				wishList = new WishList();
				wishList.setWishListNo(rset.getInt("wishlist_no"));
				wishList.setProductNo(rset.getString("product_no"));
				wishList.setMemberNo(rset.getString("member_no"));
				wishList.setWishListDate(rset.getString("wishlist_date"));
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return wishList;
	}

	public Product selectMyProd(Connection conn, String memberNo, String productNo) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = "select * from tbl_prod where member_no = ? and product_no = ?";
		
		Product prod = null;
		
		try {
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, memberNo);
			pstmt.setString(2, productNo);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				prod = new Product();
				prod.setMemberNo(memberNo);
				prod.setProductNo(productNo);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		return prod;
	}

	public ArrayList<Product> selectAllListAsc(Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String qeury = "select * from tbl_prod order by enroll_date asc";
		
		ArrayList<Product> productList = new ArrayList<Product>();
		
		try {
			pstmt = conn.prepareStatement(qeury);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				Product p = new Product();
				p.setProductNo(rset.getString("product_no"));
				p.setProductName(rset.getString("product_name"));
				p.setProductPrice(rset.getInt("product_price"));
				
				productList.add(p);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(rset);
			JDBCTemplate.close(pstmt);
		}
		
		return productList;
	}
    
}
