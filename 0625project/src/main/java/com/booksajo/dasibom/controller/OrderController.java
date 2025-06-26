package com.booksajo.dasibom.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.booksajo.dasibom.dto.OrderRequestDTO;
import com.booksajo.dasibom.service.BookService;
import com.booksajo.dasibom.service.CartService;
import com.booksajo.dasibom.service.OrderService;
import com.booksajo.dasibom.service.UserService;
import com.booksajo.dasibom.service.WishlistService;
import com.booksajo.dasibom.vo.CartVO;
import com.booksajo.dasibom.vo.OrderDetailVO;
import com.booksajo.dasibom.vo.UserOrderVO;
import com.booksajo.dasibom.vo.UserVO;
import com.booksajo.dasibom.vo.WishlistVO;

@Controller
public class OrderController {
	@Resource(name = "orderService")
	private OrderService orderService;

	@Resource(name = "UserService")
	private UserService userService;

	@Resource(name = "cartService")
	private CartService cartService;

	@Resource(name = "bookService")
	private BookService bookService;
	
	@Resource(name = "wishlistService")
	private WishlistService wishlistservice;

	@RequestMapping(value = "/order.do", method = RequestMethod.POST)
	public String goToPaymentPage(@RequestParam("userId") String userId,
			@RequestParam(value = "isbnList", required = false) String[] isbnList,
			@RequestParam(value = "countList", required = false) String[] countList,
			@RequestParam(value = "priceList", required = false) String[] priceList,
			@RequestParam(value = "goodsIdList", required = false) String[] goodsIdList,
			@RequestParam(value = "goodsCountList", required = false) String[] goodsCountList,
			@RequestParam(value = "goodsPriceList", required = false) String[] goodsPriceList,
			@RequestParam(value = "usedPoint", required = false, defaultValue = "0") int usedPoint, HttpSession session,
			Model model) {

		if (userId == null) {
			return "redirect:/login.do";
		}

		session.setAttribute("userId", userId);
		UserVO user = userService.getUserById(userId);
		model.addAttribute("loginUser", user);

		List<OrderDetailVO> orderList = new ArrayList<>();
		int sumPrice = 0;
		int sumPriceOrigin = 0;

		// 책 처리
		if (isbnList != null) {
			for (int i = 0; i < isbnList.length; i++) {
				int count = Integer.parseInt(countList[i]);
				int discountedPrice = Integer.parseInt(priceList[i]);
				int originalPrice = (int) Math.round(discountedPrice / 0.9);

				OrderDetailVO vo = new OrderDetailVO();
				vo.setIsbn(isbnList[i]);
				vo.setCount(count);
				vo.setPrice(discountedPrice);

				CartVO bookInfo = cartService.getCartBookByUserIdAndIsbn(userId, isbnList[i]);
				if (bookInfo != null) {
					vo.setTitle(bookInfo.getTitle());
					vo.setImagePath(bookInfo.getImagePath());
				}

				orderList.add(vo);
				sumPrice += discountedPrice * count;
				sumPriceOrigin += originalPrice * count;
			}
		}

		// 굿즈 처리
		if (goodsIdList != null && goodsCountList != null && goodsPriceList != null
				&& goodsIdList.length == goodsCountList.length && goodsIdList.length == goodsPriceList.length) {
			for (int i = 0; i < goodsIdList.length; i++) {
				int count = Integer.parseInt(goodsCountList[i]);
				int discountedPrice = Integer.parseInt(goodsPriceList[i]);
				int originalPrice = (int) Math.round(discountedPrice / 0.9);

				OrderDetailVO vo = new OrderDetailVO();
				vo.setGoodsId(Integer.parseInt(goodsIdList[i]));
				vo.setCount(count);
				vo.setPrice(discountedPrice);

				CartVO goodsInfo = cartService.getCartGoodsByUserIdAndGoodsId(userId, Integer.parseInt(goodsIdList[i]));
				if (goodsInfo != null) {
					vo.setGoodsName(goodsInfo.getGoodsName()); // ✅ 반드시 있어야 함!
					vo.setImagePath(goodsInfo.getImagePath());
				}

				orderList.add(vo);
				sumPrice += discountedPrice * count;
				sumPriceOrigin += originalPrice * count;
			}
		}

		int delivery = (sumPrice < 50000) ? 3000 : 0;

		model.addAttribute("orderList", orderList);
		model.addAttribute("sumPrice", sumPrice);
		model.addAttribute("delivery", delivery);
		model.addAttribute("sumPriceOrigin", sumPriceOrigin);
		model.addAttribute("usedPoint", usedPoint);

		return "Payment";
	}


