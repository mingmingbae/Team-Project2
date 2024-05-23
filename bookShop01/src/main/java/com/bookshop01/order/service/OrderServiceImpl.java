package com.bookshop01.order.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;
import com.bookshop01.order.dao.OrderDAO;
import com.bookshop01.order.vo.OrderVO;


@Service("orderService")
@Transactional(propagation=Propagation.REQUIRED)
public class OrderServiceImpl implements OrderService {
	@Autowired
	private OrderDAO orderDAO;
	
	public List<OrderVO> listMyOrderGoods(OrderVO orderVO) throws Exception{
		List<OrderVO> orderGoodsList;
		orderGoodsList=orderDAO.listMyOrderGoods(orderVO);
		return orderGoodsList;
	}
	
	//DB의 주문 정보 추가 및 장바구니테이블에 담긴 도서상품을 주문한 경우 해당 상품을 구매후 장바구니 테이블에서 삭제 
	public void addNewOrder(List<OrderVO> myOrderList) throws Exception{
		
		//주문상품목록을 주문테이블에 추가
		orderDAO.insertNewOrder(myOrderList);
		//장바구니테이블에 상품을 추가하고 주문 했을 경우  주문한 상품을 삭제 
		orderDAO.removeGoodsFromCart(myOrderList);
	}	
	
	//주문 정보 조회
	public OrderVO findMyOrder(String order_id) throws Exception{
		return orderDAO.findMyOrder(order_id);
	}
	
	
	public Boolean checkBuy(Map<String, String> buyMem) throws Exception {
		return orderDAO.checkBuy(buyMem);
	}

}
