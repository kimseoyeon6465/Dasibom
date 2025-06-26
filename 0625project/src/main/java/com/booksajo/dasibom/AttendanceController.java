package com.booksajo.dasibom;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.booksajo.dasibom.service.AttendanceService;
import com.booksajo.dasibom.service.CouponService;
import com.booksajo.dasibom.service.PointService;
import com.booksajo.dasibom.service.UserService;
import com.booksajo.dasibom.vo.DayVO;
import com.booksajo.dasibom.vo.UserVO;



/**
 * Handles requests for the application home page.
 */
@Controller
public class AttendanceController {
	
	
	@Autowired
	private UserService userService;
	
	@Resource(name = "attendanceService")
	private AttendanceService attendanceService;

	@Resource(name = "couponService")
	private CouponService couponService;

	@Resource(name = "pointService")
	private PointService pointService;
	
	
	 // �럹�씠吏� �씠�룞, 罹섎┛�뜑 蹂댁뿬二쇨린 (GET)
	@RequestMapping(value = "/attendance.do", method = RequestMethod.GET)
	    public String attendancePage(Model model, HttpSession session,
	                                 @RequestParam(value = "year", required = false) Integer year,
	                                 @RequestParam(value = "month", required = false) Integer month) {

	        UserVO user = (UserVO) session.getAttribute("user");
	        String user_Id = (user != null) ? user.getUser_Id() : null;

	        Calendar cal = Calendar.getInstance();
	        int thisYear = cal.get(Calendar.YEAR);
	        int thisMonth = cal.get(Calendar.MONTH) + 1;

	        if (year == null) year = thisYear;
	        if (month == null) month = thisMonth;

	        List<List<DayVO>> calendar = attendanceService.getCalendarForMonth(user_Id, year, month);
	        
	        model.addAttribute("calendar", calendar);
	        model.addAttribute("attendanceCount", attendanceService.countAttendanceThisMonth(user_Id));
	        model.addAttribute("year", year);
	        model.addAttribute("month", month);
	        
	        

	        return "attendance";
	    }

	
	
    // 異쒖꽍 泥섎━�슜(POST)
	@RequestMapping(value = "/attendance/check.do", method = RequestMethod.POST)
    @ResponseBody
	    public Map<String, Object> checkAttendance(HttpSession session) {
	        Map<String, Object> result = new HashMap<String, Object>();

	        System.out.println(11111);
	        System.out.println(55555);
	        System.out.println(11111);
	        
	        Integer user_seq = (Integer) session.getAttribute("user_seq");
	        UserVO user = userService.getUserBySeq(user_seq);

	        String user_Id = user.getUser_Id();
	        Date today = new Date();
	        // 1. �삤�뒛 異쒖꽍�뻽�뒗吏� �솗�씤
	        boolean alreadyChecked = attendanceService.isAlreadyChecked(user_Id, today);
	        if (alreadyChecked) {
	            result.put("status", "already_checked");
	            return result;
	        }
	        // 2. 異쒖꽍 湲곕줉 ���옣
	        attendanceService.insertAttendance(user_Id, today);
	        // 3. 珥� 異쒖꽍�씪 �닔 怨꾩궛
	        int totalDays = attendanceService.countAttendanceThisMonth(user_Id);
	        
	        String rewardMessage = "";  // 狩먲툘 蹂댁긽 硫붿떆吏� 蹂��닔 異붽�

			/*
			 * if (totalDays == 10) { couponService.issueCoupon(user_Id, 10); rewardMessage
			 * = "출석 10일 달성 🎉\n10% 할인 쿠폰 지급 완료!"; } else if (totalDays == 20) { int
			 * randomPoint = new Random().nextInt(4901) + 100;
			 * pointService.addPoint(user_Id, randomPoint, "출석 20일 보상"); rewardMessage =
			 * "출석 20일 달성 🎉\n" + randomPoint + " 포인트 지급 완료!"; } else if (totalDays == 30) {
			 * pointService.addPoint(user_Id, 5000, "출석 30일 보상"); rewardMessage =
			 * "출석 30일 달성 🎉\n5000 포인트 지급 완료!"; // 5. 異쒖꽍 湲곕줉 由ъ뀑 (�씠踰� �떖 湲곕줉 �궘�젣)
			 * attendanceService.resetAttendance(user_Id); } else { rewardMessage =
			 * "출석 완료! 🎉"; }
			 */
	        
	        couponService.issueCoupon(user_Id, 10);
	        
	        result.put("status", "success");
	        result.put("totalDays", totalDays);
	        result.put("rewardMessage", rewardMessage);  // 狩먲툘 異붽�!
	        
	        return result;
	    }
	}


