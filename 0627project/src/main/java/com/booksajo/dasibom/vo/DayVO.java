package com.booksajo.dasibom.vo;

import java.util.Date;

public class DayVO {
    private int day;        // 1, 2, 3... or 0 (ºóÄ­)
    private boolean checked; // Ãâ¼® ¿©ºÎ (true/false)
    private boolean today;	//¿À´Ã ¿©ºÎ

    public DayVO(int day, boolean checked) {
        this.day = day;
        this.checked = checked;
        this.today = false;
    }

    public DayVO(int day, boolean checked, boolean today) {
        this.day = day;
        this.checked = checked;
        this.today = today;
    }

    public int getDay() { return day; }
    public void setDay(int day) { this.day = day; }

    public boolean isChecked() { return checked; }
    public void setChecked(boolean checked) { this.checked = checked; }
    
    public boolean isToday() { return today; }   // EL¿¡¼­ ${day.isToday} »ç¿ë °¡´É
    public boolean getToday() { return today; }   // ${day.today} Áö¿ø, ÅèÄ¹ È£È¯¼º
    public void setToday(boolean today) { this.today = today; }

}
