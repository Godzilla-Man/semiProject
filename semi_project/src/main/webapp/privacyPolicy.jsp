<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인정보 수집 및 이용 동의</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #f8f8f8;
            color: #333;
        }
        .terms-container {
            width: 100%;
            max-width: 800px; /* 가독성을 위한 최대 너비 */
            margin: 20px auto;
            padding: 30px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        h1 {
            text-align: center;
            color: #0064FF; /* 줍줍 서비스의 포인트 컬러 (예시) */
            margin-bottom: 20px; /* h1 마진 조정 */
            font-size: 22px; /* h1 크기 조정 */
        }
        p {
            font-size: 14px;
            margin-bottom: 15px; /* 문단 간격 조정 */
            text-align: justify;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            margin-bottom: 20px;
            font-size: 13px; /* 테이블 내 폰트 크기 */
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px; /* 셀 패딩 조정 */
            text-align: left;
            vertical-align: top; /* 내용이 길 경우 상단 정렬 */
        }
        th {
            background-color: #f5f5f5;
            font-weight: 600; /* th 폰트 두께 */
            text-align: center; /* th 텍스트 중앙 정렬 */
        }
        .notice { /* 하단 안내 문구 스타일 */
            font-size: 13px;
            color: #555;
            margin-top: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 4px;
        }

    </style>
</head>
<body>
    <div class="terms-container">
        <h1>개인정보 수집 및 이용 동의</h1>

        <p>줍줍은 이용자의 권익 및 개인정보 보호에 만전을 기하고자 관계법령의 규정을 반영하여 줍줍의 안전결제를 사용하시는 이용자분들께 아래와 같이 개인정보의 수집 및 이용 목적, 개인정보의 항목, 개인정보의 보유 및 이용기간을 안내해 드립니다.</p>

        <table>
            <thead>
                <tr>
                    <th>목적</th>
                    <th>항목</th>
                    <th>보유 및 이용기간</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>안전결제 구매</td>
                    <td><span>필수</span> : 배송주소, 이름, 카드사 명, 은행명(가상계좌 결제시), 휴대전화번호, 이메일</td>
                    <td>동의철회 또는 회원탈퇴시</td>
                </tr>
                <tr>
                    <td>안전결제 정산</td>
                    <td><span>필수</span> : 은행명, 이름, 계좌번호</td>
                    <td>동의철회 또는 회원탈퇴시</td>
                </tr>
                <tr>
                    <td>안전결제 환불</td>
                    <td><span>필수</span> : 은행명, 이름, 계좌번호</td>
                    <td>동의철회 또는 회원탈퇴시</td>
                </tr>
            </tbody>
        </table>

        <div class="notice">
            <p>본 동의는 줍줍의 안전결제 서비스 이용을 위한 개인정보 수집·이용에 대한 동의로서, 개인정보의 수집 및 이용 동의를 거부할 수 있으나 수집·이용 동의를 거부하는 경우 안전결제 서비스 이용이 어려울 수 있습니다.</p>
        </div>

    </div> </body>
</html>