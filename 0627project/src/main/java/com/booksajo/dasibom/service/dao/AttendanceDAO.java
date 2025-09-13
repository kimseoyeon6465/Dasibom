package com.booksajo.dasibom.service.dao;

import java.util.Date;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface AttendanceDAO {

	 int countByDate(@Param("user_Id") String user_Id, @Param("date") Date date);

	 void insertAttendance(@Param("user_Id") String user_Id, @Param("date") Date date);

	 int countAttendanceThisMonth(@Param("user_Id") String user_Id);

	 void resetAttendance(@Param("user_Id") String user_Id);
    
    // 추가 6월 이후 캘린더 용
    List<Date> getAttendanceDates(@Param("user_Id") String user_Id, 
                                  @Param("year") int year, 
                                  @Param("month") int month);

}