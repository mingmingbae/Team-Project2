package com.bookshop01.review.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.review.vo.ReviewVO;

@Repository("reviewDAO")
public class ReviewDAOImpl implements ReviewDAO {
	@Autowired
	private SqlSession sqlSession;
	

    //리뷰 전체 조회
	@Override
	public List<ReviewVO> selectReviewListAll(String review_goods_id) throws DataAccessException {
		 
		 return sqlSession.selectList("mapper.review.selectReviewListAll",review_goods_id);
			
	}
	
	//선택한 글 조회
	@Override
	public ReviewVO selectDetailReview(String review_idx) throws DataAccessException {
		ReviewVO reviewVO = (ReviewVO) sqlSession.selectOne("mapper.review.selectDetailReview", review_idx);
		return 	reviewVO;
	}
	
	//리뷰 삭제
	@Override
	public int deleteReview(String review_idx) throws DataAccessException {
		
		return sqlSession.delete("mapper.review.deleteReview", review_idx);		 		
	}
	
	//리뷰 작성
	@Override
	public int insertReview(Map<String, Object> paramMap) throws DataAccessException {

		return sqlSession.insert("mapper.review.insertReview", paramMap);
	}
}
