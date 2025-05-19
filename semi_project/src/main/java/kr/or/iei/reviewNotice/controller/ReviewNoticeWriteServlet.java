package kr.or.iei.reviewNotice.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import kr.or.iei.file.model.vo.Files;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;
import kr.or.iei.category.model.vo.Category;

@WebServlet("/review/write")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5, // 개별 파일 최대 5MB
    maxRequestSize = 1024 * 1024 * 30 // 전체 요청 최대 30MB
)
public class ReviewNoticeWriteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        // 1. 기본 파라미터
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String commentEnabled = request.getParameter("commentEnabled");
        String gender = request.getParameter("genderCategory");
        String middle = request.getParameter("middleCategory");
        String small = request.getParameter("smallCategory");

        // 2. 업로드 파일 처리
        ArrayList<Files> fileList = new ArrayList<>();
        String uploadPath = getServletContext().getRealPath("/upload/review/");
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        for (Part part : request.getParts()) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String original = part.getSubmittedFileName();
                String ext = original.substring(original.lastIndexOf("."));
                String renamed = UUID.randomUUID().toString() + ext;

                part.write(uploadPath + File.separator + renamed);

                Files file = new Files();
                file.setFileName(original);
                file.setFilePath("/upload/review/" + renamed);
                fileList.add(file);
            }
        }

        // 3. 카테고리 객체 리스트 생성
        ArrayList<Category> categoryList = new ArrayList<>();

        if (gender != null && !gender.isEmpty()) {
            Category c = new Category();
            c.setCategoryCode(gender);
            c.setLarCategoryName("대분류");
            categoryList.add(c);
        }
        if (middle != null && !middle.isEmpty()) {
            Category c = new Category();
            c.setCategoryCode(middle);
            c.setMidCategoryName("중분류");
            categoryList.add(c);
        }
        if (small != null && !small.isEmpty()) {
            Category c = new Category();
            c.setCategoryCode(small);
            c.setCategoryName("소분류");
            categoryList.add(c);
        }

        // 4. VO에 세팅
        ReviewNotice rn = new ReviewNotice();
        rn.setPostTitle(title);
        rn.setPostContent(content);
        rn.setReadCount(0);
        rn.setOrderNo(null); // 주문번호 연동 시 사용
        rn.setFileList(fileList);
        rn.setCategoryList(categoryList);

        // 5. request에 저장 후 JSP 포워딩
        request.setAttribute("reviewNotice", rn);
        request.setAttribute("commentEnabled", commentEnabled);

        request.getRequestDispatcher("/WEB-INF/views/reviewnotice/reviewWrite.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED); // GET 차단
    }
}
