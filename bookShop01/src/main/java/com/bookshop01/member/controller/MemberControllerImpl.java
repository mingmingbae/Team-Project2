package com.bookshop01.member.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.common.base.BaseController;
import com.bookshop01.member.service.MemberService;
import com.bookshop01.member.vo.MemberVO;




@Controller("memberController")
@RequestMapping(value="/member")
public class MemberControllerImpl extends BaseController implements MemberController{
	@Autowired
	private MemberService memberService;
	@Autowired
	private MemberVO memberVO;
	@Autowired
	private JavaMailSenderImpl mailSenderImpl;
	
	// 비밀번호 찾기로 랜덤으로 발송되는 값
	private int checkNum;
	
	//로그인 요청
	@Override
	@RequestMapping(value="/login.do" ,method = RequestMethod.POST)
	public ModelAndView login(@RequestParam Map<String, String> loginMap,
			                  HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		 ModelAndView mav = new ModelAndView();
		 
		 //로그인 요청을 위해 입력한 아이디와 비밀번호가 DB에 저장되어 있는지 확인
		 memberVO=memberService.login(loginMap);
		 
		 //조회가 되고!! 조회한 회원의 아이디가 존재하면?
		if(memberVO!= null && memberVO.getMember_id()!=null){
			
			//조회한 회원 정보를 가져와 isLogOn 속성을 true로 설정 
			//memberInfo속성으로  조회된 회원 정보를  session에 저장 
			HttpSession session=request.getSession();
			session.setAttribute("isLogOn", true);
			session.setAttribute("memberInfo",memberVO);
			
			//상품 주문 과정에서 로그인 했으면 로그인 후 다시 주문 화면 이동하고 그외에 는 메인페이지로 이동
			String action=(String)session.getAttribute("action");
			if(action!=null && action.equals("/order/orderEachGoods.do")){
				mav.setViewName("forward:"+action);
			}else{
				mav.setViewName("redirect:/main/main.do");	
			}
				
		//로그인 요청시 입력한 아이디와 비밀번호로 회원 조회X	
		}else{
			String message="아이디나 비밀번호가 틀립니다. 다시 로그인해주세요";
			mav.addObject("message", message);
			mav.setViewName("/member/loginForm");
		}
		return mav;
	}
	
	//로그아웃 요청
	@Override
	@RequestMapping(value="/logout.do" ,method = RequestMethod.GET)
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		HttpSession session=request.getSession();
		
		session.setAttribute("isLogOn", false); //로그아웃 시키는 false값 저장 
		
		session.removeAttribute("memberInfo"); //로그인 요청시 입력한 아이디 비번을 이용해서 조회 했던 회원정보(MemberVO객체)를 삭제 !
		
		mav.setViewName("redirect:/main/main.do");
		
		return mav;
	}

	//회원 가입 요청
	@Override
	@RequestMapping(value="/addMember.do" ,method = RequestMethod.POST)
															//회원가입시 입력한 회원 정보를 MemberVO 객체의 각변수에 저장후 전달 받음 
	public ResponseEntity addMember(@ModelAttribute("memberVO") MemberVO _memberVO, 
			                		HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		
		// email2 값에 쉼표가 포함되어 있는지 확인하고, 포함되어 있다면 제거
	    if (_memberVO.getEmail2() != null && _memberVO.getEmail2().contains(",")) {
	        _memberVO.setEmail2(_memberVO.getEmail2().replace(",", ""));
	    }
		
		try {
		    memberService.addMember(_memberVO);//새 회원 정보를 DB에 추가~ 
		    message  = "<script>";
		    message +=" alert('회원가입에 성공 했습니다.');";
		    message += " location.href='"+request.getContextPath()+"/member/loginForm.do';";
		    message += " </script>";
		    
		}catch(Exception e) {
			message  = "<script>";
		    message +=" alert('회원가입 실패 했어요.');";
		    message += " location.href='"+request.getContextPath()+"/member/memberForm.do';";
		    message += " </script>";
			e.printStackTrace();
		}
		resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}
	
	
	//회원가입시 입력한 아이디가 DB에 존재 하는지 유무 확인
	@Override
	@RequestMapping(value="/overlapped.do" ,method = RequestMethod.POST)
	public ResponseEntity overlapped(@RequestParam("id") String id,
									 HttpServletRequest request, 
									 HttpServletResponse response) throws Exception{
		
		ResponseEntity resEntity = null;
		String result = memberService.overlapped(id);
		resEntity =new ResponseEntity(result, HttpStatus.OK);
		
		return resEntity;
	}
	
