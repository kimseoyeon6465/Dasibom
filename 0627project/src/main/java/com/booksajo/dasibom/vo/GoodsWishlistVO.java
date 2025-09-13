package com.booksajo.dasibom.vo;

public class GoodsWishlistVO {
	
	private String user_Id;
	private int goods_Id;
	private String addedDate;
	private String image_Path;
	private String list_Type;
	private Integer count;
	
	
	public String getUser_Id() {
		return user_Id;
	}
	public void setUser_Id(String user_Id) {
		this.user_Id = user_Id;
	}
	public int getGoods_Id() {
		return goods_Id;
	}
	public void setGoods_Id(int goods_Id) {
		this.goods_Id = goods_Id;
	}
	public String getAddedDate() {
		return addedDate;
	}
	public void setAddedDate(String addedDate) {
		this.addedDate = addedDate;
	}
	public String getImage_Path() {
		return image_Path;
	}
	public void setImage_Path(String image_Path) {
		this.image_Path = image_Path;
	}
	public String getList_Type() {
		return list_Type;
	}
	public void setList_Type(String list_Type) {
		this.list_Type = list_Type;
	}
	public Integer getCount() {
		return count;
	}
	public void setCount(Integer count) {
		this.count = count;
	}
	
	
	
}
