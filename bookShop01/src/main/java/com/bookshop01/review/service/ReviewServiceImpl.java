package com.bookshop01.review.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.review.dao.ReviewDAO;
import com.bookshop01.review.vo.ReviewVO;

@Service("reviewService")
@Transactional(propagation=Propagation.REQUIRED)
public class ReviewServiceImpl implements ReviewService {
	
	@Autowired
	private ReviewDAO reviewDAO;
	
	public List<ReviewVO> reviewListAll(String review_goods_id) throws Exception {
	
		return  reviewDAO.selectReviewListAll(review_goods_id);
		 
	}
	
	public ReviewVO detailReview(String review_idx) throws Exception {
		
		ReviewVO reviewVO = reviewDAO.selectDetailReview(review_idx);
		
		return reviewVO;

	}
	
	public int deleteReview(String review_idx) throws Exception {
		
		return reviewDAO.deleteReview(review_idx);		
	}
	
	public int insertReview(Map<String, Object> paramMap) throws Exception {

		return reviewDAO.insertReview(paramMap);
	}
}
