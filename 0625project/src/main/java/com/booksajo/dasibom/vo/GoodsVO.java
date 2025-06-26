package com.booksajo.dasibom.vo;

public class GoodsVO {

	
    private int goods_Id;          // 굿즈 ID
    private String goods_name;     // 굿즈 이름
    private String category;       // 카테고리
    private int price;             // 가격
    private String image_path;     // 이미지 경로
    
	public int getGoods_Id() {
		return goods_Id;
	}
	public void setGoods_Id(int goods_Id) {
		this.goods_Id = goods_Id;
	}
	public String getGoods_name() {
		return goods_name;
	}
	public void setGoods_name(String goods_name) {
		this.goods_name = goods_name;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getImage_path() {
		return image_path;
	}
	public void setImage_path(String image_path) {
		this.image_path = image_path;
	}

}
