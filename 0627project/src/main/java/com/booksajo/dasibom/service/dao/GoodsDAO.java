package com.booksajo.dasibom.service.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.booksajo.dasibom.vo.BookVO;
import com.booksajo.dasibom.vo.GoodsVO;
import com.booksajo.dasibom.vo.GoodsWishlistVO;
import com.booksajo.dasibom.vo.PhotosVO;
import com.booksajo.dasibom.vo.ReviewVO;

public interface GoodsDAO {
	
	GoodsVO getOnegoods(GoodsVO goodsVO);

	ArrayList<GoodsVO> getAllGoods();
	
	List<PhotosVO> getGoodsPhotoList(int goodsId);

	void insertGoodsCart(GoodsWishlistVO wish);

	int checkExist(@Param("user_Id") String userId, @Param("goods_Id") int goods_Id, @Param("type") String type);

	void insertGoodsWishlist(GoodsWishlistVO wish);

}
