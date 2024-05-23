package com.bookshop01.admin.goods.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bookshop01.admin.goods.dao.AdminGoodsDAO;
import com.bookshop01.goods.vo.GoodsVO;
import com.bookshop01.goods.vo.ImageFileVO;
import com.bookshop01.order.vo.OrderVO;


@Service("adminGoodsService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminGoodsServiceImpl implements AdminGoodsService {
	
	@Autowired
	private AdminGoodsDAO adminGoodsDAO;
	
	
	//새 도서 상품정보를 테이블에 INSERT
	@Override
	public int addNewGoods(Map newGoodsMap) throws Exception{
		
		int goods_id = adminGoodsDAO.insertNewGoods(newGoodsMap);
		ArrayList<ImageFileVO> imageFileList = (ArrayList)newGoodsMap.get("imageFileList");
		
		//각 이미지 정보에 상품 번호를 설정
		for(ImageFileVO imageFileVO : imageFileList) {
			imageFileVO.setGoods_id(goods_id);
		}
		
		//이미지 정보를 이미지 테이블에 INSERT 
		adminGoodsDAO.insertGoodsImageFile(imageFileList);
		return goods_id; //DB에 추가한 도서 상품번호 
	}
	
	//새 도서상품 리스트 조회
	@Override
	public List<GoodsVO> listNewGoods(Map condMap) throws Exception{
		return adminGoodsDAO.selectNewGoodsList(condMap);
	}
	
	//상품 수정을 위해  도서 상품 정보와 도서 이미지 정보를 조회 하여 먼저 보여주기 위함 
	@Override
	public Map goodsDetail(int goods_id) throws Exception {
		Map goodsMap = new HashMap();
		GoodsVO goodsVO=adminGoodsDAO.selectGoodsDetail(goods_id);
		List imageFileList =adminGoodsDAO.selectGoodsImageFileList(goods_id);
		goodsMap.put("goods", goodsVO);
		goodsMap.put("imageFileList", imageFileList);
		return goodsMap;
	}
	
	@Override
	public List goodsImageFile(int goods_id) throws Exception{
		List imageList =adminGoodsDAO.selectGoodsImageFileList(goods_id);
		return imageList;
	}
	
	//상품정보 수정 반영
	@Override
	public void modifyGoodsInfo(Map goodsMap) throws Exception{
		adminGoodsDAO.updateGoodsInfo(goodsMap);
	}	
	
	//상품 이미지 수정 반영
	@Override
	public void modifyGoodsImage(List<ImageFileVO> imageFileList) throws Exception{
		adminGoodsDAO.updateGoodsImage(imageFileList); 
	}
	
	//상품정보 리스트 조회
	@Override
	public List<OrderVO> listOrderGoods(Map condMap) throws Exception{
		return adminGoodsDAO.selectOrderGoodsList(condMap);
	}
	
	//주문정보 수정 반영
	@Override
	public void modifyOrderGoods(Map orderMap) throws Exception{
		adminGoodsDAO.updateOrderGoods(orderMap);
	}
	
	//상품 이미지 삭제요청
	@Override
	public void removeGoodsImage(int image_id) throws Exception{
		adminGoodsDAO.deleteGoodsImage(image_id);
	}
	
	//이미지 정보를 이미지 테이블에 INSERT
	@Override
	public void addNewGoodsImage(List imageFileList) throws Exception{
		adminGoodsDAO.insertGoodsImageFile(imageFileList);
	}
	

	
}
