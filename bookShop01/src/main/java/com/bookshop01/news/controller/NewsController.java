package com.bookshop01.news.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface NewsController {

	// 게시글 조회
	public String newsList(@RequestParam Map<String, Object> paramMap, Model model,
							HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	// 게시글 상세 보기
	public String newsView(@RequestParam Map<String, Object> paramMap, Model model,
							HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	// 게시글 등록 및 수정 뷰
	public String newsEditView(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception;
	
	
	// 게시글 등록 및 수정
	public Object newsEditPro(HttpServletRequest request, @RequestParam Map<String, Object> paramMap, MultipartFile newsSFile,
			MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception;
	
	
	// 게시글 삭제
	public Object newsDel(@RequestParam Map<String, Object> paramMap) throws Exception;

}
