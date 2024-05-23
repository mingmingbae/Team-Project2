package com.bookshop01.member.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.member.vo.MemberVO;

public interface MemberController {
	public ModelAndView login(@RequestParam Map<String, String> loginMap,HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public ResponseEntity  addMember(@ModelAttribute("member") MemberVO member,HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public ResponseEntity   overlapped(@RequestParam("id") String id,HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public ModelAndView searchId(@ModelAttribute("memId") MemberVO memberVO, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public ModelAndView checkMemInfo(@RequestParam Map<String, String> checkMem, HttpServletRequest request, HttpServletResponse response) throws Exception;

	public ResponseEntity removeMember(@RequestParam("mem_id") String member_id,HttpSession session,HttpServletRequest request,HttpServletResponse response)throws Exception;
	
	public String sendPwdMail(@RequestParam("email") String email,HttpServletRequest request,HttpServletResponse response)throws Exception;

	public ResponseEntity checkRandomPass(@RequestParam("checknum2") String checknum2)throws Exception;

	public ResponseEntity updatePass(@RequestParam("user_psw_confirm") String user_psw_confirm,@RequestParam("mem_id") String mem_id)throws Exception;
	
}
