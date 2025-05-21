-- system 계정으로 semi 계정 생성
CREATE USER semi IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO semi;

-- semi 계정으로 접속
/*
만들어야 하는 테이블
1. 회원 정보 테이블(TBL_MEMBER) O
2. 상품 카테고리 테이블(TBL_PROD_CATEGORY) O
3. 배송방법 테이블(TBL_DELIVERY_FEE) O
4. 상품상태 테이블(TBL_PROD_STATUS) O
5. 상품 정보 테이블(TBL_PROD) O
6. 상품 주문 정보 테이블(TBL_PURCHASE) O
7. 결제 API 테이블(TBL_PG)
8. 스타일 후기 게시판 테이블(TBL_STYLE_POST) O
9. 파일 테이블(TBL_FILE) O
10. 댓글 테이블(TBL_COMMENT) O
11. 평점 테이블(TBL_USER_RATING) O
12. 찜하기 테이블(TBL_WISHLIST) O
13. 신고 사유 테이블(TBL_REPORT) O
14. 신고 내역 테이블(TBL_REPORT_POST) O
15. 블랙 리스트 테이블(TBL_BLACKLIST) O
16. 공지사항 테이블(TBL_NOTICE) O
17. 이벤트 테이블(TBL_EVENT) O
*/

-- 회원 정보 테이블(TBL_MEMBER)
CREATE TABLE TBL_MEMBER (
    MEMBER_NO VARCHAR2(11) PRIMARY KEY,             -- 회원 번호 : M + yymmdd + 0001 형식
    MEMBER_ID VARCHAR2(30) UNIQUE NOT NULL,         -- 회원 아이디
    MEMBER_PW VARCHAR2(30) NOT NULL,                -- 회원 비밀번호
    MEMBER_NICKNAME VARCHAR2(30) UNIQUE NOT NULL,   -- 회원 닉네임
    MEMBER_NAME VARCHAR2(30) NOT NULL,              -- 회원 이름
    MEMBER_BIRTH DATE NOT NULL,                     -- 회원 생년월일
    MEMBER_PHONE CHAR(13) NOT NULL,                 -- 회원 전화번호
    MEMBER_ADDR VARCHAR2(300) NOT NULL,             -- 회원 주소
    MEMBER_EMAIL VARCHAR2(300) NOT NULL,            -- 회원 이메일
    JOIN_DATE DATE DEFAULT SYSDATE NOT NULL,        -- 회원 가입일
    MEMBER_RATE NUMBER DEFAULT 0 NOT NULL,          -- 회원 평점
    
);

-- 회원 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_MEMBER
MAXVALUE 9999
CYCLE;

-- 관리자 계정
INSERT INTO TBL_MEMBER VALUES ('M' || TO_CHAR(SYSDATE, 'YYMMDD') || LPAD(SEQ_MEMBER.NEXTVAL, 4, '0'),
'admin', '1234', '관리자', '관리자', sysdate, '010-1234-1234', '주소', 'admin@gmail.com', sysdate, 5);


-- 상품 카테고리 테이블(TBL_PROD_CATEGORY)
CREATE TABLE TBL_PROD_CATEGORY (
    CATEGORY_CODE CHAR(3) PRIMARY KEY,      -- 카테고리 코드
    CATEGORY_NAME VARCHAR2(30) NOT NULL,    -- 카테고리 이름
    PAR_CATEGORY_CODE CHAR(3)               -- 상위 카테고리 코드
);

