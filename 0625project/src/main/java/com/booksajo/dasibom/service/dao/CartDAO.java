package com.booksajo.dasibom.service.dao;

import java.util.ArrayList;
import java.util.Map;

import com.booksajo.dasibom.vo.CartVO;

public interface CartDAO {

	ArrayList<CartVO> getAllCart();

	// ✅ 로그인한 사용자의 장바구니 조회
	ArrayList<CartVO> getCartByUserId(String userId);

	void updateCart(CartVO cartVO);

	void deleteCart(CartVO cartVO);

	CartVO getCart(CartVO cartVO);

	void deleteCart(Map<String, Object> paramMap);

	void insertCart(CartVO cartVO);

	int existsInCart(CartVO cartVO);

	int modifyCount(CartVO cartVO);

	void removeCartItemsAfterOrder(String userId);

	CartVO getCartBookByUserIdAndIsbn(Map<String, Object> paramMap);

}
