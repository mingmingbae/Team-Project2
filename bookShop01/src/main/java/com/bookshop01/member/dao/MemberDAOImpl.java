package com.bookshop01.member.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;
import com.bookshop01.member.vo.MemberVO;

@Repository("memberDAO")
public class MemberDAOImpl  implements MemberDAO{
	@Autowired
	private SqlSession sqlSession;	
	
	@Override
	public MemberVO login(Map loginMap) throws DataAccessException{
		MemberVO member=(MemberVO)sqlSession.selectOne("mapper.member.login",loginMap);
	    return member;
	}
	
	@Override
	public void insertNewMember(MemberVO memberVO) throws DataAccessException{
		sqlSession.insert("mapper.member.insertNewMember",memberVO);
	}

	@Override
	public String selectOverlappedID(String id) throws DataAccessException{
		String result =  sqlSession.selectOne("mapper.member.selectOverlappedID",id);
		return result;
	}
	
	@Override
	public String selectMemID(MemberVO memberVO) throws DataAccessException {
		return sqlSession.selectOne("mapper.member.selectMemID",memberVO);
	}
	
	@Override
	public MemberVO checkMemInfo(Map<String, String> checkMem) throws DataAccessException {
		return sqlSession.selectOne("mapper.member.checkMemInfo",checkMem);

	}

	@Override
	public int removeMember(String mem_id) throws DataAccessException {
		return  sqlSession.delete("mapper.member.removeMember",mem_id);
	}

	@Override
	public int updatePass(String mem_id, String user_psw_confirm) throws DataAccessException {
	    Map<String, String> newPass = new HashMap<>();
	    newPass.put("mem_id", mem_id);
	    newPass.put("user_psw_confirm", user_psw_confirm);
		return sqlSession.update("mapper.member.updatePass", newPass);
	}

	
}

















