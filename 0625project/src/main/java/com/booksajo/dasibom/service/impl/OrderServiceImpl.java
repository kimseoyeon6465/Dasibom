package com.booksajo.dasibom.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.booksajo.dasibom.service.OrderService;
import com.booksajo.dasibom.service.dao.MyOrderDAO;
import com.booksajo.dasibom.service.dao.OrderDAO;
import com.booksajo.dasibom.vo.MyOrderVO;
import com.booksajo.dasibom.vo.OrderDetailVO;
import com.booksajo.dasibom.vo.UserOrderVO;

@Service("orderService")
public class OrderServiceImpl implements OrderService {

	@Autowired
	private MyOrderDAO myOrderDAO;
	
	@Override
	public List<MyOrderVO> getOrdersByUserId(Map<String, Object> params) {
		return myOrderDAO.getOrdersByUserId(params);
	}
	
	@Override
	public int countOrdersByUserId(Map<String, Object> params) {
		return myOrderDAO.countOrdersByUserId(params);
	}
	
	// (임시)
	@Override
	public MyOrderVO getOrderByOrderId(int orderId) {
		return myOrderDAO.getOrderByOrderId(orderId);
	}
	
	@Autowired
	private OrderDAO orderdao;

	@Override
	public int insertUserOrder(UserOrderVO orderVO) {
		orderdao.insertUserOrder(orderVO);
		System.out.println("✔️ order_id: " + orderVO.getOrder_Id());
		return orderVO.getOrder_Id(); // selectKey로 셋팅된 값 반환
	}

	@Override
	public void insertOrderDetails(int orderId, List<OrderDetailVO> detailList) {
		for (OrderDetailVO vo : detailList) {
			vo.setOrder_Id(orderId);
			orderdao.insertOrderDetail(vo); // DAO는 단건 처리

			Map<String, Object> salesMap = new HashMap<String, Object>();
			salesMap.put("isbn", vo.getIsbn());
			salesMap.put("count", vo.getCount());

			orderdao.increaseSales(salesMap);
			System.out.println("📦 [주문] sales 증가: isbn=" + vo.getIsbn() + ", count=" + vo.getCount());

		}
	}

	@Override
	public int getNextOrderId() {
		return orderdao.getNextOrderId();
	}

	@Override
	public void insertOrderDetail(OrderDetailVO detail) {
		orderdao.insertOrderDetail(detail);
	}

	@Override
	public UserOrderVO getUserOrder(int orderId) {
		return orderdao.getUserOrder(orderId);
	}

	@Override
	public List<UserOrderVO> getOrdersByUserId(String userId) {
		List<UserOrderVO> orders = orderdao.selectOrdersByUserId(userId);

		System.out.println("📦 [getOrdersByUserId] 불러온 주문 개수: " + orders.size());

		for (UserOrderVO order : orders) {
			System.out.println("🧾 주문번호: " + order.getOrder_Id());
			System.out.println("👤 사용자 ID: " + order.getUser_Id());
			System.out.println("💰 총합계: " + order.getSum_Price());
			System.out.println("📍 수령인: " + order.getReceiver());
			System.out.println("📦 주소: " + order.getAddress());

			List<OrderDetailVO> details = orderdao.selectOrderDetailsByOrderId(order.getOrder_Id());
			order.setDetail_List(details);

			System.out.println("📚 해당 주문의 상품 수: " + details.size());
			for (OrderDetailVO item : details) {
				System.out.println("   🔸 제목: " + item.getTitle() + ", 수량: " + item.getCount() + ", 가격: "
						+ item.getPrice() + ", 상태: " + item.getOrder_Status());
			}
			System.out.println("----------------------------------------------------");
		}

		return orders;
	}

	@Override
	public List<OrderDetailVO> getOrderDetailsByOrderId(int orderId) {
		return orderdao.selectOrderDetailsByOrderId(orderId);
	}

	@Override
	public List<OrderDetailVO> getUserOrderDetails(int orderId) {
		return orderdao.selectOrderDetailsByOrderId(orderId);
	}

	@Override
	public void updateOrderStatusToCancelled(int orderId, String isbn) {
		orderdao.updateOrderStatus(orderId, isbn, "결제취소");
	}

}