//	아이디 찾기 요청
	@Override
	@RequestMapping(value="/searchId.do" ,method = RequestMethod.POST)
	public ModelAndView searchId(@ModelAttribute("memId") MemberVO memberVO, 
    							 HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		String result=memberService.searchId(memberVO);
		
		if(result!= null && result.length()!=0){
			mav.addObject("searchId", result);
			mav.setViewName("/member/searchId");
		}else {
			result="일치하는 회원의 정보가 없습니다.";
			mav.addObject("searchId", result);
			mav.setViewName("/member/searchId");
		}
		return mav;
	}
	
//	비밀번호 찾기에서 회원정보 DB에 존재유무 판단
	@Override
	@RequestMapping(value="/checkMemInfo.do" ,method = RequestMethod.POST)
	public ModelAndView checkMemInfo(@RequestParam Map<String, String> checkMem, HttpServletRequest request, HttpServletResponse response)
									throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		memberVO=memberService.checkMemInfo(checkMem);
		
		if(memberVO!= null && memberVO.getMember_id()!=null){
			mav.addObject("memberInfo", memberVO);
			mav.setViewName("/member/sendEmailForm");	
		}else{
			HttpSession session = request.getSession();
	        session.setAttribute("checkPwdMessage", "일치하는 회원정보가 없습니다.");
			mav.setViewName("redirect:/member/searchPwdForm.do");
		}
		return mav;
	}
	
//	회원 탈퇴 요청
	@Override
	@RequestMapping(value="/removeMember.do" ,method = RequestMethod.POST)
	public ResponseEntity removeMember(@RequestParam("mem_id") String mem_id,HttpSession session,HttpServletRequest request,HttpServletResponse response) 
										throws Exception {

		ResponseEntity resEntity = null;
		String result=null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		
	    try {
	        int remove = memberService.removeMember(mem_id);
	        if (remove == 1) {
	            session.invalidate();
	            result="탈퇴성공";
	            resEntity =new ResponseEntity(result, responseHeaders, HttpStatus.OK);
	        } else {
	            result="탈퇴실패";
	            resEntity =new ResponseEntity(result, responseHeaders, HttpStatus.OK);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resEntity;
	}

	
	//이메일 인증
	@Override
	@ResponseBody
	@RequestMapping(value="/sendPwdMail.do",method = RequestMethod.POST)
	public String sendPwdMail(@RequestParam("email") String email,HttpServletRequest request,HttpServletResponse response) throws Exception {
		
		//난수의 범위 111111 ~ 999999 (6자리 난수)
		Random random = new Random();
		checkNum = random.nextInt(888888)+111111;
			
		//이메일 보낼 양식
		String setFrom = "발신자 메일 주소"; //2단계 인증 x, 메일 설정에서 POP/IMAP 사용 설정에서 POP/SMTP 사용함으로 설정o
		String toMail = email;
		String title = "비밀번호 찾기 인증 이메일 입니다.";
		String content = "인증 코드는 <span style='color: blue; text-decoration: underline;'>" + checkNum + "</span> 입니다." +
                "<br>" +
                "해당 인증 코드를 인증 코드 확인란에 기입하여 주세요.";
			
		try {
				MimeMessage message = mailSenderImpl.createMimeMessage(); //Spring에서 제공하는 mail API
	            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
	            helper.setFrom(setFrom);
	            helper.setTo(toMail);
	            helper.setSubject(title);
	            helper.setText(content, true);
	            mailSenderImpl.send(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return String.valueOf(checkNum);
		}
	
//	이메일 인증번호 일치 여부 확인
	@Override
	@RequestMapping(value="/checkRandomPass.do", method = RequestMethod.POST)
	public ResponseEntity checkRandomPass(@RequestParam("checknum2") String checknum2) throws Exception {
		ResponseEntity resEntity = null;
	    String result = "불일치"; // 기본값을 설정
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
	    
	    checknum2 = checknum2.replace("=", "");
	    if (checknum2.equals(String.valueOf(checkNum))) {
	        result = "일치";
	        resEntity =new ResponseEntity(result, responseHeaders, HttpStatus.OK);
	    } 
	    return resEntity;
	}
	
	// 비밀번호 수정 요청
	@Override
	@RequestMapping(value="/updatePass.do", method = RequestMethod.POST)
	public ResponseEntity updatePass(@RequestParam("user_psw_confirm") String user_psw_confirm,
									 @RequestParam("mem_id") String mem_id) throws Exception {
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
	    String result = "실패"; // 기본값을 설정

		try {
			int updateResult = memberService.updatePass(mem_id,user_psw_confirm);
			if(updateResult>0) {
		    	result = "성공";
		    	resEntity =new ResponseEntity(result, responseHeaders, HttpStatus.OK);
		    }
		} catch (Exception e) {
			e.printStackTrace();
		}
	    return resEntity;
	}
}









