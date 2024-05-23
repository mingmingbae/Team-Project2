package com.bookshop01.review.vo;
import java.sql.Date;
import org.springframework.stereotype.Component;

@Component("reviewVO")
public class ReviewVO {
	private int review_idx; //리뷰 인덱스
	private String review_title; //리뷰 글제목
	private String review_content; //리뷰 글내용
	private Date review_date; //리뷰 작성 날짜
	private String review_member_id; //리뷰 작성자 아이디
	private int review_goods_id; //구매 상품 번호
	
	public ReviewVO() { }	
	
	public int getReview_idx() {
		return review_idx;
	}
	public void setReview_idx(int review_idx) {
		this.review_idx = review_idx;
	}
	public String getReview_title() {
		return review_title;
	}
	public void setReview_title(String review_title) {
		this.review_title = review_title;
	}
	public String getReview_content() {
		return review_content;
	}
	public void setReview_content(String review_content) {
		this.review_content = review_content;
	}
	public Date getReview_date() {
		return review_date;
	}
	public void setReview_date(Date review_date) {
		this.review_date = review_date;
	}

	public String getReview_member_id() {
		return review_member_id;
	}
	public void setReview_member_id(String review_member_id) {
		this.review_member_id = review_member_id;
	}

	public int getReview_goods_id() {
		return review_goods_id;
	}

	public void setReview_goods_id(int review_goods_id) {
		this.review_goods_id = review_goods_id;
	}
	
	
	
}




