<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>스타일 후기 작성</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        html { box-sizing: border-box; }
        *, *:before, *:after { box-sizing: inherit; }
        body {
            font-family: "Noto Sans KR", "Arial", sans-serif;
            background: #f0f2f5;
            color: #333;
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
            color: #333;
            font-size: 28px;
        }
        .review-form-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 30px 40px;
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .review-form-container form {
            display: flex;
            flex-direction: column;
            gap: 22px;
        }
        .form-group {
            /* margin-bottom: 15px; */
        }
        .review-form-container label, .form-group .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #222;
        }
        .review-form-container input[type="text"],
        .review-form-container textarea {
            width: 100%;
            padding: 12px 15px;
            font-size: 1em;
            font-family: 'Noto Sans KR', sans-serif;
            border: 1px solid #ced4da;
            border-radius: 5px;
            box-sizing: border-box;
            resize: vertical;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }
        .review-form-container input[type="text"]:focus,
        .review-form-container textarea:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        input[type="file"]#files {
            display: none;
        }
        .image-preview {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 10px;
            padding: 10px;
            border: 1px dashed #ced4da;
            border-radius: 5px;
            min-height: 120px;
            align-items: center;
        }
        .image-preview > div:not(.add-image-btn) {
            position: relative;
            width: 120px;
            height: 120px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            overflow: hidden;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .image-preview img {
            max-width: 100%;
            max-height: 100%;
            object-fit: cover;
        }
        .image-preview button {
            position: absolute;
            top: 5px;
            right: 5px;
            background-color: rgba(0,0,0,0.5);
            border: none;
            color: white;
            font-weight: bold;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            cursor: pointer;
            line-height: 24px;
            text-align: center;
            font-size: 14px;
            transition: background-color 0.2s ease;
        }
        .image-preview button:hover {
            background-color: rgba(220, 53, 69, 0.9);
        }
        .image-preview .add-image-btn {
            font-size: 36px;
            color: #adb5bd;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 120px;
            height: 120px;
            border: 2px dashed #adb5bd;
            border-radius: 5px;
            cursor: pointer;
            user-select: none;
            transition: border-color 0.2s ease, color 0.2s ease;
            background-color: #f8f9fa;
        }
        .image-preview .add-image-btn:hover {
            border-color: #007bff;
            color: #007bff;
        }
        .category-col li.selected,
        .category-col li.active {
            font-weight: 600;
            color: #007bff;
            background-color: #e6f7ff;
        }
        #selectedCategoryLabel {
            display: block;
            font-size: 0.9em;
            color: #007bff;
            font-weight: 500;
            margin-top: 10px;
            padding: 8px;
            background-color: #e6f7ff;
            border: 1px solid #b3e5fc;
            border-radius: 4px;
            min-height: 20px; /* 내용 없을 때도 높이 유지 */
        }
        .error-message {
            color: red;
            font-weight: bold;
            padding: 10px;
            border: 1px solid red;
            background-color: #ffebee;
            margin-bottom: 20px;
            border-radius: 4px;
            text-align: center;
        }
        .button-group {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 25px;
        }
        button.submit-btn,
        button.cancel-btn {
            font-family: 'Noto Sans KR', sans-serif;
            color: white;
            font-weight: 500;
            border: none;
            padding: 12px 28px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.2s ease, box-shadow 0.2s ease;
            font-size: 1em;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        button.submit-btn {
            background-color: #007bff;
        }
        button.submit-btn:hover {
            background-color: #0056b3;
            box-shadow: 0 2px 5px rgba(0,0,0,0.15);
        }
        button.cancel-btn {
            background-color: #6c757d;
        }
        button.cancel-btn:hover {
            background-color: #545b62;
            box-shadow: 0 2px 5px rgba(0,0,0,0.15);
        }
        @media (max-width: 768px) {
            .review-form-container {
                margin: 20px 15px;
                padding: 20px;
            }
            h1 {
                font-size: 24px;
            }
            .category-container {
                flex-direction: column;
            }
            .category-col {
                width: 100%;
                margin-bottom: 12px;
                min-height: 150px;
                height: auto;
            }
            .image-preview > div:not(.add-image-btn),
            .image-preview .add-image-btn {
                width: calc(50% - 6px);
                height: auto;
                aspect-ratio: 1 / 1;
            }
            .button-group {
                flex-direction: column;
            }
            button.submit-btn,
            button.cancel-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="review-form-container">
        <h1>스타일 후기 작성</h1>

        <c:if test="${not empty errorMsg}">
            <p class="error-message"><c:out value="${errorMsg}"/></p>
        </c:if>

        <form action="${pageContext.request.contextPath}/review/write" method="post" enctype="multipart/form-data" onsubmit="return validateForm();">
            <div class="form-group">
                <label for="orderNo">주문번호</label>
                <input type="text" id="orderNo" name="orderNo" placeholder="리뷰를 작성할 주문의 주문번호 (예: O2405220001)" value="<c:out value='${reviewNotice.orderNo}'/>" required>
            </div>

            <div class="form-group">
                <label for="postTitle">제목</label>
                <input type="text" id="postTitle" name="postTitle" value="<c:out value='${reviewNotice.postTitle}'/>" required>
            </div>

            <div class="form-group">
                <label for="postContent">내용</label>
                <textarea id="postContent" name="postContent" rows="10" required><c:out value='${reviewNotice.postContent}'/></textarea>
            </div>

            <div class="form-group">
                <label for="files">상품 이미지 (최대 5장)</label>
                <input type="file" id="files" name="files" multiple accept="image/*">
                <div class="image-preview" id="imagePreview"></div>
            </div>

            <div class="button-group">
                <button type="button" class="cancel-btn" onclick="history.back();">취소</button>
                <button type="submit" class="submit-btn">작성 완료</button>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // 이미지 업로드 JS
            let selectedFiles = [];
            const filesInput = document.getElementById('files');
            const imagePreview = document.getElementById('imagePreview');

            filesInput.addEventListener('change', () => {
                const newFiles = Array.from(filesInput.files);
                if (newFiles.length + selectedFiles.length > 5) {
                    alert('이미지는 최대 5장까지 업로드 가능합니다.');
                    filesInput.value = ''; // Clear the input
                    return;
                }
                selectedFiles = selectedFiles.concat(newFiles);
                renderPreviews();
                updateFileInput();
            });

            function renderPreviews() {
                imagePreview.innerHTML = ''; // Clear existing previews

                if (selectedFiles.length < 5) {
                    const addBtnDiv = document.createElement('div');
                    addBtnDiv.className = 'add-image-btn';
                    addBtnDiv.innerHTML = '+';
                    addBtnDiv.addEventListener('click', (e) => {
                        e.stopPropagation(); // Prevent event bubbling
                        filesInput.click(); // Trigger file input click
                    });
                    imagePreview.appendChild(addBtnDiv);
                }

                selectedFiles.forEach((file) => {
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        const previewDiv = document.createElement('div');
                        const img = document.createElement('img');
                        img.src = e.target.result;

                        const delBtn = document.createElement('button');
                        delBtn.innerHTML = '&times;';
                        delBtn.type = 'button'; // Important for not submitting form
                        delBtn.addEventListener('click', (event) => {
                            event.stopPropagation(); // Prevent event bubbling
                            selectedFiles = selectedFiles.filter(f => f !== file);
                            renderPreviews();
                            updateFileInput();
                        });

                        previewDiv.appendChild(img);
                        previewDiv.appendChild(delBtn);

                        const addButton = imagePreview.querySelector('.add-image-btn');
                        if (addButton) {
                            imagePreview.insertBefore(previewDiv, addButton);
                        } else {
                            imagePreview.appendChild(previewDiv);
                        }
                    };
                    reader.readAsDataURL(file);
                });
            }

            function updateFileInput() {
                const dataTransfer = new DataTransfer();
                selectedFiles.forEach((file) => dataTransfer.items.add(file));
                filesInput.files = dataTransfer.files;
            }

            window.validateForm = function() {
                const title = document.getElementById('postTitle').value.trim();
                const postContent = document.getElementById('postContent').value.trim();
                // const finalCategoryCodeVal = document.getElementById('categoryCode').value; // categoryCode element is not in the HTML
                const orderNoInput = document.getElementById('orderNo');
                const orderNoVal = orderNoInput ? orderNoInput.value.trim() : "";

                if (!title) {
                    alert('제목을 입력하세요.');
                    document.getElementById('postTitle').focus();
                    return false;
                }
                if (!postContent) {
                    alert('내용을 입력하세요.');
                    document.getElementById('postContent').focus();
                    return false;
                }
                if (!orderNoVal) {
                    alert('주문 번호를 입력하세요.');
                    if (orderNoInput) orderNoInput.focus();
                    return false;
                }
                // Regex for Order Number: Starts with 'O' followed by 10 digits.
                if (orderNoVal && !/^O\d{10}$/.test(orderNoVal)) {
                    alert('유효하지 않은 주문 번호 형식입니다. (예: O2405220001)');
                    if (orderNoInput) orderNoInput.focus();
                    return false;
                }
                if (selectedFiles.length === 0) {
                    alert('이미지를 1장 이상 업로드해주세요.');
                    return false;
                }
                if (selectedFiles.length > 5) {
                    alert('최대 5장까지 업로드 가능합니다.');
                    return false;
                }
                return true;
            };

            renderPreviews(); // Initial call to show the '+' button if no files are pre-selected
        });
    </script>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>