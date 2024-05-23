-- ���� �Խ��� ���̺�
CREATE TABLE T_SHOPPING_NEWS (
    NEWS_IDX NUMBER PRIMARY KEY not null,  -- ���� �ε���
    NEWS_TITLE VARCHAR2(100) not null,     -- ���� ����
    NEWS_CONTENT VARCHAR2(2000) not null,  -- ���� ����
    NEWS_DATE DATE not null,               -- ���� �ۼ� ��¥ 
    NEWS_CNT NUMBER not null,              -- ���� ��ȸ��
    NEWS_SFILE VARCHAR2(200),              -- ���� ����
    NEWS_MEMBER_ID VARCHAR2(50) not null   -- ��� ���̵�
);

-- ���� �Խ��� ���̺� ������
CREATE SEQUENCE SEQ_NEWS_IDX
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 9999
NOCYCLE
NOCACHE
NOORDER;

commit;


-- ��ǰ ���� ���̺�
CREATE TABLE t_shopping_review(
    review_idx NUMBER PRIMARY KEY NOT NULL, -- ���� �ε���
    review_title VARCHAR2(100) NOT NULL, -- ���� ������
    review_content VARCHAR2(1000) NOT NULL, -- ���� �۳���
    review_date DATE NOT NULL, -- ���� �ۼ� ��¥
    review_member_id VARCHAR2(100)NOT NULL, -- ���� �ۼ��� ���̵�
    review_goods_id NUMBER --å ��ǰ ��ȣ 
    );

-- ���� ���̺� ������    
CREATE SEQUENCE SEQ_REVIEW_IDX
    INCREMENT BY 1
    START with 1
    MINVALUE 1
    MAXVALUE 9999
    NOCYCLE
    NOCACHE
    NOORDER;



-- -------------------------------------------------------------------------------







--------------------------------------------------------
--  DDL for Table T_GOODS_DETAIL_IMAGE
--------------------------------------------------------
-- ��ǰ�̹��� ���� ���̺�
  CREATE TABLE "T_GOODS_DETAIL_IMAGE" 
   (	
    "IMAGE_ID" NUMBER(20,0) primary key,  -- ��ǰ �̹��� ��ȣ
	"GOODS_ID" NUMBER(20,0),  -- ��ǰ ��ȣ
	"FILENAME" VARCHAR2(50 BYTE), -- ��ǰ �̹��� ���ϸ�
	"REG_ID" VARCHAR2(20 BYTE), -- ��ǰ ����� ���̵�
	"FILETYPE" VARCHAR2(40 BYTE), -- ��ǰ �̹��� ��������
	"CREDATE" DATE DEFAULT sysdate -- ��ǰ �����
   ) ;
--------------------------------------------------------
--  DDL for Table T_SHOPPING_GOODS
--------------------------------------------------------
-- ���� ��ǰ ���� ���̺� 
  CREATE TABLE "T_SHOPPING_GOODS" 
   (	"GOODS_ID" NUMBER(20,0) primary key, -- ���� ��ǰ��ȣ
	"GOODS_SORT" VARCHAR2(50 BYTE), -- ���� ��ǰ����
	"GOODS_TITLE" VARCHAR2(100 BYTE), -- ���� ��ǰ����
	"GOODS_WRITER" VARCHAR2(50 BYTE), -- ���� ��ǰ �����̸�
	"GOODS_PUBLISHER" VARCHAR2(50 BYTE), -- ������ǰ ���ǻ��̸�
	"GOODS_PRICE" NUMBER(10,0), -- ���� ��ǰ ����
	"GOODS_SALES_PRICE" NUMBER(10,0), -- ���� ��ǰ �ǸŰ���  
	"GOODS_POINT" NUMBER(10,0), -- ���� ��ǰ ����Ʈ
	"GOODS_PUBLISHED_DATE" DATE, -- ���� ��ǰ ������
	"GOODS_TOTAL_PAGE" NUMBER(5,0), -- ���� ��ǰ ����������
	"GOODS_ISBN" VARCHAR2(50 BYTE), -- ���� ��ǰ isbn��ȣ
	"GOODS_DELIVERY_PRICE" NUMBER(10,0), -- ���� ��ǰ ��ۺ�
	"GOODS_DELIVERY_DATE" DATE,  -- ���� ��ǰ �����
	"GOODS_STATUS" VARCHAR2(50 BYTE), -- ���� ��ǰ �з�
	"GOODS_INTRO" VARCHAR2(2000 BYTE), -- ���� ��ǰ ���� �Ұ�
	"GOODS_WRITER_INTRO" VARCHAR2(2000 BYTE), -- ���� ��ǰ �Ұ�
	"GOODS_PUBLISHER_COMMENT" VARCHAR2(2000 BYTE),  -- ���� ��ǰ ���ǻ� ��
	"GOODS_RECOMMENDATION" VARCHAR2(2000 BYTE), -- ���� ��ǰ ��õ��
	"GOODS_CONTENTS_ORDER" CLOB, -- ���� ��ǰ ����
	"GOODS_CREDATE" DATE DEFAULT sysdate -- ���� ��ǰ �԰���
   ) ;
