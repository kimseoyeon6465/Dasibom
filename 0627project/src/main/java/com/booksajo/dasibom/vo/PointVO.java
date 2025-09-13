package com.booksajo.dasibom.vo;

import java.util.Date;

public class PointVO {

    private int point_Id;
    private String user_Id;
    private int point;
    private Date point_date;
    private String description;
	public int getPoint_Id() {
		return point_Id;
	}
	public void setPoint_Id(int point_Id) {
		this.point_Id = point_Id;
	}
	public String getUser_Id() {
		return user_Id;
	}
	public void setUser_Id(String user_Id) {
		this.user_Id = user_Id;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	public Date getPoint_date() {
		return point_date;
	}
	public void setPoint_date(Date point_date) {
		this.point_date = point_date;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}

}
