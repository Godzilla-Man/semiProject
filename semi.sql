-- system �������� semi ���� ����
CREATE USER semi IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO semi;

-- semi �������� ����
/*
������ �ϴ� ���̺�
1. ȸ�� ���� ���̺�(TBL_MEMBER) O
2. ��ǰ ī�װ� ���̺�(TBL_PROD_CATEGORY) O
3. ��۹�� ���̺�(TBL_DELIVERY_FEE) O
4. ��ǰ���� ���̺�(TBL_PROD_STATUS) O
5. ��ǰ ���� ���̺�(TBL_PROD) O
6. ��ǰ �ֹ� ���� ���̺�(TBL_PURCHASE) O
7. ���� API ���̺�(TBL_PG)
8. ��Ÿ�� �ı� �Խ��� ���̺�(TBL_STYLE_POST) O
9. ���� ���̺�(TBL_FILE) O
10. ��� ���̺�(TBL_COMMENT) O
11. ���� ���̺�(TBL_USER_RATING) O
12. ���ϱ� ���̺�(TBL_WISHLIST) O
13. �Ű� ���� ���̺�(TBL_REPORT) O
14. �Ű� ���� ���̺�(TBL_REPORT_POST) O
15. �� ����Ʈ ���̺�(TBL_BLACKLIST) O
16. �������� ���̺�(TBL_NOTICE) O
17. �̺�Ʈ ���̺�(TBL_EVENT) O
*/

-- ȸ�� ���� ���̺�(TBL_MEMBER)
CREATE TABLE TBL_MEMBER (
    MEMBER_NO VARCHAR2(11) PRIMARY KEY,             -- ȸ�� ��ȣ : M + yymmdd + 0001 ����
    MEMBER_ID VARCHAR2(30) UNIQUE NOT NULL,         -- ȸ�� ���̵�
    MEMBER_PW VARCHAR2(30) NOT NULL,                -- ȸ�� ��й�ȣ
    MEMBER_NICKNAME VARCHAR2(30) UNIQUE NOT NULL,   -- ȸ�� �г���
    MEMBER_NAME VARCHAR2(30) NOT NULL,              -- ȸ�� �̸�
    MEMBER_BIRTH DATE NOT NULL,                     -- ȸ�� �������
    MEMBER_PHONE CHAR(13) NOT NULL,                 -- ȸ�� ��ȭ��ȣ
    MEMBER_ADDR VARCHAR2(300) NOT NULL,             -- ȸ�� �ּ�
    MEMBER_EMAIL VARCHAR2(300) NOT NULL,            -- ȸ�� �̸���
    JOIN_DATE DATE DEFAULT SYSDATE NOT NULL,        -- ȸ�� ������
    MEMBER_RATE NUMBER DEFAULT 0 NOT NULL,          -- ȸ�� ����
    
);

-- ȸ�� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_MEMBER
MAXVALUE 9999
CYCLE;

-- ������ ����
INSERT INTO TBL_MEMBER VALUES ('M' || TO_CHAR(SYSDATE, 'YYMMDD') || LPAD(SEQ_MEMBER.NEXTVAL, 4, '0'),
'admin', '1234', '������', '������', sysdate, '010-1234-1234', '�ּ�', 'admin@gmail.com', sysdate, 5);


-- ��ǰ ī�װ� ���̺�(TBL_PROD_CATEGORY)
CREATE TABLE TBL_PROD_CATEGORY (
    CATEGORY_CODE CHAR(3) PRIMARY KEY,      -- ī�װ� �ڵ�
    CATEGORY_NAME VARCHAR2(30) NOT NULL,    -- ī�װ� �̸�
    PAR_CATEGORY_CODE CHAR(3)               -- ���� ī�װ� �ڵ�
);

