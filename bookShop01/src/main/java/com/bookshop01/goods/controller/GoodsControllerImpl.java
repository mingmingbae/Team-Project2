package com.bookshop01.goods.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.common.base.BaseController;
import com.bookshop01.goods.service.GoodsService;
import com.bookshop01.goods.vo.GoodsVO;
import com.bookshop01.member.vo.MemberVO;
import com.bookshop01.order.service.OrderService;
import com.bookshop01.review.service.ReviewService;
import com.bookshop01.review.vo.ReviewVO;

import net.sf.json.JSONObject;


@Controller("goodsController")
@RequestMapping(value="/goods") 
public class GoodsControllerImpl extends BaseController   implements GoodsController {
   @Autowired
   private GoodsService goodsService;
   @Autowired
   private ReviewService reviewService;
   @Autowired
   private OrderService orderService;
   @Autowired
   HttpSession session;
   
   //상품 상세정보 요청
   @RequestMapping(value="/goodsDetail.do" ,method = RequestMethod.GET)
      //main.jsp에서 상품 클릭시 전달한 상품번호(상품아이디) 얻기 
      public ModelAndView goodsDetail(@RequestParam("goods_id") String goods_id, 
                              		  HttpServletRequest request, HttpServletResponse response) throws Exception {
         
         String viewName=(String)request.getAttribute("viewName"); 
         
         //빠른메뉴에 표시 될 최근 본 상품 목록 정보가 session메모리영역에 있는지 없는지 판단하기 위해 session영역 얻기
         MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
         
         String member_id = null;
         
         if(memberInfo == null) {
            member_id = "";
         }else if(memberInfo.getMember_id().contains("admin")){
            member_id = "admin";
         }else {
            member_id = memberInfo.getMember_id();
         }

      //도서 상품 정보를 조회한후  Map으로 반환
      Map goodsMap=goodsService.goodsDetail(goods_id); //상품 아이디 전달!
      
      ModelAndView mav = new ModelAndView(viewName);
      mav.addObject("goodsMap", goodsMap);  //조회된 도서 상품 정보 저장 
      
      GoodsVO goodsVO=(GoodsVO)goodsMap.get("goodsVO");
      addGoodsInQuick(goods_id,goodsVO,session); 
      
      		//상세페이지 리뷰 가져오기
            List<ReviewVO> listReview  = reviewService.reviewListAll(goods_id);
            mav.addObject("listReview", listReview);
            
            //구매 여부 판단
            Map<String,String> buyMem = new HashMap<String,String>();
            buyMem.put("goods_id", goods_id);
            buyMem.put("member_id", member_id);
            Boolean buyMem_ = orderService.checkBuy(buyMem);         
            
            mav.addObject("buyMem_", buyMem_);
            
      return mav;
   }
   

   //퀵메뉴에 최근 본 상품 정보 추가
   private void addGoodsInQuick(String goods_id,GoodsVO goodsVO,HttpSession session){
      
      boolean already_existed=false;
      
      List<GoodsVO> quickGoodsList; 
      
      //최근 본 목록 조회
      quickGoodsList=(ArrayList<GoodsVO>)session.getAttribute("quickGoodsList");
       
      if(quickGoodsList!=null){
         //최근 본 상품목록이 네개 미만인 경우
         if(quickGoodsList.size() < 4){
            for(int i=0; i<quickGoodsList.size();i++){      
               GoodsVO _goodsBean=(GoodsVO)quickGoodsList.get(i);
               //이미 존재하는 상품인지 비교
               if(goods_id.equals(_goodsBean.getGoods_id())){
                  //이미 존재 할 경우 변수의 값을 true로 설정
                  already_existed=true;
                  break;
               }
            }
            if(already_existed==false){
               quickGoodsList.add(goodsVO);	//목록에 저장
            }
         }
      }else{//최근 본 상품 목록이 없으면 상품정보를 저장
         quickGoodsList =new ArrayList<GoodsVO>();
         quickGoodsList.add(goodsVO);
         
      }
      session.setAttribute("quickGoodsList",quickGoodsList); //상품목록
      session.setAttribute("quickGoodsListNum", quickGoodsList.size()); //상품 개수
   }

//Ajax 이용해 입력한 검색어 관련  데이터 자동으로 표시하기   
   @RequestMapping(value="/keywordSearch.do",method = RequestMethod.GET,produces = "application/text; charset=utf8")
   public @ResponseBody String  keywordSearch(@RequestParam("keyword") String keyword,
                                           	  HttpServletRequest request, HttpServletResponse response) throws Exception{
      response.setContentType("text/html;charset=utf-8");
      response.setCharacterEncoding("utf-8");

      if(keyword == null || keyword.equals("")) {
         return null ;
      }
      keyword = keyword.toUpperCase();
      
       List<String> keywordList =goodsService.keywordSearch(keyword);
       
       //JSONObject객체 -> {  } 객체 를 생성 
      JSONObject jsonObject = new JSONObject();
      jsonObject.put("keyword", keywordList);
      
       String jsonInfo = jsonObject.toString();
       
       return jsonInfo ;
   }
    
   
   //검색어 단어가 포함된 도서상품 검색 
   @RequestMapping(value="/searchGoods.do" ,method = RequestMethod.GET)
   public ModelAndView searchGoods(@RequestParam("searchWord") String searchWord,
                                   HttpServletRequest request, HttpServletResponse response) throws Exception{
      
      String viewName=(String)request.getAttribute("viewName");
      
      List<GoodsVO> goodsList=goodsService.searchGoods(searchWord);
      
      ModelAndView mav = new ModelAndView(viewName); 
      mav.addObject("goodsList", goodsList);
      
      return mav;
      
   }
     
   // goodsSort 값에 따른 책 분류 페이지 보여주기
   @Override
   @RequestMapping(value= "/goodsSort.do" ,method={RequestMethod.POST,RequestMethod.GET})
   public String goodsSortView (@RequestParam("goodsSort") String goodsSort,
                         		Model model,
                         		HttpServletRequest request, HttpServletResponse response) throws Exception{
      
      // goodsSort 값에 따라 페이지 각각 이동
      String viewName = null;
      
      // goodsSort 값에 따라 처리
       if (goodsSort.equals("IT/인터넷")) {
           viewName = "/goods/itInternet"; 
           
       } else if (goodsSort.equals("자기계발")) {
           viewName = "/goods/selfDevelopment"; 
           
       } else if (goodsSort.equals("국내소설")) {
           viewName = "/goods/domesticNovel"; 
       }
       
      // IT/인터넷, 자기계발, 국내소설 도서정보를 조회 해 Map에 저장받기 위해  서비스의 메소드 호출!
      Map<String,List<GoodsVO>> goodsMap = goodsService.sortList(goodsSort);
      model.addAttribute("goodsMap", goodsMap); 
      
      return viewName;
   }

}



