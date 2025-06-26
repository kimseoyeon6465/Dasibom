package com.booksajo.dasibom.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.booksajo.dasibom.dto.GuestOrderRequestDTO;
import com.booksajo.dasibom.service.BookService;
import com.booksajo.dasibom.service.GuestOrderService;
import com.booksajo.dasibom.vo.BookVO;
import com.booksajo.dasibom.vo.GuestOrderDetailVO;
import com.booksajo.dasibom.vo.GuestOrderVO;

@Controller
public class GuestOrderController {
	@Resource(name = "guestOrderService")
	private GuestOrderService guestOrderService;
	
	@Resource(name = "bookService")
	private BookService bookService;

	@RequestMapping(value = "/guestOrderList.do", method = RequestMethod.GET)
	public String getGuestOrdersByEmail(@RequestParam("email") String email, Model model) {
		List<GuestOrderVO> guestOrders = guestOrderService.getGuestOrdersByEmail(email);
		model.addAttribute("guestOrders", guestOrders);
		return "guestOrderList"; // → guestOrderList.jsp에서 출력
	}

	@RequestMapping(value = "/guestOrderDetail.do", method = RequestMethod.GET)
	public String getGuestOrderDetails(@RequestParam("orderId") int orderId, Model model) {
		GuestOrderVO guestOrder = guestOrderService.getGuestOrderById(orderId);
		List<GuestOrderDetailVO> details = guestOrderService.getGuestOrderDetailsByOrderId(orderId);

		model.addAttribute("guestOrder", guestOrder); // 주문 정보
		model.addAttribute("orderDetails", details); // 상세 리스트

		return "guestOrderDetail"; // → guestOrderDetail.jsp에서 출력
	}

	@RequestMapping(value = "/guestOrder.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> processGuestOrder(@RequestBody GuestOrderRequestDTO dto, HttpSession session) {
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			GuestOrderVO order = new GuestOrderVO();
			order.setReceiver(dto.getReceiver());
			order.setAddress(dto.getAddress());
			order.setRequest(dto.getRequest());
			order.setTel(dto.getTel());
			order.setEmail(dto.getEmail());
			order.setSumPrice(dto.getSumPrice());

			// ✅ 하나의 메서드에서 일괄 insert 처리
			int orderId = guestOrderService.insertGuestOrderWithDetails(order, dto.getOrderList());

			session.setAttribute("lastGuestOrderId", orderId);
			result.put("result", "success");
			System.out.println("📥 [GuestOrderController] 비회원 주문 접수 시작");
			System.out.println("📦 주문자 이메일: " + dto.getEmail());
			System.out.println("📦 주문 수: " + dto.getOrderList().size());
			System.out.println("🟡 sum_Price from DTO: " + dto.getSumPrice());
			System.out.println("🟡 sumPrice in VO before insert: " + order.getSumPrice());

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "error");
		}

		return result;
	}

	@RequestMapping(value = "/guestOrderForm.do", method = RequestMethod.GET)
	public String guestOrderForm(@RequestParam("isbn") String isbn, @RequestParam("count") int count, Model model) {

		BookVO book = new BookVO();
		
		System.out.println(isbn);
		System.out.println(count);
		
		book = bookService.getBookByIsbn(isbn);

		System.out.println(book.getImage_Path());
		System.out.println(book.getTitle());
		System.out.println(book.getDiscount_price());
		
		model.addAttribute("book", book);
		model.addAttribute("count", count);
		
		return "guestOrderForm";
	}

	@RequestMapping("/guestPaymentComplete.do")
	public String showGuestPaymentCompletePage(HttpSession session, Model model) {
		Integer orderId = (Integer) session.getAttribute("lastGuestOrderId");

		if (orderId != null) {
			GuestOrderVO guestOrder = guestOrderService.getGuestOrderById(orderId);
			List<GuestOrderDetailVO> orderList = guestOrderService.getGuestOrderDetailsByOrderId(orderId);

			model.addAttribute("guestOrder", guestOrder);
			model.addAttribute("orderList", orderList);
		}

		return "guestPaymentComplete";
	}
}
