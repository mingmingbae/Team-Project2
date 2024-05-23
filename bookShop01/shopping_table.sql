-- 공지 게시판 테이블
CREATE TABLE T_SHOPPING_NEWS (
    NEWS_IDX NUMBER PRIMARY KEY not null,  -- 공지 인덱스
    NEWS_TITLE VARCHAR2(100) not null,     -- 공지 제목
    NEWS_CONTENT VARCHAR2(2000) not null,  -- 공지 내용
    NEWS_DATE DATE not null,               -- 공지 작성 날짜 
    NEWS_CNT NUMBER not null,              -- 공지 조회수
    NEWS_SFILE VARCHAR2(200),              -- 공지 파일
    NEWS_MEMBER_ID VARCHAR2(50) not null   -- 멤버 아이디
);

-- 공지 게시판 테이블 시퀀스
CREATE SEQUENCE SEQ_NEWS_IDX
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 9999
NOCYCLE
NOCACHE
NOORDER;

commit;


-- 상품 리뷰 테이블
CREATE TABLE t_shopping_review(
    review_idx NUMBER PRIMARY KEY NOT NULL, -- 리뷰 인덱스
    review_title VARCHAR2(100) NOT NULL, -- 리뷰 글제목
    review_content VARCHAR2(1000) NOT NULL, -- 리뷰 글내용
    review_date DATE NOT NULL, -- 리뷰 작성 날짜
    review_member_id VARCHAR2(100)NOT NULL, -- 리뷰 작성자 아이디
    review_goods_id NUMBER --책 상품 번호 
    );

-- 리뷰 테이블 시퀀스    
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
-- 상품이미지 정보 테이블
  CREATE TABLE "T_GOODS_DETAIL_IMAGE" 
   (	
    "IMAGE_ID" NUMBER(20,0) primary key,  -- 상품 이미지 번호
	"GOODS_ID" NUMBER(20,0),  -- 상품 번호
	"FILENAME" VARCHAR2(50 BYTE), -- 상품 이미지 파일명
	"REG_ID" VARCHAR2(20 BYTE), -- 상품 등록자 아이디
	"FILETYPE" VARCHAR2(40 BYTE), -- 상품 이미지 파일종류
	"CREDATE" DATE DEFAULT sysdate -- 상품 등록일
   ) ;
--------------------------------------------------------
--  DDL for Table T_SHOPPING_GOODS
--------------------------------------------------------
-- 도서 상품 정보 테이블 
  CREATE TABLE "T_SHOPPING_GOODS" 
   (	"GOODS_ID" NUMBER(20,0) primary key, -- 도서 상품번호
	"GOODS_SORT" VARCHAR2(50 BYTE), -- 도서 상품종류
	"GOODS_TITLE" VARCHAR2(100 BYTE), -- 도서 상품제목
	"GOODS_WRITER" VARCHAR2(50 BYTE), -- 도서 상품 저자이름
	"GOODS_PUBLISHER" VARCHAR2(50 BYTE), -- 도서상품 출판사이름
	"GOODS_PRICE" NUMBER(10,0), -- 도서 상품 정가
	"GOODS_SALES_PRICE" NUMBER(10,0), -- 도서 상품 판매가격  
	"GOODS_POINT" NUMBER(10,0), -- 도서 상품 포인트
	"GOODS_PUBLISHED_DATE" DATE, -- 도서 상품 출판일
	"GOODS_TOTAL_PAGE" NUMBER(5,0), -- 도서 상품 총페이지수
	"GOODS_ISBN" VARCHAR2(50 BYTE), -- 도서 상품 isbn번호
	"GOODS_DELIVERY_PRICE" NUMBER(10,0), -- 도서 상품 배송비
	"GOODS_DELIVERY_DATE" DATE,  -- 도서 상품 배송일
	"GOODS_STATUS" VARCHAR2(50 BYTE), -- 도서 상품 분류
	"GOODS_INTRO" VARCHAR2(2000 BYTE), -- 도서 상품 저자 소개
	"GOODS_WRITER_INTRO" VARCHAR2(2000 BYTE), -- 도서 상품 소개
	"GOODS_PUBLISHER_COMMENT" VARCHAR2(2000 BYTE),  -- 도서 상품 출판사 평
	"GOODS_RECOMMENDATION" VARCHAR2(2000 BYTE), -- 도서 상품 추천사
	"GOODS_CONTENTS_ORDER" CLOB, -- 도서 상품 목차
	"GOODS_CREDATE" DATE DEFAULT sysdate -- 도서 상품 입고일
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