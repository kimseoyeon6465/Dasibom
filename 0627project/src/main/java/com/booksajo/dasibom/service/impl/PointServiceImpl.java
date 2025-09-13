package com.booksajo.dasibom.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.booksajo.dasibom.service.PointService;
import com.booksajo.dasibom.service.dao.PointDAO;
import com.booksajo.dasibom.vo.PointVO;


@Service("pointService")
public class PointServiceImpl implements PointService {

    @Resource(name = "pointDAO")
    private PointDAO pointDAO;

    @Override
    public void addPoint(String user_Id, int point, String description) {
        PointVO vo = new PointVO();
        vo.setUser_Id(user_Id);
        vo.setPoint(point);
        vo.setDescription(description);
        pointDAO.insertPoint(vo);
    }

    @Override
    public void usePoint(String user_Id, int point, String description) {
        PointVO vo = new PointVO();
        vo.setUser_Id(user_Id);
        vo.setPoint(-point); // 사용 시 마이너스
        vo.setDescription(description);
        pointDAO.insertPoint(vo);
    }

    @Override
    public int getTotalPoint(String user_Id) {
        return pointDAO.getTotalPoint(user_Id);
    }

    @Override
    public List<PointVO> getPointHistory(String user_Id) {
        return pointDAO.getPointHistory(user_Id);
    }
    
    //포인트업뎃
    @Override
    public void updateUserPoint(String user_Id, int point) {
        pointDAO.updateUserPoint(user_Id, point);
    }

}