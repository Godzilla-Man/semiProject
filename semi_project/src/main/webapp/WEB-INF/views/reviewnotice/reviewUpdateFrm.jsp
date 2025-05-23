<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스타일 후기 수정</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        margin: 20px;
        color: #333;
    }

    .wrap {
        max-width: 800px;
        margin: 40px auto;
        padding: 30px;
        border: 1px solid #ddd;
        border-radius: 8px;
        background-color: #fff;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    .page-title {
        font-size: 1.8em;
        font-weight: 600;
        margin-bottom: 25px;
        text-align: center;
        color: #007bff;
    }

    .tbl {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }

    .tbl th,
    .tbl td {
        padding: 12px 15px;
        border: 1px solid #e0e0e0;
        text-align: left;
        font-size: 0.95em;
    }

    .tbl th {
        background-color: #f8f9fa;
        width: 20%;
        font-weight: 500;
    }

    .input-item input[type="text"],
    .input-item textarea {
        width: calc(100% - 22px); /* padding 고려 */
        padding: 10px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        box-sizing: border-box;
        font-family: 'Noto Sans KR', sans-serif;
    }

    .input-item input[type="text"]:focus,
    .input-item textarea:focus {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, .25);
        outline: none;
    }

    .input-item textarea {
        min-height: 200px;
        resize: vertical;
    }

    .files {
        margin-bottom: 8px;
        padding: 8px;
        border: 1px dashed #e0e0e0;
        border-radius: 4px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: #fdfdfd;
    }

    .delFileName {
        font-size: 0.9em;
        color: #495057;
    }

    .delBtn {
        color: #e74c3c;
        display: inline-block;
        vertical-align: middle;
        font-size: 20px;
    }

    .delBtn:hover {
        cursor: pointer;
        color: #c0392b;
    }

    .btn-primary,
    .btn-secondary {
        border: none;
        padding: 10px 25px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 1em;
        font-weight: 500;
        transition: background-color 0.2s ease;
    }

    .btn-primary {
        background-color: #007bff;
        color: white;
    }

    .btn-primary:hover {
        background-color: #0056b3;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
        margin-left: 10px;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }

    .left {
        text-align: left;
    }

    .tbl td.left { 
        text-align: left;
    }

    .button-container {
        text-align: center;
        margin-top: 20px;
    }
    small {
        display:block;
        margin-top:5px;
        color:#6c757d;
        font-size:0.85em;
    }
</style>
</head>
<body>
    <div class="wrap">
        <main class="content">
            <section class="section review-update-wrap">
                <div class="page-title">스타일 후기 수정</div>
                <form action="${pageContext.request.contextPath}/review/update"
                      method="post"
                      enctype="multipart/form-data">
                    <input type="hidden" name="stylePostNo" value="${review.stylePostNo}">
                    <input type="hidden" name="orderNo" value="${review.orderNo}">

                    <table class="tbl">
                        <tr>
                            <th>제목</th>
                            <td>
                                <div class="input-item">
                                    <input type="text" name="postTitle" value="<c:out value='${review.postTitle}'/>" required>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>기존 첨부파일</th>
                            <td class="left"> 
                                <div id="existingFilesArea">
                                    <c:if test="${empty review.fileList}">
                                        <span>기존 첨부파일이 없습니다.</span>
                                    </c:if>
                                    <c:forEach var="file" items="${review.fileList}">
                                        <div class="files" id="fileDiv_${file.fileNo}">
                                            <span class="delFileName"><c:out value='${file.fileName}'/></span>
                                            <span class="material-icons delBtn" onclick="delFile(this, ${file.fileNo})" title="파일 삭제 목록에 추가">remove_circle</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>파일 추가</th>
                            <td class="left">
                                <input type="file" name="addFile" multiple> 
                                <small>새 파일을 추가하면 기존 파일 중 '삭제 목록에 추가'하지 않은 파일은 유지됩니다.</small>
                                <small>파일을 변경하고 싶지 않다면 이 필드를 비워두세요.</small>
                            </td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td class="left">
                                <div class="input-item">
                                    <textarea name="postContent" required><c:out value='${review.postContent}'/></textarea>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align:center;">
                                <div class="button-container">
                                    <button type="submit" class="btn-primary lg">수정 완료</button>
                                    <button type="button" class="btn-secondary lg" onclick="location.href='${pageContext.request.contextPath}/review/detail?stylePostNo=${review.stylePostNo}'">취소</button>
                                </div>
                            </td>
                        </tr>
                    </table>
                </form>
            </section>
        </main>
    </div>
<script>
    function delFile(obj, fileNo) {
        if (!confirm("'" + $(obj).siblings('.delFileName').text() + "' 파일을 삭제 목록에 추가하시겠습니까? '수정 완료' 시 최종 반영됩니다.")) {
            return false;
        }
        let input = $('<input>');
        input.attr('type', 'hidden');
        input.attr('name', 'delFileNo');
        input.attr('value', fileNo);
        
        $(obj).closest('.files')
            .css({
                'text-decoration': 'line-through',
                'opacity': '0.6',
                'border-style': 'solid'
            })
            .attr('title', '삭제 예정');
        
        $('form').prepend(input);
        $(obj).remove(); // 삭제 아이콘 자체는 제거
    }
</script>
</body>
</html>