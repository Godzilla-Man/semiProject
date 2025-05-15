<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="/resources/css/header.css">
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
                <li><a href="#">로그인</a></li>
               	</c:when>
               	<c:otherwise>
                <li>${loginMember.memberNickname}님</li>
                <li><a href="#">마이페이지</a></li>
                <li><a href="#">로그아웃</a></li>
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
                                    <td><a href="#">점퍼</a></td>
                                    <td><a href="#">긴팔티</a></td>
                                    <td><a href="#">데님팬츠</a></td>
                                    <td><a href="#">신발</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="#">자켓</a></td>
                                    <td><a href="#">반팔티</a></td>
                                    <td><a href="#">정장팬츠</a></td>
                                    <td><a href="#">모자</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="#">코트</a></td>
                                    <td><a href="#">니트</a></td>
                                    <td><a href="#">반바지</a></td>
                                    <td><a href="#">목걸이</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="#">패딩</a></td>
                                    <td><a href="#">후드</a></td>
                                    <td></td>
                                    <td><a href="#">반지</a></td>
                                </tr>
                                 <tr class="small-category">
                                    <td></td>
                                    <td><a href="#">셔츠</a></td>
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
                                    <td><a href="#">점퍼</a></td>
                                    <td><a href="#">긴팔티</a></td>
                                    <td><a href="#">데님팬츠</a></td>
                                    <td><a href="#">신발</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="#">자켓</a></td>
                                    <td><a href="#">반팔티</a></td>
                                    <td><a href="#">정장팬츠</a></td>
                                    <td><a href="#">모자</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="#">코트</a></td>
                                    <td><a href="#">니트</a></td>
                                    <td><a href="#">반바지</a></td>
                                    <td><a href="#">목걸이</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="#">패딩</a></td>
                                    <td><a href="#">후드</a></td>
                                    <td></td>
                                    <td><a href="#">반지</a></td>
                                </tr>
                                 <tr class="small-category">
                                    <td></td>
                                    <td><a href="#">셔츠</a></td>
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
                                    <td><a href="#">점퍼</a></td>
                                    <td><a href="#">긴팔티</a></td>
                                    <td><a href="#">데님팬츠</a></td>
                                    <td><a href="#">신발</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="#">자켓</a></td>
                                    <td><a href="#">반팔티</a></td>
                                    <td><a href="#">정장팬츠</a></td>
                                    <td><a href="#">모자</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="#">코트</a></td>
                                    <td><a href="#">니트</a></td>
                                    <td><a href="#">반바지</a></td>
                                    <td><a href="#">목걸이</a></td>
                                </tr>
                                <tr class="small-category">
                                    <td><a href="#">패딩</a></td>
                                    <td><a href="#">후드</a></td>
                                    <td></td>
                                    <td><a href="#">반지</a></td>
                                </tr>
                                 <tr class="small-category">
                                    <td></td>
                                    <td><a href="#">셔츠</a></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                    </li>
                </ul>
            </li>
            <li><a href="#">스타일 후기</a></li>
            <li><a href="/event/list?reqPage=1">이벤트</a></li>
            <li><a href="/notice/list?reqPage=1">공지사항</a></li>
            <li><a href="#">판매하기</a></li>
        </ul>
        <form class="search" action="#" method="get">
            <select name="search-option" id="search-option">
                <option value="title">상품명</option>
                <option value="nickname">작성자</option>
            </select>
            <input type="text" name="search">
            <button type="submit">검색</button>
        </form>
    </div>
</header>
<div class="padding"></div>

<div class="fixed" style="right: 280px;">
	<c:if test="${!empty sessionScope.loginMember}">
    <div class="post">
        <span class="material-symbols-outlined">add</span>
    </div>
    </c:if>
    <div class="top" onclick="scrollToTop()">
        <span class="material-symbols-outlined">arrow_upward</span>
    </div>
</div>

 <script>
    function scrollToTop() {
        window.scrollTo({
        top: 0,
        behavior: 'smooth' // 부드럽게 스크롤
        });
    }
</script>