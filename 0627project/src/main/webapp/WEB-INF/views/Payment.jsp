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


	<!-- 제목 영역 (container 밖!) -->
	<div class="cart-header-section">
		<div class="cart-header-box">
			<div class="best-text">
				<h1>결제 정보</h1>
				<div class="underline"></div>
			</div>
		</div>
	</div>

	<div class="payment-layout" style="flex-direction: column;">
		<!-- 배송지 + 결제요약 한 줄 배치 -->
		<div class="payment-content-row">
			<div class="payment-container">
				<div class="order-info-box">
					<div class="order-info-header">
						<h2>배송지 정보</h2>
					</div>

					<div class="order-info-flex">
						<div class="info-title">기본 배송지</div>
						<div class="info-details">
							<div class="detail-item">
								<span class="detail-label">주문자 이름</span> <span class="detail-value">${loginUser.irum}</span>
							</div>
							<div class="detail-item">
								<span class="detail-label">연락처</span> <span class="detail-value">${loginUser.tel}</span>
							</div>
							<div class="detail-item">
								<span class="detail-label">배송지 주소</span> <span class="detail-value">${loginUser.address}</span>
							</div>
							<div class="detail-item">
								<span class="detail-label">보유 포인트</span> <span class="detail-value"> <span id="userPoint" class="highlight-point">${loginUser.point}P</span>
								</span>
							</div>
						</div>
					</div>

					<div class="request-box">
						<span class="info-label">배송 요청사항</span>
						<textarea id="requestInput" placeholder="예: 문 앞에 놓아주세요."></textarea>
					</div>
					<br> <br> <br> <br> <br> <br>
				</div>
				<!-- order-info-box 끝 -->
				<!-- 📦 주문 상품 영역 + 결제 요약 박스 -->
				<div class="product-list-wrapper">
					<h3>주문 상품 목록</h3>

					<c:forEach var="item" items="${orderList}">
						<div class="cart-item-card" data-type="book" data-isbn="${item.isbn}">
							<img src="${item.imagePath}" class="book-image" />
							<div class="item-info">
								<div class="item-title">${item.title}</div>
							</div>
							<div class="item-quantity">${item.count}개</div>
							<div class="item-price">
								<div class="discounted-price">
									<fmt:formatNumber value="${item.price}" type="number" />
									원
								</div>
								<div class="original-price">
									<fmt:formatNumber value="${item.price/0.9}" type="number" />
									원
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
			<!-- payment-container 끝 -->
			<!-- 📚 책 항목 -->
			<c:forEach var="item" items="${orderList}">
				<c:if test="${not empty item.title}">
					<div class="cart-item-card" data-type="book" data-isbn="${item.isbn}">
						<img src="${item.image_Path}" alt="책 이미지" class="book-image" />
						<div class="book-info">
							<p>
								<strong>상품명:</strong> ${item.title}
							</p>
							<p>
								<strong>가격:</strong> <span class="original-price"> <fmt:formatNumber value="${item.price / 0.9}" type="number" />
								</span> → <span class="discounted-price"> <fmt:formatNumber value="${item.price}" type="number" />
								</span> 원
							</p>
							<p>
								<strong>수량:</strong> ${item.count}개
							</p>
							<input type="hidden" class="item-isbn" value="${item.isbn}" /> <input type="hidden" class="item-image" value="${item.imagePath}" /> <input type="hidden" class="item-title" value="${item.title}" /> <input type="hidden" class="item-count" value="${item.count}" /> <input type="hidden" class="item-price" value="${item.price}" /> <input type="hidden" class="item-original-price" value="${item.price / 0.9}" />
						</div>
					</div>
				</c:if>
			</c:forEach>

			<!-- 🎁 굿즈 항목 -->
			<c:forEach var="item" items="${orderList}">
				<c:if test="${item.goodsId != null and item.goodsId != 0}">
					<div class="cart-item-card" data-type="goods" data-goodsid="${item.goodsId}">
						<img src="${pageContext.request.contextPath}${item.imagePath}" alt="굿즈 이미지" class="book-image" />
						<div class="book-info">
							<p>
								<strong>상품명:</strong> ${item.goodsName}
							</p>
							<p>
								<strong>가격:</strong> <span class="original-price"> <fmt:formatNumber value="${item.price / 0.9}" type="number" />
								</span> → <span class="discounted-price"> <fmt:formatNumber value="${item.price}" type="number" />
								</span> 원
							</p>
							<p>
								<strong>수량:</strong> ${item.count}개
							</p>
							<input type="hidden" class="item-goods-id" value="${item.goodsId}" /><input type="hidden" class="item-image" value="${item.imagePath}" /> <input type="hidden" class="item-goods-name" value="${item.goodsName}" /> <input type="hidden" class="item-count" value="${item.count}" /> <input type="hidden" class="item-price" value="${item.price}" /> <input type="hidden" class="item-original-price" value="${item.price / 0.9}" />

						</div>
					</div>
				</c:if>
			</c:forEach>


			<!-- 💰 결제 요약 박스 -->
			<div class="summary-box">
				<p class="price-line">
					<span class="label">상품 금액</span> <span class="value"> <fmt:formatNumber value="${sumPriceOrigin}" type="number" />원
					</span>
				</p>
				<p class="price-line">
					<span class="label">상품 할인 금액</span> <span class="value discount">- <fmt:formatNumber value="${sumPriceOrigin - sumPrice}" type="number" />원
					</span>
				</p>
				<hr class="divider" />
				<p class="price-line">
					<span class="label">할인 적용 소계</span> <span class="value"><fmt:formatNumber value="${sumPrice}" type="number" />원</span>
				</p>
				<p class="price-line">
					<span class="label">배송비</span> <span class="value"> <fmt:formatNumber value="${delivery}" type="number" />원
					</span>
				</p>

				<hr>
				<p class="price-line">
					<span class="label">포인트 사용</span> <span class="value" id="displayUsedPoint">- 0원</span>
				</p>
				<input type="number" id="usedPointInput" placeholder="0" min="0" style="width: 100%; margin-top: 5px;" />
				<button type="button" onclick="applyPoint()">포인트 적용</button>

				<hr>
				<p class="final-line">
					<span class="label">총 결제 금액</span> <span class="value total" id="finalPriceText"> <fmt:formatNumber value="${sumPrice + delivery}" type="number" />원
					</span>
				</p>

				<p style="font-size: 13px; color: #666;">
					적립 예정 포인트 <span id="expectedPoint">${(sumPrice * 0.05) - ((sumPrice * 0.05) % 1)}P</span>
				</p>
				<!-- ✅ 결제 버튼 -->

				<button type="button" onclick="goToKakaoPay()">결제하기</button>
			</div>
			<!-- summary-box 끝 -->
		</div>
		<!-- payment-content-row 끝 -->


	</div>
	<!-- payment-layout 끝 -->


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
	<input type="hidden" id="finalPriceHidden" value="${sumPrice + delivery}" />

	<!-- ✅ JS에서 넣어줄 것 -->
	<div id="orderData" style="display: none;">
		<c:forEach var="item" items="${orderList}">
			<input type="hidden" class="item-isbn" value="${item.isbn}" />
			<input type="hidden" class="item-count" value="${item.count}" />
			<input type="hidden" class="item-price" value="${item.price}" />
			<input type="hidden" class="item-original-price" value="${item.price / 0.9}" />

			<input type="hidden" class="item-title" value="${item.title}" />
			<input type="hidden" class="item-image" value="${item.imagePath}" />
		</c:forEach>
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
			const originalPrices = document
					.querySelectorAll(".item-original-price");
			const titles = document.querySelectorAll(".item-title");
			const images = document.querySelectorAll(".item-image");

			for (let i = 0; i < isbns.length; i++) {
				orderList.push({
					isbn : isbns[i].value,
					count : parseInt(counts[i].value),
					price : parseInt(prices[i].value),
					originalPrice : parseInt(originalPrices[i].value), // ✅ 정가 추가
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
