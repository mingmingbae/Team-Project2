package com.bookshop01.kakao.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bookshop01.kakao.dao.KakaoDAO;
import com.bookshop01.kakao.vo.KakaoVO;
import com.bookshop01.member.vo.MemberVO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service("kakaoService")
@Transactional(propagation = Propagation.REQUIRED)
public class KakaoServiceImpl implements KakaoService{
	
	@Autowired
	private KakaoDAO kakaoDAO;
	
	// access_Token 얻기
	@Override
	public String getAccessToken (String authorize_code, String contextPath) {
		String access_Token = "";
		String refresh_Token = "";
		String reqURL = "https://kauth.kakao.com/oauth/token";

		try {
			URL url = new URL(reqURL);
            
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			
			// POST 요청을 위해 기본값이 false인 setDoOutput을 true로
			conn.setRequestProperty("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
			conn.setDoOutput(true); //OutputStream으로 POST 데이터를 넘겨주겠다는 옵션.
			
			// POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			StringBuilder sb = new StringBuilder();
			
			sb.append("grant_type=authorization_code");
			sb.append("클라이언트아이디"); //본인이 발급받은 key
			sb.append("&redirect_uri=리다이렉트주소"); // 본인이 설정한 주소
			sb.append("&code=" + authorize_code);
			
			bw.write(sb.toString());
			bw.flush();
            
			// 결과 코드가 200이라면 성공
			int responseCode = conn.getResponseCode();
            
			// 요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line = "";
			String result = "";
            
			while ((line = br.readLine()) != null) {
				result += line;
			}
            
			// Jackson 라이브러리에 포함된 클래스로 JSON 파싱 객체 생성
			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode rootNode = objectMapper.readTree(result);

			access_Token = rootNode.path("access_token").asText();
			refresh_Token = rootNode.path("refresh_token").asText();
            
			br.close();
			bw.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return access_Token;
	}
	
	
	// 토큰 보내서 사용자 정보 얻기
	@Override
	public MemberVO getUserInfo(String access_Token) {
		
		// 요청하는 클라이언트마다 가진 정보가 다를 수 있기에 HashMap타입으로 선언
		HashMap<String, Object> userInfo = new HashMap<String, Object>();
		String reqURL = "https://kapi.kakao.com/v2/user/me";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");

			// 요청에 필요한 Header에 포함될 내용
			conn.setRequestProperty("Authorization", "Bearer " + access_Token);

			int responseCode = conn.getResponseCode();

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

			String line = "";
			String result = "";

			while ((line = br.readLine()) != null) {
				result += line;
			}

			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode rootNode = objectMapper.readTree(result);

			JsonNode propertiesNode = rootNode.get("properties");
			JsonNode kakaoAccountNode = rootNode.get("kakao_account");
			JsonNode idNode = rootNode.get("id");

			String nickname = propertiesNode.get("nickname").asText();
			String email = kakaoAccountNode.get("email").asText();
			String id = idNode.asText();
			
			// "@" 기준으로 이메일을 분할
			String[] emailParts = email.split("@");

			// 분할된 이메일 부분
			String email1 = emailParts[0]; // 이메일 아이디
			String email2 = emailParts[1]; // 이메일 주소

			userInfo.put("nickName", nickname);
			userInfo.put("email1", email1);
			userInfo.put("email2", email2);
			userInfo.put("id", id);

		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// 정보가 저장되어있는지 확인하는 코드
		MemberVO result = kakaoDAO.findKakao(userInfo);
		
		if(result==null) {
			// result가 null이면 정보가 저장이 안되있는거므로 정보를 저장.
			// 위 코드는 정보 저장 후 컨트롤러에 정보를 보내는 코드임.
			kakaoDAO.kakaoInsert(userInfo);
			
			return kakaoDAO.findKakao(userInfo);
			
		} else {
			return result;
			// 정보가 이미 있기 때문에 result를 리턴함.
		}
	}
	
	
	
	// 카카오 추가 정보 업데이트
	@Override
	public void addKakaoJoin(MemberVO _memberVO) {
		
		kakaoDAO.addKakaoJoin(_memberVO);
	}
	
	
	
	

	// id 값이 테이블에 존재하는지 	여부 확인
	@Override
	public KakaoVO serviceCheckId(KakaoVO kakaoVO) throws Exception {
		
		return kakaoDAO.checkId(kakaoVO.getId());
	}
	
	
	// 카카오 로그인 처리
	@Override
	public KakaoVO serviceLogin(KakaoVO kakaoVO) throws Exception {
		
		// 카카오 아이디 없을 시 , DB 등록 후 자동 로그인 
		return kakaoDAO.kakaoLogin(kakaoVO);
	}
	
}
