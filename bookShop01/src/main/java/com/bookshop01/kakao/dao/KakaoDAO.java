package com.bookshop01.kakao.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bookshop01.kakao.vo.KakaoVO;
import com.bookshop01.member.vo.MemberVO;

public interface KakaoDAO {

	// 카카오 아이디 있을 시, DB 등록 후 자동 로그인 
	public KakaoVO kakaoLogin(KakaoVO kakaoVO) throws DataAccessException;

	// id 값이 테이블에 존재하는지 여부 확인
	public KakaoVO checkId(String id) throws DataAccessException;

	// 정보가 저장되어있는지 확인
	public MemberVO findKakao(HashMap<String, Object> userInfo) throws DataAccessException;

	// 카카오 정보 저장
	public void kakaoInsert(HashMap<String, Object> userInfo) throws DataAccessException;

	// 카카오 추가 정보 저장
	public void addKakaoJoin(MemberVO _memberVO) throws DataAccessException;

	
	
}
