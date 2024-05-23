package com.bookshop01.order.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.common.base.BaseController;
import com.bookshop01.goods.vo.GoodsVO;
import com.bookshop01.member.vo.MemberVO;
import com.bookshop01.order.service.OrderService;
import com.bookshop01.order.vo.OrderVO;
import com.google.gson.Gson;
import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;


@Controller("orderController")   
@RequestMapping(value="/order") 
public class OrderControllerImpl extends BaseController implements OrderController {
	@Autowired
	private OrderService orderService;
	@Autowired
	private OrderVO orderVO;
	
	private IamportClient api;
	
	//구매하기
	@RequestMapping(value="/orderEachGoods.do" ,method = RequestMethod.POST)
	public ModelAndView orderEachGoods(@ModelAttribute("orderVO") OrderVO _orderVO,
			                           HttpServletRequest request, 
			                           HttpServletResponse response)  throws Exception{
		
		request.setCharacterEncoding("utf-8");
		HttpSession session=request.getSession();
		session=request.getSession();
		
		Boolean isLogOn=(Boolean)session.getAttribute("isLogOn"); //로그인 상태 확인
		
		String action=(String)session.getAttribute("action");
	
		//로그인을 하지 않았다면 먼저 로그인 후 주문을 처리하도록 주문 정보와 주문 페이지 요청 URL을 session에 저장 
		if(isLogOn==null || isLogOn==false){
			session.setAttribute("orderInfo", _orderVO);
			session.setAttribute("action", "/order/orderEachGoods.do");
			return new ModelAndView("redirect:/member/loginForm.do");
		}else{
			 //로그인을 하지 않고 구매하기를 눌렀을때 session에 저장 했던 주문 페이지  요청 주소가 존재하면?
			 if(action!=null && action.equals("/order/orderEachGoods.do")){
				orderVO=(OrderVO)session.getAttribute("orderInfo"); //session에서 주문정보(OderVO객체) 가져오기
				session.removeAttribute("action");//session에 저장되어 있던  주문페이지 요청 주소 제거

			 }else {//session에 저장 했던   주문 페이지  요청 주소가 존재 하지 않으면?
				 orderVO=_orderVO;
			 }
		 }
		
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		
		// OrderVO객체(주문 정보)를 저장
		List myOrderList=new ArrayList<OrderVO>();
		myOrderList.add(orderVO);

		//회원정보 조회
		MemberVO memberInfo=(MemberVO)session.getAttribute("memberInfo");
		
		//주문 상품 정보와  주문자 정보를 session영역에 저장(바인딩) 
		session.setAttribute("myOrderList", myOrderList); //OrderVO객체(주문 정보)가 저장된  ArrayList배열 정보 
		session.setAttribute("orderer", memberInfo); //로그인한 주문자 정보
		return mav;
	}
	
    //최종결제 요청
	@RequestMapping(value="/orderAllCartGoods.do" ,method = RequestMethod.POST)
	public ModelAndView orderAllCartGoods(@RequestParam("cart_goods_qty")  String[] cart_goods_qty,//체크박스에 선택하 상품 수량
										  HttpServletRequest request, HttpServletResponse response)  throws Exception{

		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		
		//장바구니 상품 목록
		HttpSession session=request.getSession();
		Map cartMap=(Map)session.getAttribute("cartMap");
		List<GoodsVO> myGoodsList=(List<GoodsVO>)cartMap.get("myGoodsList");
		
		List myOrderList=new ArrayList<OrderVO>();
				
		//구매자 정보
		MemberVO memberVO=(MemberVO)session.getAttribute("memberInfo");
		
		//장바구니에 저장된 구매할 상품 개수만큼 반복 
		for(int i=0; i<cart_goods_qty.length;i++){
			
			//문자열로 결합되어 전송된 상품 번호와 주문 수량을  split()메소드를 이용해 분리 
			String[] cart_goods=cart_goods_qty[i].split(":");
			
			for(int j = 0; j< myGoodsList.size();j++) {
				GoodsVO goodsVO = myGoodsList.get(j);
				//구매할 상품 번호
				int goods_id = goodsVO.getGoods_id();
				
				//전송된 상품 번호와  GoodsVO객체에서 꺼내온 상품번호와 같으면 
				//주문하는 상품이므로  OrderVO객체를 생성한 후 상품 정보를 OrderVO객체에 설정
				//그리고 다시 myOrderList참조변수를 가진 ArrayList배열에 OrderVO객체를 저장
				if(goods_id==Integer.parseInt(cart_goods[0])) {
					OrderVO _orderVO=new OrderVO();
					String goods_title=goodsVO.getGoods_title();
					int goods_sales_price=goodsVO.getGoods_sales_price();
					String goods_fileName=goodsVO.getGoods_fileName();
					_orderVO.setGoods_id(goods_id);
					_orderVO.setGoods_title(goods_title);
					_orderVO.setGoods_sales_price(goods_sales_price);
					_orderVO.setGoods_fileName(goods_fileName);
					_orderVO.setOrder_goods_qty(Integer.parseInt(cart_goods[1]));
					myOrderList.add(_orderVO);
					break;
				}
			}
		} 
		session.setAttribute("myOrderList", myOrderList);
		session.setAttribute("orderer", memberVO);
		return mav;
	}	
	
