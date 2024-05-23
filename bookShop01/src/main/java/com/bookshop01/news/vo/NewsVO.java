package com.bookshop01.news.vo;

import java.io.Serializable;
import java.sql.Date;

public class NewsVO implements Serializable {

	private int news_idx; 			       // 공지 인덱스
    private String news_title;	           // 공지 제목
    private String news_content;            // 공지 내용
    private String news_date;                 // 공지 작성 날짜 
    private int news_cnt;                   // 공지 조회수
    private String news_sfile;              // 공지 파일
    private String news_member_id;           // 멤버 아이디
	
    
    
    public int getNews_idx() {
		return news_idx;
	}
	public void setNews_idx(int news_idx) {
		this.news_idx = news_idx;
	}
	public String getNews_title() {
		return news_title;
	}
	public void setNews_title(String news_title) {
		this.news_title = news_title;
	}
	public String getNews_content() {
		return news_content;
	}
	public void setNews_content(String news_content) {
		this.news_content = news_content;
	}
	public String getNews_date() {
		return news_date;
	}
	public void setNews_date(String news_date) {
		this.news_date = news_date;
	}
	public int getNews_cnt() {
		return news_cnt;
	}
	public void setNews_cnt(int news_cnt) {
		this.news_cnt = news_cnt;
	}
	public String getNews_sfile() {
		return news_sfile;
	}
	public void setNews_sfile(String news_sfile) {
		this.news_sfile = news_sfile;
	}
	public String getNews_member_id() {
		return news_member_id;
	}
	public void setNews_member_id(String news_member_id) {
		this.news_member_id = news_member_id;
	}
	
    
    
    
	
    
    
    
	 
	
}
