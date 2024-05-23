package com.bookshop01.member.dao;

import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bookshop01.member.vo.MemberVO;

public interface MemberDAO {
	public MemberVO login(Map loginMap) throws DataAccessException;
	
	public void insertNewMember(MemberVO memberVO) throws DataAccessException;
	
	public String selectOverlappedID(String id) throws DataAccessException;
	
	public String selectMemID(MemberVO memberVO) throws DataAccessException;

	public MemberVO checkMemInfo(Map<String, String> checkMem) throws DataAccessException;

	public int removeMember(String mem_id)throws DataAccessException;

	public int updatePass(String mem_id, String user_psw_confirm)throws DataAccessException;
	
}
