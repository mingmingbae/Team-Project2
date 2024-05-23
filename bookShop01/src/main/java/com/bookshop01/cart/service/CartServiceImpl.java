package com.bookshop01.cart.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bookshop01.cart.dao.CartDAO;
import com.bookshop01.cart.vo.CartVO;
import com.bookshop01.goods.vo.GoodsVO;

@Service("cartService")
@Transactional(propagation=Propagation.REQUIRED)
public class CartServiceImpl  implements CartService{
	@Autowired
	private CartDAO cartDAO;
	

	//장바구니 테이블에 저장된 상품 목록 조회요청
	public Map<String ,List> myCartList(CartVO cartVO) throws Exception{
		
		Map<String,List> cartMap = new HashMap<String,List>();
		
		List<CartVO> myCartList=cartDAO.selectCartList(cartVO);

		//장바구 테이블에서 조회된 상품이 없는 경우
		if(myCartList.size()==0){ 
			return null;
		}
		//장바구니 페이지에 표시할  도서 상품 정보를 조회
		List<GoodsVO> myGoodsList=cartDAO.selectGoodsList(myCartList);
		
		cartMap.put("myCartList", myCartList);
		cartMap.put("myGoodsList",myGoodsList);		
		return cartMap;
	}
	
	//도서 상품 번호가 장바구니 테이블에 있는지 조회
	public boolean findCartGoods(CartVO cartVO) throws Exception{
		 return cartDAO.selectCountInCart(cartVO);
	}	
	
	//장바구니 테이블에 추가 및 추가 성공 메세지를 브라우저로 전송  
	public void addGoodsInCart(CartVO cartVO) throws Exception{
		cartDAO.insertGoodsInCart(cartVO);
	}
	
	//장바구니 상품 수량 변경 요청
	public boolean modifyCartQty(CartVO cartVO) throws Exception{
		int result = cartDAO.updateCartGoodsQty(cartVO);
		if(result == 1) { //수량 수정 성공
			return true;
		}
			return false; 
	}
	
	//장바구니 상품 삭제
	public void removeCartGoods(int cart_id) throws Exception{
		cartDAO.deleteCartGoods(cart_id);
	}
	
}






