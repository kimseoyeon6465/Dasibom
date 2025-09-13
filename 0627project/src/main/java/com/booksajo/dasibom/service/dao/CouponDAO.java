package com.booksajo.dasibom.service.dao;

import java.util.List;

import com.booksajo.dasibom.vo.CouponVO;


public interface CouponDAO {

    void insertCoupon(CouponVO coupon);

    List<CouponVO> getUserCoupons(String user_Id);

    void updateCouponUsed(int coupon_Id);
}
