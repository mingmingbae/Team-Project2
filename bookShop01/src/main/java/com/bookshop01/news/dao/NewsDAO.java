package com.bookshop01.news.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bookshop01.news.vo.NewsVO;

public interface NewsDAO {


	// 전체 건수
	public int getContentCnt(Map<String, Object> paramMap) throws DataAccessException;

	// 전체 목록
	public List<NewsVO> getContentList(Map<String, Object> paramMap) throws DataAccessException;

	// 게시글 상세 보기
	public NewsVO getContentView(Map<String, Object> paramMap) throws DataAccessException;
	
	// 조회수 증가
	public void increamentCnt(Map<String, Object> paramMap) throws DataAccessException;

	// 아이디가 없으면 입력
	public int regContent(Map<String, Object> paramMap) throws DataAccessException;

	// 아이디가 있으면 수정
	public int modifyContent(Map<String, Object> paramMap) throws DataAccessException;

	// 사이드용 전체 목록
	public List<NewsVO> getSideList() throws DataAccessException;

	// 게시글 삭제
	public int delNews(Map<String, Object> paramMap) throws DataAccessException;

	
	

	

}