-- ī�װ� INSERT
INSERT INTO TBL_PROD_CATEGORY VALUES ('A01', '����', NULL);
INSERT INTO TBL_PROD_CATEGORY VALUES ('A02', '����', NULL);
INSERT INTO TBL_PROD_CATEGORY VALUES ('A03', '����', NULL);
INSERT INTO TBL_PROD_CATEGORY VALUES ('B01', '�ƿ���', 'A01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B02', '����', 'A01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B03', '����', 'A01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B04', '�Ǽ��縮', 'A01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B05', '�ƿ���', 'A02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B06', '����', 'A02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B07', '����', 'A02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B08', '�Ǽ��縮', 'A02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B09', '�ƿ���', 'A03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B10', '����', 'A03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B11', '����', 'A03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('B12', '�Ǽ��縮', 'A03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C01', '����', 'B01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C02', '����', 'B01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C03', '��Ʈ', 'B01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C04', '�е�', 'B01');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C05', '����Ƽ', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C06', '����Ƽ', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C07', '��Ʈ', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C08', '�ĵ�', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C09', '����', 'B02');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C10', '��������', 'B03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C11', '��������', 'B03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C12', '�ݹ���', 'B03');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C13', '�Ź�', 'B04');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C14', '����', 'B04');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C15', '�����', 'B04');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C16', '����', 'B04');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C17', '����', 'B05');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C18', '����', 'B05');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C19', '��Ʈ', 'B05');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C20', '�е�', 'B05');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C21', '����Ƽ', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C22', '����Ƽ', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C23', '��Ʈ', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C24', '�ĵ�', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C25', '����', 'B06');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C26', '��������', 'B07');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C27', '��������', 'B07');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C28', '�ݹ���', 'B07');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C29', '�Ź�', 'B08');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C30', '����', 'B08');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C31', '�����', 'B08');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C32', '����', 'B08');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C33', '����', 'B09');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C34', '����', 'B09');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C35', '��Ʈ', 'B09');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C36', '�е�', 'B09');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C37', '����Ƽ', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C38', '����Ƽ', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C39', '��Ʈ', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C40', '�ĵ�', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C41', '����', 'B10');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C42', '��������', 'B11');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C43', '��������', 'B11');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C44', '�ݹ���', 'B11');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C45', '�Ź�', 'B12');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C46', '����', 'B12');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C47', '�����', 'B12');
INSERT INTO TBL_PROD_CATEGORY VALUES ('C48', '����', 'B12');


-- ��۹�� ���̺�(TBL_DELIVERY_FEE)
CREATE TABLE TBL_DELIVERY_FEE (
    TRADE_METHOD_CODE CHAR(2) PRIMARY KEY,          -- ��۹�� �ڵ�
    TRADE_METHOD_NAME VARCHAR2(30) UNIQUE NOT NULL  -- ��۹��
);

-- ��۹�� INSERT
INSERT INTO TBL_DELIVERY_FEE VALUES ('M1', '��ۺ� ����');
INSERT INTO TBL_DELIVERY_FEE VALUES ('M2', '��ۺ� ������');
INSERT INTO TBL_DELIVERY_FEE VALUES ('M3', '��ۺ� ����');


-- ��ǰ���� ���̺�(TBL_PROD_STATUS)
CREATE TABLE TBL_PROD_STATUS (
    STATUS_CODE CHAR(3) PRIMARY KEY,            -- ��ǰ���� �ڵ�
    STATUS_NAME VARCHAR2(20) UNIQUE NOT NULL    -- ��ǰ����
);

-- ��ǰ���� INSERT
INSERT INTO TBL_PROD_STATUS VALUES ('S01', '�Ǹ� ��');
INSERT INTO TBL_PROD_STATUS VALUES ('S02', '���� �Ϸ�');
INSERT INTO TBL_PROD_STATUS VALUES ('S03', '��� ��');
INSERT INTO TBL_PROD_STATUS VALUES ('S04', '��� �غ�');
INSERT INTO TBL_PROD_STATUS VALUES ('S05', '��� ��');
INSERT INTO TBL_PROD_STATUS VALUES ('S06', '��� �Ϸ�');
INSERT INTO TBL_PROD_STATUS VALUES ('S07', '�ŷ� �Ϸ�');
INSERT INTO TBL_PROD_STATUS VALUES ('S08', 'ȯ�� ��û');
INSERT INTO TBL_PROD_STATUS VALUES ('S09', 'ȯ�� �Ϸ�');
INSERT INTO TBL_PROD_STATUS VALUES ('S10', '�ŷ� ����');
INSERT INTO TBL_PROD_STATUS VALUES ('S11', '��� ��û');
INSERT INTO TBL_PROD_STATUS VALUES ('S12', '��� �Ϸ�');


