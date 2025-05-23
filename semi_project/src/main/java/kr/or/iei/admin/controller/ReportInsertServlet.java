package kr.or.iei.admin.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.or.iei.admin.model.service.AdminServcie;
import kr.or.iei.admin.model.vo.ReportPost;

/**
 * @author 팀원
 * @summary 상품 상세 페이지에서 신고된 내용을 DB에 저장
 */
@WebServlet("/admin/reportInsert")
public class ReportInsertServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ReportInsertServlet() {
		super();
	}

	/**
	 * POST 방식으로 신고 등록
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 인코딩 처리
		request.setCharacterEncoding("UTF-8");

		// 2. 요청값 추출
		String reportCode = request.getParameter("reportCode");                // 신고 사유 코드 (RE1~RE4)
		String reportedMemberNo = request.getParameter("reportedMemberNo");   // 신고자 회원 번호
		String productNo = request.getParameter("productNo");                 // 신고 대상 상품 번호
		String reportDetail = request.getParameter("reportDetail");           // 신고 상세 내용

		// 3. VO 생성
		ReportPost report = new ReportPost();
		report.setReportCode(reportCode);
		report.setReportedMemberNo(reportedMemberNo);
		report.setProductNo(productNo);
		report.setReportDetail(reportDetail);

		// 4. 서비스 객체 생성
		AdminServcie service = new AdminServcie();

		// 4-1. 신고 이력 확인 (중복 신고 방지)
		boolean alreadyReported = service.hasAlreadyReported(reportedMemberNo, productNo);
		if (alreadyReported) {
			// 이미 신고한 경우: 경고 메시지 페이지로 이동
			request.setAttribute("msg", "이미 이 상품을 신고하셨습니다.");
			request.setAttribute("loc", "/product/detail?no=" + productNo);
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
			return;
		}

		// 4-2. 신고 등록
		int result = service.insertReport(report);

		// 5. 결과 처리
		if (result > 0) {
			response.sendRedirect(request.getContextPath() + "/product/detail?no=" + productNo);
		} else {
			response.sendRedirect(request.getContextPath() + "/error/reportInsertFail.jsp");
		}
	}
}
