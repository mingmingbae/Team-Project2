package com.bookshop01.news.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bookshop01.news.dao.NewsDAO;
import com.bookshop01.news.vo.NewsVO;

@Service("newsService")
@Transactional(propagation = Propagation.REQUIRED)
public class NewsServiceImpl implements NewsService{

	@Autowired
	NewsDAO newsDAO;
	
	
	// 사이드용 전체 목록
	@Override
	public List<NewsVO> getSideList() throws Exception {
		return newsDAO.getSideList();
	}
	
	// 전체 건수
	@Override
	public int getContentCnt(Map<String, Object> paramMap) throws Exception{
		return newsDAO.getContentCnt(paramMap);
	}

	
	// 전체 목록
	@Override
	public List<NewsVO> getContentList(Map<String, Object> paramMap) throws Exception {
		return newsDAO.getContentList(paramMap);
	}
	
	
	// 게시글 상세 보기
	@Override
	public NewsVO getContentView(Map<String, Object> paramMap) throws Exception{
		newsDAO.increamentCnt(paramMap);
		return newsDAO.getContentView(paramMap);
	}
	
	// 정보 입력
	@Override
	public int regContent(Map<String, Object> paramMap) throws Exception{
		//글번호가 없으면 새글 등록
		if(paramMap.get("news_idx")==null) {
			return newsDAO.regContent(paramMap);
		}else {//글번호가 있으면 수정
			return newsDAO.modifyContent(paramMap);
		}
	}
	
	
	// 게시글 삭제
	@Override
	public int delNews(Map<String, Object> paramMap) throws Exception {
		return newsDAO.delNews(paramMap);
	}
	
}