-- ��ǰ ���� ���̺�(TBL_PROD)
CREATE TABLE TBL_PROD (
    PRODUCT_NO VARCHAR2(11) PRIMARY KEY,                                        -- ��ǰ ��ȣ : P + yymmdd + 0001 ����
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO) ON DELETE CASCADE,  -- ȸ�� ��ȣ (ȸ�� ���� ���̺�, ȸ�� ��ȣ�� �����Ǹ� ��ǰ ������ ����)
    PRODUCT_NAME VARCHAR2(100) NOT NULL,                                        -- ��ǰ��
    PRODUCT_INTROD VARCHAR2(3000) NOT NULL,                                     -- ��ǰ ����
    PRODUCT_PRICE NUMBER NOT NULL,                                              -- ��ǰ ���� (��)
    CATEGORY_CODE CHAR(3) REFERENCES TBL_PROD_CATEGORY(CATEGORY_CODE),          -- ī�װ� �ڵ� (ī�װ� ���̺�)
    TRADE_METHOD_CODE CHAR(2) REFERENCES TBL_DELIVERY_FEE(TRADE_METHOD_CODE),   -- ��۹�� �ڵ� (��۹�� ���̺�)
    STATUS_CODE CHAR(3) REFERENCES TBL_PROD_STATUS(STATUS_CODE),                -- ��ǰ���� �ڵ� (��ǰ���� ���̺�)
    ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL,                                  -- ��ǰ �����
    READ_COUNT NUMBER DEFAULT 0                                                 -- ��ȸ��
    PRODUCT_QUANTITY NUMBER DEFAULT 1 NOT NULL                                  -- ��ǰ ����(�Ǹ� ����/�Ұ�)
);

-- ��ǰ ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_PROD
MAXVALUE 9999
CYCLE;

-- �׽�Ʈ ��ǰ
INSERT INTO TBL_PROD VALUES ('P' || TO_CHAR(SYSDATE, 'YYMMDD') || LPAD(SEQ_PROD.NEXTVAL, 4, '0'),
'M2505120001', '����Ű �Ź�', '�� ���� �� ���� �Ź��Դϴ�.', '50000', 'C13', 'M1', 'S01', DEFAULT, DEFAULT);

select * from tbl_prod;  

-- ��ǰ �ֹ� ���� ���̺�(TBL_PURCHASE)
CREATE TABLE TBL_PURCHASE (
    ORDER_NO VARCHAR2(11) PRIMARY KEY,                          -- �ֹ� ��ȣ : O + yymmdd + 0001 ����
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO),    -- ��ǰ ��ȣ (��ǰ ���� ���̺�)
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),    -- ������ ��ȣ (ȸ�� ���� ���̺�)
    DELIVERY_FEE NUMBER NOT NULL,                               -- ��ۺ�
    DELIVERY_ADDR VARCHAR2(300) NOT NULL,                       -- ��� �ּ�
    DEAL_DATE DATE DEFAULT SYSDATE NOT NULL,                    -- �ŷ� �Ͻ�
    UPDATE_DATE DATE DEFAULT SYSDATE NOT NULL                   -- ��ǰ ���� ���� �Ͻ� 
);

select * from tbl_purchase;


-- �ֹ� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_PURCHASE
MAXVALUE 9999
CYCLE;

-- ��Ÿ�� �ı� �Խ��� ���̺�(TBL_STYLE_POST)
CREATE TABLE TBL_STYLE_POST (
    STYLE_POST_NO VARCHAR2(11) PRIMARY KEY,                     -- �Խñ� ��ȣ : S + yymmdd + 0001 ����
    POST_TITLE VARCHAR2(100) NOT NULL,                          -- �Խñ� ����
    POST_CONTENT VARCHAR2(3000) NOT NULL,                       -- �Խñ� ����
    ORDER_NO VARCHAR2(11) REFERENCES TBL_PURCHASE(ORDER_NO),    -- �ֹ� ��ȣ (��ǰ �ֹ� ���� ���̺�)
    POST_DATE DATE DEFAULT SYSDATE NOT NULL,                    -- �Խñ� �ۼ���
    READ_COUNT NUMBER DEFAULT 0                                 -- ��ȸ��
);

-- �ֹ� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_STYLE
MAXVALUE 9999
CYCLE;


