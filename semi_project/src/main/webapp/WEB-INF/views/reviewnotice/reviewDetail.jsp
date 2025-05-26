<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><c:out value="${review.postTitle}"/> - 스타일 상세</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.css"/>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick-theme.min.css"/>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<style>
    html {
        box-sizing: border-box;
    }
    *, *:before, *:after {
        box-sizing: inherit;
    }
    body {
        font-family: 'Noto Sans KR', sans-serif;
        margin: 0;
        padding: 0;
        color: #333;
        line-height: 1.6;
    }
    .review-detail-container {
        max-width: 960px;
        margin: 20px auto;
        background-color: #fff;
        padding: 25px 30px;
        box-shadow: 0 2px 15px rgba(0,0,0,0.08);
        border-radius: 8px;
    }
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
    .review-content {
        margin-bottom: 30px;
        line-height: 1.8;
        min-height: 100px;
        white-space: pre-wrap;
        font-size: 1.1em;
        color: #343a40;
    }
    .post-images-slider {
        margin: 0 auto 30px auto;
        max-width: 100%;
    }
    .post-images-slider .slick-slide {
        padding: 0 5px;
    }
    .post-images-slider .slick-slide div {
        outline: none;
    }
    .post-images-slider img {
        width: 100%;
        max-height: 600px;
        object-fit: contain;
        border-radius: 6px;
        display: block;
        margin: auto;
    }
    .no-images-message {
        text-align: center;
        color: #6c757d;
        margin: 20px 0;
        padding: 30px;
        border: 1px dashed #ced4da;
        border-radius:5px;
        background-color: #f8f9fa;
    }
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
    .slick-prev { left: 10px; } 
    .slick-next { right: 10px; }
    .slick-prev:before, 
    .slick-next:before {
        font-family: 'Material Icons';
        font-size: 30px;
        color: #555;
        opacity: 0.7;
        line-height: 1;
    }
    .slick-prev:hover:before, 
    .slick-next:hover:before {
        opacity: 1;
        color: #000;
    }
    .slick-prev:before { content: "chevron_left"; } 
    .slick-next:before { content: "chevron_right"; }
    .slick-dots {
        bottom: 10px;
    }
    .slick-dots li button:before {
        font-size: 10px !important;
        color: #adb5bd !important;
    }
    .slick-dots li.slick-active button:before {
        color: #007bff !important;
    }
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
    p.comment-content {
        margin-top: 5px;
        margin-bottom: 10px;
        white-space: pre-wrap;
        line-height: 1.7;
        color: #343a40;
        font-size: 1em;
    }
    div.input-item {
        display: none;
        margin-top: 8px;
    }
    div.input-item textarea.edit-comment-textarea {
        width: 100%;
        min-height: 60px;
        padding: 10px 12px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        resize: vertical;
        font-family: 'Noto Sans KR', sans-serif;
        font-size: 0.95em;
        margin-bottom: 5px;
    }
    .comment-actions {
        text-align: right;
        margin-top: 5px;
    }
    .comment-actions a {
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
    .edit-comment-area button.cancel-btn:hover {
        background-color: #5a6268;
    }
    .edit-comment-area button.save-btn:hover {
        background-color: #1e7e34;
    }
    .no-data-message {
        text-align: center;
        color: #6c757d;
        margin-top: 50px;
        font-size: 1.2em;
        padding: 20px;
    }
    .no-comments-message {
        text-align: center;
        color: #6c757d;
        padding: 20px 0;
    }
    .back-to-list-container {
        text-align: center;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid #e9ecef;
    }
    .back-to-list, 
    .post-action-btn {
        display: inline-block;
        padding: 10px 20px;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-weight: 500;
        font-size: 0.95em;
        margin-left: 10px;
        border: none;
        cursor:pointer;
    }
    .back-to-list {
        background-color: #007bff;
    }
    .back-to-list:hover {
        background-color: #0056b3;
    }
   
    .post-actions-container {
        margin-top: 20px;
        padding-top: 20px;
        border-top: 1px solid #e9ecef;
        text-align: right;
    }
    .post-actions-container .edit-post-btn {
        background-color: #17a2b8;
    }
    .post-actions-container .edit-post-btn:hover {
        background-color: #138496;
    }
    .post-actions-container .delete-post-btn {
        background-color: #dc3545;
    }
    .post-actions-container .delete-post-btn:hover {
        background-color: #c82333;
    }
     .error-message-detail {
        color: red;
        font-weight: bold;
        padding: 10px;
        border: 1px solid red;
        background-color: #ffebee;
        margin-bottom: 20px;
        border-radius: 4px;
        text-align: center;
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <c:if test="${not empty sessionScope.alertMsg}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                swal("${sessionScope.alertMsg}").then(function(){
                    <% session.removeAttribute("alertMsg"); %>
                });
            });
        </script>
    </c:if>

    <c:if test="${not empty review}">
        <div class="review-detail-container">
            <div class="review-header">
                <h2><c:out value="${review.postTitle}"/></h2>
                <div class="review-info">
                    <span>작성자: <c:out value="${review.memberNickname}"/></span>
                    <span>작성일: <c:out value="${review.postDate}"/></span>
                    <span>조회수: <c:out value="${review.readCount}"/></span>
                    <span class="category-display">
                        카테고리:
                        <c:choose>
                            <c:when test="${not empty category}">
                               <c:out value="${category.larCategoryName} > ${category.midCategoryName} > ${category.categoryName}"/>
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

            <c:if test="${not empty sessionScope.loginMember && not empty review.memberNo && sessionScope.loginMember.memberNo eq review.memberNo}">
                <div class="post-actions-container">
                    <a href="/review/editFrm?stylePostNo=${review.stylePostNo}" class="post-action-btn edit-post-btn">게시글 수정</a>
                    <button type="button" onclick="confirmDeletePost('${review.stylePostNo}');" class="post-action-btn delete-post-btn">게시글 삭제</button>
                </div>
            </c:if>

            <%-- 댓글 관련 HTML --%>
            <c:if test="${not empty param.commentError}"></c:if>
            <c:if test="${not empty param.commentResult}"></c:if>

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
                        <p class="comment-login-prompt">댓글을 작성하려면 <a href="${pageContext.request.contextPath}/member/login">로그인</a>이 필요합니다.</p>
                    </c:if>
                </div>

                <ul class="comment-list">
                    <c:choose>
                        <c:when test="${empty review.commentList}">
                            <p class="no-comments-message">등록된 댓글이 없습니다. 첫 댓글을 작성해보세요!</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="comment" items="${review.commentList}">
                                <li class="comment-item" id="commentItem_${comment.commentNo}">
                                    <div class="comment-meta">
                                        <span class="comment-nickname"><c:out value="${comment.memberNickname}"/></span>
                                        <span class="comment-date"><c:out value="${comment.createdDate}"/></span>
                                    </div>
                                    <p class="comment-content" id="commentP_${comment.commentNo}"><c:out value="${comment.content}" escapeXml="false"/></p>
                                    <div class="input-item" id="editArea_${comment.commentNo}">
                                        <textarea class="edit-comment-textarea"><c:out value="${comment.content}"/></textarea>
                                    </div>
                                    <c:if test="${not empty sessionScope.loginMember && not empty comment.memberNo && sessionScope.loginMember.memberNo eq comment.memberNo}">
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
                 <%-- 중요: 아래 링크에도 컨텍스트 경로 및 .do 확장자 확인 필요 --%>
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

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.js"></script>
    <script>
        $(document).ready(function(){
            var $slider = $('.post-images-slider');
            if ($slider.length > 0 && $slider.find('img').length > 0) {
                if (!$slider.hasClass('slick-initialized')) {
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
                    });
                }
            }
        });

        const currentStylePostNoForJs = "${review.stylePostNo}";

        function confirmDeletePost(stylePostNo) {
            swal({
                title: "게시글 삭제 확인", 
                text: "이 게시글을 정말로 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.", 
                icon: "warning",
                buttons: { 
                    cancel: { text: "취소", value: false, visible: true, closeModal: true }, 
                    confirm: { text: "삭제", value: true, visible: true, closeModal: true, className: "btn-danger" }
                },
                dangerMode: true,
            }).then(function(isConfirm) {
                if (isConfirm) {
                    let form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '/review/delete';
                    let inputPostNo = document.createElement('input');
                    inputPostNo.type = 'hidden'; 
                    inputPostNo.name = 'stylePostNo'; 
                    inputPostNo.value = stylePostNo;
                    form.appendChild(inputPostNo);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }

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
                dangerMode: true,
            }).then(function(isConfirm){ 
                if(isConfirm){ 
                    let form = $('<form></form>');
                    form.attr('action', '/review/commentDelete'); // 수정: 컨텍스트 경로 추가
                    form.attr('method', 'post');
                    form.append($('<input/>', {type: 'hidden', name: 'commentNo', value: commentNo }));
                    form.append($('<input/>', {type: 'hidden', name: 'stylePostNo', value: currentStylePostNoForJs })); // 수정: 올바른 변수명 사용
                    $('body').append(form);
                    form.submit();
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
            
            form.append($('<input/>', {type: 'hidden', name: 'stylePostNo', value: currentStylePostNoForJs}));
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
</body>
</html>