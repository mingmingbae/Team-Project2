package com.bookshop01.kakao.service;

import java.util.HashMap;
import java.util.Map;

import com.bookshop01.kakao.vo.KakaoVO;
import com.bookshop01.member.vo.MemberVO;

public interface KakaoService {

	// 카카오 로그인 처리
	public KakaoVO serviceLogin(KakaoVO kakaoVO) throws Exception;

	// id 값이 테이블에 존재하는지 	여부 확인
	public KakaoVO serviceCheckId(KakaoVO kakaoVO) throws Exception;

	// access_Token 얻기
	public String getAccessToken(String code, String contextPath);

	// 토큰보내서 사용자 정보 얻기
	public MemberVO getUserInfo(String access_Token);

	// 카카오 추가정보 업데이트
	public void addKakaoJoin(MemberVO _memberVO);

	
	
}
