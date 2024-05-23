package com.bookshop01.goods.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bookshop01.goods.dao.GoodsDAO;
import com.bookshop01.goods.vo.GoodsVO;
import com.bookshop01.goods.vo.ImageFileVO;

@Service("goodsService")
@Transactional(propagation=Propagation.REQUIRED)
public class GoodsServiceImpl implements GoodsService{
	
	@Autowired
	private GoodsDAO goodsDAO;
	
	//상품 리스트를 조회
	@Override
	public Map<String,List<GoodsVO>> listGoods() throws Exception {
		
		Map<String,List<GoodsVO>> goodsMap=new HashMap<String,List<GoodsVO>>();
		
		List<GoodsVO> goodsList=goodsDAO.selectGoodsList("bestseller");
		goodsMap.put("bestseller",goodsList);
		
		goodsList=goodsDAO.selectGoodsList("newbook");
		goodsMap.put("newbook",goodsList);
		
		goodsList=goodsDAO.selectGoodsList("steadyseller");
		goodsMap.put("steadyseller",goodsList);
		
		return goodsMap;
	}
	
	//상품아이디를 매개변수로 전달 받아 도서상품정보 + 도서이미지정보 조회
	@Override
	public Map goodsDetail(String _goods_id) throws Exception {
		
		Map goodsMap=new HashMap();
		
		GoodsVO goodsVO = goodsDAO.selectGoodsDetail(_goods_id); //도서 상품 조회
		goodsMap.put("goodsVO", goodsVO);
		
		List<ImageFileVO> imageList =goodsDAO.selectGoodsDetailImage(_goods_id); //도서상품의 이미지 정보 조회 
		goodsMap.put("imageList", imageList);
		
		return goodsMap;
	}
	
	//Ajax 이용해 입력한 검색어 관련  데이터 자동으로 표시하기
	@Override
	public List<String> keywordSearch(String keyword) throws Exception {
		List<String> list=goodsDAO.selectKeywordSearch(keyword);
		return list;
	}
	
	//검색어로 상품을 검색
	@Override
	public List<GoodsVO> searchGoods(String searchWord) throws Exception{
		List goodsList=goodsDAO.selectGoodsBySearchWord(searchWord);
		return goodsList;
	}
	
	// goods_sort 값에 따른 도서 목록 조회
	@Override
	public Map<String, List<GoodsVO>> sortList(String goodsSort) throws Exception {

		Map<String,List<GoodsVO>> goodsMap=new HashMap<String,List<GoodsVO>>();
		
		List<GoodsVO> goodsList = goodsDAO.selectSortList(goodsSort);
		goodsMap.put("goodsList", goodsList);
		
		return goodsMap;
	}
	
}







