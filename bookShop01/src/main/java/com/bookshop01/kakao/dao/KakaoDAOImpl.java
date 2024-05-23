package com.bookshop01.kakao.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.bookshop01.kakao.vo.KakaoVO;
import com.bookshop01.member.vo.MemberVO;

@Repository("kakaoDAO")
public class KakaoDAOImpl implements KakaoDAO {
	@Autowired
	private SqlSession sqlSession;
	
	// id 값이 테이블에 존재하는지 여부 확인 
	@Override
	public KakaoVO checkId(String id) throws DataAccessException {

		return sqlSession.selectOne("mapper.kakao.checkId", id);
	}
	
	// id 값이 테이블에 존재하는지 여부 확인
	@Override
	public KakaoVO kakaoLogin(KakaoVO kakaoVO) throws DataAccessException {

		sqlSession.insert("mapper.kakao.insertKakao", kakaoVO);
		
		return sqlSession.selectOne("mapper.kakao.loginKakao", kakaoVO);
	}
	
	// 정보가 있는지 확인
	@Override
	public MemberVO findKakao(HashMap<String, Object> userInfo) throws DataAccessException {
		
		return sqlSession.selectOne("mapper.kakao.findKakao", userInfo);
	}
	
	// 카카오 정보 저장
	@Override
	public void kakaoInsert(HashMap<String, Object> userInfo) throws DataAccessException {

		sqlSession.insert("mapper.kakao.kakaoInsert", userInfo);
	}
	
	// 카카오 추가 정보 저장
	@Override
	public void addKakaoJoin(MemberVO _memberVO) throws DataAccessException {

		sqlSession.update("mapper.kakao.kakaoUpdate", _memberVO);
	}
	
}
