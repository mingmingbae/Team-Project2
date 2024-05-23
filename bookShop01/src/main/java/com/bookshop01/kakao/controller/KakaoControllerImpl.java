package com.bookshop01.kakao.controller;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookshop01.common.base.BaseController;
import com.bookshop01.kakao.service.KakaoService;
import com.bookshop01.kakao.vo.KakaoVO;
import com.bookshop01.member.vo.MemberVO;

@Controller("kakaoController")
@RequestMapping("/kakao")
public class KakaoControllerImpl extends BaseController implements KakaoController {

	@Autowired
	private KakaoService kakaoService;
	
	@Autowired
	private KakaoVO kakaoVO;
	
	@Autowired
	private MemberVO memberVO;
	
	
	@Override
	@RequestMapping(value = "/login.do", method = RequestMethod.GET)
	public String kakaoLogin(@RequestParam(value = "code", required = false) String code, 
							 Model model,
						     HttpServletRequest request,
						     HttpServletResponse response) throws Exception {
		
		String contextPath = request.getContextPath();
		
		// 토큰 얻기
		String access_Token = kakaoService.getAccessToken(code, contextPath); 
	
		// 토큰 보내서 사용자 정보 얻기
		MemberVO userInfo = kakaoService.getUserInfo(access_Token);
		
	    // 추가 정보가 필요한 경우
		if (userInfo.getMember_pw() == null || userInfo.getMember_pw().equals("")) {
	    	
	    	// 추가 정보 입력 페이지로 이동
	    	model.addAttribute("memberInfo", userInfo);
	    	model.addAttribute("access_Token", access_Token);
	        return "/kakao/kakaoAddJoin";
	        
	    } else {
	    	
	        // 추가 정보가 모두 채워진 경우, 메인 화면으로 이동
	    	HttpSession session = request.getSession();
			session.setAttribute("isLogOn", true);
			session.setAttribute("memberInfo", userInfo);
			
			/*카카오 로그아웃 용*/
			session.setAttribute("access_Token", access_Token);
	    	
	        return "/main/main";
	    }
		
    }
	
	
	@RequestMapping(value="/addKakaoJoin.do" ,method = RequestMethod.POST)
															//회원가입시 입력한 회원 정보를 MemberVO 객체의 각변수에 저장후 전달 받음 
	public ResponseEntity addKakaoJoin(@ModelAttribute("memberVO") MemberVO _memberVO, 
			                		   HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		try {			
		    kakaoService.addKakaoJoin(_memberVO);//새 회원 정보를 DB에 추가~ 
		    
		    HttpSession session = request.getSession();
			session.setAttribute("isLogOn", true);
			session.setAttribute("memberInfo", _memberVO);
			
			/*카카오 로그아웃 용*/
			String access_Token = request.getParameter("access_Token");
			session.setAttribute("access_Token", access_Token);
		    
		    message  = "<script>";
		    message +=" alert('회원가입에 성공 했습니다.');";
		    message += " location.href='"+request.getContextPath()+"/main/main.do';";
		    message += " </script>";
		    
		}catch(Exception e) {
			message  = "<script>";
		    message +=" alert('회원가입 실패 했어요.');";
		    message += " window.location.reload();";
		    message += " </script>";
			e.printStackTrace();
		}
		resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		
		return resEntity;
	}
	
}
