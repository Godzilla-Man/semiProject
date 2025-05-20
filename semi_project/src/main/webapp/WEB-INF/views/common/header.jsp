<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="/resources/css/default.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"> <!-- 구글 아이콘 url -->
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> <!-- jquery 연결 url -->
<script src="/resources/js/sweetalert.min.js"></script>

<header class="header">
    <div class="header-wrap">
        <ul class="header-menu">
            <%-- 세선에 로그인 회원 정보 등록 여부에 따라 다른 메뉴 출력 --%>
        	<c:choose>
           		<c:when test="${empty sessionScope.loginMember}">
                <li><a href="/member/joinFrm">회원가입</a></li>
                <li><a href="/member/loginFrm">로그인</a></li>
               	</c:when>
               	<c:otherwise>
                <li>${loginMember.memberNickname}님</li>
                	<c:choose>
	                	<c:when test="${loginMember.memberId eq 'admin'}">
	                	<%-- 관리자로 로그인 했을 때 관리페이지 보이게하기 --%>
	                	<li><a href="/member/adminPage">관리페이지</a></li>
	                	</c:when>
	                	<c:otherwise>
		                <li><a href="#">마이페이지</a></li>
	                	</c:otherwise>
                	</c:choose>
	                <li><a href="/member/logout">로그아웃</a></li>
               	</c:otherwise>
         	</c:choose>
        </ul>
        <div class="logo">
            <a href="/">
                <img src="/resources/images/KakaoTalk_20250514_101220497.png">
            </a>
        </div>
    </div>
    <div class="header-list">
        <ul class="main-menu">
            <li>카테고리
                <ul class="large-category">
                    <li>남성
                        <div class="medium-category" id="male">
                            <table class="tbl-category">
                                <tr>
                                    <td>아우터</td>
                                    <td>상의</td>
                                    <td>하의</td>
                                    <td>악세사리</td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C01">점퍼</a></td>
                                    <td><a href="/product/categoryList?ctg=C05">긴팔티</a></td>
                                    <td><a href="/product/categoryList?ctg=C10">데님팬츠</a></td>
                                    <td><a href="/product/categoryList?ctg=C13">신발</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C02">자켓</a></td>
                                    <td><a href="/product/categoryList?ctg=C06">반팔티</a></td>
                                    <td><a href="/product/categoryList?ctg=C11">정장팬츠</a></td>
                                    <td><a href="/product/categoryList?ctg=C14">모자</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C03">코트</a></td>
                                    <td><a href="/product/categoryList?ctg=C07">니트</a></td>
                                    <td><a href="/product/categoryList?ctg=C12">반바지</a></td>
                                    <td><a href="/product/categoryList?ctg=C15">목걸이</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C04">패딩</a></td>
                                    <td><a href="/product/categoryList?ctg=C08">후드</a></td>
                                    <td></td>
                                    <td><a href="/product/categoryList?ctg=C16">반지</a></td>
                                </tr>
                                 <tr class="small-category">
                                    <td></td>
                                    <td><a href="/product/categoryList?ctg=C09">셔츠</a></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                    </li>
                    <li>여성
                        <div class="medium-category" id="female">
                            <table class="tbl-category">
                                <tr>
                                    <td>아우터</td>
                                    <td>상의</td>
                                    <td>하의</td>
                                    <td>악세사리</td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C17">점퍼</a></td>
                                    <td><a href="/product/categoryList?ctg=C21">긴팔티</a></td>
                                    <td><a href="/product/categoryList?ctg=C26">데님팬츠</a></td>
                                    <td><a href="/product/categoryList?ctg=C29">신발</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C18">자켓</a></td>
                                    <td><a href="/product/categoryList?ctg=C22">반팔티</a></td>
                                    <td><a href="/product/categoryList?ctg=C27">정장팬츠</a></td>
                                    <td><a href="/product/categoryList?ctg=C30">모자</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C19">코트</a></td>
                                    <td><a href="/product/categoryList?ctg=C23">니트</a></td>
                                    <td><a href="/product/categoryList?ctg=C28">반바지</a></td>
                                    <td><a href="/product/categoryList?ctg=C31">목걸이</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C20">패딩</a></td>
                                    <td><a href="/product/categoryList?ctg=C24">후드</a></td>
                                    <td></td>
                                    <td><a href="/product/categoryList?ctg=C32">반지</a></td>
                                </tr>
                                 <tr class="small-category">
                                    <td></td>
                                    <td><a href="/product/categoryList?ctg=C25">셔츠</a></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                    </li>
                    <li>공용
                        <div class="medium-category" id="unisex">
                            <table class="tbl-category">
                                <tr>
                                    <td>아우터</td>
                                    <td>상의</td>
                                    <td>하의</td>
                                    <td>악세사리</td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C33">점퍼</a></td>
                                    <td><a href="/product/categoryList?ctg=C37">긴팔티</a></td>
                                    <td><a href="/product/categoryList?ctg=C42">데님팬츠</a></td>
                                    <td><a href="/product/categoryList?ctg=C45">신발</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C34">자켓</a></td>
                                    <td><a href="/product/categoryList?ctg=C38">반팔티</a></td>
                                    <td><a href="/product/categoryList?ctg=C43">정장팬츠</a></td>
                                    <td><a href="/product/categoryList?ctg=C46">모자</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C35">코트</a></td>
                                    <td><a href="/product/categoryList?ctg=C39">니트</a></td>
                                    <td><a href="/product/categoryList?ctg=C44">반바지</a></td>
                                    <td><a href="/product/categoryList?ctg=C47">목걸이</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="/product/categoryList?ctg=C36">패딩</a></td>
                                    <td><a href="/product/categoryList?ctg=C40">후드</a></td>
                                    <td></td>
                                    <td><a href="/product/categoryList?ctg=C48">반지</a></td>
                                </tr>
                                 <tr class="small-category">
                                    <td></td>
                                    <td><a href="/product/categoryList?ctg=C41">셔츠</a></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                    </li>
                </ul>
            </li>
            <li><a href="/review/list">스타일 후기</a></li>
            <li><a href="/event/list?reqPage=1">이벤트</a></li>
            <li><a href="/notice/list?reqPage=1">공지사항</a></li>
            <li><a href="/product/enroll">판매하기</a></li>
        </ul>
        <form class="search" action="/product/searchList" method="get">
            <select name="searchOption" id="search-option">
                <option value="productName">상품명</option>
                <option value="memberNickname">작성자</option>
            </select>
            <input type="text" name="search">
            <button type="submit">검색</button>
        </form>
    </div>
</header>
<div class="padding"></div>

<div class="fixed" style="right: 280px;">
	<%-- 로그인 시에만 판매 글을 올릴 수 있는 등록 버튼 표시 --%>
	<c:if test="${!empty sessionScope.loginMember}">
    <div class="post" onclick="productEnroll()">
        <span class="material-symbols-outlined">add</span>
    </div>
    </c:if>
    <div class="top" onclick="scrollToTop()">
        <span class="material-symbols-outlined">arrow_upward</span>
    </div>
</div>

 <script>
 	//로그인 후 우측 하단 + 버튼 클릭 시 상품 판매 페이지로 이동
 	function productEnroll() {
 		location.href = "/product/enroll";
 	}
 
 	//우측 하단 ↑ 버튼 클릭 시 상단으로 스크롤 이동
    function scrollToTop() {
        window.scrollTo({
        top: 0,
        behavior: 'smooth' // 부드럽게 스크롤
        });
    }
</script>