-- ���� ���̺�(TBL_FILE)
CREATE TABLE TBL_FILE (
    FILE_NO NUMBER PRIMARY KEY,                                                             -- ���� ��ȣ
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO) ON DELETE CASCADE,              -- ��ǰ ��ȣ (��ǰ ���� ���̺�)
    STYLE_POST_NO VARCHAR2(11) REFERENCES TBL_STYLE_POST(STYLE_POST_NO) ON DELETE CASCADE,  -- �Խñ� ��ȣ (��Ÿ�� �ı� �Խ��� ���̺�)
    NOTICE_NO VARCHAR2(11) REFERENCES TBL_NOTICE(NOTICE_NO) ON DELETE CASCADE,              -- �������� ��ȣ (�������� ���̺�)
    EVENT_NO VARCHAR2(11) REFERENCES TBL_EVENT(EVENT_NO) ON DELETE CASCADE,                 -- �̺�Ʈ ��ȣ (�̺�Ʈ ���̺�)
    FILE_NAME VARCHAR2(300),                                                                -- ����ڰ� ���ε��� ���� ��Ī
    FILE_PATH VARCHAR2(300),                                                                -- ���� ���� �ߺ��� ���ϸ��� �������� �ʵ��� ������ ���� ��Ī
    UPLOAD_DATE DATE DEFAULT SYSDATE NOT NULL                                               -- ���� ���ε� �Ͻ�
);

-- ���� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_FILE;

-- ���� �׽�Ʈ
INSERT INTO TBL_FILE VALUES (SEQ_FILE.NEXTVAL, 'P2505120001', NULL, NULL, NULL, 'DDD', 'DDD', DEFAULT);


-- ��� ���̺�(TBL_COMMENT)
CREATE TABLE TBL_COMMENT (
    COMMENT_NO NUMBER PRIMARY KEY,                                                          -- ��� ��ȣ
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO) ON DELETE CASCADE,              -- ȸ�� ��ȣ (ȸ�� ���� ���̺�)
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO) ON DELETE CASCADE,              -- ��ǰ ��ȣ (��ǰ ���� ���̺�)
    STYLE_POST_NO VARCHAR2(11) REFERENCES TBL_STYLE_POST(STYLE_POST_NO) ON DELETE CASCADE,  -- �Խñ� ��ȣ (��Ÿ�� �ı� �Խ��� ���̺�)
    CONTENT VARCHAR2(300) NOT NULL,                                                         -- ��� ����
    CREATED_DATE DATE DEFAULT SYSDATE NOT NULL                                              -- ��� �ۼ���
);

-- ��� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_COMMENT;

-- ��� �׽�Ʈ
INSERT INTO TBL_COMMENT VALUES (SEQ_COMMENT.NEXTVAL, 'M2505120001', 'P2505120001', NULL, '�Ź� �����׿�', DEFAULT);


-- ���� ���̺�(TBL_USER_RATING)
CREATE TABLE TBL_USER_RATING (
    RATING_NO NUMBER PRIMARY KEY,                               -- ���� ��ȣ
    ORDER_NO VARCHAR2(11) REFERENCES TBL_PURCHASE(ORDER_NO),    -- �ֹ� ��ȣ (��ǰ �ֹ� ���� ���̺�)
    RATING_SCORE NUMBER NOT NULL,                               -- ����
    RATING_DATE DATE DEFAULT SYSDATE NOT NULL                   -- ���� ����
);

-- ���� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_RATING;


-- ���ϱ� ���̺�(TBL_WISHLIST)
CREATE TABLE TBL_WISHLIST (
    WISHLIST_NO NUMBER PRIMARY KEY,                                             -- �� ��ȣ
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO) ON DELETE CASCADE,  -- ��ǰ ��ȣ (��ǰ ���� ���̺�)
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO) ON DELETE CASCADE,  -- ���� ȸ�� ��ȣ (ȸ�� ���� ���̺�)
    WISHLIST_DATE DATE DEFAULT SYSDATE NOT NULL                                 -- ���� ����
);

-- �� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_WISHLIST;


-- �Ű� ���� ���̺�(TBL_REPORT)
CREATE TABLE TBL_REPORT (
    REPORT_CODE VARCHAR2(3) PRIMARY KEY,        -- �Ű� ���� �ڵ�
    REPORT_REASON VARCHAR2(100) NOT NULL        -- �Ű� ����
);

-- �Ű� ���� �ڵ� INSERT
INSERT INTO TBL_REPORT VALUES ('RE1', '���۱� ħ��');
INSERT INTO TBL_REPORT VALUES ('RE2', '��ǥ�� ħ��');
INSERT INTO TBL_REPORT VALUES ('RE3', '�ŷ� ���� ǰ��');
INSERT INTO TBL_REPORT VALUES ('RE4', 'û�ҳ� ���ظ�ü��');


