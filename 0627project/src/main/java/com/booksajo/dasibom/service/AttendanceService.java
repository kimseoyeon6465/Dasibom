package com.booksajo.dasibom.service;

import java.util.Date;
import java.util.List;

import com.booksajo.dasibom.vo.DayVO;



public interface AttendanceService {
	
	
    // 오늘 출석 여부 확인
    boolean isAlreadyChecked(String user_Id, Date today);

    // 출석 기록 저장
    void insertAttendance(String user_Id, Date today);

    // 이번 달 총 출석 일수
    int countAttendanceThisMonth(String user_Id);

    // 출석 기록 리셋 (예: 30일 달성 시 리셋)
    void resetAttendance(String user_Id);

    // 추가 (출석용 캘린더 보여주기용)
    List<List<DayVO>> getCalendarForMonth(String user_Id, int year, int month);

}
