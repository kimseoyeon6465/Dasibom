<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니 목록</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="/dasibom/CSS/cartAll.css">
</head>
<body>
	<jsp:include page="/common/header.jsp" />

	<h1>나의 장바구니</h1>
	<hr>
	<!-- -------------------------update-start------------------------------ -->
	<c:if test="${empty sessionScope.userId}">
		<script>
			alert("로그인이 필요합니다.");
			location.href = "loginPage.jsp";
		</script>
	</c:if>
	<!-- -------------------------update-end------------------------------ -->

	<form id="cartForm" action="deleteCart.do" method="post">
		<div style="text-align: left; margin: 0 5%;">
			<label><input type="checkbox" id="selectAll" /> 전체선택</label>
		</div>

		<table>
			<thead>
				<tr>
					<th>선택</th>
					<th>상품</th>
					<th>가격</th>
					<th>수량</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="imsi" items="${alist}">
					<tr class="cart_info_td" data-isbn="${imsi.isbn}">
						<td><input type="checkbox" name="checkedItems"
							value="${imsi.isbn}" class="individual_cart_checkbox"
							data-image="${imsi.imagePath}" data-title="${imsi.title}"
							data-count="${imsi.count}" data-price="${imsi.price}" /></td>
						<td><img src="${imsi.imagePath}" alt="책 이미지" width="140"><br>
							${imsi.title}</td>
						<td><span class="original-price"><fmt:formatNumber
									value="${imsi.price}" type="number" /></span><br> <span
							class="discounted-price"><fmt:formatNumber
									value="${imsi.price * 0.9}" type="number" /></span></td>

						<td>
							<button type="button" class="decrease-btn">-</button> <span
							class="book-count">${imsi.count}</span>
							<button type="button" class="increase-btn">+</button>
						</td>
						<input type="hidden" class="individual_bookPrice_input"
							value="${imsi.price * 0.9}">

						<input type="hidden" class="individual_bookCount_input"
							value="${imsi.count}">
						<input type="hidden" class="individual_totalPrice_input"
							value="${(imsi.price*0.9) * imsi.count}">
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<br>
		<button type="submit">선택한 항목 삭제</button>
		<button type="button" onclick="moveToWishlist()">보관함으로 이동</button>
		<button type="button" id="orderSelectedBtn">선택상품 결제하기</button>
	</form>

	<hr>
	<p>
		총 가격: <span class="totalPrice_span"></span>원
	</p>
	<p>
		총 수량: <span class="totalCount_span"></span>권
	</p>
	<p>
		배송비: <span class="delivery_price"></span>원
	</p>
	<p>
		최종 합계: <span class="finalTotalPrice_span"></span>원
	</p>

	<script>
		$("#selectAll").on("click", function() {
			$(".individual_cart_checkbox").prop("checked", this.checked);
			setTotalInfo();
		});

		$(document)
				.on(
						"click",
						".individual_cart_checkbox",
						function() {
							const allChecked = $(".individual_cart_checkbox").length === $(".individual_cart_checkbox:checked").length;
							$("#selectAll").prop("checked", allChecked);
							setTotalInfo();
						});

		function setTotalInfo() {
			let totalPrice = 0;
			let totalCount = 0;
			let deliveryPrice = 0;
			let finalTotalPrice = 0;

			$(".individual_cart_checkbox:checked").each(
					function() {
						const row = $(this).closest(".cart_info_td");
						totalPrice += parseInt(row.find(
								".individual_totalPrice_input").val());
						totalCount += parseInt(row.find(
								".individual_bookCount_input").val());
					});

			deliveryPrice = (totalPrice >= 50000 || totalPrice === 0) ? 0
					: 3000;
			finalTotalPrice = totalPrice + deliveryPrice;

			$(".totalPrice_span").text(totalPrice.toLocaleString());
			$(".totalCount_span").text(totalCount);
			$(".delivery_price").text(deliveryPrice.toLocaleString());
			$(".finalTotalPrice_span").text(finalTotalPrice.toLocaleString());
		}

		$(document).ready(function() {
			setTotalInfo();
		});

		$(document)
				.on(
						"click",
						".increase-btn, .decrease-btn",
						function() {
							const row = $(this).closest("tr");
							const isbn = row.data("isbn");

							const countSpan = row.find(".book-count");
							let count = parseInt(countSpan.text());

							if ($(this).hasClass("increase-btn")) {
								count++;
							} else if ($(this).hasClass("decrease-btn")
									&& count > 1) {
								count--;
							} else {
								return;
							}

							countSpan.text(count);
							row.find(".individual_bookCount_input").val(count);

							const price = parseInt(row.find(
									".individual_bookPrice_input").val());
							row.find(".individual_totalPrice_input").val(
									count * price);

							row.find(".individual_cart_checkbox").prop(
									"checked", true);
							const allChecked = $(".individual_cart_checkbox").length === $(".individual_cart_checkbox:checked").length;
							$("#selectAll").prop("checked", allChecked);

							setTotalInfo();

							$.ajax({
								url : "modifyCartCount.do",
								method : "POST",
								data : {
									isbn : isbn,
									count : count
								},
								success : function(res) {
									if (res === "login-required") {
										alert("로그인이 필요합니다.");
										location.href = "loginPage.jsp";
									} else if (res !== "success") {
										alert("서버 오류 발생");
									}
								},
								error : function() {
									alert("요청 실패");
								}
							});
						});

		function moveToWishlist() {
			const checked = $(".individual_cart_checkbox:checked");
			if (checked.length === 0) {
				alert("이동할 항목을 선택해주세요.");
				return;
			}

			const userId = "${sessionScope.userId}";
			let completed = 0;
			let duplicated = [];

			checked.each(function() {
				const isbn = $(this).val();
				const image = $(this).data("image");

				$.ajax({
					url : "moveToWishlist.do",
					method : "POST",
					data : {
						userId : userId,
						isbn : isbn,
						imagePath : image
					},
					success : function(res) {
						if (res === "duplicated") {
							duplicated.push(isbn);
						}
					},
					error : function() {
						alert("에러 발생. 관리자에게 문의하세요.");
					},
					complete : function() {
						completed++;
						if (completed === checked.length) {
							if (duplicated.length > 0) {
								alert("일부 항목은 이미 보관함에 존재합니다.");
							} else {
								alert("보관함으로 이동 완료!");
							}
						}
					}
				});
			});
		}

		// 선택상품 결제
		$("#orderSelectedBtn")
				.on(
						"click",
						function() {
							const checkedItems = $(".individual_cart_checkbox:checked");
							if (checkedItems.length === 0) {
								alert("결제할 상품을 선택해주세요.");
								return;
							}

							const form = $("<form>", {
								method : "POST",
								action : "order.do"
							});

							form.append($("<input>", {
								type : "hidden",
								name : "userId",
								value : "${sessionScope.userId}"
							}));

							checkedItems.each(function() {
								const isbn = $(this).val();
								const count = $(this).closest("tr").find(
										".individual_bookCount_input").val();
								const price = $(this).closest("tr").find(
										".individual_bookPrice_input").val();

								form.append($("<input>", {
									type : "hidden",
									name : "isbnList",
									value : isbn
								}));
								form.append($("<input>", {
									type : "hidden",
									name : "countList",
									value : count
								}));
								form.append($("<input>", {
									type : "hidden",
									name : "priceList",
									value : Math.floor(price)
								}));
							});

							$("body").append(form);
							form.submit();
						});
	</script>


	<jsp:include page="/common/footer.jsp" />
</body>
</html>