-- �Ű� ���� ���̺�(TBL_REPORT_POST)
CREATE TABLE TBL_REPORT_POST (
    REPORT_NO NUMBER PRIMARY KEY,                                           -- �Ű� ��ȣ
    REPORT_CODE VARCHAR2(3) REFERENCES TBL_REPORT(REPORT_CODE),             -- �Ű� ���� �ڵ� (�Ű� ���� ���̺�)
    REPORTED_MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),       -- �Ű��� ȸ�� ��ȣ (ȸ�� ���� ���̺�)
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO),                -- �Ű���� ��ǰ ��ȣ (��ǰ ���� ���̺�)
    REPORT_DATE DATE DEFAULT SYSDATE NOT NULL                               -- �Ű� ��¥
);

-- �Ű� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_REPORT;


-- �� ����Ʈ ���̺�(TBL_BLACKLIST)
CREATE TABLE TBL_BLACKLIST (
    BLACK_NO NUMBER PRIMARY KEY,                                -- �� ��ȣ
    REPORT_NO NUMBER REFERENCES TBL_REPORT_POST(REPORT_NO),     -- �Ű� ��ȣ (�Ű� ���� ���̺�)
    BLACK_REASON VARCHAR2(300) NOT NULL,                        -- �� ����
    BLACK_DATE DATE DEFAULT SYSDATE NOT NULL                    -- �� �����
);

-- �� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_BLACK;


-- �������� ���̺�(TBL_NOTICE)
CREATE TABLE TBL_NOTICE (
    NOTICE_NO VARCHAR2(11) PRIMARY KEY,                             -- �������� ��ȣ : N + yymmdd + 0001
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),        -- ������ ��ȣ (ȸ�� ���� ���̺�)
    NOTICE_TITLE VARCHAR2(100) NOT NULL,                            -- �������� ����
    NOTICE_CONTENT VARCHAR2(300) NOT NULL,                          -- �������� ����
    NOTICE_ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL,               -- �Խ���
    READ_COUNT NUMBER DEFAULT 0                                     -- ��ȸ��
);

-- �������� ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_NOTICE
MAXVALUE 9999
CYCLE;
select * from tbl_member;
insert into tbl_notice values ('N' || to_char(sysdate, 'yymmdd') || lpad(seq_notice.nextval, 4, '0'), 'M2505110001', '��������1', '����1', default, default);


-- �̺�Ʈ ���̺�(TBL_EVENT)
CREATE TABLE TBL_EVENT (
    EVENT_NO VARCHAR2(11) PRIMARY KEY,                              -- �̺�Ʈ ��ȣ : E + yymmdd + 0001
    MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),        -- ������ ��ȣ (ȸ�� ���� ���̺�)
    EVENT_TITLE VARCHAR2(100) NOT NULL,                             -- �̺�Ʈ ����
    EVNET_CONTENT VARCHAR2(300) NOT NULL,                           -- �̺�Ʈ ����
    EVENT_ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL,                -- �Խ���
    READ_COUNT NUMBER DEFAULT 0                                     -- ��ȸ��
);

-- �̺�Ʈ ��ȣ ���� �� ����� ������
CREATE SEQUENCE SEQ_EVENT
MAXVALUE 9999
CYCLE;

-- ��� ���� ������ ���� ���̺���� ��� ������ ���� '����'�� �� �ֵ��� �ۼ��߽��ϴ�. 
-- ���� ���̺��� �ۼ��� �Ŀ�, �Ʒ��� ��ɾ���� �ϳ��� ������ �ּ���.

-- ȸ���� ��ǰ �Ѱ��� �ϳ��� �� �� �� �ֵ��� UNIQUE ���� (0512 16:05)
    ALTER TABLE TBL_WISHLIST
    ADD CONSTRAINT UQ_WISHLIST_MEMBER_PRODUCT
    UNIQUE (MEMBER_NO, PRODUCT_NO);    -- UNIQUE ���� ����
    
-- ȸ���� ���� ���� ���·� �ٽ� ������ ���� �����Ǵ� INSERT/DELETE ������� ���� ( 0512 16:05 ) 
-- END; �ϴ��� / ���� �����ؼ� ��ü �巡�� �� �����ؾ� ������ ���� ����.