-- 카테고리 INSERT
INSERT INTO TBL_PROD_CATEGORY VALUES ('A01', '남성', NULL);
INSERT INTO TBL_PROD_CATEGORY VALUES ('A02', '여성', NULL);
INSERT INTO TBL_PROD_CATEGORY VALUES ('A03', '공용', NULL);
INSERT INTO TBL_PROD_CATEGORY VALUES ('B01', '아우터', 'A01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B02', '상의', 'A01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B03', '하의', 'A01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B04', '악세사리', 'A01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B05', '아우터', 'A02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B06', '상의', 'A02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B07', '하의', 'A02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B08', '악세사리', 'A02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B09', '아우터', 'A03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B10', '상의', 'A03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B11', '하의', 'A03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B12', '악세사리', 'A03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C01', '점퍼', 'B01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C02', '자켓', 'B01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C03', '코트', 'B01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C04', '패딩', 'B01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C05', '긴팔티', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C06', '반팔티', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C07', '니트', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C08', '후드', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C09', '셔츠', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C10', '데님팬츠', 'B03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C11', '정장팬츠', 'B03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C12', '반바지', 'B03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C13', '신발', 'B04');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C14', '모자', 'B04');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C15', '목걸이', 'B04');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C16', '반지', 'B04');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C17', '점퍼', 'B05');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C18', '자켓', 'B05');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C19', '코트', 'B05');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C20', '패딩', 'B05');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C21', '긴팔티', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C22', '반팔티', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C23', '니트', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C24', '후드', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C25', '셔츠', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C26', '데님팬츠', 'B07');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C27', '정장팬츠', 'B07');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C28', '반바지', 'B07');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C29', '신발', 'B08');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C30', '모자', 'B08');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C31', '목걸이', 'B08');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C32', '반지', 'B08');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C33', '점퍼', 'B09');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C34', '자켓', 'B09');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C35', '코트', 'B09');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C36', '패딩', 'B09');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C37', '긴팔티', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C38', '반팔티', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C39', '니트', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C40', '후드', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C41', '셔츠', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C42', '데님팬츠', 'B11');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C43', '정장팬츠', 'B11');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C44', '반바지', 'B11');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C45', '신발', 'B12');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C46', '모자', 'B12');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C47', '목걸이', 'B12');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C48', '반지', 'B12');


-- 배송방법 테이블(TBL_DELIVERY_FEE)
CREATE TABLE TBL_DELIVERY_FEE (
    TRADE_METHOD_CODE CHAR(2) PRIMARY KEY,          -- 배송방법 코드
    TRADE_METHOD_NAME VARCHAR2(30) UNIQUE NOT NULL  -- 배송방법
);

-- 배송방법 INSERT
INSERT INTO TBL_DELIVERY_FEE VALUES ('M1', '배송비 포함');
INSERT INTO TBL_DELIVERY_FEE VALUES ('M2', '배송비 미포함');
INSERT INTO TBL_DELIVERY_FEE VALUES ('M3', '배송비 착불');


-- 상품상태 테이블(TBL_PROD_STATUS)
CREATE TABLE TBL_PROD_STATUS (
    STATUS_CODE CHAR(3) PRIMARY KEY,            -- 상품상태 코드
    STATUS_NAME VARCHAR2(20) UNIQUE NOT NULL    -- 상품상태
);

-- 상품상태 INSERT
INSERT INTO TBL_PROD_STATUS VALUES ('S01', '판매 중');
INSERT INTO TBL_PROD_STATUS VALUES ('S02', '결제 완료');
INSERT INTO TBL_PROD_STATUS VALUES ('S03', '배송 전');
INSERT INTO TBL_PROD_STATUS VALUES ('S04', '배송 준비');
INSERT INTO TBL_PROD_STATUS VALUES ('S05', '배송 중');
INSERT INTO TBL_PROD_STATUS VALUES ('S06', '배송 완료');
INSERT INTO TBL_PROD_STATUS VALUES ('S07', '거래 완료');
INSERT INTO TBL_PROD_STATUS VALUES ('S08', '환불 신청');
INSERT INTO TBL_PROD_STATUS VALUES ('S09', '환불 완료');
INSERT INTO TBL_PROD_STATUS VALUES ('S10', '거래 실패');
INSERT INTO TBL_PROD_STATUS VALUES ('S11', '취소 신청');
INSERT INTO TBL_PROD_STATUS VALUES ('S12', '취소 완료');


