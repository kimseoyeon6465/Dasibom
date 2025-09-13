package com.booksajo.dasibom.service.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import com.booksajo.dasibom.vo.PointVO;


public interface PointDAO {

    void insertPoint(PointVO point);

    int getTotalPoint(String user_Id);

    List<PointVO> getPointHistory(String user_Id);
    
    void updateUserPoint(@Param("user_Id") String user_Id, @Param("point") int point);

}
