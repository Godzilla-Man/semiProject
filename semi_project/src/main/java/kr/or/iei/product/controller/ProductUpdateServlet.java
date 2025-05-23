package kr.or.iei.product.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import kr.or.iei.file.model.vo.Files;
import kr.or.iei.product.model.service.ProductService;
import kr.or.iei.product.model.vo.Product;

@WebServlet("/product/update")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50, // 전체 요청 50MB까지 허용
    fileSizeThreshold = 1024 * 1024 // 1MB 넘으면 디스크 임시 저장
)
public class ProductUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 인코딩 설정
        request.setCharacterEncoding("UTF-8");

        // 2. 파일 저장 경로 지정 (서버 내부 실제 경로)
        String savePath = getServletContext().getRealPath("/resources/upload/product");

        // 저장 경로 존재 확인 및 없으면 생성
        File dir = new File(savePath);
        if (!dir.exists()) {
			dir.mkdirs();
		}

        // 3. 일반 텍스트 데이터 추출
        String productNo = request.getParameter("productNo");
        String productName = request.getParameter("productName");
        String productIntro = request.getParameter("productIntrod");
        int productPrice = Integer.parseInt(request.getParameter("productPrice"));
        String categoryCode = request.getParameter("categoryCode");
        String tradeMethodCode = request.getParameter("tradeMethodCode");
        String priceOfferYn = request.getParameter("priceOffer");
        if (priceOfferYn == null) {
            priceOfferYn = "N"; //  체크하지 않은 경우 N으로 처리
        }

        // 4. 상품 객체 생성
        Product p = new Product();
        p.setProductNo(productNo);
        p.setProductName(productName);
        p.setProductIntrod(productIntro);
        p.setProductPrice(productPrice);
        p.setCategoryCode(categoryCode);
        p.setTradeMethodCode(tradeMethodCode);
        p.setPriceOfferYn(priceOfferYn);

        // 5. 첨부파일 처리 (multipart/form-data의 Part 객체 사용)
        List<Files> fileList = new ArrayList<>();

        for (Part part : request.getParts()) {
            // 업로드 input name이 productImages일 경우만 처리
            if (part.getName().equals("productImages") && part.getSize() > 0) {
                String submittedFileName = part.getSubmittedFileName(); // 원본 파일명

                // 저장할 서버 측 파일명 생성 (중복 방지)
                String renamedFile = UUID.randomUUID().toString() + "_" + submittedFileName;
                String fullPath = savePath + File.separator + renamedFile;

                // 파일 저장
                part.write(fullPath);

                // DB 저장용 파일 객체 생성
                Files f = new Files();
                f.setProductNo(productNo);
                f.setFileName(submittedFileName);
                f.setFilePath("/resources/upload/product/" + renamedFile);
                fileList.add(f);
            }
        }
        // 6. 서비스 호출 (기존 파일 삭제 후 새 이미지 등록)
        ProductService service = new ProductService();
        int result = service.updateProductWithFreshFiles(p, fileList);

        // 7. 결과 처리
        if (result > 0) {
            response.sendRedirect("/product/detail?no=" + productNo);
        } else {
            request.setAttribute("msg", "상품 수정에 실패했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
        }
    }
}