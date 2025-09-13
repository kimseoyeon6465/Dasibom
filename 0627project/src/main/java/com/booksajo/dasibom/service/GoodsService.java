package com.booksajo.dasibom.service;


import java.util.ArrayList;
import java.util.List;

import com.booksajo.dasibom.vo.GoodsVO;
import com.booksajo.dasibom.vo.GoodsWishlistVO;
import com.booksajo.dasibom.vo.PhotosVO;


public interface GoodsService {
 
	GoodsVO getOnegoods(GoodsVO goodsVO);
	ArrayList<GoodsVO> getAllGoods();
	public List<PhotosVO> getGoodsPhotoList(int goodsId);
	void insertGoodsCart(GoodsWishlistVO wish);
	int checkExist(String user_Id, int goods_Id, String type);
	void insertGoodsWishlist(GoodsWishlistVO wish);


}