DECLARE
    v_count NUMBER;
BEGIN
    -- 1. �ش� ȸ���� �̹� ���ߴ��� Ȯ��
    SELECT COUNT(*)
    INTO v_count
    FROM TBL_WISHLIST
    WHERE MEMBER_NO = 'M2505110001'
      AND PRODUCT_NO = 'P2505110005';

    -- 2. �� �� ������ INSERT
    IF v_count = 0 THEN
        INSERT INTO TBL_WISHLIST (
            WISHLIST_NO, MEMBER_NO, PRODUCT_NO, WISHLIST_DATE
        ) VALUES (
            SEQ_WISHLIST.NEXTVAL, 'M2505110001', 'P2505110005', SYSDATE
        );

    -- 3. �� �������� DELETE (�� ����)
    ELSE
        DELETE FROM TBL_WISHLIST
        WHERE MEMBER_NO = 'M2505110001'
          AND PRODUCT_NO = 'P2505110005';
        END IF;
    END;
/

-- ��ۺ� ���� ���� ���� ( -NNNN���� �Ұ����ϰ� ) ���� ( 0512 16:34 )
ALTER TABLE TBL_PURCHASE
ADD CONSTRAINT CK_DELIVERY_FEE_NONNEG
CHECK (DELIVERY_FEE >= 0);

-- ��ǰ ���ݿ� ���� ���� ���� ( -NNNN������ ����� �Ұ����ϰ� ) ���� ( 0512 16:40 )
ALTER TABLE TBL_PROD
ADD CONSTRAINT CK_PROD_PRICE_NONNEGATIVE
CHECK (PRODUCT_PRICE >= 0);

-- �̺�Ʈ ���̺�(TBL_EVENT) ( �̺�Ʈ ���̺� ��Ÿ ���� EVNET_CONTENT -> EVENT_CONTENT ) (0512-16:19)
ALTER TABLE TBL_EVENT
RENAME COLUMN EVNET_CONTENT TO EVENT_CONTENT;

-- �߰� ������Ʈ �ؾ� �ϴ� ���� ����
-- 1. 12���� �Ǵ� ��ǰ���¸� � ���ذ� �������� ������ȯ ��ų�� ���ؾ� ��. 
-- 2. ���� API ���̺� �ϼ�

SELECT * FROM TBL_MEMBER;

SELECT * FROM TBL_PROD_CATEGORY;

SELECT C.CATEGORY_CODE,
       C.CATEGORY_NAME,
       C.PAR_CATEGORY_CODE,
       P.CATEGORY_NAME ����ī�װ�
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
TBL_PROD �� PRODCUT_QUANTITY �÷� �߰�
�߰� ���� : �ش� ��ǰ ���� �Ǹ� ����/�Ұ� ���� �ٷ� �Ǵ��ϱ� �����̸� ���� '��ǰ ����'�δ� ���°��� �ʹ� ���� �����Ͽ� �� ����Ͻô� �е鲲�� ��ǰ ���� ���� � ����Ҽ� �ֵ��� ���Դϴ�.
*/

ALTER TABLE TBL_PROD
  ADD (PRODUCT_QUANTITY NUMBER DEFAULT 1 NOT NULL);

COMMENT ON COLUMN TBL_PROD.PRODUCT_QUANTITY IS '��ǰ ��� ����(1: ��� ���� / 0:�Ǹ� �Ϸ�)';

COMMIT;

-- -----------------------------------------------------------
-- SQL�� ������ �� �־����ϴ�. ���߿� ��ǰ�� ������ ���� ��, SQL���� ���� ��ɾ�� �״�� �����Ͻø� �˴ϴ�.

-- ���� ���� ���θ� ������ �÷� �߰�
-- 'Y' = ���� ���� �ޱ�, 'N' = ���� ����
ALTER TABLE TBL_PROD
ADD PRICE_OFFER_YN VARCHAR2(1) DEFAULT 'N' CHECK (PRICE_OFFER_YN IN ('Y', 'N'));
--2.

-- ���� ������ ���� �θ� ��� ��ȣ �÷� �߰�
ALTER TABLE TBL_COMMENT
ADD PARENT_COMMENT_NO NUMBER REFERENCES TBL_COMMENT(COMMENT_NO);

