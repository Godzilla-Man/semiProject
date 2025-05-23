<%@page import="kr.or.iei.product.model.vo.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.or.iei.product.model.service.ProductService"%>
<%@page import="kr.or.iei.member.model.vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%	
	//메인 화면에서 서블릿을 거치지 않고 DB에 있는 정보 가져오기 위한 작업
	String memberNo = null;
	Member loginMember = null;
	session = request.getSession(false);
	if(session != null){
		loginMember = (Member) session.getAttribute("loginMember");
		
		if(loginMember != null){			
			memberNo = loginMember.getMemberNo();
		}
	}

	ProductService pService = new ProductService();
	ArrayList<Product> productList = pService.selectMemberWishList(memberNo);
	
	request.setAttribute("productList", productList);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<br>
	<div class="cards-container">
		<c:choose>
			<c:when test="${empty productList}">
				<span style="display: block; width: 250px;">찜한 상품이 존재하지 않습니다.</span>
			</c:when>
			<c:otherwise>
				<c:forEach var="prod" items="${productList}" begin="0" end="7">
				<div style="color: inherit; text-decoration: none;">
					<div class="card">
						<div class="image">
							<c:choose>
							<c:when test="${empty prod.filePath}">
							<img src="/" alt="해당 상품에 등록된 이미지가 존재하지 않습니다." onclick="clickProd('${prod.productNo}')">
							</c:when>
							<c:otherwise>
							<img src="${prod.filePath}" alt="${prod.productName}" onclick="clickProd('${prod.productNo}')">
							</c:otherwise>
							</c:choose>
							<c:if test="${not empty sessionScope.loginMember}">
								<c:if test="${prod.wishYn eq 'Y'}">
									<span class="material-symbols-outlined fill" onclick="delWhishList(this, '${loginMember.memberNo}', '${prod.productNo}')">favorite</span>
								</c:if>
								<c:if test="${prod.wishYn ne 'Y'}">
									<span class="material-symbols-outlined" onclick="addWishList(this,'${loginMember.memberNo}`, '${prod.productNo}')">favorite</span>
								</c:if>
							</c:if>
						</div>
						<div class="image-info">
							<span class="image-prod"><a href="/product/detail?no=${prod.productNo}">${prod.productName}</a></span>
							<span class="image-price">${prod.productPrice}</span>
						</div>
					</div>
				</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
	<script>
	//클릭 시 해당 상품 상세 페이지로 이동
	function clickProd(productNo) {
		location.href="/product/detail?no=" + productNo;
	}
	//찜하기 추가
	function addWishList(obj, memberNo, productNo) {
		swal({
			title : "알림",
			text : "해당 상품을 찜하기 리스트에 추가하시겠습니까?",
			icon : "warning",
			buttons : {
				cancel : {
					text : "취소",
					value : false,
					visible : true,
					closeModal : true
				},
				confirm : {
					text : "추가",
					value : true,
					visible : true,
					closeModal : true
				}
			}
		}).then(function(val){
			if(val){ //추가 버튼 클릭 시
				$.ajax({
					url : "/product/addWishList",
					data : {"memberNo" : memberNo, "productNo" : productNo},
					type : "get",
					success : function(res){
						if(res > 0){ //찜하기 성공
							swal({
								title : "성공",
								text : "찜하기 리스트에 추가되었습니다.",
								icon : "success"
							});
							
							//클릭시 스타일 변경
							$(obj).attr("class", "material-symbols-outlined fill");
							$(obj).attr("onclick", "delWhishList(this, '" + memberNo + "', '" + productNo + "')");
							
						}else if(res == 0){ //찜하기 실패
							swal({
								title : "실패",
								text : "찜하기 리스트 추가 중 오류가 발생했습니다.",
								icon : "error"
							});
						}else if(res == -1){ //이미 찜한 상품
							swal({
								title : "실패",
								text : "이미 찜한 상품입니다.",
								icon : "error"
							});
						}else{
							swal({ //내가 등록한 상품
								title : "실패",
								text : "내가 등록한 상품입니다.",
								icon : "error"
							});
						}
					},
					error : function(){
						console.log("ajax 통신 오류");
					}
				});
			}
		});
	}
	
	//찜하기 삭제
	function delWhishList(obj, memberNo, productNo) {
		swal({
			title : "알림",
			text : "해당 상품을 찜하기 리스트에 삭제하시겠습니까?",
			icon : "warning",
			buttons : {
				cancel : {
					text : "취소",
					value : false,
					visible : true,
					closeModal : true
				},
				confirm : {
					text : "삭제",
					value : true,
					visible : true,
					closeModal : true
				}
			}
		}).then(function(val){
			if(val){ //삭제 버튼 클릭 시
				$.ajax({
					url : "/product/delWishList",
					data : {"memberNo" : memberNo, "productNo" : productNo},
					type : "get",
					success : function(res){
						if(res > 0){ //찜하기 성공
							swal({
								title : "성공",
								text : "찜하기 리스트에서 삭제되었습니다.",
								icon : "success"
							});
							
							//클릭시 스타일 변경
							$(obj).attr("class", "material-symbols-outlined");
							$(obj).attr("onclick", "addWishList(this, '" + memberNo + "', '" + productNo + "')");
							
						}else{ //찜하기 삭제 실패
							swal({
								title : "실패",
								text : "찜하기 리스트 삭제 중 오류가 발생했습니다.",
								icon : "error"
							});
						}
					},
					error : function(){
						console.log("ajax 통신 오류");
					}
				});
			}
		});
	}
	</script>
</body>
</html>