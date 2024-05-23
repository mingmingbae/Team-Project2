package com.bookshop01.news.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.bookshop01.common.base.BaseController;
import com.bookshop01.member.service.MemberService;
import com.bookshop01.member.vo.MemberVO;
import com.bookshop01.news.service.NewsService;
import com.bookshop01.news.vo.NewsVO;


@Controller("newsController")
@RequestMapping(value = "/news")
public class NewsControllerImpl extends BaseController implements NewsController{

	@Autowired
	private NewsService newsService;
	@Autowired
	private MemberService memberService;
	
	
	// 게시글 조회
	@Override
	@RequestMapping(value = "/newsList.do", method={RequestMethod.POST,RequestMethod.GET} )
	public String newsList(@RequestParam Map<String, Object> paramMap, Model model, 
			               HttpServletRequest request, HttpServletResponse response) throws Exception {
	
		//조회 하려는 페이지
		int startPage = (paramMap.get("startPage")!=null?Integer.parseInt(paramMap.get("startPage").toString()):1);
		//한페이지에 보여줄 리스트 수
		int visiblePages = (paramMap.get("visiblePages")!=null?Integer.parseInt(paramMap.get("visiblePages").toString()):3);
		//전체 건수
		int totalCnt = newsService.getContentCnt(paramMap);
		
		String member_id = (String)paramMap.get("member_id");

		//아래 1,2는 실제 개발에서는 class로 빼준다. (여기서는 이해를 위해 직접 적음)
		//1.하단 페이지 네비게이션에서 보여줄 리스트 수를 구한다.
		BigDecimal decimal1 = new BigDecimal(totalCnt);
		BigDecimal decimal2 = new BigDecimal(visiblePages);
		BigDecimal totalPage = decimal1.divide(decimal2, 0, BigDecimal.ROUND_UP);

		int startLimitPage = 0;
		//2.mysql limit 범위를 구하기 위해 계산
		if(startPage==1){
			startLimitPage = 0;
		}else{
			startLimitPage = (startPage-1)*visiblePages;
		}

		paramMap.put("start", startLimitPage);

		//ORACLE
		paramMap.put("end", startLimitPage+visiblePages);

		//jsp 에서 보여줄 정보 추출
		model.addAttribute("startPage", startPage+"");//현재 페이지      
		model.addAttribute("totalCnt", totalCnt);//전체 게시물수
		model.addAttribute("totalPage", totalPage);//페이지 네비게이션에 보여줄 리스트 수
		model.addAttribute("newsList", newsService.getContentList(paramMap));// 전체 목록
		model.addAttribute("member_id", member_id);
		
		String viewName=(String)request.getAttribute("viewName");
		
		return viewName;
	}
	
	
	// 게시글 상세 보기
	@Override
	@RequestMapping(value = "/newsView.do")
	public String newsView(@RequestParam Map<String, Object> paramMap, Model model, HttpServletRequest request,
							HttpServletResponse response) throws Exception {
		
		model.addAttribute("newsView", newsService.getContentView(paramMap));
		model.addAttribute("news_member_id", paramMap.get("member_id"));
	
		String viewName=(String)request.getAttribute("viewName"); 
			
		return viewName;
		
	}
	
	
	// 게시글 등록 및 수정 뷰
	@Override
	@RequestMapping("/editView.do")
	public String newsEditView(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		
        if (paramMap.get("news_idx") != null) { // 글번호가 있으면 게시글 수정
        	
                model.addAttribute("newsView", newsService.getContentView(paramMap));
                model.addAttribute("news_member_id", paramMap.get("news_member_id"));
                
                // 타일즈에 넘길 값
                return "/news/newsEdit";
                
        } else { // 없으면 게시글 등록
        	
        		model.addAttribute("news_member_id", paramMap.get("news_member_id"));
                return "/news/newsEdit";   
        }
	}
	
	
	// 게시글 등록 및 수정
	@Override
	@RequestMapping(value = "/newsSave.do", method=RequestMethod.POST)
	@ResponseBody
	public Object newsEditPro(HttpServletRequest request,
							  @RequestParam Map<String, Object> paramMap,
            				  @RequestPart("news_sfile") MultipartFile newsSFile,
            				  MultipartHttpServletRequest multipartRequest,
            				  HttpServletResponse response) throws Exception{

		multipartRequest.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String file_path = request.getSession().getServletContext().getRealPath("/resources/fileimage/news");
		
		// 리턴값
	    Map<String, Object> retVal = new HashMap<>();

	    try {
	        // 파일 업로드 처리
	        if (newsSFile != null && !newsSFile.isEmpty()) {
	            String uploadPath = file_path;
	            String fileName = newsSFile.getOriginalFilename();
	            
	            File file = new File(uploadPath + "\\" + fileName);
	            if(newsSFile.getSize()!=0) {
	            	if(! file.exists()) {
	            		if(file.getParentFile().mkdirs()) {
	            			file.createNewFile();
	            		}
	            	}
	            	try {
		            	File destFile = new File(uploadPath+"\\"+"temp"+"\\"+ fileName);
		            	newsSFile.transferTo(destFile);	            	
	            	}catch (IOException e) {
	            		System.out.println("파일 저장 실패: " + e.getMessage());
	            	}
	            }
	            // 파일 이름를 paramMap에 추가
	            paramMap.put("news_sfile", fileName);
	        }
	        // 나머지 데이터 처리 등록 한 후 등록한 글 번호 반환 받는다
	        int result = newsService.regContent(paramMap);
	        
	        File srcFile = new File(file_path+"\\"+"temp"+"\\"+paramMap.get("news_sfile"));
	        File destDir = new File(file_path+"\\"+result);
	        FileUtils.moveFileToDirectory(srcFile, destDir, true);
	        
	        if (result != 0) {
	        	retVal.put("news_member_id", paramMap.get("news_member_id"));
	            retVal.put("code", "OK");
	            retVal.put("message", "등록에 성공 하였습니다.");
	        } else {
	            retVal.put("code", "FAIL");
	            retVal.put("message", "등록에 실패 하였습니다.");
	        }
	    } catch (Exception e) {
	        retVal.put("code", "ERROR");
	        retVal.put("message", "서버 오류가 발생했습니다.");
	        e.printStackTrace();
	    }
	    return retVal;
	}
	
	
	// 게시글 삭제
	@Override
	@RequestMapping(value = "/newsDel.do", method=RequestMethod.POST)
	@ResponseBody
	public Object newsDel(@RequestParam Map<String, Object> paramMap) throws Exception{

		//리턴값
		Map<String, Object> retVal = new HashMap<String, Object>();

		//정보입력
		int result = newsService.delNews(paramMap);

		if(result!=0){
			retVal.put("code", "OK");
			retVal.put("message", "삭제되었습니다.");
		}else{
			retVal.put("code", "FAIL");
			retVal.put("message", "삭제에 실패 하였습니다.");
		}
		return retVal;
	}
}
