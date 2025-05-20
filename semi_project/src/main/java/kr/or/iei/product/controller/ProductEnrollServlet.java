package kr.or.iei.product.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import kr.or.iei.file.model.vo.Files;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.product.model.vo.Product;
import kr.or.iei.product.model.service.ProductService;

@WebServlet("/product/enroll")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50, // 50MB
    fileSizeThreshold = 1024 * 1024 * 1 // 1MB 이상은 디스크에 저장
)
public class ProductEnrollServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ProductEnrollServlet() {
        super();
    }
    
    	@Override
    	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 판매 글 등록 페이지로 이동
        request.getRequestDispatcher("/WEB-INF/views/product/productEnroll.jsp").forward(request, response);
    	}

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. 인코딩 - 필터에서 처리됨
        // 2. 클라이언트가 전송한 값 추출

        String productName = request.getParameter("productName");
        String productIntrod = request.getParameter("productIntrod");
        int productPrice = Integer.parseInt(request.getParameter("productPrice"));
        String tradeMethodCode = request.getParameter("tradeMethodCode");
        String categoryCode = request.getParameter("categoryCode");
        
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginMember") == null) {
            // 로그인하지 않은 사용자는 로그인 페이지로 리다이렉트
            response.sendRedirect("/member/loginFrm");
            return;
        }

        // 세션에서 로그인한 회원 정보 꺼내기
        Member loginMember = (Member) session.getAttribute("loginMember");
        String memberNo = loginMember.getMemberNo(); // 로그인한 회원의 고유번호 추출


        // 파일 저장 경로 (서버 내 실제 경로)
        String uploadPath = getServletContext().getRealPath("/resources/upload/product");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // 업로드된 이미지 파일 리스트 수집
        List<Files> fileList = new ArrayList<>();
        for (Part part : request.getParts()) {
            if (part.getName().equals("productImages") && part.getSize() > 0) {
            	String originName = part.getSubmittedFileName().replaceAll("[^a-zA-Z0-9._-]", "_");


                // 중복 방지를 위한 새로운 파일명 생성 (ex: timestamp_파일명)
                String newFileName = System.currentTimeMillis() + "_" + originName;
                part.write(uploadPath + "/" + newFileName);

                // 파일 객체 생성
                Files file = new Files();
                file.setFileName(originName);
                file.setFilePath("/resources/upload/product/" + newFileName);
                fileList.add(file);
            }
        }

        // 3. 로직 처리 - 서비스 호출 → 상품 + 파일 등록
        Product p = new Product();
        p.setProductName(productName);
        p.setProductIntrod(productIntrod);
        p.setProductPrice(productPrice);
        String priceOfferYn = request.getParameter("priceOffer");
        if (priceOfferYn == null) {
            priceOfferYn = "N";
        }
        p.setPriceOfferYn(priceOfferYn);
        p.setCategoryCode(categoryCode);
        p.setTradeMethodCode(tradeMethodCode);
        p.setMemberNo(memberNo);
        p.setStatusCode("S01"); // 등록 시 기본 상태 = 판매 중
        
        //enrollDate, readCount는 기본값 처리

        int result = new ProductService().insertProduct(p, fileList);

        // 4. 결과 처리
        // 4.1 이동할 JSP 페이지 경로 지정
        // 4.2 화면 구현에 필요한 데이터 등록
        if (result > 0) {
            // 등록 성공 시 상세페이지로 리다이렉트
        	String priceOffer = request.getParameter("priceOffer") != null ? "true" : "false";
        	response.sendRedirect(request.getContextPath() + "/product/detail?no=" + p.getProductNo() + "&priceOffer=" + priceOffer);
        } else {
            // 등록 실패 시 실패 페이지로 포워드
            request.setAttribute("msg", "상품 등록에 실패했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/product/enrollFail.jsp").forward(request, response);
        }

    }
}
