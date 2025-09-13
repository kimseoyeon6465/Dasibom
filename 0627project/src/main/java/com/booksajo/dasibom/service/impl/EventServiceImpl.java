package com.booksajo.dasibom.service.impl;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.w3c.dom.*;
import org.xml.sax.InputSource;

import com.booksajo.dasibom.service.EventService;
import com.booksajo.dasibom.service.dao.EventDAO;
import com.booksajo.dasibom.vo.EventVO;


@Service("eventService")
public class EventServiceImpl implements EventService {

	@Autowired
	private EventDAO eventDAO;
	
	@Override
	@Transactional
	public ArrayList<EventVO> getAllEvent() {
		// TODO Auto-generated method stub
		return eventDAO.getAllEvent();
	}	
	
	
	@Override
	@Transactional
	public EventVO getOneevent(EventVO eventVO) {
	     return eventDAO.getOneevent(eventVO); 
	    }
	
	

	
}