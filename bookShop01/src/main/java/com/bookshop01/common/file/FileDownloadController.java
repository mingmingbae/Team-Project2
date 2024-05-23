package com.bookshop01.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import net.coobird.thumbnailator.Thumbnails;


@Controller
public class FileDownloadController {
	
	//이미지 파일 이름과 상품 id 조회
	@RequestMapping("/download")
	protected void download(@RequestParam("fileName") String fileName,
		                 	@RequestParam("goods_id") String goods_id,
		                 	HttpServletRequest request,
			                HttpServletResponse response) throws Exception {
		
		OutputStream out = response.getOutputStream();
		
		String file_path=request.getSession().getServletContext().getRealPath("/"); //이미지 저장경로			
		String book_path=file_path+"resources\\fileimage\\book";
		String path=book_path+"\\"+goods_id+"\\"+fileName;
		
		File image=new File(path);

		response.setHeader("Cache-Control","no-cache");
		response.addHeader("Content-disposition", "attachment; fileName="+fileName);
		
		FileInputStream in=new FileInputStream(image); 
		
		byte[] buffer=new byte[1024*8];
		
		while(true){
			int count=in.read(buffer);
			if(count==-1)
				break;
			out.write(buffer,0,count);
		}
		in.close();
		out.close();
	}
	
	
	//썸네일 이미지 지정
	@RequestMapping("/thumbnails.do")
	protected void thumbnails(@RequestParam("fileName") String fileName,
                              @RequestParam("goods_id") String goods_id,
                              HttpServletRequest request,
			                  HttpServletResponse response) throws Exception {
		OutputStream out = response.getOutputStream();

		String file_path=request.getSession().getServletContext().getRealPath("/");
		
		String book_path=file_path+"resources\\fileimage\\book";
		String path=book_path+"\\"+goods_id+"\\"+fileName;
		File image=new File(path);
		
		//메인 페이지 이미지를 썸네일 이미지로 표시 하는 부분
		if (image.exists()) { 
			Thumbnails.of(image).size(121,154).outputFormat("png").toOutputStream(out);
		}
		byte[] buffer = new byte[1024 * 8];
		out.write(buffer);
		out.close();
	}
}
