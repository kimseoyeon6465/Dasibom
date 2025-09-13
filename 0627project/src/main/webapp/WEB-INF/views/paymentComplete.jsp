<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PaymentComplete</title>
<link rel="stylesheet" href="/dasibom/CSS/paymentComplete.css">
</head>
<body>
	<jsp:include page="/common/header.jsp" />

	<h2>✅ 결제가 완료되었습니다!</h2>
	<p>주문이 정상적으로 처리되었습니다. 감사합니다.</p>
	<c:if test="${not empty order}">
		<h3>📦 주문 정보</h3>
		<ul>
			<li><strong>주문 번호:</strong> ${order.orderId}</li>
			<li><strong>주문일자:</strong> <fmt:formatDate
					value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm:ss" /></li>
			<li><strong>수령인:</strong> ${order.receiver}</li>
			<li><strong>배송지:</strong> ${order.address}</li>
			<li><strong>주문 상태:</strong> 결제완료</li>
			<li><strong>총 합계:</strong> <fmt:formatNumber
					value="${order.sumPrice}" type="number" /> 원</li>
		</ul>
	</c:if>

	<c:if test="${not empty orderDetailList}">
		<h3>📚 주문 상세</h3>
		<table>
			<thead>
				<tr>
					<th>상품</th>
					<th>도서명</th>
					<th>수량</th>
					<th>할인가</th>
					<th>상태</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="item" items="${orderDetailList}">
					<tr>
						<td><img src="${item.imagePath}" alt="${item.title}" /></td>
						<td>${item.title}</td>
						<td>${item.count}</td>
						
						<td><span class="discounted-price" style="color: red;">
								<fmt:formatNumber value="${item.price}" type="number" />
						</span> 원</td>


						<td>${item.orderStatus}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</c:if>
	<jsp:include page="/common/footer.jsp" />
</body>
</html>
