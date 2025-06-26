package com.booksajo.dasibom.service;

import java.util.ArrayList;
import java.util.List;

import com.booksajo.dasibom.vo.CartVO;

public interface CartService {

	ArrayList<CartVO> getAllCart() throws Exception;

	CartVO getCart(CartVO cartVO) throws Exception;

	void insertCart(CartVO cartVO) throws Exception;

	void updateCart(CartVO cartVO) throws Exception;

	ArrayList<CartVO> getCartByUserId(String userId) throws Exception;

	void deleteCart(String userId, List<String> isbnList);

	int modifyCount(CartVO cartVO);

	void removeCartItemsAfterOrder(String userId);

	CartVO getCartBookByUserIdAndIsbn(String userId, String string);

}