-- 상품 정보 테이블(TBL_PROD)
CREATE TABLE TBL_PROD (
    PRODUCT_NO VARCHAR2(11) PRIMARY KEY,                                        -- 상품 번호 : P + yymmdd + 0001 형식
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO) ON DELETE CASCADE,  -- 회원 번호 (회원 정보 테이블, 회원 번호가 삭제되면 상품 정보도 삭제)
    PRODUCT_NAME VARCHAR2(100) NOT NULL,                                        -- 상품명
    PRODUCT_INTROD VARCHAR2(3000) NOT NULL,                                     -- 상품 설명
    PRODUCT_PRICE NUMBER NOT NULL,                                              -- 상품 가격 (원)
    CATEGORY_CODE CHAR(3) REFERENCES TBL_PROD_CATEGORY(CATEGORY_CODE),          -- 카테고리 코드 (카테고리 테이블)
    TRADE_METHOD_CODE CHAR(2) REFERENCES TBL_DELIVERY_FEE(TRADE_METHOD_CODE),   -- 배송방법 코드 (배송방법 테이블)
    STATUS_CODE CHAR(3) REFERENCES TBL_PROD_STATUS(STATUS_CODE),                -- 상품상태 코드 (상품상태 테이블)
    ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL,                                  -- 상품 등록일
    READ_COUNT NUMBER DEFAULT 0                                                 -- 조회수
    PRODUCT_QUANTITY NUMBER DEFAULT 1 NOT NULL                                  -- 상품 수량(판매 가능/불가)
);

-- 상품 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_PROD
MAXVALUE 9999
CYCLE;

-- 테스트 상품
INSERT INTO TBL_PROD VALUES ('P' || TO_CHAR(SYSDATE, 'YYMMDD') || LPAD(SEQ_PROD.NEXTVAL, 4, '0'),
'M2505120001', '나이키 신발', '한 번도 안 신은 신발입니다.', '50000', 'C13', 'M1', 'S01', DEFAULT, DEFAULT);

select * from tbl_prod;  

-- 상품 주문 정보 테이블(TBL_PURCHASE)
CREATE TABLE TBL_PURCHASE (
    ORDER_NO VARCHAR2(11) PRIMARY KEY,                          -- 주문 번호 : O + yymmdd + 0001 형식
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO),    -- 상품 번호 (상품 정보 테이블)
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),    -- 구매자 번호 (회원 정보 테이블)
    DELIVERY_FEE NUMBER NOT NULL,                               -- 배송비
    DELIVERY_ADDR VARCHAR2(300) NOT NULL,                       -- 배송 주소
    DEAL_DATE DATE DEFAULT SYSDATE NOT NULL,                    -- 거래 일시
    UPDATE_DATE DATE DEFAULT SYSDATE NOT NULL                   -- 상품 상태 갱신 일시 
);

select * from tbl_purchase;


-- 주문 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_PURCHASE
MAXVALUE 9999
CYCLE;

-- 스타일 후기 게시판 테이블(TBL_STYLE_POST)
CREATE TABLE TBL_STYLE_POST (
    STYLE_POST_NO VARCHAR2(11) PRIMARY KEY,                     -- 게시글 번호 : S + yymmdd + 0001 형식
    POST_TITLE VARCHAR2(100) NOT NULL,                          -- 게시글 제목
    POST_CONTENT VARCHAR2(3000) NOT NULL,                       -- 게시글 내용
    ORDER_NO VARCHAR2(11) REFERENCES TBL_PURCHASE(ORDER_NO),    -- 주문 번호 (상품 주문 정보 테이블)
    POST_DATE DATE DEFAULT SYSDATE NOT NULL,                    -- 게시글 작성일
    READ_COUNT NUMBER DEFAULT 0                                 -- 조회수
);

-- 주문 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_STYLE
MAXVALUE 9999
CYCLE;


-- 파일 테이블(TBL_FILE)
CREATE TABLE TBL_FILE (
    FILE_NO NUMBER PRIMARY KEY,                                                             -- 파일 번호
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO) ON DELETE CASCADE,              -- 상품 번호 (상품 정보 테이블)
    STYLE_POST_NO VARCHAR2(11) REFERENCES TBL_STYLE_POST(STYLE_POST_NO) ON DELETE CASCADE,  -- 게시글 번호 (스타일 후기 게시판 테이블)
    NOTICE_NO VARCHAR2(11) REFERENCES TBL_NOTICE(NOTICE_NO) ON DELETE CASCADE,              -- 공지사항 번호 (공지사항 테이블)
    EVENT_NO VARCHAR2(11) REFERENCES TBL_EVENT(EVENT_NO) ON DELETE CASCADE,                 -- 이벤트 번호 (이벤트 테이블)
    FILE_NAME VARCHAR2(300),                                                                -- 사용자가 업로드한 파일 명칭
    FILE_PATH VARCHAR2(300),                                                                -- 서버 내에 중복된 파일명이 존재하지 않도록 생성한 파일 명칭
    UPLOAD_DATE DATE DEFAULT SYSDATE NOT NULL                                               -- 파일 업로드 일시
);

