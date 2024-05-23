package com.bookshop01.kakao.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

//카카오 로그인
public interface KakaoController {

	public String kakaoLogin(@RequestParam(value = "code", required = false) String code, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
}
