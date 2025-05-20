<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>스타일 올리기</title>
  <style>
    * { box-sizing: border-box; }
    body {
      font-family: Arial, sans-serif;
      background-color: #fff;
    }

    .container {
      max-width: 800px;
      margin: auto;
    }

    h2 {
      text-align: center;
      border-bottom: 2px solid #ccc;
      padding-bottom: 10px;
    }

    label {
      font-weight: bold;
      display: block;
      margin-bottom: 5px;
    }

    #title, textarea {
      width: 100%;
      padding: 8px;
      margin-bottom: 15px;
      border: 1px solid #aaa;
      border-radius: 4px;
    }

    textarea {
      resize: vertical;
    }

    .image-preview {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      margin-bottom: 10px;
    }

    .image-box {
      position: relative;
      width: 120px;
      height: 120px;
      border: 2px dashed #aaa;
      display: flex;
      justify-content: center;
      align-items: center;
      color: #aaa;
      font-size: 14px;
      cursor: pointer;
      background-color: #fafafa;
    }

    .image-box img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .image-box.add {
      font-size: 32px;
      font-weight: bold;
      color: #555;
      border-style: solid;
    }

    .remove-btn, .edit-btn {
      position: absolute;
      top: 2px;
      width: 20px;
      height: 20px;
      font-size: 12px;
      border: none;
      cursor: pointer;
      color: white;
      border-radius: 3px;
    }

    .remove-btn {
      right: 2px;
      background: red;
    }

    .edit-btn {
      left: 2px;
      background: #007bff;
    }

    .submit-buttons {
      text-align: right;
      margin: 20px 0;
    }

    .submit-buttons > button {
      padding: 8px 16px;
      margin-left: 10px;
      font-size: 14px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    /* 카테고리 선택 관련 스타일 */
    .form-row.category-row {
      margin-top: 30px;
    }

    .form-row.category-row .category-col {
      width: 150px;
      height: 200px;
      border: 1px solid #ccc;
      padding: 10px;
      box-sizing: border-box;
      background-color: #fff;
      overflow-y: auto;
    }

    .form-row.category-row .category-col ul {
      list-style: none;
      margin: 0;
      padding: 0;
    }

    .form-row.category-row .category-col li {
      cursor: pointer;
      padding: 6px 0;
      font-size: 14px;
      color: #000;
      transition: color 0.2s;
    }

    .form-row.category-row .category-col li:hover {
      text-decoration: underline;
      color: #007acc;
    }

    .form-row.category-row .category-col li.active {
      font-weight: bold;
      color: #d60000;
    }

    #selectedCategory {
      font-size: 14px;
      color: #d60000;
      font-weight: bold;
      margin-top: 10px;
    }
  </style>
</head>
<body>
<!-- 헤더 영역: 상단 로고 및 메뉴 -->
<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>
	<div class="container">
  	<h2>스타일 올리기</h2>

  	<form id="uploadForm" action="${pageContext.request.contextPath}/review/write" method="post" enctype="multipart/form-data">

    <label for="title">제목</label>
    <input type="text" id="title" name="title" maxlength="20" placeholder="최대 20자 가능합니다. / 스타일을 자랑해보세요.">

    <label for="content">내용</label>
    <textarea id="content" name="content" rows="4" maxlength="200" placeholder="최대 200자 가능합니다. / 스타일을 자랑해보세요."></textarea>

    <label>이미지</label>
    <div class="image-preview" id="imagePreview">
      <div class="image-box add" id="addImageBox">+</div>
    </div>
    <input type="file" id="imageInput" name="upfile" accept="image/*" multiple hidden>
    <small>가장 먼저 등록한 이미지가 썸네일입니다. (최대 5장)</small>

    <br><br>

    <label>댓글 기능</label>
    <label style="font-weight : normal;"><input type="radio" name="commentEnabled" value="Y" checked> 댓글기능 활성화</label>
    <label style="font-weight : normal;"><input type="radio" name="commentEnabled" value="N"> 댓글기능 비활성화</label>

    <br><br>

    <!-- 카테고리 영역 -->
    <div class="form-row category-row">
      <label class="form-label">카테고리</label>
      <div class="category-container" style="display: flex; gap: 20px;">
        <div class="category-col" id="category-level1">
          <ul>
            <li data-value="남성">1. 남성</li>
            <li data-value="여성">2. 여성</li>
            <li data-value="공용">3. 공용</li>
          </ul>
        </div>
        <div class="category-col" id="category-level2">
          <ul id="midCategoryList"></ul>
        </div>
        <div class="category-col" id="category-level3">
          <ul id="subCategoryList"></ul>
        </div>
      </div>
      <div id="selectedCategory">현재 설정한 카테고리:</div>
    </div>

    <input type="hidden" name="categoryCode" id="categoryCode">

    <div class="submit-buttons">
      <button type="submit">등록하기</button>
    </div>

  </form>
