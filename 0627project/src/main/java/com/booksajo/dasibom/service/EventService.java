package com.booksajo.dasibom.service;


import java.util.ArrayList;
import com.booksajo.dasibom.vo.EventVO;

public interface EventService {
 
	EventVO getOneevent(EventVO eventVO);

	ArrayList<EventVO> getAllEvent();

}