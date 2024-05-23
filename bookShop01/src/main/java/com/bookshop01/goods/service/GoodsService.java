package com.bookshop01.goods.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.bookshop01.goods.vo.GoodsVO;

public interface GoodsService {
	
	//상품 리스트를 조회
	public Map<String,List<GoodsVO>> listGoods() throws Exception;
	
	//상품 상세정보를 조회
	public Map goodsDetail(String _goods_id) throws Exception;
	
	//검색어 관련  데이터 자동으로 표시
	public List<String> keywordSearch(String keyword) throws Exception;
	
	//검색어로 상품을 검색
	public List<GoodsVO> searchGoods(String searchWord) throws Exception;
	
	//goods_sort 값에 따라 도서 목록 조회
	public Map<String, List<GoodsVO>> sortList(String goodsSort) throws Exception;
}