</div>

<!-- Footer Include -->
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
<!-- JavaScript (생략된 부분 없이 완성된 버전 필요시 다시 요청해주세요) -->
<script>
  const imageInput = document.getElementById("imageInput");
  const imagePreview = document.getElementById("imagePreview");
  const addImageBox = document.getElementById("addImageBox");
  let imageCount = 0;

  addImageBox.addEventListener("click", () => {
    if (imageCount >= 5) {
      alert("이미지는 최대 5개까지 등록 가능합니다.");
      return;
    }
    imageInput.click();
  });

  imageInput.addEventListener("change", function () {
    const files = Array.from(this.files);
    files.forEach(file => {
      if (imageCount >= 5) return;
      const reader = new FileReader();
      reader.onload = function (e) {
        const imgBox = document.createElement("div");
        imgBox.className = "image-box";
        imgBox.innerHTML = `
          <img src="${e.target.result}" alt="미리보기">
          <button class="remove-btn" title="삭제">×</button>
          <button class="edit-btn" title="변경">✎</button>
        `;
        imgBox.querySelector(".remove-btn").addEventListener("click", () => {
          imgBox.remove();
          imageCount--;
        });
        imgBox.querySelector(".edit-btn").addEventListener("click", () => {
          const tempInput = document.createElement("input");
          tempInput.type = "file";
          tempInput.accept = "image/*";
          tempInput.onchange = (e) => {
            const newFile = e.target.files[0];
            if (newFile) {
              const newReader = new FileReader();
              newReader.onload = (ev) => {
                imgBox.querySelector("img").src = ev.target.result;
              };
              newReader.readAsDataURL(newFile);
            }
          };
          tempInput.click();
        });
        imagePreview.insertBefore(imgBox, addImageBox);
        imageCount++;
      };
      reader.readAsDataURL(file);
    });
    this.value = "";
  });

  // 카테고리 JS 코드 (동일 유지)
  document.addEventListener('DOMContentLoaded', () => {
    const level1Items = document.querySelectorAll('#category-level1 li');
    const midCategoryList = document.getElementById('midCategoryList');
    const subCategoryList = document.getElementById('subCategoryList');
    const selectedCategory = document.getElementById('selectedCategory');

    const midCategories = {
      '남성': [{code:'B1',name:'남성 아우터'},{code:'B2',name:'남성 상의'},{code:'B3',name:'남성 하의'},{code:'B4',name:'남성 악세사리'}],
      '여성': [{code:'B5',name:'여성 아우터'},{code:'B6',name:'여성 상의'},{code:'B7',name:'여성 하의'},{code:'B8',name:'여성 악세사리'}],
      '공용': [{code:'B9',name:'공용 아우터'},{code:'B10',name:'공용 상의'},{code:'B11',name:'공용 하의'},{code:'B12',name:'공용 악세사리'}]
    };

    const subCategories = {
      'B1': [{code:'C01',name:'남성 점퍼'},{code:'C02',name:'남성 자켓'},{code:'C03',name:'남성 코트'},{code:'C04',name:'남성 패딩'}],
      'B2': [{code:'C05',name:'남성 긴팔티'},{code:'C06',name:'남성 반팔티'},{code:'C07',name:'남성 니트'},{code:'C08',name:'남성 후드'},{code:'C09',name:'남성 셔츠'}],
      'B3': [{code:'C10',name:'남성 데님팬츠'},{code:'C11',name:'남성 정장팬츠'},{code:'C12',name:'남성 반바지'}],
      'B4': [{code:'C13',name:'남성 신발'},{code:'C14',name:'남성 목걸이'},{code:'C15',name:'남성 반지'},{code:'C16',name:'남성 모자'}],
      'B5': [{code:'C17',name:'여성 점퍼'},{code:'C18',name:'여성 자켓'},{code:'C19',name:'여성 코트'},{code:'C20',name:'여성 패딩'}],
      'B6': [{code:'C21',name:'여성 긴팔티'},{code:'C22',name:'여성 반팔티'},{code:'C23',name:'여성 니트'},{code:'C24',name:'여성 후드'},{code:'C25',name:'여성 셔츠'}],
      'B7': [{code:'C26',name:'여성 데님팬츠'},{code:'C27',name:'여성 정장팬츠'},{code:'C28',name:'여성 반바지'}],
      'B8': [{code:'C29',name:'여성 신발'},{code:'C30',name:'여성 목걸이'},{code:'C31',name:'여성 반지'},{code:'C32',name:'여성 모자'}],
      'B9': [{code:'C33',name:'공용 점퍼'},{code:'C34',name:'공용 자켓'},{code:'C35',name:'공용 코트'},{code:'C36',name:'공용 패딩'}],
      'B10': [{code:'C37',name:'공용 긴팔티'},{code:'C38',name:'공용 반팔티'},{code:'C39',name:'공용 니트'},{code:'C40',name:'공용 후드'},{code:'C41',name:'공용 셔츠'}],
      'B11': [{code:'C42',name:'공용 데님팬츠'},{code:'C43',name:'공용 정장팬츠'},{code:'C44',name:'공용 반바지'}],
      'B12': [{code:'C45',name:'공용 신발'},{code:'C46',name:'공용 목걸이'},{code:'C47',name:'공용 반지'},{code:'C48',name:'공용 모자'}]
    };

    let selectedMain = '', selectedMid = '', selectedSub = '';

    function updateCategoryText() {
      const categoryParts = [selectedMain, selectedMid, selectedSub].filter(Boolean);
      selectedCategory.textContent = "현재 설정한 카테고리: " + categoryParts.join(" / ");
    }

    level1Items.forEach(item => {
      item.addEventListener('click', () => {
        level1Items.forEach(li => li.classList.remove('active'));
        item.classList.add('active');
        selectedMain = item.dataset.value;
        selectedMid = '';
        selectedSub = '';
        midCategoryList.innerHTML = '';
        subCategoryList.innerHTML = '';

        const mids = midCategories[selectedMain];
        mids.forEach(mid => {
          const li = document.createElement('li');
          li.textContent = mid.name;
          li.dataset.code = mid.code;
          li.dataset.name = mid.name;
          li.classList.add('mid-category-item');
          li.addEventListener('click', () => {
            document.querySelectorAll('.mid-category-item').forEach(el => el.classList.remove('active'));
            li.classList.add('active');
            selectedMid = li.dataset.name;
            selectedSub = '';
            subCategoryList.innerHTML = '';

            const subs = subCategories[li.dataset.code];
            subs.forEach(sub => {
              const subLi = document.createElement('li');
              subLi.textContent = sub.name;
              subLi.dataset.name = sub.name;
              subLi.dataset.code = sub.code;
              subLi.classList.add('sub-category-item');
              subLi.addEventListener('click', () => {
                document.querySelectorAll('.sub-category-item').forEach(el => el.classList.remove('active'));
                subLi.classList.add('active');
                selectedSub = subLi.dataset.name;
                document.getElementById("categoryCode").value = subLi.dataset.code;
                updateCategoryText();
              });
              subCategoryList.appendChild(subLi);
            });
            updateCategoryText();
          });
          midCategoryList.appendChild(li);
        });
        updateCategoryText();
      });
    });
  });
</script>


</body>
</html>