-- 파일 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_FILE;

-- 파일 테스트
INSERT INTO TBL_FILE VALUES (SEQ_FILE.NEXTVAL, 'P2505120001', NULL, NULL, NULL, 'DDD', 'DDD', DEFAULT);


-- 댓글 테이블(TBL_COMMENT)
CREATE TABLE TBL_COMMENT (
    COMMENT_NO NUMBER PRIMARY KEY,                                                          -- 댓글 번호
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO) ON DELETE CASCADE,              -- 회원 번호 (회원 정보 테이블)
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO) ON DELETE CASCADE,              -- 상품 번호 (상품 정보 테이블)
    STYLE_POST_NO VARCHAR2(11) REFERENCES TBL_STYLE_POST(STYLE_POST_NO) ON DELETE CASCADE,  -- 게시글 번호 (스타일 후기 게시판 테이블)
    CONTENT VARCHAR2(300) NOT NULL,                                                         -- 댓글 내용
    CREATED_DATE DATE DEFAULT SYSDATE NOT NULL                                              -- 댓글 작성일
);

-- 댓글 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_COMMENT;

-- 댓글 테스트
INSERT INTO TBL_COMMENT VALUES (SEQ_COMMENT.NEXTVAL, 'M2505120001', 'P2505120001', NULL, '신발 멋지네요', DEFAULT);


-- 평점 테이블(TBL_USER_RATING)
CREATE TABLE TBL_USER_RATING (
    RATING_NO NUMBER PRIMARY KEY,                               -- 평점 번호
    ORDER_NO VARCHAR2(11) REFERENCES TBL_PURCHASE(ORDER_NO),    -- 주문 번호 (상품 주문 정보 테이블)
    RATING_SCORE NUMBER NOT NULL,                               -- 평점
    RATING_DATE DATE DEFAULT SYSDATE NOT NULL                   -- 평점 일자
);

-- 평점 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_RATING;


-- 찜하기 테이블(TBL_WISHLIST)
CREATE TABLE TBL_WISHLIST (
    WISHLIST_NO NUMBER PRIMARY KEY,                                             -- 찜 번호
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO) ON DELETE CASCADE,  -- 상품 번호 (상품 정보 테이블)
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO) ON DELETE CASCADE,  -- 찜한 회원 번호 (회원 정보 테이블)
    WISHLIST_DATE DATE DEFAULT SYSDATE NOT NULL                                 -- 찜한 일자
);

-- 찜 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_WISHLIST;


-- 신고 사유 테이블(TBL_REPORT)
CREATE TABLE TBL_REPORT (
    REPORT_CODE VARCHAR2(3) PRIMARY KEY,        -- 신고 사유 코드
    REPORT_REASON VARCHAR2(100) NOT NULL        -- 신고 사유
);

-- 신고 사유 코드 INSERT
INSERT INTO TBL_REPORT VALUES ('RE1', '저작권 침해');
INSERT INTO TBL_REPORT VALUES ('RE2', '상표권 침해');
INSERT INTO TBL_REPORT VALUES ('RE3', '거래 금지 품목');
INSERT INTO TBL_REPORT VALUES ('RE4', '청소년 유해매체물');


-- 신고 내역 테이블(TBL_REPORT_POST)
CREATE TABLE TBL_REPORT_POST (
    REPORT_NO NUMBER PRIMARY KEY,                                           -- 신고 번호
    REPORT_CODE VARCHAR2(3) REFERENCES TBL_REPORT(REPORT_CODE),             -- 신고 사유 코드 (신고 사유 테이블)
    REPORTED_MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),       -- 신고한 회원 번호 (회원 정보 테이블)
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO),                -- 신고당한 상품 번호 (상품 정보 테이블)
    REPORT_DATE DATE DEFAULT SYSDATE NOT NULL                               -- 신고 날짜
);

-- 신고 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_REPORT;


