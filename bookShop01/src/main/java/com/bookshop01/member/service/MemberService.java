package com.bookshop01.member.service;

import java.util.Map;

import com.bookshop01.member.vo.MemberVO;

public interface MemberService {
	public MemberVO login(Map  loginMap) throws Exception;
	public void addMember(MemberVO memberVO) throws Exception;
	public String overlapped(String id) throws Exception;
	public String searchId(MemberVO memberVO) throws Exception;
	public MemberVO checkMemInfo(Map<String, String> checkMem) throws Exception;
	public int removeMember(String mem_id)throws Exception;
	public int updatePass(String mem_id, String user_psw_confirm)throws Exception;
}