	//팝업창에서 최종결제하기 버튼을 눌렀을때 
	@ResponseBody
	@RequestMapping(value="/payToOrderGoods.do" ,method = RequestMethod.POST,produces = "application/text; charset=utf8")
    public String payToOrderGoods(@RequestParam Map<String, String> receiverMap,
                                  HttpServletRequest request, HttpServletResponse response) {
        String res = "성공";

        try {
            HttpSession session = request.getSession();
            MemberVO memberVO = (MemberVO) session.getAttribute("orderer");
            String member_id = memberVO.getMember_id();
            String orderer_name = memberVO.getMember_name();
            String orderer_hp = memberVO.getHp1() + "-" + memberVO.getHp2() + "-" + memberVO.getHp3();

            List<OrderVO> myOrderList = (List<OrderVO>) session.getAttribute("myOrderList");

            for (int i = 0; i < myOrderList.size(); i++) {
                OrderVO orderVO = myOrderList.get(i);
                
                orderVO.setMember_id(member_id);
                orderVO.setOrderer_name(orderer_name);
                orderVO.setReceiver_name(receiverMap.get("receiver_name"));
                orderVO.setReceiver_hp1(receiverMap.get("receiver_hp1"));
                orderVO.setReceiver_hp2(receiverMap.get("receiver_hp2"));
                orderVO.setReceiver_hp3(receiverMap.get("receiver_hp3"));
                orderVO.setReceiver_tel1(receiverMap.get("receiver_tel1"));
                orderVO.setReceiver_tel2(receiverMap.get("receiver_tel2"));
                orderVO.setReceiver_tel3(receiverMap.get("receiver_tel3"));
                orderVO.setDelivery_address(receiverMap.get("delivery_address"));
                orderVO.setDelivery_message(receiverMap.get("delivery_message"));
                orderVO.setDelivery_method(receiverMap.get("delivery_method"));
                orderVO.setGift_wrapping(receiverMap.get("gift_wrapping"));
                orderVO.setPay_method(receiverMap.get("pay_method"));
                orderVO.setCard_com_name(null);
                orderVO.setCard_pay_month(null);
                orderVO.setPay_orderer_hp_num(null);
                orderVO.setOrderer_hp(orderer_hp);
                
                myOrderList.set(i, orderVO);
            }
            orderService.addNewOrder(myOrderList);
            session.setAttribute("myOrderInfo", receiverMap);
            session.setAttribute("myOrderList", myOrderList);
        } catch (Exception e) {
            e.printStackTrace();
            res = "실패";
        }
        return res;
    }
	
	//아임포트(카카오페이) 결제
	@ResponseBody
	@RequestMapping(value="/verify_iamport.do/{imp_uid}",method = RequestMethod.POST)
	public IamportResponse<Payment> paymentByImpUid(Model model, Locale locale, HttpSession session, 
													@PathVariable(value= "imp_uid") String imp_uid) throws IamportResponseException, IOException{	
		api=new IamportClient("아임포트 API key","아임포트 API 시크릿 키");
			return api.paymentByImpUid(imp_uid);
		}

}
	







