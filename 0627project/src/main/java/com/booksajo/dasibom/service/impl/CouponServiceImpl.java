package com.booksajo.dasibom.service.impl;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.booksajo.dasibom.service.CouponService;
import com.booksajo.dasibom.service.dao.CouponDAO;
import com.booksajo.dasibom.vo.CouponVO;


@Service("couponService")
public class CouponServiceImpl implements CouponService {

    @Resource(name = "couponDAO")
    private CouponDAO couponDAO;

    @Override
    public void issueCoupon(String user_Id, int discountPercent) {
    	CouponVO coupon = new CouponVO();
        coupon.setUser_Id(user_Id);
        coupon.setDiscount(discountPercent);
        coupon.setCoupon_code("ATTEND-" + System.currentTimeMillis());
        
        // 荑좏룿 �쑀�슚湲곌컙 (+30�씪)
        Date validDate = new Date(System.currentTimeMillis() + (30L * 24 * 60 * 60 * 1000));
        coupon.setValid_date(validDate);
        
        // �윍� �븘�닔 : coupon_irum + coupon_text �꽔湲�
        if (discountPercent == 10) {
            coupon.setCouponIrum("異쒖꽍 10�씪 荑좏룿");
            coupon.setCoupon_text("異쒖꽍 10�씪 �떖�꽦 �떆 吏�湲됰릺�뒗 10% �븷�씤 荑좏룿");
        } else if (discountPercent == 15) {
            coupon.setCouponIrum("異쒖꽍 20�씪 荑좏룿");
            coupon.setCoupon_text("異쒖꽍 20�씪 �떖�꽦 �떆 吏�湲됰릺�뒗 15% �븷�씤 荑좏룿");
        } else if (discountPercent == 20) {
            coupon.setCouponIrum("異쒖꽍 30�씪 荑좏룿");
            coupon.setCoupon_text("異쒖꽍 30�씪 �떖�꽦 �떆 吏�湲됰릺�뒗 20% �븷�씤 荑좏룿");
        } else {
            coupon.setCouponIrum("異쒖꽍 �씠踰ㅽ듃 荑좏룿");
            coupon.setCoupon_text("異쒖꽍 �씠踰ㅽ듃 李몄뿬 媛먯궗 荑좏룿");
        }
        
        // INSERT �떎�뻾
        couponDAO.insertCoupon(coupon);
        System.out.println(111111);
        System.out.println(222222);
        System.out.println(111111);
    }

    @Override
    public List<CouponVO> getUserCoupons(String user_Id) {
        return couponDAO.getUserCoupons(user_Id);
    }

    @Override
    public void useCoupon(int coupon_Id) {
        couponDAO.updateCouponUsed(coupon_Id);
    }
}