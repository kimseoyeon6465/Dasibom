package com.booksajo.dasibom.vo;

import java.util.Date;

public class ChatRoomVO {
	private int id;
	private String user1_id;
	private String user2_id;
	private Date created_at;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUser1_id() {
		return user1_id;
	}
	public void setUser1_id(String user1_id) {
		this.user1_id = user1_id;
	}
	public String getUser2_id() {
		return user2_id;
	}
	public void setUser2_id(String user2_id) {
		this.user2_id = user2_id;
	}
	public Date getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}
}
