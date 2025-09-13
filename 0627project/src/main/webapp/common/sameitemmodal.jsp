<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/loginmodal.css">
<script src="${pageContext.request.contextPath}/JS/sameItemModal.js"></script>

<!-- 로그인 모달 -->
<div id="sameItemModal" class="login-modal-overlay">
	<div class="login-modal">
		<h2>이미 같은 상품이 장바구니에 담겨져 있습니다.</h2>
		<form action = "login.do" method="get"> 
			<div class="modal-buttons">
				<button type="button" class="cancel-btn" onclick="goToCart()">장바구니로 이동</button>
				<button type="button" class="confirm-btn" onclick="closeSameItemModal()">닫기</button>
			</div>
		</form>
	</div>
</div>

