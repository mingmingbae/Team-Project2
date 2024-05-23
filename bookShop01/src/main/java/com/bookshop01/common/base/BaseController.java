package com.bookshop01.common.base;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.bookshop01.goods.vo.ImageFileVO;

public abstract class BaseController  {
	
	//메인 화면
	@RequestMapping(value="/")
	protected  String home(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return "redirect:/main/main.do" ;
	}
	
//	파일 업로드 + 업로드된 파일 객체 리스트 반환
	protected List<ImageFileVO> upload(MultipartHttpServletRequest multipartRequest,HttpServletRequest request) throws Exception{
//		업로드된 파일 정보를 담을 리스트
		List<ImageFileVO> fileList= new ArrayList<ImageFileVO>();
//		파일 이름을 가져오는 반복 객체
		Iterator<String> fileNames = multipartRequest.getFileNames();
		while(fileNames.hasNext()){
			ImageFileVO imageFileVO =new ImageFileVO();
			String fileName = fileNames.next(); //파일 이름가져오기
			imageFileVO.setFileType(fileName); //파일 타입 설정
			MultipartFile mFile = multipartRequest.getFile(fileName); //파일 이름에 해당하는 파일 가져오기
			String originalFileName=mFile.getOriginalFilename(); //원본파일 이름 가져오기
			imageFileVO.setFileName(originalFileName); //원본파일 이름 설정
			fileList.add(imageFileVO); //파일 정보를 담을 리스트에 추가
			
			String file_path=request.getSession().getServletContext().getRealPath("/"); //파일이 저장된 실제 경로
			
			File file = new File(file_path +"resources\\fileimage\\book"+ fileName); //파일이 저장될 경로 설정
			if(mFile.getSize()!=0){ //파일이 비어있는지 아닌지 확인
				if(! file.exists()){ //파일이 존재하지 않을경우
					if(file.getParentFile().mkdirs()){ //부모 디렉토리 생성
							file.createNewFile(); //새파일 생성
					}
				}
				mFile.transferTo(new File(file_path +"resources\\fileimage\\book\\temp\\"+originalFileName)); //업로드된 파일을 해당경로로 이동
			}
		}
		return fileList;
	}
	
	//파일 삭제
	private void deleteFile(String fileName,HttpServletRequest request) {
		String file_path=request.getSession().getServletContext().getRealPath("/");
		File file =new File(file_path+"resources\\fileimage\\book"+fileName);
		try{
			file.delete();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	//페이지 이동 요청
	@RequestMapping(value="/*.do" ,method={RequestMethod.POST,RequestMethod.GET})
	protected  ModelAndView viewForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		return mav;
	}
	
	//조회 기간 설정
	protected String calcSearchPeriod(String fixedSearchPeriod){
		String beginDate=null;
		String endDate=null;
		String endYear=null;
		String endMonth=null;
		String endDay=null;
		String beginYear=null;
		String beginMonth=null;
		String beginDay=null;
		DecimalFormat df = new DecimalFormat("00");
		Calendar cal=Calendar.getInstance();
		
		endYear   = Integer.toString(cal.get(Calendar.YEAR));
		endMonth  = df.format(cal.get(Calendar.MONTH) + 1);
		endDay   = df.format(cal.get(Calendar.DATE));
		endDate = endYear +"-"+ endMonth +"-"+endDay;
		
		if(fixedSearchPeriod == null) {
			cal.add(cal.MONTH,-4);
		}else if(fixedSearchPeriod.equals("one_week")) {
			cal.add(Calendar.DAY_OF_YEAR, -7);
		}else if(fixedSearchPeriod.equals("two_week")) {
			cal.add(Calendar.DAY_OF_YEAR, -14);
		}else if(fixedSearchPeriod.equals("one_month")) {
			cal.add(cal.MONTH,-1);
		}else if(fixedSearchPeriod.equals("two_month")) {
			cal.add(cal.MONTH,-2);
		}else if(fixedSearchPeriod.equals("three_month")) {
			cal.add(cal.MONTH,-3);
		}else if(fixedSearchPeriod.equals("four_month")) {
			cal.add(cal.MONTH,-4);
		}
		
		beginYear   = Integer.toString(cal.get(Calendar.YEAR));
		beginMonth  = df.format(cal.get(Calendar.MONTH) + 1);
		beginDay   = df.format(cal.get(Calendar.DATE));
		beginDate = beginYear +"-"+ beginMonth +"-"+beginDay;
		
		return beginDate+","+endDate;
	}
	
}
