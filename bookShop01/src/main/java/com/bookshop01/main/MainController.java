package com.bookshop01.main;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.bookCraw.vo.BookCrawVO;
import com.bookshop01.common.base.BaseController;
import com.bookshop01.goods.service.GoodsService;
import com.bookshop01.goods.vo.GoodsVO;
import com.bookshop01.news.service.NewsService;
import com.bookshop01.news.vo.NewsVO;
import com.bookshop01.selenium.SeleniumVO;


@Controller("mainController")
@EnableAspectJAutoProxy
public class MainController extends BaseController {
	
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private NewsService newsService;

	// 메인화면 중앙에 보여줄 베스트셀러, 신간, 스테디 셀러를 조회
	@RequestMapping(value= "/main/main.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		//첫 메인 화면 main.jsp의 side_menu속성값에따른 상태 보여주기
		HttpSession session;
		session=request.getSession();
		session.setAttribute("side_menu", "user");
		
		//사이드 바에 공지사항 리스트 조회
		List<NewsVO> newsList = newsService.getSideList();
		session.setAttribute("newsList", newsList);
		
		ModelAndView mav=new ModelAndView();
		
		String viewName=(String)request.getAttribute("viewName");
		mav.setViewName(viewName);
		
		//베스트 셀러, 신간, 스테디 셀러  도서정보를 조회 해 Map에 저장
		Map<String,List<GoodsVO>> goodsMap=goodsService.listGoods();
		mav.addObject("goodsMap", goodsMap); 
		
		//--사이드에 보여줄 유튜브 파씽---------------------------------------------------------		
		
		WebDriver driver;
		List<SeleniumVO> seleniumList = new ArrayList<SeleniumVO>();
		
		//드라이버 설치 경로
		String WEB_DRIVER_ID = "webdriver.chrome.driver";
		String WEB_DRIVER_PATH = "C:\\selenium\\chromedriver.exe";
		 
		System.setProperty(WEB_DRIVER_ID, WEB_DRIVER_PATH);
			 
		ChromeOptions options = new ChromeOptions();
		options.addArguments("--start-maximized");
		options.addArguments("--disable-popup-blocking");
		options.addArguments("--remote-allow-origins=*");
		options.addArguments("headless"); //백그라운드(창안보이게) 실행
		driver = new ChromeDriver(options);
		 
		// YouTube 검색 결과 페이지 URL
	     String url_ = "https://tv.naver.com/v/13856192";

		 try {
			 
			driver.get(url_);
			driver.manage().timeouts().implicitlyWait(500,TimeUnit.MILLISECONDS);
			
			List<WebElement> webElements = driver.findElements(By.cssSelector("div.webplayer-internal-source-wrapper video"));
            
            for (WebElement webElement : webElements) {
            	
                String src = webElement.getAttribute("src");
                
                if (src != null) { //중간에 null값이 있어서 조건문 달음
	                
	                SeleniumVO seleniumVO = new SeleniumVO();
	                seleniumVO.setYouUrl(src);
	                
	                seleniumList.add(seleniumVO);
                }
            }

		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			driver.quit();
		}
		 
		 session.setAttribute("seleniumList", seleniumList);
				 
				//--메인 화면에 보여줄 책정보 파씽-------------------------------------------------------------------	
				 
					List<BookCrawVO> bookList = new ArrayList<BookCrawVO>();
					
					 try {
				            // URL에서 HTML 문서 가져오기
				            String url = "https://search.shopping.naver.com/book/search?bookTabType=NEW_BOOK&catId=50005542&pageIndex=1&pageSize=40&query=%EC%B1%85&sort=REL";
				            Document doc = Jsoup.connect(url).get();
				            
				               
				                Elements imgElements = doc.select("div.bookListItem_thumbnail__54Smr"); //이미지
				                Elements titleElements = doc.select("div.bookListItem_title__K9pVs"); //책제목
				                Elements authorElements = doc.select("span.bookListItem_define_data__IUMgt"); //책저자
				                Elements publisherElements = doc.select("div.bookListItem_detail_publish__67dDL"); //출판사
				                Elements priceElements = doc.select("span.bookPrice_price__OagxI"); //가격
				                Elements dateElements = doc.select("div.bookListItem_detail_date__s7KQe"); //출판일
					            Elements linksElements = doc.select("a.bookListItem_info_top__r54Eg.linkAnchor");

				                for (int i = 0; i < imgElements.size(); i++) {
				                    BookCrawVO bookCrawVO = new BookCrawVO(); ; // 각 반복마다 새로운 객체 생성

				                    // 이미지
				                    Element img = imgElements.get(i);
				                    String bookImg = img.select("img").attr("src");
				                    bookCrawVO.setBook_img(bookImg);

				                    // 제목
				                    Element title = titleElements.get(i);
				                    String bookTitle = title.text();
				                    bookCrawVO.setBook_title(bookTitle);

				                    // 저자
				                    Element author = authorElements.get(i);
				                    String bookAuthor = author.text();
				                    bookCrawVO.setBook_author(bookAuthor);

				                    // 출판사
				                    Element publisher = publisherElements.get(i);
				                    String bookPublisher = publisher.text();
				                    bookCrawVO.setBook_publisher(bookPublisher);

				                    // 가격
				                    Element price = priceElements.get(i);
				                    String bookPrice = price.text();
				                    bookCrawVO.setBook_price(bookPrice);

				                    // 출판일
				                    Element date = dateElements.get(i);
				                    String bookDate = date.text();
				                    bookCrawVO.setBook_date(bookDate);
				                    
				                    //책 판매링크
				                    Element link = linksElements.get(i);
				                    String bookLink = link.attr("href");
				                    bookCrawVO.setBook_link(bookLink);
				                    
				                    bookList.add(bookCrawVO); // 리스트에 객체 추가
				                }
				        } catch (IOException e) {
				            e.printStackTrace();
				        }
					 
					 	mav.addObject("bookList", bookList);
			
		return mav;
	}
}