-- 블랙 리스트 테이블(TBL_BLACKLIST)
CREATE TABLE TBL_BLACKLIST (
    BLACK_NO NUMBER PRIMARY KEY,                                -- 블랙 번호
    REPORT_NO NUMBER REFERENCES TBL_REPORT_POST(REPORT_NO),     -- 신고 번호 (신고 내역 테이블)
    BLACK_REASON VARCHAR2(300) NOT NULL,                        -- 블랙 사유
    BLACK_DATE DATE DEFAULT SYSDATE NOT NULL                    -- 블랙 등록일
);

-- 블랙 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_BLACK;


-- 공지사항 테이블(TBL_NOTICE)
CREATE TABLE TBL_NOTICE (
    NOTICE_NO VARCHAR2(11) PRIMARY KEY,                             -- 공지사항 번호 : N + yymmdd + 0001
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),        -- 관리자 번호 (회원 정보 테이블)
    NOTICE_TITLE VARCHAR2(100) NOT NULL,                            -- 공지사항 제목
    NOTICE_CONTENT VARCHAR2(300) NOT NULL,                          -- 공지사항 내용
    NOTICE_ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL,               -- 게시일
    READ_COUNT NUMBER DEFAULT 0                                     -- 조회수
);

-- 공지사항 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_NOTICE
MAXVALUE 9999
CYCLE;
select * from tbl_member;
insert into tbl_notice values ('N' || to_char(sysdate, 'yymmdd') || lpad(seq_notice.nextval, 4, '0'), 'M2505110001', '공지사항1', '내용1', default, default);


-- 이벤트 테이블(TBL_EVENT)
CREATE TABLE TBL_EVENT (
    EVENT_NO VARCHAR2(11) PRIMARY KEY,                              -- 이벤트 번호 : E + yymmdd + 0001
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),        -- 관리자 번호 (회원 정보 테이블)
    EVENT_TITLE VARCHAR2(100) NOT NULL,                             -- 이벤트 제목
    EVNET_CONTENT VARCHAR2(300) NOT NULL,                           -- 이벤트 내용
    EVENT_ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL,                -- 게시일
    READ_COUNT NUMBER DEFAULT 0                                     -- 조회수
);

-- 이벤트 번호 생성 시 사용할 시퀀스
CREATE SEQUENCE SEQ_EVENT
MAXVALUE 9999
CYCLE;

-- 모든 수정 사항은 위의 테이블들을 모두 생성한 다음 '수정'할 수 있도록 작성했습니다. 
-- 먼저 테이블을 작성한 후에, 아래의 명령어들을 하나씩 실행해 주세요.

-- 회원당 제품 한개에 하나의 찜만 할 수 있도록 UNIQUE 설정 (0512 16:05)
    ALTER TABLE TBL_WISHLIST
    ADD CONSTRAINT UQ_WISHLIST_MEMBER_PRODUCT
    UNIQUE (MEMBER_NO, PRODUCT_NO);    -- UNIQUE 제약 설정
    
-- 회원이 찜을 누른 상태로 다시 누르면 찜이 해제되는 INSERT/DELETE 방식으로 수정 ( 0512 16:05 ) 
-- END; 하단의 / 까지 포함해서 전체 드래그 후 실행해야 오류가 나지 않음.

DECLARE
    v_count NUMBER;
BEGIN
    -- 1. 해당 회원이 이미 찜했는지 확인
    SELECT COUNT(*)
    INTO v_count
    FROM TBL_WISHLIST
    WHERE MEMBER_NO = 'M2505110001'
      AND PRODUCT_NO = 'P2505110005';

    -- 2. 찜 안 했으면 INSERT
    IF v_count = 0 THEN
        INSERT INTO TBL_WISHLIST (
            WISHLIST_NO, MEMBER_NO, PRODUCT_NO, WISHLIST_DATE
        ) VALUES (
            SEQ_WISHLIST.NEXTVAL, 'M2505110001', 'P2505110005', SYSDATE
        );

    -- 3. 찜 돼있으면 DELETE (찜 해제)
    ELSE
        DELETE FROM TBL_WISHLIST
        WHERE MEMBER_NO = 'M2505110001'
          AND PRODUCT_NO = 'P2505110005';
        END IF;
    END;
/

-- 배송비에 음수 제약 조건 ( -NNNN원이 불가능하게 ) 제시 ( 0512 16:34 )
ALTER TABLE TBL_PURCHASE
ADD CONSTRAINT CK_DELIVERY_FEE_NONNEG
CHECK (DELIVERY_FEE >= 0);

