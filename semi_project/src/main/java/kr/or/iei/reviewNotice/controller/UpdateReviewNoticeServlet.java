package kr.or.iei.reviewNotice.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import kr.or.iei.file.model.vo.Files;
import kr.or.iei.member.model.vo.Member;
import kr.or.iei.reviewNotice.model.service.ReviewNoticeService;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;

@WebServlet("/review/update")
public class UpdateReviewNoticeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("--- UpdateReviewNoticeServlet doPost() 실행됨 ---");
        HttpSession session = request.getSession();
        Member loginMember = (Member) session.getAttribute("loginMember");

        if (loginMember == null) {
            session.setAttribute("alertMsg", "로그인이 필요합니다.");
            response.sendRedirect(request.getContextPath() + "/views/member/login.jsp"); // 실제 로그인 페이지 경로
            return;
        }

        // 📌 파일 저장 기본 경로
        String saveDirectory = getServletContext().getRealPath("/resources/upload/reviewnotice");
        File RsaveDirectory = new File(saveDirectory);
        if (!RsaveDirectory.exists()) {
            RsaveDirectory.mkdirs();
        }
        int maxSize = 100 * 1024 * 1024;
        String encoding = "UTF-8";
        MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxSize, encoding, new DefaultFileRenamePolicy());

        // 폼 데이터 추출
        String stylePostNo = multi.getParameter("stylePostNo");
        String postTitle = multi.getParameter("postTitle");
        String postContent = multi.getParameter("postContent");
        String orderNo = multi.getParameter("orderNo");

        System.out.println("UpdateServlet - 수정 대상 stylePostNo: " + stylePostNo + ", postTitle: " + postTitle);

        // 삭제하도록 선택된 기존 파일들의 FILE_NO 목록
        String[] deleteFileNosStr = multi.getParameterValues("delFileNo");
        ArrayList<Integer> fileNosToDelete = new ArrayList<>();
        if (deleteFileNosStr != null) {
            for (String fileNoStr : deleteFileNosStr) {
                if (fileNoStr != null && !fileNoStr.trim().isEmpty()) {
                    try {
                        fileNosToDelete.add(Integer.parseInt(fileNoStr.trim()));
                        System.out.println("삭제 요청된 기존 파일 FILE_NO: " + fileNoStr);
                    } catch (NumberFormatException e) {
                        System.err.println("UpdateReviewNoticeServlet: 잘못된 삭제 파일 번호 형식 - " + fileNoStr);
                    }
                }
            }
        }

        ReviewNotice review = new ReviewNotice();
        review.setStylePostNo(stylePostNo);
        review.setPostTitle(postTitle);
        review.setPostContent(postContent);
        review.setOrderNo(orderNo);
        review.setMemberNo(loginMember.getMemberNo()); // 수정 시도자(로그인 사용자)

        // 새로 추가된 파일 처리 (name="addFile")
        ArrayList<Files> newFilesList = new ArrayList<>();
        String originalFileName = multi.getOriginalFileName("addFile");
        String filesystemName = multi.getFilesystemName("addFile"); // 서버에 저장된 실제 (변경된) 파일명

        if (originalFileName != null && filesystemName != null) { // 새 파일이 실제로 업로드된 경우
            System.out.println("새로 추가된 파일 원본명: " + originalFileName + ", 서버 저장명: " + filesystemName);
            Files newFile = new Files();
            newFile.setFileName(originalFileName); // 원본 파일명 (TBL_FILE.FILE_NAME 에 저장될 값)
            newFile.setFilePath("/resources/upload/reviewnotice/" + filesystemName); // (TBL_FILE.FILE_PATH 에 저장될 값)
            newFilesList.add(newFile);
        }

        ReviewNoticeService rnService = new ReviewNoticeService();
        int result = rnService.updatePost(review, newFilesList, fileNosToDelete, saveDirectory);
        System.out.println("Service updatePost 결과: " + result);

        // 결과 처리
        if (result > 0) {
            session.setAttribute("alertMsg", "게시글이 성공적으로 수정되었습니다.");
            response.sendRedirect(request.getContextPath() + "/review/detail?stylePostNo=" + stylePostNo);
        } else if (result == -1) { // 권한 없음
            session.setAttribute("alertMsg", "게시글 수정 권한이 없습니다.");
            if (!newFilesList.isEmpty() && filesystemName != null) { // 업로드 시도한 새 파일이 있다면 물리적으로 삭제
                File failedUpload = new File(saveDirectory + File.separator + filesystemName);
                if (failedUpload.exists()) {
                    if(failedUpload.delete()){ System.out.println("권한 없음 - 업로드된 새 파일 삭제 성공: " + filesystemName); }
                    else { System.err.println("권한 없음 - 업로드된 새 파일 삭제 실패: " + filesystemName); }
                }
            }
            response.sendRedirect(request.getContextPath() + "/review/detail?stylePostNo=" + stylePostNo);
        } else { // result == 0 (일반적인 수정 실패)
            session.setAttribute("alertMsg", "게시글 수정에 실패했습니다. 다시 시도해주세요.");
            if (!newFilesList.isEmpty() && filesystemName != null) { // 업로드 시도한 새 파일이 있다면 물리적으로 삭제
                File failedUpload = new File(saveDirectory + File.separator + filesystemName);
                if (failedUpload.exists()) {
                     if(failedUpload.delete()){ System.out.println("수정 실패 - 업로드된 새 파일 삭제 성공: " + filesystemName); }
                     else { System.err.println("수정 실패 - 업로드된 새 파일 삭제 실패: " + filesystemName); }
                }
            }
            response.sendRedirect(request.getContextPath() + "/review/editFrm?stylePostNo=" + stylePostNo);
        }
    }
}