package com.bookshop01.news.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.bookshop01.news.vo.NewsVO;

@Repository("newsDAO")
public class NewsDAOImpl implements NewsDAO {
	@Autowired
	private SqlSession sqlSession;
	
	public void setSqlSession(SqlSession sqlSession){
        this.sqlSession = sqlSession;
    }
	

	// 사이드용 전체 목록
	@Override
	public List<NewsVO> getSideList() throws DataAccessException {
		return sqlSession.selectList("mapper.news.selectSideList");
	}
	
	
	// 전체 건수
	@Override
	public int getContentCnt(Map<String, Object> paramMap) throws DataAccessException{
		return sqlSession.selectOne("mapper.news.selectContentCnt", paramMap);
	}
	
	
	// 전체 목록
	@Override
	public List<NewsVO> getContentList(Map<String, Object> paramMap) throws DataAccessException{
		return sqlSession.selectList("mapper.news.selectContent", paramMap);
	}
	
	
	
	// 게시글 상세 보기
	@Override
	public NewsVO getContentView(Map<String, Object> paramMap) throws DataAccessException{
		return sqlSession.selectOne("mapper.news.selectContentView", paramMap);
	}
	
	// 조회수 증가
	@Override
	public void increamentCnt(Map<String, Object> paramMap) throws DataAccessException {
		sqlSession.update("mapper.news.incrementCnt", paramMap);
	}
	
	
	// 글번호가 없으면 새글 등록
	@Override
	public int regContent(Map<String, Object> paramMap) throws DataAccessException{
		sqlSession.insert("mapper.news.insertContent", paramMap);
		
		// Insert 후에 새로운 글번호를 가져오기 위해 다시 쿼리를 실행하여 paramMap에 추가
	    int newNewsIdx = sqlSession.selectOne("mapper.news.getNewNewsIdx");
	    paramMap.put("newNewsIdx", newNewsIdx);
		
		return newNewsIdx;
	}
	
	// 글번호가 있으면 수정
	@Override
	public int modifyContent(Map<String, Object> paramMap) throws DataAccessException{

		sqlSession.update("mapper.news.updateContent", paramMap);
		return Integer.parseInt((String)paramMap.get("news_idx"));
	}
	
	// 게시글 삭제 
	@Override
	public int delNews(Map<String, Object> paramMap) throws DataAccessException {
		return sqlSession.delete("mapper.news.deleteNews", paramMap);
	}
	
}
