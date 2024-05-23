package com.bookshop01.review.service;

import java.util.List;
import java.util.Map;

import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.goods.vo.GoodsVO;
import com.bookshop01.review.vo.ReviewVO;

public interface ReviewService {

	public List<ReviewVO> reviewListAll(String review_goods_id) throws Exception;

	public ReviewVO detailReview(String review_idx) throws Exception;

	public int deleteReview(String review_idx) throws Exception;

	public int insertReview(Map<String, Object> paramMap) throws Exception;

}
