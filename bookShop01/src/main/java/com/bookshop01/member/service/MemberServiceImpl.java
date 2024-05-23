package com.bookshop01.member.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bookshop01.member.dao.MemberDAO;
import com.bookshop01.member.vo.MemberVO;

@Service("memberService")
@Transactional(propagation=Propagation.REQUIRED)
public class MemberServiceImpl implements MemberService {
	@Autowired
	private MemberDAO memberDAO;
	
	@Override
	public MemberVO login(Map  loginMap) throws Exception{
		return memberDAO.login(loginMap);
	}
	
	@Override
	public void addMember(MemberVO memberVO) throws Exception{
		memberDAO.insertNewMember(memberVO);
	}
	
	@Override
	public String overlapped(String id) throws Exception{
		return memberDAO.selectOverlappedID(id);
	}
	
	@Override
	public String searchId(MemberVO memberVO) throws Exception{
		return memberDAO.selectMemID(memberVO);
	}
	
	@Override
	public MemberVO checkMemInfo(Map<String, String> checkMem) throws Exception {
		return memberDAO.checkMemInfo(checkMem);
	}

	@Override
	public int removeMember(String mem_id) throws Exception{
		return memberDAO.removeMember(mem_id);
	}

	@Override
	public int updatePass(String mem_id, String user_psw_confirm) throws Exception {
		return memberDAO.updatePass(mem_id,user_psw_confirm);
		
	}
	
}
