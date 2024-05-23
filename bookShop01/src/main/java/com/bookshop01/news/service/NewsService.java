package com.bookshop01.news.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.bookshop01.news.vo.NewsVO;

public interface NewsService {


	// 전체 건수
	public int getContentCnt(Map<String, Object> paramMap) throws Exception;

	// 전체 목록
	public List<NewsVO> getContentList(Map<String, Object> paramMap) throws Exception;

	// 게시글 상세 보기
	public NewsVO getContentView(Map<String, Object> paramMap) throws Exception;

	// 정보 입력
	public int regContent(Map<String, Object> paramMap) throws Exception;

	// 사이드바용 전체 목록
	public List<NewsVO> getSideList() throws Exception;

	// 게시글 삭제
	public int delNews(Map<String, Object> paramMap) throws Exception;

	

	

}
