package com.booksajo.dasibom.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.booksajo.dasibom.service.EventService;
import com.booksajo.dasibom.vo.EventVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class EventController {
	
	@Resource(name = "eventService")
	private EventService eventService;
	
		// 이벤트 목록 페이지
	    @RequestMapping("/event_list.do")
	    public String eventList(Model model) {
	        
	        ArrayList<EventVO> eventList = eventService.getAllEvent();
	        model.addAttribute("eventList", eventList);
	
	        return "event_list";   // → goods_list.jsp 로 이동
	    }
		
	 // 이벤트 상세 페이지
	    @RequestMapping("/event_detail.do")
	    public String eventDetail(EventVO eventVO, Model model) {
	    	EventVO oneevent = eventService.getOneevent(eventVO);
	        if (oneevent == null) {
	            return "redirect:/MainPage.do";
	        }
	        model.addAttribute("event", oneevent);
	        return "event_detail";   // → goods_detail.jsp 로 이동
	    }
	}
