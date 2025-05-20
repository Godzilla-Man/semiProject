package kr.or.iei.comment.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.product.model.service.ProductService;

/**
 * Servlet implementation class DeleteCommentServlet
 */
@WebServlet("/product/deleteComment")
public class DeleteCommentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteCommentServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int commentNo = Integer.parseInt(request.getParameter("no"));
        String productNo = request.getParameter("product");

        int result = new ProductService().deleteComment(commentNo);

        
        if (result > 0) {
          response.sendRedirect(request.getContextPath() + "/product/detail?no=" + productNo);
        } else {
          request.setAttribute("msg", "댓글 삭제에 실패했습니다.");
          request.getRequestDispatcher("/WEB-INF/views/common/error.jsp").forward(request, response);
        }
      }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
