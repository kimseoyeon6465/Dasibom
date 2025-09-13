package com.booksajo.dasibom.service.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.booksajo.dasibom.service.AttendanceService;
import com.booksajo.dasibom.service.CouponService;
import com.booksajo.dasibom.service.PointService;
import com.booksajo.dasibom.service.dao.AttendanceDAO;
import com.booksajo.dasibom.vo.DayVO;


@Service("attendanceService")
public class AttendanceServiceImpl implements AttendanceService {

    @Resource(name = "attendanceDAO")
    private AttendanceDAO attendanceDAO;
    
    @Resource(name = "couponService")
    private CouponService couponService;
    
    @Resource(name = "pointService")
    private PointService pointService;

    @Override
    public boolean isAlreadyChecked(String user_Id, Date today) {
        return attendanceDAO.countByDate(user_Id, today) > 0;
    }

    @Override
    public int countAttendanceThisMonth(String user_Id) {
        return attendanceDAO.countAttendanceThisMonth(user_Id);
    }

    @Override
    public void resetAttendance(String user_Id) {
        attendanceDAO.resetAttendance(user_Id);
    }

    @Override
    public List<List<DayVO>> getCalendarForMonth(String user_Id, int year, int month) {
        List<Date> attendanceDates = attendanceDAO.getAttendanceDates(user_Id, year, month);

        Set<Integer> checkedDays = new java.util.HashSet<Integer>();

        for (Date date : attendanceDates) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            int dayOfMonth = cal.get(Calendar.DAY_OF_MONTH);
            checkedDays.add(dayOfMonth);
        }

        List<List<DayVO>> calendar = new ArrayList<List<DayVO>>();

        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.YEAR, year);
        cal.set(Calendar.MONTH, month - 1); // 0-based
        cal.set(Calendar.DAY_OF_MONTH, 1);

        int startDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
        int maxDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

        // ¿À´Ã ³¯Â¥ °è»ê
        Calendar todayCal = Calendar.getInstance();
        int todayYear = todayCal.get(Calendar.YEAR);
        int todayMonth = todayCal.get(Calendar.MONTH) + 1;
        int todayDate = todayCal.get(Calendar.DAY_OF_MONTH);
        
        List<DayVO> week = new ArrayList<DayVO>();

        // ¾Õ ºóÄ­
        for (int i = 1; i < startDayOfWeek; i++) {
            week.add(new DayVO(0, false));
        }

        // ³¯Â¥
        for (int day = 1; day <= maxDay; day++) {
            boolean checked = checkedDays.contains(day);

            boolean isToday = (year == todayYear) && (month == todayMonth) && (day == todayDate);

            week.add(new DayVO(day, checked, isToday));

            if (week.size() == 7) {
                calendar.add(week);
                week = new ArrayList<DayVO>();
            }
        }

        // ¸¶Áö¸· ÁÖ ºóÄ­ Ã¤¿ì±â
        if (!week.isEmpty()) {
            while (week.size() < 7) {
                week.add(new DayVO(0, false));
            }
            calendar.add(week);
        }

        return calendar;
    }
    
    @Override
    public void insertAttendance(String user_Id, Date today) {
        attendanceDAO.insertAttendance(user_Id, today);

        
    }



}