--------------------------------------------------------
--  DDL for Table T_SHOPPING_MEMBER
--------------------------------------------------------

  CREATE TABLE "T_SHOPPING_MEMBER" 
   (	"MEMBER_ID" VARCHAR2(20 BYTE) primary key, 
	"MEMBER_PW" VARCHAR2(30 BYTE), 
	"MEMBER_NAME" VARCHAR2(50 BYTE), 
	"MEMBER_GENDER" VARCHAR2(10 BYTE), 
	"TEL1" VARCHAR2(20 BYTE), 
	"TEL2" VARCHAR2(20 BYTE), 
	"TEL3" VARCHAR2(20 BYTE), 
	"HP1" VARCHAR2(20 BYTE), 
	"HP2" VARCHAR2(20 BYTE), 
	"HP3" VARCHAR2(20 BYTE), 
	"SMSSTS_YN" VARCHAR2(20 BYTE), 
	"EMAIL1" VARCHAR2(20 BYTE), 
	"EMAIL2" VARCHAR2(20 BYTE), 
	"EMAILSTS_YN" VARCHAR2(20 BYTE), 
	"ZIPCODE" VARCHAR2(20 BYTE), 
	"ROADADDRESS" VARCHAR2(500 BYTE), 
	"JIBUNADDRESS" VARCHAR2(500 BYTE), 
	"NAMUJIADDRESS" VARCHAR2(500 BYTE), 
	"MEMBER_BIRTH_Y" VARCHAR2(20 BYTE), 
	"MEMBER_BIRTH_M" VARCHAR2(20 BYTE), 
	"MEMBER_BIRTH_D" VARCHAR2(20 BYTE), 
	"MEMBER_BIRTH_GN" VARCHAR2(20 BYTE), 
	"JOINDATE" DATE DEFAULT sysdate, 
	"DEL_YN" VARCHAR2(20 BYTE) DEFAULT 'N'
   ) ;
--------------------------------------------------------
--  DDL for Table T_SHOPPING_ORDER
--------------------------------------------------------

  CREATE TABLE "T_SHOPPING_ORDER" 
   (	"ORDER_SEQ_NUM" NUMBER(20,0) primary key, 
	"ORDER_ID" NUMBER(20,0), 
	"MEMBER_ID" VARCHAR2(20 BYTE), 
	"GOODS_ID" NUMBER(20,0), 
	"ORDERER_NAME" VARCHAR2(50 BYTE), 
	"GOODS_TITLE" VARCHAR2(100 BYTE), 
	"ORDER_GOODS_QTY" NUMBER(5,0), 
	"GOODS_SALES_PRICE" NUMBER(5,0), 
	"GOODS_FILENAME" VARCHAR2(60 BYTE), 
	"RECEIVER_NAME" VARCHAR2(50 BYTE), 
	"RECEIVER_HP1" VARCHAR2(20 BYTE), 
	"RECEIVER_HP2" VARCHAR2(20 BYTE), 
	"RECEIVER_HP3" VARCHAR2(20 BYTE), 
	"RECEIVER_TEL1" VARCHAR2(20 BYTE), 
	"RECEIVER_TEL2" VARCHAR2(20 BYTE), 
	"RECEIVER_TEL3" VARCHAR2(20 BYTE), 
	"DELIVERY_ADDRESS" VARCHAR2(500 BYTE), 
	"DELIVERY_METHOD" VARCHAR2(40 BYTE), 
	"DELIVERY_MESSAGE" VARCHAR2(300 BYTE), 
	"GIFT_WRAPPING" VARCHAR2(20 BYTE), 
	"PAY_METHOD" VARCHAR2(200 BYTE), 
	"CARD_COM_NAME" VARCHAR2(50 BYTE), 
	"CARD_PAY_MONTH" VARCHAR2(20 BYTE), 
	"PAY_ORDERER_HP_NUM" VARCHAR2(20 BYTE), 
	"DELIVERY_STATE" VARCHAR2(20 BYTE) DEFAULT 'delivery_prepared', 
	"PAY_ORDER_TIME" DATE DEFAULT sysdate, 
	"ORDERER_HP" VARCHAR2(50 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table T_SHOPPING_CART
--------------------------------------------------------

  CREATE TABLE "T_SHOPPING_CART" 
   (	"CART_ID" NUMBER(10,0) primary key, 
	"GOODS_ID" NUMBER(20,0), 
	"MEMBER_ID" VARCHAR2(20 BYTE), 
	"DEL_YN" VARCHAR2(20 BYTE) DEFAULT 'N', 
	"CREDATE" DATE DEFAULT sysdate, 
	"CART_GOODS_QTY" NUMBER(4,0) DEFAULT 1
   ) ;
   
   
   
   






drop sequence ORDER_SEQ_NUM;
drop sequence SEQ_GOODS_ID;
drop sequence SEQ_IMAGE_ID;
drop sequence SEQ_ORDER_ID;
--------------------------------------------------------
--  DDL for Sequence ORDER_SEQ_NUM
--------------------------------------------------------

   CREATE SEQUENCE  "ORDER_SEQ_NUM"  MINVALUE 0 MAXVALUE 10000000 INCREMENT BY 1 START WITH 400 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_GOODS_ID
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_GOODS_ID"  MINVALUE 100 MAXVALUE 1000000 INCREMENT BY 1 START WITH 400 CACHE 20 ORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_IMAGE_ID
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_IMAGE_ID"  MINVALUE 1 MAXVALUE 11111111 INCREMENT BY 1 START WITH 400 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_ORDER_ID
--------------------------------------------------------

   CREATE SEQUENCE  "SEQ_ORDER_ID"  MINVALUE 0 MAXVALUE 10000000 INCREMENT BY 1 START WITH 400 NOCACHE  ORDER  NOCYCLE ;

commit;