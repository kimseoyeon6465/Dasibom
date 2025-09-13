package com.booksajo.dasibom.service;

import java.util.Date;
import java.util.List;

import com.booksajo.dasibom.vo.CouponVO;


public interface CouponService {

	// 출석 10일 쿠폰 발급
    void issueCoupon(String user_Id, int discountPercent);

    // 쿠폰 목록 조회 (ex. 마이페이지에서 사용)
    List<CouponVO> getUserCoupons(String user_Id);

    // 쿠폰 사용 처리
    void useCoupon(int coupon_Id);
}
