package com.booksajo.dasibom.service.dao;

import java.util.ArrayList;

import com.booksajo.dasibom.vo.BookVO;
import com.booksajo.dasibom.vo.EventVO;
import com.booksajo.dasibom.vo.GoodsVO;
import com.booksajo.dasibom.vo.ReviewVO;

public interface EventDAO {
	
	EventVO getOneevent(EventVO eventVO);

	ArrayList<EventVO> getAllEvent();
	
	
}