	@RequestMapping(value = "/orderInsert.do", method = RequestMethod.POST)
	public String orderInsert(
		@RequestParam("user_Id") String user_Id,
		@RequestParam("isbn") String isbn,
		@RequestParam("added_date") String added_date,
		@RequestParam("image_path") String image_path,
		@RequestParam("list_type") String list_type,
		@RequestParam("count") String count,
		Model model,
		RedirectAttributes redirectAttributes,
		HttpSession session
	) {
		
		WishlistVO wish = new WishlistVO();
		
		wish.setIsbn(isbn);
		wish.setUserId(user_Id);
		wish.setAddedDate(added_date);
		wish.setImagePath(image_path);
		wish.setListType(list_type);
		wish.setCount(Integer.parseInt(count));
		
		try {
			wishlistservice.insertWishlist(wish);
			session.setAttribute("cartStatus", "addedbefore");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		return "redirect:/bookview.do?isbn=" + isbn;
	    

	}
		
	@ResponseBody
	@RequestMapping(value = "/orderInsert22.do", method = RequestMethod.POST)
	public Map<String, Object> orderInsert(@RequestBody OrderRequestDTO dto, HttpSession session) {
		System.out.println("✅ orderInsert.do 컨트롤러 도착!");
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			String sessionUserId = (String) session.getAttribute("userId");

			// 1. 주문 정보 저장
			UserOrderVO order = new UserOrderVO();
			order.setUser_Id(sessionUserId);
			order.setReceiver(dto.getReceiver());
			order.setTel(dto.getTel());
			order.setAddress(dto.getAddress());
			order.setRequest(dto.getRequest());

			int sumPrice = dto.getSumPrice();
			int usedPoint = dto.getUsedPoint();
			int finalPrice = sumPrice - usedPoint;
			order.setSum_Price(sumPrice);

			int orderId = orderService.insertUserOrder(order);
			session.setAttribute("lastOrderId", orderId);

			if (usedPoint > 0) {
				userService.updateUserPoint(dto.getUser_Id(), -usedPoint); // 차감
			}
			session.setAttribute("usedPoint", usedPoint);
			System.out.println("📦 dto.getUser_Id(): " + dto.getUser_Id()); // 여기!

			// 사용자 정보 세션 저장
			UserVO user = userService.getUserById(dto.getUser_Id());
			System.out.println("🧪 userService.getUserById 결과: " + (user == null ? "null" : user.getUser_Id()));

			if (user == null) {
				System.out.println("🚨 userService.getUserById(" + dto.getUser_Id() + ") 결과: null");
				throw new RuntimeException("사용자 정보 조회 실패: " + dto.getUser_Id());
			}
			session.setAttribute("loginUser", user);

			if (dto.getBookOrderList() != null) {
				for (OrderDetailVO detail : dto.getBookOrderList()) {
					detail.setOrder_Id(orderId);
					detail.setOrder_Status("결제완료");

					int original = bookService.getBookByIsbn(detail.getIsbn()).getPrice(); // 이 부분도 NPE 가능성 있음
					detail.setOriginalPrice(original);
				}
				orderService.insertOrderDetails(orderId, dto.getBookOrderList());
			}

			if (dto.getGoodsOrderList() != null) {
				for (OrderDetailVO detail : dto.getGoodsOrderList()) {
					detail.setOrder_Id(orderId);
					detail.setOrder_Status("결제완료");
				}
				orderService.insertGoodsOrderDetails(orderId, dto.getGoodsOrderList());
			}

			// ✅ 4. 포인트 적립
			int savePoint = (int) Math.floor(finalPrice * 0.05);
			if (savePoint > 0) {
				userService.updateUserPoint(dto.getUser_Id(), savePoint);
			}

			List<String> orderedIsbnList = new ArrayList<>();
			if (dto.getBookOrderList() != null) {
				for (OrderDetailVO detail : dto.getBookOrderList()) {
					orderedIsbnList.add(detail.getIsbn());
				}
				cartService.removeCartItemsAfterOrder(dto.getUser_Id(), orderedIsbnList);
			}

			List<Integer> orderedGoodsIdList = new ArrayList<>();
			if (dto.getGoodsOrderList() != null) {
				for (OrderDetailVO detail : dto.getGoodsOrderList()) {
					orderedGoodsIdList.add(detail.getGoodsId());
				}
				cartService.removeCartGoodsItemsAfterOrder(dto.getUser_Id(), orderedGoodsIdList);
			}

			result.put("result", "success");
			result.put("orderId", orderId);

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "error");
		}

