<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 페이지</title>
<link rel="stylesheet" href="/dasibom/CSS/Payment.css">

</head>
<body>
	<jsp:include page="/common/header.jsp" />

	<!-- 🧾 주문자 정보 + 요청사항 -->
	<div class="info-container">
		<!-- 👤 결제 정보 -->
		<div class="order-info">
			<h2>🏎 결제 정보</h2>
			<p>
				<strong>주문자 이름:</strong> ${loginUser.irum}
			</p>
			<p>
				<strong>배송지 주소:</strong> ${loginUser.address}
			</p>
			<p>
				<strong>연락처:</strong> ${loginUser.tel}
			</p>
			<p>
				<strong>보유 포인트:</strong> <span id="userPoint">${loginUser.point}</span>P
			</p>

			<!-- ✏️ 배송 요청사항 -->
			<div class="request-box">
				<label for="requestInput"><strong>배송 시 요청사항:</strong></label><br>
				<textarea id="requestInput" placeholder="예: 문 앞에 놓아주세요." rows="3"
					cols="80"></textarea>
			</div>
		</div>
	</div>

	<hr>

	<!-- 📦 주문 상품 영역 + 결제 요약 박스 -->
	<div class="order-summary-container">
		<!-- 🛒 주문 상품 테이블 -->
		<div class="product-table">
			<h3>🛒 주문 상품 목록</h3>
			<table>
				<thead>
					<tr>
						<th>상품</th>
						<th>제목</th>
						<th>수량</th>
						<th>가격</th>
						<th>소계</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="item" items="${orderList}">
						<tr>
							<td><img src="${item.imagePath}" width="100"></td>
							<td>${item.title}</td>
							<td>${item.count}</td>
							<td><span class="original-price"> <fmt:formatNumber
										value="${item.price / 0.9}" type="number" />
							</span><br> <span class="discounted-price"> <fmt:formatNumber
										value="${item.price}" type="number" />
							</span> 원</td>
							<td><fmt:formatNumber value="${item.price * item.count}"
									type="number" /> 원</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<!-- 💰 결제 요약 박스 -->
		<div class="summary-box">
			<p class="price-line">
				<span class="label">상품 정가 금액</span> <span class="value"> <fmt:formatNumber
						value="${sumPriceOrigin}" type="number" />원
				</span>
			</p>
			<p class="price-line">
				<span class="label">상품 할인 금액</span> <span class="value discount">-
					<fmt:formatNumber value="${sumPriceOrigin - sumPrice}"
						type="number" />원
				</span>
			</p>
			<hr class="divider" />
			<p class="price-line">
				<span class="label">할인 적용 소계</span> <span class="value"><fmt:formatNumber
						value="${sumPrice}" type="number" />원</span>
			</p>
			<p class="price-line">
				<span class="label">배송비</span> <span class="value"> <fmt:formatNumber
						value="${delivery}" type="number" />원
				</span>
			</p>

			<hr>
			<p class="price-line">
				<span class="label">포인트 사용</span> <span class="value"
					id="displayUsedPoint">- 0원</span>
			</p>
			<input type="number" id="usedPointInput" placeholder="0" min="0"
				style="width: 100%; margin-top: 5px;" />
			<button type="button" onclick="applyPoint()">포인트 적용</button>

			<hr>
			<p class="final-line">
				<span class="label">총 결제 금액</span> <span class="value total"
					id="finalPriceText"> <fmt:formatNumber
						value="${sumPrice + delivery}" type="number" />원
				</span>
			</p>

			<p style="font-size: 13px; color: #666;">
				적립 예정 포인트 <span id="expectedPoint">${(sumPrice * 0.05) - ((sumPrice * 0.05) % 1)}P</span>
			</p>
		</div>
	</div>

	<!-- ✅ Hidden fields -->
	<input type="hidden" id="sumPrice" value="${sumPrice}" />
	<input type="hidden" id="delivery" value="${delivery}" />
	<input type="hidden" id="userPoint" value="${loginUser.point}" />
	<input type="hidden" id="usedPoint" value="0" />
	<input type="hidden" id="usedPointHidden" value="0" />
	<input type="hidden" id="userId" value="${loginUser.userId}" />
	<input type="hidden" id="receiver" value="${loginUser.irum}" />
	<input type="hidden" id="tel" value="${loginUser.tel}" />
	<input type="hidden" id="address" value="${loginUser.address}" />
	<input type="hidden" id="request" />
	<input type="hidden" id="finalPriceHidden"
		value="${sumPrice + delivery}" />

	<!-- ✅ JS에서 넣어줄 것 -->
	<div id="orderData" style="display: none;">
		<c:forEach var="item" items="${orderList}">
			<input type="hidden" class="item-isbn" value="${item.isbn}" />
			<input type="hidden" class="item-count" value="${item.count}" />
			<input type="hidden" class="item-price" value="${item.price}" />
			<input type="hidden" class="item-original-price"
				value="${item.price / 0.9}" />

			<input type="hidden" class="item-title" value="${item.title}" />
			<input type="hidden" class="item-image" value="${item.imagePath}" />
		</c:forEach>
	</div>

	<!-- ✅ 결제 버튼 -->
	<div class="button-container">
		<button type="button" onclick="goToKakaoPay()">결제하기</button>
	</div>

	<script>
		function applyPoint() {
			const totalPrice = parseInt("${sumPrice}")
					+ parseInt("${delivery}");
			const userPoint = parseInt(document.getElementById("userPoint").innerText);
			const usedPoint = parseInt(document
					.getElementById("usedPointInput").value) || 0;

			if (usedPoint > userPoint) {
				alert("보유 포인트를 초과할 수 없습니다.");
				return;
			}

			if (usedPoint > totalPrice) {
				alert("결제 금액보다 많은 포인트를 사용할 수 없습니다.");
				return;
			}

			const finalPrice = totalPrice - usedPoint;
			const expectedPoint = Math.floor(finalPrice * 0.05);

			document.getElementById("finalPriceText").innerText = finalPrice
					.toLocaleString()
					+ "원";
			document.getElementById("expectedPoint").innerText = expectedPoint
					.toLocaleString()
					+ "P";
			document.getElementById("displayUsedPoint").innerText = "- "
					+ usedPoint.toLocaleString() + "원";

			document.getElementById("usedPoint").value = usedPoint;
			document.getElementById("usedPointHidden").value = usedPoint;
			document.getElementById("finalPriceHidden").value = finalPrice;
		}

		function goToKakaoPay() {
			applyPoint(); // ✅ 포인트 계산 강제 실행

			const orderList = [];
			const isbns = document.querySelectorAll(".item-isbn");
			const counts = document.querySelectorAll(".item-count");
			const prices = document.querySelectorAll(".item-price");
			const originalPrices = document.querySelectorAll(".item-original-price");
			const titles = document.querySelectorAll(".item-title");
			const images = document.querySelectorAll(".item-image");

			for (let i = 0; i < isbns.length; i++) {
				orderList.push({
					isbn : isbns[i].value,
					count : parseInt(counts[i].value),
					price : parseInt(prices[i].value),
					originalPrice: parseInt(originalPrices[i].value), // ✅ 정가 추가
					title : titles[i].value,
					imagePath : images[i].value
				});
			}

			const orderData = {
				userId : document.getElementById("userId").value,
				receiver : document.getElementById("receiver").value,
				tel : document.getElementById("tel").value,
				address : document.getElementById("address").value,
				request : document.getElementById("requestInput").value,
				sumPrice : parseInt(document.getElementById("finalPriceHidden").value) || 0,
				usedPoint : parseInt(document.getElementById("usedPoint").value),
				orderList : orderList
			};

			localStorage.setItem("orderData", JSON.stringify(orderData));
			const contextPath = "${pageContext.request.contextPath}";
			location.href = contextPath + "/payment/kakaopay.html";
		}
	</script>

	<jsp:include page="/common/footer.jsp" />
</body>
</html>
