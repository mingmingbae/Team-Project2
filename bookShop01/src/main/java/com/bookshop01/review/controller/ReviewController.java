package com.bookshop01.review.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

public interface ReviewController {
	
	public String detailReview(@RequestParam ("review_idx") String review_idx,HttpServletRequest request, HttpServletResponse response) throws Exception;
	public Map<String, String> deleteReview(@RequestParam ("review_idx") String review_idx,HttpServletRequest request, HttpServletResponse response) throws Exception;
	public Map<String, String> writeReview(@RequestParam Map<String, Object> paramMap) throws Exception;
}
