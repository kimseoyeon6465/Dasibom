package com.booksajo.dasibom.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.booksajo.dasibom.service.GoodsService;
import com.booksajo.dasibom.service.UserService;
import com.booksajo.dasibom.vo.GoodsVO;
import com.booksajo.dasibom.vo.GoodsWishlistVO;
import com.booksajo.dasibom.vo.PhotosVO;
import com.booksajo.dasibom.vo.UserVO;
import com.booksajo.dasibom.vo.WishlistVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class GoodsController {
	
	@Autowired
	private UserService userService;
	
	@Resource(name = "goodsService")
	private GoodsService goodsService;
	
	
	
	
		// 援우쫰 紐⑸줉 �럹�씠吏�
	    @RequestMapping("/goods_list.do")
	    public String goodsList(Model model) {
	        
	        ArrayList<GoodsVO> goodsList = goodsService.getAllGoods();
	        model.addAttribute("goodsList", goodsList);
	
	        return "goods_list";   // �넂 goods_list.jsp 濡� �씠�룞
	    }
		
	 // 援우쫰 �긽�꽭 �럹�씠吏�
	    @RequestMapping("/goods_detail.do")
	    public String goodsDetail(GoodsVO goodsVO, Model model) {
	       //1. 援우쫰 �젙蹂�
	    	GoodsVO onegoods = goodsService.getOnegoods(goodsVO);
	        if (onegoods == null) {
	            return "redirect:/MainPage.do";
	        }
	        model.addAttribute("goods", onegoods);
	        
	        // 2. 援우쫰 �씠誘몄� 紐⑸줉 議고쉶 (photos_table �궗�슜)
	        List<PhotosVO> photoList = goodsService.getGoodsPhotoList(onegoods.getGoods_Id());
	        model.addAttribute("photoList", photoList);  
	        
	        return "goods_detail";   // �넂 goods_detail.jsp 濡� �씠�룞
	    }
	    
	    @Controller
		public class checkGoodsCartItem {

	    	@ResponseBody
		    @GetMapping("/checkGoodsCartItem.do")
		    public String checkGoodsCartItem(@RequestParam int goods_Id, 
		    		@RequestParam String count , 
		    		@RequestParam String image_Path ,
		    		HttpSession session) {
	    		
	        	
		        Integer user_seq = (Integer) session.getAttribute("user_seq");
		        UserVO user = userService.getUserBySeq(user_seq);
		        
		       
	        	GoodsWishlistVO wish = new GoodsWishlistVO();
	        	
	        	String type = "cart";
	        	
	        	
	        	System.out.println(user.getUser_Id());
	        	System.out.println(goods_Id);
	        	System.out.println(type);
	        	
	        	int exists = goodsService.checkExist(user.getUser_Id(), goods_Id, type);
	        	System.out.println(exists);
	    		
	        	if (exists == 0) {
		    		wish.setGoods_Id(goods_Id);
		    		wish.setUser_Id(user.getUser_Id());
		    		wish.setCount(Integer.parseInt(count));
		    		wish.setList_Type(type);
		    		wish.setImage_Path(image_Path);
		    		try {
						goodsService.insertGoodsCart(wish);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	        	}
	    		return exists >= 1 ? "exist" : "empty";
		    }
		}
	    @Controller
		public class checkGoodsJjimItem {

		    @ResponseBody
		    @GetMapping("/checkGoodsJjimItem.do")
		    public String checkGoodsJjimItem(@RequestParam int goods_Id, 
		    		@RequestParam String count , 
		    		@RequestParam String image_Path ,
		    		HttpSession session) {

		        Integer user_seq = (Integer) session.getAttribute("user_seq");
		        UserVO user = userService.getUserBySeq(user_seq);
		        
		        String type = "wishlist";
		        int exists = goodsService.checkExist(user.getUser_Id(), goods_Id, type);
		        
		        if(exists == 0) {
		        	GoodsWishlistVO wish = new GoodsWishlistVO();
		    		
		    		wish.setGoods_Id(goods_Id);
		    		wish.setUser_Id(user.getUser_Id());
		    		wish.setCount(Integer.parseInt(count));
		    		wish.setList_Type(type);
		    		wish.setImage_Path(image_Path);
		    		
		    		
		    		
		    		try {
		    			goodsService.insertGoodsWishlist(wish);;
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
		        }
		        
		        return exists >= 1 ? "exist" : "empty";
		        
		    }
		}
	}