-- ��ǰ ���� �ִ�ġ ����
ALTER TABLE TBL_PROD
ADD CONSTRAINT CK_PROD_PRICE_RANGE
CHECK (PRODUCT_PRICE >= 0 AND PRODUCT_PRICE <= 1000000000);

commit;





-- ---------------------------------------------------------------
-- 20250520 ȭ���� SQL ���� ���� ����
-- �������ϴ� �ܷ� Ű(FK) �������� ����
ALTER TABLE TBL_USER_RATING
DROP CONSTRAINT SYS_C007425;

ALTER TABLE TBL_STYLE_POST
DROP CONSTRAINT SYS_C007415;

-- �ڱ��� TBL_PURCHASE ���̺� ����
DROP TABLE TBL_PURCHASE;

-- �ֹ� ���� �ڵ� ���̺� �߰�
CREATE TABLE TBL_PURCHASE_STATUS (
    PURCHASE_STATUS_CODE VARCHAR2(4) PRIMARY KEY,
    STATUS_NAME VARCHAR2(30) NOT NULL
);

-- ���� ���� �߰�
INSERT INTO TBL_PURCHASE_STATUS (PURCHASE_STATUS_CODE, STATUS_NAME) VALUES ('PS00', '�������');
INSERT INTO TBL_PURCHASE_STATUS (PURCHASE_STATUS_CODE, STATUS_NAME) VALUES ('PS01', '�����Ϸ�');
-- ... ��Ÿ �ʿ��� ���µ� ���� �߰� ����...

-- ��ǰ �ֹ� ���� ���̺�(TBL_PURCHASE)
CREATE TABLE TBL_PURCHASE (
    ORDER_NO VARCHAR2(11) PRIMARY KEY,                          -- �ֹ� ��ȣ : O + yymmdd + 0001 ����
    PRODUCT_NO VARCHAR2(11) REFERENCES TBL_PROD(PRODUCT_NO),    -- ��ǰ ��ȣ (��ǰ ���� ���̺�)
    SELLER_MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO), -- �Ǹ��� ��ȣ(ȸ�� ���� ���̺�)
    BUYER_MEMBER_NO VARCHAR2(11) REFERENCES TBL_MEMBER(MEMBER_NO),  -- ������ ��ȣ(ȸ�� ���� ���̺�)
    DELIVERY_ADDR VARCHAR2(300),                       -- ��� �ּ�
    DELIVERY_FEE NUMBER DEFAULT 0 NOT NULL,                               -- ��ۺ�
    ORDER_AMOUNT NUMBER NOT NULL,                              -- �� ���� �ݾ�
    PG_PROVIDER VARCHAR2(20),                                   -- PG�� ����
    PG_TRANSACTION_ID VARCHAR2(100),                             -- PG�� �ŷ� ID ��    
    DEAL_DATE DATE DEFAULT SYSDATE NOT NULL,                    -- �ŷ� �Ͻ�    
    PURCHASE_STATUS_CODE VARCHAR2(4) REFERENCES TBL_PURCHASE_STATUS(PURCHASE_STATUS_CODE) -- �ֹ� ���� �ڵ�
);

-- TBL_USER_RATING ���̺� FK �ٽ� �߰� (�÷���� �������Ǹ��� ���� ����ϴ� ������ ����)
ALTER TABLE TBL_USER_RATING
ADD CONSTRAINT FK_USER_RATING_ORDER_NO -- ���ο� FK �������� �̸� (����)
FOREIGN KEY (ORDER_NO) -- TBL_USER_RATING ���̺��� ORDER_NO �÷� (�Ǵ� �ٸ� �̸��� �� ����)
REFERENCES TBL_PURCHASE(ORDER_NO);

-- TBL_STYLE_POST ���̺� FK �ٽ� �߰� (�÷���� �������Ǹ��� ���� ����ϴ� ������ ����)
ALTER TABLE TBL_STYLE_POST
ADD CONSTRAINT FK_STYLE_POST_ORDER_NO -- ���ο� FK �������� �̸� (����)
FOREIGN KEY (ORDER_NO) -- TBL_STYLE_POST ���̺��� ORDER_NO �÷� (�Ǵ� �ٸ� �̸��� �� ����)
REFERENCES TBL_PURCHASE(ORDER_NO);

-- �ֹ� ��ȣ ���� �� ����� ������(�̹� �����Ǿ� ������ �߰� ���� �� �ʿ� ����!!)
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
