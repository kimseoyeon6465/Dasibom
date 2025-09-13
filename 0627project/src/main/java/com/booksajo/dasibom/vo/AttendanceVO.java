package com.booksajo.dasibom.vo;

import java.util.Date;

public class AttendanceVO {

    private String user_Id;
    private Date attend_date;

    // Getters / Setters
    public String getUser_Id() {
        return user_Id;
    }
    public void setUser_id(String user_Id) {
        this.user_Id = user_Id;
    }
    public Date getAttend_date() {
        return attend_date;
    }
    public void setAttend_date(Date attend_date) {
        this.attend_date = attend_date;
    }
}
