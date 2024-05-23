package com.bookshop01.review.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.review.vo.ReviewVO;

public interface ReviewDAO {
	
	public List<ReviewVO> selectReviewListAll(String review_goods_id) throws DataAccessException;

	public ReviewVO selectDetailReview(String review_idx) throws DataAccessException;

	public int deleteReview(String review_idx) throws DataAccessException;

	public int insertReview(Map<String, Object> paramMap) throws DataAccessException;

}
