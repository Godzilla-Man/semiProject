package kr.or.iei.file.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import kr.or.iei.common.JDBCTemplate;
import kr.or.iei.file.model.vo.Files;

public class FileDao {

    /**
     * 특정 상품 번호(productNo)에 해당하는 파일들 중 가장 먼저 등록된(FILE_NO가 가장 작은)
     * 파일의 경로(FILE_PATH)를 썸네일로 조회하는 메소드
     */
    public String selectThumbnail(Connection conn, String productNo) {
        PreparedStatement pstmt = null;
        ResultSet rset = null;
        String filePath = null;
        
        // ROWNUM = 1을 사용하여 정렬된 결과 중 첫 번째 행만 가져옴
        // FILE_NO를 기준으로 오름차순 정렬하여 가장 먼저 등록된 이미지를 선택
        String query = "SELECT FILE_PATH " +
                       "FROM ( " +
                       "    SELECT FILE_PATH FROM TBL_FILE " +
                       "    WHERE PRODUCT_NO = ? " +
                       "    ORDER BY FILE_NO ASC " +
                       ") WHERE ROWNUM = 1";

        try {
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productNo);
            rset = pstmt.executeQuery();

            if (rset.next()) {
                filePath = rset.getString("FILE_PATH");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCTemplate.close(rset);
            JDBCTemplate.close(pstmt);
        }
        return filePath;
    }   
}