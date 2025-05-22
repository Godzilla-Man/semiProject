<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${review.postTitle}"/> - 스타일 상세</title>

    <%-- jQuery (Slick Carousel 및 사용자 스크립트에 필요) --%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <%-- SweetAlert (댓글 삭제 확인창에 필요) --%>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    
    <%-- Slick Carousel CSS --%>
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.css"/>
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick-theme.min.css"/>
    
    <%-- Google Fonts 및 Material Icons --%>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        /* Box Sizing Reset */
        html {
            box-sizing: border-box;
        }
        *, *:before, *:after {
            box-sizing: inherit;
        }

        /* 기본 레이아웃 */
        body { 
            font-family: 'Noto Sans KR', sans-serif; 
            margin: 0; 
            padding: 0; 
            background-color: #f0f2f5; 
            color: #333; 
        }
        
        .review-detail-container { 
            max-width: 960px; 
            margin: 20px auto; 
            background-color: #fff; 
            padding: 25px 30px; 
            box-shadow: 0 2px 15px rgba(0,0,0,0.08); 
            border-radius: 8px;
        }

        /* 게시글 헤더 */
        .review-header { 
            margin-bottom: 25px; 
            border-bottom: 1px solid #e9ecef; 
            padding-bottom: 20px; 
        }
        .review-header h2 { 
            margin: 0 0 12px 0; 
            font-size: 2.2em; 
            font-weight: 700; 
            color: #212529;
        }
        .review-info { 
            font-size: 0.95em; 
            color: #495057; 
        }
        .review-info span { 
            margin-right: 18px; 
            line-height: 1.5;
        }
        .review-info .category-display {
            background-color: #e6f7ff; 
            color: #007bff; 
            padding: 4px 10px; 
            border-radius: 4px; 
            font-weight: 500; 
        }

        /* 게시글 내용 */
        .review-content { 
            margin-bottom: 30px; 
            line-height: 1.8; 
            min-height: 100px; 
            white-space: pre-wrap; 
            font-size: 1.1em; 
            color: #343a40;
        }

        /* 이미지 슬라이더 */
        .post-images-slider { 
            margin: 0 auto 30px auto; 
            max-width: 100%; 
        }
        .post-images-slider .slick-slide {
            padding: 0 5px; /* 슬라이드 간 약간의 간격 (선택 사항) */
        }
        .post-images-slider .slick-slide div { /* Slick의 내부 div까지 고려 */
             outline: none; /* 포커스 시 아웃라인 제거 */
        }
        .post-images-slider img { 
            width: 100%; 
            max-height: 600px; /* 최대 높이 설정, adaptiveHeight와 함께 사용 */
            object-fit: contain; /* 이미지 비율 유지, 컨테이너에 맞게 */
            border-radius: 6px; 
            display: block;
            margin: auto; /* 이미지가 슬라이드 내에서 가운데 오도록 */
        }
        .no-images-message { /* 첨부 이미지 없을 때 메시지 스타일 */
            text-align: center; 
            color: #6c757d; 
            margin: 20px 0; 
            padding: 30px; 
            border: 1px dashed #ced4da; 
            border-radius:5px;
            background-color: #f8f9fa;
        }

        /* Slick Carousel 화살표 스타일 */
        .slick-prev, 
        .slick-next {
            width: 45px; 
            height: 45px;
            z-index: 10; 
            background-color: rgba(250, 250, 250, 0.6); 
            border-radius: 50%;
            transition: background-color 0.2s ease;
        }
        .slick-prev:hover, 
        .slick-next:hover {
            background-color: rgba(250, 250, 250, 0.9);
        }
        .slick-prev { 
            left: 10px; 
        } 
        .slick-next { 
            right: 10px; 
        }
        /* Slick 기본 화살표 아이콘을 Material Icons로 대체 */
        .slick-prev:before, 
        .slick-next:before {
            font-family: 'Material Icons'; /* Material Icons 폰트 사용 */
            font-size: 30px;               /* 아이콘 크기 */
            color: #555;                  /* 아이콘 색상 */
            opacity: 0.7;
            line-height: 1;                /* 아이콘 수직 정렬을 위해 line-height를 버튼 높이와 맞추거나 1로 설정 */
                                           /* 버튼 자체에 display:flex, align-items:center, justify-content:center 를 주면 더 정확한 중앙정렬 가능 */
        }
        .slick-prev:hover:before, 
        .slick-next:hover:before {
            opacity: 1;
            color: #000;
        }
        .slick-prev:before { 
            content: "chevron_left"; /* Material Icon 이름 */
        } 
        .slick-next:before { 
            content: "chevron_right"; /* Material Icon 이름 */
        }

        /* Slick Carousel 점 스타일 */
        .slick-dots { 
            bottom: 10px; /* 이미지 하단과의 간격 조정 */
        } 
        .slick-dots li button:before {
            font-size: 10px !important; /* important는 라이브러리 스타일 우선순위 때문 */
            color: #adb5bd !important; 
        }
        .slick-dots li.slick-active button:before {
            color: #007bff !important; 
        }

        /* 댓글 섹션 */
        .comments-section { 
            border-top: 1px solid #e9ecef; 
            padding-top: 25px; 
        }
        .comments-section h3 {
            font-size: 1.6em; 
            color: #212529;
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        /* 댓글 입력 영역 */
        .comment-input-area { 
            display: flex; 
            align-items: stretch; 
            margin-bottom: 25px; 
        }
        .comment-input-area textarea { 
            flex-grow: 1; 
            padding: 12px 15px; 
            border: 1px solid #ced4da; 
            border-radius: 4px 0 0 4px; 
            margin-right: 0; 
            resize: vertical; 
            min-height: 80px; 
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 1em;
        }
        .comment-input-area button { 
            flex-shrink: 0; 
            padding: 0 20px; 
            background-color: #007bff; 
            color: white; 
            border: none; 
            border-radius: 0 4px 4px 0; 
            cursor: pointer; 
            font-weight: 500;
            font-size: 1em;
            line-height: normal; 
        }
        .comment-input-area button:hover { 
            background-color: #0056b3; 
        }
        .comment-login-prompt {
            text-align: center; 
            width: 100%; 
            color: #495057; 
            padding: 15px;
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 4px;
        }
        .comment-login-prompt a {
            color:#007bff; 
            text-decoration:none; 
            font-weight:bold;
        }

        /* 댓글 목록 */
        ul.comment-list { 
            list-style-type: none; 
            padding-left: 0; 
            margin-top: 0; 
        }
        li.comment-item { 
            border-bottom: 1px dashed #e9ecef; 
            padding: 15px 0; 
        }
        li.comment-item:last-child { 
            border-bottom: none; 
        }
        .comment-meta { 
            display: flex; 
            align-items: center; 
            margin-bottom: 8px; 
        }
        .comment-meta .comment-nickname { 
            font-weight: 700; 
            font-size: 1.05em; 
            margin-right: 12px; 
            color: #212529;
        }
        .comment-meta .comment-date { 
            font-size: 0.85em; 
            color: #6c757d; 
        }
        
        p.comment-content { /* 댓글 내용 표시 p 태그 */
            margin-top: 5px; 
            margin-bottom: 10px; 
            white-space: pre-wrap; 
            line-height: 1.7; 
            color: #343a40; 
            font-size: 1em; 
        }
        
        /* 댓글 수정용 div (내부에 textarea 포함) */
        div.input-item { 
            display: none; /* 기본적으로 숨김 */
            margin-top: 8px; 
        }
        div.input-item textarea.edit-comment-textarea { 
            width: 100%; /* JS 생성 폼의 textarea는 이 스타일을 직접 받지 않음. 아래 .edit-comment-area textarea 참조 */
            min-height: 60px;
            padding: 10px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            resize: vertical;
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 0.95em;
            margin-bottom: 5px; 
        }
        
        /* 댓글 수정/삭제 버튼 영역 */
        .comment-actions { 
            text-align: right; 
            margin-top: 5px; 
        }
        .comment-actions a { /* JS가 버튼을 a 태그로 변경 */
            font-size: 0.85em; 
            padding: 5px 10px; 
            margin-left: 8px; 
            background-color: #f8f9fa; 
            border: 1px solid #ced4da; 
            border-radius: 4px; 
            cursor: pointer; 
            color: #495057;
            text-decoration: none;
        }
        .comment-actions a:hover { 
            background-color: #e2e6ea; 
            border-color: #adb5bd; 
        }
        
        /* JS로 동적 생성되는 수정 폼 스타일 */
        .edit-comment-area { 
            display: flex; 
            align-items: stretch; 
            margin-top: 10px; 
        }
        .edit-comment-area textarea { 
            flex-grow: 1; 
            padding: 10px 12px; 
            border: 1px solid #ced4da; 
            border-radius: 4px 0 0 4px; 
            margin-right: 0; 
            resize: vertical; 
            min-height: 60px; 
            font-family: 'Noto Sans KR', sans-serif; 
            font-size: 0.95em;
        }
        .edit-comment-area button { 
            flex-shrink: 0; 
            padding: 0 15px; 
            border: none; 
            cursor: pointer; 
            font-weight: 500;
            font-size: 0.9em;
            line-height: normal;
        }
        .edit-comment-area button.save-btn { 
            background-color: #28a745; 
            color: white; 
            border-radius: 0; 
        }
        .edit-comment-area button.cancel-btn { 
            background-color: #6c757d; 
            color: white;
            border-radius: 0 4px 4px 0;
        }
        .edit-comment-area button.cancel-btn:hover { background-color: #5a6268; } 
        .edit-comment-area button.save-btn:hover { background-color: #1e7e34; }

        /* 기타 메시지 및 버튼 스타일 */
        .no-data-message { text-align: center; color: #6c757d; margin-top: 50px; font-size: 1.2em; padding: 20px; }
        .no-comments-message { text-align: center; color: #6c757d; padding: 20px 0; }
        .back-to-list-container { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #e9ecef; }
        .back-to-list { display: inline-block; padding: 10px 25px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; font-weight: 500; font-size: 1em; }
        .back-to-list:hover { background-color: #0056b3; }
        .error-message-detail { color: red; font-weight: bold; padding: 10px; border: 1px solid red; background-color: #ffebee; margin-bottom: 20px; border-radius: 4px; text-align: center;}
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <c:if test="${not empty review}">
        <div class="review-detail-container">
            <div class="review-header">
                <h2><c:out value="${review.postTitle}"/></h2>
                <div class="review-info">
                    <span>작성자: <c:out value="${review.memberNickname}"/></span>
                    <span>작성일: ${review.postDate}</span>
                    <span>조회수: <c:out value="${review.readCount}"/></span>
                    <span class="category-display">
                        카테고리: 
                        <c:choose>
                            <c:when test="${not empty review.categoryList && not empty review.categoryList[0] && not empty review.categoryList[0].categoryName}">
                                <c:out value="${review.categoryList[0].categoryName}"/>
                            </c:when>
                            <c:when test="${not empty review.categoryList && not empty review.categoryList[0] && not empty review.categoryList[0].categoryCode}">
                                (<c:out value="${review.categoryList[0].categoryCode}"/>)
                            </c:when>
                            <c:when test="${not empty review.categoryCode}"> 
                                (<c:out value="${review.categoryCode}"/> - 사용자 선택값)
                            </c:when>
                            <c:otherwise>미분류</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <c:if test="${not empty review.fileList && review.fileList.size() > 0}">
                <div class="post-images-slider">
                    <c:forEach var="file" items="${review.fileList}">
                        <div>
                            <img src="${pageContext.request.contextPath}${file.filePath}" 
									     alt="<c:out value='${file.fileName != null ? file.fileName : review.postTitle}'/>" 
									     onerror="this.style.display='none'; this.parentElement.innerHTML='<div style=\'width:100%;height:100%;display:flex;align-items:center;justify-content:center;background-color:#eee;color:#aaa;font-size:0.9em;\'>이미지 표시 오류: <c:out value="${file.fileName}"/></div>';"/>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            <c:if test="${empty review.fileList || review.fileList.size() == 0}">
                 <p class="no-images-message">첨부된 이미지가 없습니다.</p>
            </c:if>

            <div class="review-content">
                <c:out value="${review.postContent}" escapeXml="false"/>
            </div>
            
            <%-- 댓글 관련 오류/결과 메시지 --%>
            <c:if test="${not empty param.commentError}">
                <p class="error-message-detail">
                    <c:choose>
                        <c:when test="${param.commentError eq 'loginRequired'}">댓글 작업은 로그인이 필요합니다.</c:when>
                        <c:when test="${param.commentError eq 'invalidCommentNo'}">잘못된 댓글 요청입니다.</c:when>
                        <c:otherwise>댓글 처리 중 오류가 발생했습니다.</c:otherwise>
                    </c:choose>
                </p>
            </c:if>
            <c:if test="${not empty param.commentResult}">
                <p style="text-align:center; font-weight:bold; margin-bottom:15px;" 
                   class="${param.commentResult.startsWith('success') ? 'text-success' : 'text-danger'}">
                    <c:choose>
                        <c:when test="${param.commentResult eq 'insertSuccess'}">댓글이 성공적으로 등록되었습니다.</c:when>
                        <c:when test="${param.commentResult eq 'insertFail'}">댓글 등록에 실패했습니다.</c:when>
                        <c:when test="${param.commentResult eq 'updateSuccess'}">댓글이 성공적으로 수정되었습니다.</c:when>
                        <c:when test="${param.commentResult eq 'updateFail'}">댓글 수정에 실패했습니다.</c:when>
                        <c:when test="${param.commentResult eq 'updateAuthFail'}">댓글 수정 권한이 없습니다.</c:when>
                        <c:when test="${param.commentResult eq 'deleteSuccess'}">댓글이 성공적으로 삭제되었습니다.</c:when>
                        <c:when test="${param.commentResult eq 'deleteFail'}">댓글 삭제에 실패했습니다.</c:when>
                        <c:when test="${param.commentResult eq 'deleteAuthFail'}">댓글 삭제 권한이 없습니다.</c:when>
                    </c:choose>
                </p>
            </c:if>


            <div class="comments-section">
                <h3>댓글 <c:if test="${not empty review.commentList && review.commentList.size() > 0}">(${review.commentList.size()})</c:if></h3>
                <div class="comment-input-area">
                    <c:if test="${not empty sessionScope.loginMember}">
                        <form action="${pageContext.request.contextPath}/review/commentInsert" method="post" style="width: 100%; display: flex;">
                            <input type="hidden" name="stylePostNo" value="${review.stylePostNo}">
                            <textarea name="commentContent" placeholder="따뜻한 댓글을 남겨주세요." required></textarea>
                            <button type="submit">등록</button>
                        </form>
                    </c:if>
                    <c:if test="${empty sessionScope.loginMember}">
                        <p class="comment-login-prompt">댓글을 작성하려면 <a href="/member/loginFrm">로그인</a>이 필요합니다.</p>
                    </c:if>
                </div>

                <ul class="comment-list"> 
                    <c:choose>
                        <c:when test="${empty review.commentList}"><p class="no-comments-message">등록된 댓글이 없습니다. 첫 댓글을 작성해보세요!</p></c:when>
                        <c:otherwise>
                            <c:forEach var="comment" items="${review.commentList}">
                                <li class="comment-item" id="commentItem_${comment.commentNo}"> 
                                    <div class="comment-meta">
                                        <span class="comment-nickname"><c:out value="${comment.memberNickname}"/></span>
                                        <span class="comment-date"><fmt:formatDate value="${comment.createdDate}" pattern="yyyy.MM.dd HH:mm"/></span>
                                    </div>
                                    
                                    <p class="comment-content" id="commentP_${comment.commentNo}"><c:out value="${comment.content}" escapeXml="false"/></p>
                                    
                                    <div class="input-item" id="editArea_${comment.commentNo}">
                                        <textarea class="edit-comment-textarea"><c:out value="${comment.content}"/></textarea>
                                    </div>

                                    <c:if test="${not empty sessionScope.loginMember && sessionScope.loginMember.memberNo eq comment.memberNo}">
                                        <div class="comment-actions">
                                            <a href="javascript:void(0);" onclick="mdfComment(this, ${comment.commentNo})" class="comment-edit-btn">수정</a>
                                            <a href="javascript:void(0);" onclick="delComment(${comment.commentNo})" class="comment-delete-btn">삭제</a>
                                        </div>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>

            <div class="back-to-list-container">
                <a href="${pageContext.request.contextPath}/review/list" class="back-to-list">목록으로</a>
            </div>
        </div>
    </c:if>
    
    <c:if test="${empty review}">
        <div class="review-detail-container">
            <p class="no-data-message"><c:out value="${errorMsg != null ? errorMsg : '요청하신 게시글을 찾을 수 없습니다.'}"/></p>
             <div class="back-to-list-container" style="border-top:none;">
                <a href="${pageContext.request.contextPath}/review/list" class="back-to-list">목록으로</a>
            </div>
        </div>
    </c:if>

    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.js"></script>
    <script>
        // Slick Carousel 초기화
        $(document).ready(function(){
            var $slider = $('.post-images-slider');
            // 슬라이더 내부에 이미지가 실제로 있고, 아직 slick이 초기화되지 않았을 때만 실행
            if ($slider.length > 0 && $slider.find('img').length > 0) { // img 태그가 있는지 확인
                if (!$slider.hasClass('slick-initialized')) { // 중복 초기화 방지
                    $slider.slick({
                        dots: true,
                        infinite: true, 
                        speed: 500,
                        slidesToShow: 1,
                        adaptiveHeight: true, 
                        autoplay: true,
                        autoplaySpeed: 3500,
                        fade: true,
                        cssEase: 'linear'
                        // 기본 화살표를 사용하고 CSS로 아이콘을 변경합니다.
                        // prevArrow, nextArrow 옵션을 명시적으로 제거하거나 Slick 기본값을 따릅니다.
                    });
                }
            }
        });

        // 현재 게시글 번호 (댓글 수정/삭제 시 사용)
        const currentStylePostNo = "${review.stylePostNo}"; // EL이므로 String 처리됨

        // 댓글 삭제 함수 (SweetAlert 사용, POST 요청)
        function delComment(commentNo){
            swal({
                title: "삭제 확인",
                text: "댓글을 정말로 삭제하시겠습니까?",
                icon: "warning",
                buttons: {
                    cancel: { text: "취소", value: false, visible: true, closeModal: true },
                    confirm: { text: "삭제", value: true, visible: true, closeModal: true }
                },
                dangerMode: true, // 삭제 버튼에 위험 강조
            }).then(function(isConfirm){ 
                if(isConfirm){ 
                    let form = $('<form></form>'); // jQuery 객체로 form 생성
                    form.attr('action', '/review/commentDelete');
                    form.attr('method', 'post');
                    // input 요소들도 jQuery로 생성하여 추가
                    form.append($('<input/>', {type: 'hidden', name: 'commentNo', value: commentNo }));
                    form.append($('<input/>', {type: 'hidden', name: 'stylePostNo', value: currentStylePostNo }));
                    $('body').append(form); // 생성된 폼을 body에 추가
                    form.submit(); // 폼 제출
                }
            });
        }
        
        // 댓글 수정 버튼 클릭 시 UI 변경 함수
        function mdfComment(obj, commentNo){ // obj는 클릭된 '수정' a 태그
            const listItem = $(obj).closest("li.comment-item"); 
            
            listItem.find("p.comment-content").hide(); // 기존 댓글 내용(p) 숨기기
            listItem.find("div.input-item").show();    // 수정용 textarea를 감싼 div 보여주기
            listItem.find("div.input-item textarea.edit-comment-textarea").focus(); // textarea에 포커스
            
            // '수정' 링크를 '수정완료'로 변경하고 onclick 이벤트 변경
            $(obj).text('수정완료');
            $(obj).attr('onclick', 'mdfCommentComplete(this, ' + commentNo + ')');
            
            // '삭제' 링크를 '수정취소'로 변경하고 onclick 이벤트 변경
            // $(obj).next()는 DOM 구조에 따라 정확하지 않을 수 있으므로, 클래스나 ID로 찾는 것이 더 안정적입니다.
            // 여기서는 comment-actions div 내의 두번째 a 태그를 가정합니다.
            listItem.find(".comment-delete-btn").text('수정취소'); 
            listItem.find(".comment-delete-btn").attr('onclick', 'mdfCommentCancel(this, '+ commentNo +')');
        }
        
        // 수정완료 클릭 시 form 제출 함수
        function mdfCommentComplete(obj, commentNo){
            const listItem = $(obj).closest("li.comment-item");
            const editedContent = listItem.find("div.input-item textarea.edit-comment-textarea").val(); // 수정된 내용

            if (!editedContent || editedContent.trim() === "") {
                swal("입력 오류", "댓글 내용을 입력해주세요.", "error");
                return;
            }

            let form = $('<form>');
            form.attr('action', '/review/commentUpdate');
            form.attr('method', 'post');
            
            form.append($('<input/>', {type: 'hidden', name: 'stylePostNo', value: currentStylePostNo}));
            form.append($('<input/>', {type: 'hidden', name: 'commentNo', value: commentNo}));
            form.append($('<input/>', {type: 'hidden', name: 'commentContent', value: editedContent})); 
            
            $('body').append(form);
            form.submit();
        }
        
        // 수정취소 클릭 시 UI 원복 함수
        function mdfCommentCancel(obj, commentNo){ // obj는 '수정취소' a 태그
            const listItem = $(obj).closest("li.comment-item");
            
            listItem.find("p.comment-content").show(); // 기존 댓글 내용 다시 보여주기
            listItem.find("div.input-item").hide();    // 수정용 div 숨기기
            
            // '수정완료' 버튼을 다시 '수정'으로 변경 (obj의 이전 형제 요소가 '수정완료' 버튼)
            listItem.find(".comment-edit-btn").text('수정'); 
            listItem.find(".comment-edit-btn").attr('onclick', 'mdfComment(this, '+ commentNo +')');
            
            // '수정취소' 버튼을 다시 '삭제'로 변경 (obj 자신이 '수정취소' 버튼)
            $(obj).text('삭제');
            $(obj).attr('onclick', 'delComment('+ commentNo +')');
        }
    </script>
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>