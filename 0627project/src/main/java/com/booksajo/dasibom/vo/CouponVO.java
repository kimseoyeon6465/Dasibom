package com.booksajo.dasibom.vo;

import java.util.Date;

public class CouponVO {

	private int coupon_Id;
	private String user_Id;
	private String couponIrum;   // 추가
	private String coupon_text;   // 추가 (있으면 마이페이지 등에서 표시하기 편리)
	private String coupon_code;
	private int discount;
	private Date valid_date;
	private Date issue_date;
	private String used;

    // Getters / Setters
    public int getCoupon_Id() {
        return coupon_Id;
    }
    public void setCoupon_Id(int coupon_Id) {
        this.coupon_Id = coupon_Id;
    }
    public String getUser_Id() {
        return user_Id;
    }
    public void setUser_Id(String user_Id) {
        this.user_Id = user_Id;
    }
    public String getCoupon_code() {
        return coupon_code;
    }
    public void setCoupon_code(String coupon_code) {
        this.coupon_code = coupon_code;
    }
    public int getDiscount() {
        return discount;
    }
    public void setDiscount(int discount) {
        this.discount = discount;
    }
    public Date getValid_date() {
        return valid_date;
    }
    public String getCouponIrum() {
        return couponIrum;
    }

    public void setCouponIrum(String couponIrum) {
        this.couponIrum = couponIrum;
    }
	public String getCoupon_text() {
		return coupon_text;
	}
	public void setCoupon_text(String coupon_text) {
		this.coupon_text = coupon_text;
	}
	public void setValid_date(Date valid_date) {
        this.valid_date = valid_date;
    }
    public Date getIssue_date() {
        return issue_date;
    }
    public void setIssue_date(Date issue_date) {
        this.issue_date = issue_date;
    }
    public String getUsed() {
        return used;
    }
    public void setUsed(String used) {
        this.used = used;
    }
}