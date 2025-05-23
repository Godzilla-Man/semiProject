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

@WebServlet("/review/list")
public class ReviewListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryCode = request.getParameter("category");

        ReviewNoticeService service = new ReviewNoticeService();
        ArrayList<ReviewNotice> reviewList = service.selectAllReview(categoryCode);

        request.setAttribute("reviewList", reviewList);
        request.setAttribute("selectedCategory", categoryCode); 

        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/reviewnotice/reviewList.jsp");
        view.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}