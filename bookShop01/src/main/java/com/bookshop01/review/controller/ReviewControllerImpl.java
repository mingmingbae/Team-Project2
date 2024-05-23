package com.bookshop01.review.controller;

import java.io.File;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.common.base.BaseController;
import com.bookshop01.review.service.ReviewService;
import com.bookshop01.review.vo.ReviewVO;

import net.sf.json.JSONObject;

@Controller("reviewController")
@RequestMapping(value="/review")
public class ReviewControllerImpl extends BaseController implements ReviewController {
	
	@Autowired ReviewService reviewService;
		
		//AJAX 호출 (게시글 상세 조회)
		@RequestMapping(value="/detailReview.do", method=RequestMethod.POST,produces = "application/json; charset=utf8")
		@ResponseBody
		public String detailReview(@RequestParam ("review_idx") String review_idx,
				                 	HttpServletRequest request, HttpServletResponse response) throws Exception {
	
			ReviewVO reviewVO = reviewService.detailReview(review_idx);			
			
			JSONObject jsonObject = new JSONObject();

			 if (reviewVO != null) {
					jsonObject.put("review_mem_id", reviewVO.getReview_member_id());
					jsonObject.put("review_goods_id", reviewVO.getReview_goods_id());
					jsonObject.put("review_title", reviewVO.getReview_title());
					jsonObject.put("review_content", reviewVO.getReview_content());

					String review_date = String.valueOf(reviewVO.getReview_date());
					jsonObject.put("review_date", review_date);
			    } else {
			        jsonObject.put("조회실패", "조회실패");
			    }
			
			 String jsonInfo = jsonObject.toString();
			 
			 return jsonInfo;
		}

		//AJAX 호출 (리뷰 삭제)
		@RequestMapping(value="/deleteReview.do", method=RequestMethod.POST, produces="application/json")
		@ResponseBody
		public Map<String, String> deleteReview(@RequestParam ("review_idx") String review_idx,
				 			   	   				HttpServletRequest request, HttpServletResponse response) throws Exception {
			
			Map<String, String> resultMap = new HashMap<>();
			
			int result = reviewService.deleteReview(review_idx);
			
		    if(result > 0) {
		    	resultMap.put("status", "success");
		        resultMap.put("message", "삭제 성공");
		    } else {
		    	resultMap.put("status", "fail");
		        resultMap.put("message", "삭제 실패");
		    }

		    return resultMap;

		}
	
		//리뷰 추가
		@RequestMapping(value = "/write.do", method=RequestMethod.POST, produces = "application/json;charset=utf-8")
		@ResponseBody
		public JSONObject writeReview(@RequestParam Map<String, Object> paramMap) throws Exception {
			
			JSONObject jsonObject = new JSONObject();
			
			int result_ = reviewService.insertReview(paramMap);
			
			if(result_>0){
				jsonObject.put("code", "OK");
				jsonObject.put("message", "등록에 성공 하였습니다.");
			}else{
				jsonObject.put("code", "FAIL");
				jsonObject.put("message", "등록에 실패 하였습니다.");
			}
			
			return jsonObject ;
		}
		

}