		return result;
	}

	@RequestMapping("/paymentComplete.do")
	public String showPaymentCompletePage(HttpSession session, Model model) {
		Integer orderId = (Integer) session.getAttribute("lastOrderId");
		if (orderId != null) {
			UserOrderVO order = orderService.getUserOrder(orderId);
			List<OrderDetailVO> detailList = orderService.getUserOrderDetails(orderId);
			/* -----------------update-start------------------- */
			List<OrderDetailVO> goodsList = orderService.getUserGoodsOrderDetails(orderId); // ✅ 굿즈 목록 추가

			for (OrderDetailVO detail : detailList) {
				CartVO bookInfo = cartService.getCartBookByUserIdAndIsbn(order.getUser_Id(), detail.getIsbn());
				if (bookInfo != null) {
					detail.setImagePath(bookInfo.getImagePath());
					detail.setTitle(bookInfo.getTitle());
				}
			}
			/* -----------------update-end--------------------- */
			model.addAttribute("order", order);
			model.addAttribute("orderDetailList", detailList);
			model.addAttribute("goodsDetailList", goodsList);
		}
		return "paymentComplete";
	}

	@RequestMapping("/paymentComplete.do")
	public String showPaymentCompletePage(HttpSession session, Model model) {
		Integer orderId = (Integer) session.getAttribute("lastOrderId");
		if (orderId != null) {
			UserOrderVO order = orderService.getUserOrder(orderId);
			List<OrderDetailVO> detailList = orderService.getUserOrderDetails(orderId);
			model.addAttribute("order", order);
			model.addAttribute("orderDetailList", detailList);
		}
		return "paymentComplete";
	}

	@RequestMapping("/myOrders.do")
	public String getMyOrders(HttpSession session, Model model) {
		String userId = (String) session.getAttribute("userId");
		session.setAttribute("userId", userId);
		if (userId == null) {
			return "redirect:/login.do";
		}
		List<UserOrderVO> orderList = orderService.getOrdersByUserId(userId);
		model.addAttribute("orderList", orderList);
		return "myOrders"; // myOrders.jsp
	}

	@RequestMapping("/cancelPayment.do")
	public String cancelPayment(@RequestParam("orderId") int orderId, @RequestParam("isbn") String isbn,
			RedirectAttributes redirect) {
		try {
			orderService.updateOrderStatusToCancelled(orderId, isbn);
			redirect.addFlashAttribute("msg", "정상 취소 되었습니다.");
		} catch (Exception e) {
			redirect.addFlashAttribute("msg", "오류 발생: " + e.getMessage());
		}
		return "redirect:/myOrders.do"; // ← 주문 내역 목록으로 리다이렉트
	}
}
