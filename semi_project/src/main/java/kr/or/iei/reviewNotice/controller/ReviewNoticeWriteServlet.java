package kr.or.iei.reviewNotice.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
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
import kr.or.iei.reviewNotice.model.service.ReviewNoticeService;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;

@WebServlet("/review/write")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 55
)
public class ReviewNoticeWriteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/review/writeFrm");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginMember") == null) {
            request.setAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            request.getRequestDispatcher("/WEB-INF/views/member/login.jsp").forward(request, response); // 실제 로그인 페이지
            return;
        }
        Member loginMember = (Member) session.getAttribute("loginMember");

        String postTitle = request.getParameter("postTitle");
        String postContent = request.getParameter("postContent");
        String orderNo = request.getParameter("orderNo");
        String categoryCodeFromForm = request.getParameter("categoryCode");

        ReviewNotice rn = new ReviewNotice();
        rn.setPostTitle(postTitle);
        rn.setPostContent(postContent);
        rn.setOrderNo(orderNo);
        rn.setMemberNo(loginMember.getMemberNo());
        rn.setCategoryCode(categoryCodeFromForm);

        if (orderNo == null || orderNo.trim().isEmpty()) {
            request.setAttribute("errorMsg", "주문번호는 필수입니다. 리뷰를 작성할 주문을 선택(입력)해주세요.");
            request.setAttribute("reviewNotice", rn);
            request.getRequestDispatcher("/WEB-INF/views/reviewnotice/reviewWrite.jsp").forward(request, response);
            return;
        }

        ArrayList<Files> fileList = new ArrayList<>();
        String root = getServletContext().getRealPath("/"); 
        String saveDirectory = root + "resources/upload" + File.separator + "reviewnotice"; 

        File directory = new File(saveDirectory);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        boolean fileProcessingError = false;
        try {
            for (Part part : request.getParts()) {
                if (part.getName().equals("files") && part.getSize() > 0) {
                    String originalFileName = part.getSubmittedFileName();
                    if (originalFileName != null && !originalFileName.isEmpty()) {
                        String extension = "";
                        int dotIndex = originalFileName.lastIndexOf(".");
                        if (dotIndex > -1 && dotIndex < originalFileName.length() - 1) {
                            extension = originalFileName.substring(dotIndex); 
                        }
                        String newFileName = "review_" + System.currentTimeMillis() + "_" + (int)(Math.random()*10000) + extension;
                        part.write(saveDirectory + File.separator + newFileName);

                        Files fileVo = new Files();
                        fileVo.setFileName(originalFileName); 
                        fileVo.setFilePath("/resources/upload/reviewnotice/" + newFileName); 
                        fileList.add(fileVo);
                    }
                }
            }
        } catch (IOException | ServletException e) {
            e.printStackTrace();
            fileProcessingError = true;
            for(Files fVo : fileList) { 
                if (fVo.getFilePath() != null) {
                    String uploadedFileName = fVo.getFilePath().substring(fVo.getFilePath().lastIndexOf("/") + 1);
                    File createdFile = new File(saveDirectory + File.separator + uploadedFileName);
                    if(createdFile.exists()) createdFile.delete();
                }
            }
            fileList.clear();
        }

        if(fileProcessingError){
            request.setAttribute("errorMsg", "파일 업로드 중 오류가 발생했습니다.");
            request.setAttribute("reviewNotice", rn);
            request.getRequestDispatcher("/WEB-INF/views/reviewnotice/reviewWrite.jsp").forward(request, response);
            return;
        }
        
        ReviewNoticeService service = new ReviewNoticeService();
        int result = service.insertReviewNotice(rn, fileList); 

        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/review/detail?stylePostNo=" + rn.getStylePostNo());
        } else {
            for(Files fVo : fileList) {
                if (fVo.getFilePath() != null) {
                    String uploadedFileName = fVo.getFilePath().substring(fVo.getFilePath().lastIndexOf("/") + 1);
                    File failedFile = new File(saveDirectory + File.separator + uploadedFileName);
                    if(failedFile.exists()) failedFile.delete();
                }
            }
            request.setAttribute("errorMsg", "게시글 등록에 실패했습니다.");
            request.setAttribute("reviewNotice", rn);
            RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/reviewnotice/reviewWrite.jsp");
            view.forward(request, response);
        }
    }
}