-- 상품 가격에 음수 제약 조건 ( -NNNN원으로 등록이 불가능하게 ) 제시 ( 0512 16:40 )
ALTER TABLE TBL_PROD
ADD CONSTRAINT CK_PROD_PRICE_NONNEGATIVE
CHECK (PRODUCT_PRICE >= 0);

-- 이벤트 테이블(TBL_EVENT) ( 이벤트 테이블 오타 수정 EVNET_CONTENT -> EVENT_CONTENT ) (0512-16:19)
ALTER TABLE TBL_EVENT
RENAME COLUMN EVNET_CONTENT TO EVENT_CONTENT;

-- 추가 업데이트 해야 하는 사항 정리
-- 1. 12개나 되는 상품상태를 어떤 기준과 권한으로 상태전환 시킬지 정해야 함. 
-- 2. 결제 API 테이블 완성

SELECT * FROM TBL_MEMBER;

SELECT * FROM TBL_PROD_CATEGORY;

SELECT C.CATEGORY_CODE,
       C.CATEGORY_NAME,
       C.PAR_CATEGORY_CODE,
       P.CATEGORY_NAME 상위카테고리
  FROM TBL_PROD_CATEGORY P
  JOIN TBL_PROD_CATEGORY C
    ON (P.CATEGORY_CODE = C.PAR_CATEGORY_CODE)
 WHERE C.PAR_CATEGORY_CODE = 'B02';
 
SELECT * FROM TBL_DELIVERY_FEE;

SELECT * FROM TBL_PROD_STATUS;

SELECT * FROM TBL_PROD;

SELECT MEMBER_NICKNAME,
       PRODUCT_NAME,
       PRODUCT_INTROD,
       PRODUCT_PRICE,
       CATEGORY_NAME,
       TRADE_METHOD_NAME,
       STATUS_NAME
  FROM TBL_PROD
  JOIN TBL_MEMBER USING(MEMBER_NO)
  JOIN TBL_PROD_CATEGORY USING(CATEGORY_CODE)
  JOIN TBL_DELIVERY_FEE USING(TRADE_METHOD_CODE)
  JOIN TBL_PROD_STATUS USING(STATUS_CODE);
  
SELECT * FROM TBL_PURCHASE;

SELECT * FROM TBL_STYLE_POST;

SELECT * FROM TBL_FILE;

SELECT * FROM TBL_COMMENT;

SELECT * FROM TBL_PROD;

COMMIT;

-- ------------------------------------------------------
/*
TBL_PROD 에 PRODCUT_QUANTITY 컬럼 추가
추가 사유 : 해당 상품 상태 판매 가능/불가 값을 바로 판단하기 위함이며 현재 '상품 상태'로는 상태값이 너무 많고 복잡하여 각 담당하시는 분들께서 상품 노출 조건 등에 사용할수 있도록 함입니다.
*/

ALTER TABLE TBL_PROD
  ADD (PRODUCT_QUANTITY NUMBER DEFAULT 1 NOT NULL);

COMMENT ON COLUMN TBL_PROD.PRODUCT_QUANTITY IS '상품 재고 수량(1: 재고 있음 / 0:판매 완료)';

COMMIT;

-- -----------------------------------------------------------
-- SQL문 수정이 좀 있었습니다. 나중에 상품상세 페이지 들어가기 전, SQL문에 다음 명령어들 그대로 실행하시면 됩니다.

-- 가격 제안 여부를 저장할 컬럼 추가
-- 'Y' = 가격 제안 받기, 'N' = 받지 않음
ALTER TABLE TBL_PROD
ADD PRICE_OFFER_YN VARCHAR2(1) DEFAULT 'N' CHECK (PRICE_OFFER_YN IN ('Y', 'N'));
--2.

-- 대댓글 구현을 위한 부모 댓글 번호 컬럼 추가
ALTER TABLE TBL_COMMENT
ADD PARENT_COMMENT_NO NUMBER REFERENCES TBL_COMMENT(COMMENT_NO);

-- 상품 가격 최대치 구현
ALTER TABLE TBL_PROD
ADD CONSTRAINT CK_PROD_PRICE_RANGE
CHECK (PRODUCT_PRICE >= 0 AND PRODUCT_PRICE <= 1000000000);

