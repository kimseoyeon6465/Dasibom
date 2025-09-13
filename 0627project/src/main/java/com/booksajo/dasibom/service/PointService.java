package com.booksajo.dasibom.service;

import java.util.Date;
import java.util.List;

import com.booksajo.dasibom.vo.PointVO;


public interface PointService {
	
	
	 // 포인트 적립
    void addPoint(String user_Id, int point, String description);

    // 포인트 사용
    void usePoint(String user_Id, int point, String description);

    // 현재 총 포인트 조회
    int getTotalPoint(String user_Id);

    // 포인트 내역 조회
    List<PointVO> getPointHistory(String user_Id);
    
    void updateUserPoint(String user_Id, int point);

}
