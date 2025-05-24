package kr.or.iei.reviewNotice.controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.reviewNotice.model.service.ReviewNoticeService;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;
// 페이징 처리를 위해 필요할 수 있는 PageInfo, Pagination 클래스 (별도 구현 가정)
// import kr.or.iei.common.PageInfo;
// import kr.or.iei.common.Pagination;

@WebServlet("/review/list") // 📌 JSP 링크와 일치하도록 .do 추가
public class ReviewListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("--- ReviewListServlet doGet() 실행됨 ---"); // 실행 확인 로그

        // 1. 카테고리 코드 가져오기
        String categoryCode = request.getParameter("category");
        if (categoryCode == null || categoryCode.isEmpty() || categoryCode.equals("all")) {
            categoryCode = "all"; // 기본값 또는 "all" 파라미터는 전체 카테고리
        }
        System.out.println("요청된 카테고리 코드: " + categoryCode);

        // 2. 페이징 처리
        int currentPage = 1; // 현재 페이지 번호 (기본값 1)
        String cpParam = request.getParameter("currentPage");
        if (cpParam != null && !cpParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(cpParam);
            } catch (NumberFormatException e) {
                System.err.println("ReviewListServlet: 잘못된 currentPage 파라미터 - " + cpParam);
                // currentPage는 기본값 1로 유지
            }
        }
        System.out.println("현재 페이지: " + currentPage);

        ReviewNoticeService rnService = new ReviewNoticeService();

        // 2-1. 해당 카테고리의 전체 게시물 수 조회 (페이징 계산용)
        int totalReviews = rnService.getTotalReviewCountByCategory(categoryCode);
        System.out.println("카테고리 [" + categoryCode + "]의 전체 게시물 수: " + totalReviews);


        // 2-2. 페이징 정보 계산 (PageInfo 객체 또는 직접 계산)
        int recordCountPerPage = 12; // 한 페이지에 보여줄 게시물 수 (예: 4열 x 3행)
        int naviCountPerPage = 5;    // 페이지 네비게이션에 보여줄 페이지 수 (예: < 1 2 3 4 5 >)

        // 총 페이지 수 계산
        int totalPage = (int)Math.ceil((double)totalReviews / recordCountPerPage);
        if (totalPage == 0)
		 {
			totalPage = 1; // 게시물이 없어도 1페이지는 표시
		}

        // 현재 페이지 보정 (잘못된 값으로 요청 시)
        if(currentPage < 1) {
			currentPage = 1;
		}
        if(currentPage > totalPage) {
			currentPage = totalPage;
		}


        // 페이지 네비게이션 시작/끝 번호 계산
        int startNavi = ((currentPage - 1) / naviCountPerPage) * naviCountPerPage + 1;
        int endNavi = startNavi + naviCountPerPage - 1;
        if (endNavi > totalPage) {
            endNavi = totalPage;
        }

        // 이전/다음 버튼 필요 여부
        boolean needPrev = startNavi > 1;
        boolean needNext = endNavi < totalPage;

        // JSP로 전달할 페이지 정보 구성 (PageInfo 객체 대신 직접 전달)
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("startNavi", startNavi);
        request.setAttribute("endNavi", endNavi);
        request.setAttribute("needPrev", needPrev);
        request.setAttribute("needNext", needNext);
        request.setAttribute("totalPage", totalPage);


        // 3. Service 호출하여 카테고리별 & 페이징 처리된 게시물 목록 조회
        ArrayList<ReviewNotice> reviewList = rnService.getReviewListByCategory(categoryCode, currentPage, recordCountPerPage); // 직접 값 전달 시

        System.out.println("조회된 게시물 수: " + (reviewList != null ? reviewList.size() : 0));

        // 4. JSP로 전달할 데이터 설정
        request.setAttribute("reviewList", reviewList);
        request.setAttribute("selectedCategory", categoryCode); // 현재 선택된 카테고리 코드 전달

        // 5. JSP로 포워딩
        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/reviewnotice/reviewList.jsp"); // 실제 JSP 파일 경로
        view.forward(request, response);
    }

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response); // POST 요청도 GET으로 동일하게 처리
    }
}