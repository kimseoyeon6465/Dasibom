package com.booksajo.dasibom.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.booksajo.dasibom.vo.CartVO;
import com.booksajo.dasibom.vo.WishlistVO;

public interface WishlistService {

	ArrayList<WishlistVO> getAllWishlist() throws Exception;

	ArrayList<WishlistVO> getWishlistByUserId(String userId) throws Exception;

	WishlistVO getWishlist(WishlistVO wishVO) throws Exception;

	void insertWishlist(WishlistVO wishVO) throws Exception;

	void updateWishlist(WishlistVO wishVO) throws Exception;

	void deleteWishlist(String userId, List<String> isbnList);

	void moveToCart(WishlistVO wishVO);

	void moveToWishlist(WishlistVO wishVO);

	List<WishlistVO> getWishlistByPage(Map<String, Object> param);

	int getWishlistCount(String userId);

	int checkExist(String user_Id, String isbn, String type);
	
	WishlistVO getWishlistBookByUserIdAndIsbn(String userId, String isbn, String listType);

	void deleteGoodsFromWishlist(String userId, List<Integer> goodsIdList);
	
	void insertGoodsToWishlistAsCart(CartVO vo);
	
	void incrementGoodsCountInCart(String userId, int goodsId);
	
	boolean checkGoodsExistsInCart(String userId, int goodsId);
	
	List<CartVO> getGoodsWishlistByUserId(String userId);
}