commit;





-- ---------------------------------------------------------------
-- 20250520 화요일 SQL 변경 사항 공유
-- ★참조하는 외래 키(FK) 제약조건 삭제
ALTER TABLE TBL_USER_RATING
DROP CONSTRAINT SYS_C007425;

ALTER TABLE TBL_STYLE_POST
DROP CONSTRAINT SYS_C007415;

-- ★기존 TBL_PURCHASE 테이블 삭제
DROP TABLE TBL_PURCHASE;

-- 주문 상태 코드 테이블 추가
CREATE TABLE TBL_PURCHASE_STATUS (
    PURCHASE_STATUS_CODE VARCHAR2(4) PRIMARY KEY,
    STATUS_NAME VARCHAR2(30) NOT NULL
);

-- 예시 상태 추가
INSERT INTO TBL_PURCHASE_STATUS (PURCHASE_STATUS_CODE, STATUS_NAME) VALUES ('PS00', '결제대기');
INSERT INTO TBL_PURCHASE_STATUS (PURCHASE_STATUS_CODE, STATUS_NAME) VALUES ('PS01', '결제완료');
-- ... 기타 필요한 상태들 차후 추가 예정...

-- 상품 주문 정보 테이블(TBL_PURCHASE)
CREATE TABLE TBL_PURCHASE (
    ORDER_NO VARCHAR2(11) PRIMARY KEY,                          -- 주문 번호 : O + yymmdd + 0001 형식
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO),    -- 상품 번호 (상품 정보 테이블)
    SELLER_MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO), -- 판매자 번호(회원 정보 테이블)
    BUYER_MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),  -- 구매자 번호(회원 정보 테이블)
    DELIVERY_ADDR VARCHAR2(300),                       -- 배송 주소
    DELIVERY_FEE NUMBER DEFAULT 0 NOT NULL,                               -- 배송비
    ORDER_AMOUNT NUMBER NOT NULL,                              -- 총 구매 금액
    PG_PROVIDER VARCHAR2(20),                                   -- PG사 정보
    PG_TRANSACTION_ID VARCHAR2(100),                             -- PG사 거래 ID 값    
    DEAL_DATE DATE DEFAULT SYSDATE NOT NULL,                    -- 거래 일시    
    PURCHASE_STATUS_CODE VARCHAR2(4) REFERENCES TBL_PURCHASE_STATUS(PURCHASE_STATUS_CODE) -- 주문 상태 코드
);

-- TBL_USER_RATING 테이블에 FK 다시 추가 (컬럼명과 제약조건명은 실제 사용하는 것으로 변경)
ALTER TABLE TBL_USER_RATING
ADD CONSTRAINT FK_USER_RATING_ORDER_NO -- 새로운 FK 제약조건 이름 (예시)
FOREIGN KEY (ORDER_NO) -- TBL_USER_RATING 테이블의 ORDER_NO 컬럼 (또는 다른 이름일 수 있음)
REFERENCES TBL_PURCHASE(ORDER_NO);

-- TBL_STYLE_POST 테이블에 FK 다시 추가 (컬럼명과 제약조건명은 실제 사용하는 것으로 변경)
ALTER TABLE TBL_STYLE_POST
ADD CONSTRAINT FK_STYLE_POST_ORDER_NO -- 새로운 FK 제약조건 이름 (예시)
FOREIGN KEY (ORDER_NO) -- TBL_STYLE_POST 테이블의 ORDER_NO 컬럼 (또는 다른 이름일 수 있음)
REFERENCES TBL_PURCHASE(ORDER_NO);

-- 주문 번호 생성 시 사용할 시퀀스(이미 생성되어 있으면 추가 생성 할 필요 없음!!)
CREATE SEQUENCE SEQ_PURCHASE
MAXVALUE 9999
CYCLE;

COMMIT;

select * from TBL_PURCHASE;
select * from tbl_prod;
select * from tbl_member;
SELECT * FROM TBL_PURCHASE_STATUS;

SELECT * FROM TBL_PROD WHERE PRODUCT_NO = 'P2505120001';

delete from tbl_purchase;
commit;

select*from tbl_purchase_status;
SELECT * FROM TBL_PROD_STATUS WHERE STATUS_CODE = 'S02';
