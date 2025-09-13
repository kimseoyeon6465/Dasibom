package com.booksajo.dasibom.vo;

import java.util.Date;
import java.util.List;

public class UsedBookVO {

    private int post_id;
    private Date post_date;
    private String title;
    private int price;
    private String isbn;
    private String sale_status;
    private String sale_Status;
    
    private String image_path;
    private String sale_type;
    private String user_id;
    private String content;

    // ?�� 추�??�� ?��?��
    private List<String> imagePathList;

    // 기본 ?��?��?��
    public UsedBookVO() {}

    // ?��?��?�� (?��?��?�� ?��?��)
    public UsedBookVO(int post_id, Date post_date, String title, int price, String isbn,
                      String sale_status, String image_path, String sale_type,
                      String user_id, String content) {
        this.post_id = post_id;
        this.post_date = post_date;
        this.title = title;
        this.price = price;
        this.isbn = isbn;
        this.sale_status = sale_status;
        this.image_path = image_path;
        this.sale_type = sale_type;
        this.user_id = user_id;
        this.content = content;
    }

    // ?�� Getter & Setter for imagePathList
    public List<String> getImagePathList() {
        return imagePathList;
    }

    public void setImagePathList(List<String> imagePathList) {
        this.imagePathList = imagePathList;
    }

    
    public String getSale_Status() {
		return sale_Status;
	}

	public void setSale_Status(String sale_Status) {
		this.sale_Status = sale_Status;
	}

	// 기존 Getter/Setter ?��?�� ?��?�� 그�?�?? ?���??
    public int getPost_id() { return post_id; }
    public void setPost_id(int post_id) { this.post_id = post_id; }

    public Date getPost_date() { return post_date; }
    public void setPost_date(Date post_date) { this.post_date = post_date; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getSale_status() { return sale_status; }
    public void setSale_status(String sale_status) { this.sale_status = sale_status; }

    public String getImage_path() { return image_path; }
    public void setImage_path(String image_path) { this.image_path = image_path; }

    public String getSale_type() { return sale_type; }
    public void setSale_type(String sale_type) { this.sale_type = sale_type; }

    public String getUser_id() { return user_id; }
    public void setUser_id(String user_id) { this.user_id = user_id; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
