package com.bookshop01.cart.controller;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.bookshop01.cart.service.CartService;
import com.bookshop01.cart.vo.CartVO;
import com.bookshop01.common.base.BaseController;
import com.bookshop01.goods.vo.GoodsVO;
import com.bookshop01.member.vo.MemberVO;

@Controller("cartController")     
@RequestMapping(value="/cart")  
public class CartControllerImpl extends BaseController implements CartController{
	@Autowired
	private CartService cartService;
	@Autowired
	private CartVO cartVO;
	@Autowired
	private MemberVO memberVO;
	
	//장바구니 테이블에 저장된 상품 목록 조회요청
	@RequestMapping(value="/myCartList.do" ,method = RequestMethod.GET)
	public ModelAndView myCartMain(HttpServletRequest request, HttpServletResponse response)  throws Exception {
		
		String viewName=(String)request.getAttribute("viewName");	
		ModelAndView mav = new ModelAndView(viewName);
		
		HttpSession session=request.getSession();		
		MemberVO memberVO=(MemberVO)session.getAttribute("memberInfo");	
		String member_id=memberVO.getMember_id();
	
		cartVO.setMember_id(member_id);	//장바구니테이블에 저장되어 있는 상품정보를 조회 리스트
		Map<String ,List> cartMap=cartService.myCartList(cartVO); //상품번호에 대한 상품을 도서상품 테이블과 도서이미지정보테이블을 조인한 리스트
		
		session.setAttribute("cartMap", cartMap); //상품 주문 대비 상품 정보를 미리 세션영역에 저장
		return mav;
	}
	
	//장바구니에 상품을 추가
	@RequestMapping(value="/addGoodsInCart.do" ,method = RequestMethod.POST,produces = "application/text; charset=utf8")
	public  @ResponseBody String addGoodsInCart(@RequestParam("goods_id") int goods_id,
												@RequestParam("cart_goods_qty") int cart_goods_qty,
				                                HttpServletRequest request, 
				                                HttpServletResponse response)  throws Exception{
			
			HttpSession session=request.getSession();
			memberVO=(MemberVO)session.getAttribute("memberInfo");
			String member_id=memberVO.getMember_id();
		
			cartVO.setGoods_id(goods_id);
			cartVO.setMember_id(member_id);
			cartVO.setCart_goods_qty(cart_goods_qty);
			
			//도서 상품 번호가 장바구니 테이블에 있는지 조회
			boolean isAreadyExisted=cartService.findCartGoods(cartVO);
			
			//이미 장바구니에 테이블에 있으면 이미 추가되었다는 메세지를 브라우저로 전송
			if(isAreadyExisted==true){
				return "already_existed";
			}else{
				//장바구니 테이블에 추가 및 추가 성공 메세지를 브라우저로 전송
				cartService.addGoodsInCart(cartVO);
				return "add_success";
			}
	}
	
	//장바구니 상품 수량 변경 요청
	@RequestMapping(value="/modifyCartQty.do" ,method = RequestMethod.POST)
	public @ResponseBody String  modifyCartQty(@RequestParam("goods_id") int goods_id,
			                                   @RequestParam("cart_goods_qty") int cart_goods_qty,
			                                   HttpServletRequest request, HttpServletResponse response)  throws Exception{
		HttpSession session=request.getSession();
		memberVO=(MemberVO)session.getAttribute("memberInfo");
		String member_id=memberVO.getMember_id();
		cartVO.setGoods_id(goods_id);
		cartVO.setMember_id(member_id);
		cartVO.setCart_goods_qty(cart_goods_qty);
		
		boolean result=cartService.modifyCartQty(cartVO);
		
		if(result==true){
		   return "modify_success";
		}else{
			  return "modify_failed";	
		}
	}
	
	//장바구니 상품 삭제 
	@RequestMapping(value="/removeCartGoods.do" ,method = RequestMethod.POST)
	public ModelAndView removeCartGoods(@RequestParam("cart_id") int cart_id,
			                            HttpServletRequest request, HttpServletResponse response)  throws Exception{
		ModelAndView mav=new ModelAndView();
		cartService.removeCartGoods(cart_id);
		mav.setViewName("redirect:/cart/myCartList.do");
		return mav;
	}
}
