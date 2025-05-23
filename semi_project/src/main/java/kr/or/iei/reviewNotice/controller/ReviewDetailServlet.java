package kr.or.iei.reviewNotice.controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.category.model.vo.Category;
import kr.or.iei.reviewNotice.model.service.ReviewNoticeService;
import kr.or.iei.reviewNotice.model.vo.ReviewNotice;

@WebServlet("/review/detail")
public class ReviewDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String stylePostNo = request.getParameter("stylePostNo");

        ReviewNoticeService service = new ReviewNoticeService();
        ReviewNotice review = service.selectReviewDetail(stylePostNo); // 변수명 review로 사용
        Category category = service.selectCategory(stylePostNo);
        
        String path;
        if (review != null) {
            request.setAttribute("review", review); // JSP에서 사용할 이름 "review"
            request.setAttribute("category", category);
            path = "/WEB-INF/views/reviewnotice/reviewDetail.jsp";
        } else {
            request.setAttribute("errorMsg", "게시글을 조회할 수 없습니다.");
            path = "/WEB-INF/views/reviewnotice/reviewList.jsp";
        }
        RequestDispatcher view = request.getRequestDispatcher(path);
        view.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}