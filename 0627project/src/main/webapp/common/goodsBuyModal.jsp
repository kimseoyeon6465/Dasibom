<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/CSS/loginmodal.css">
<script src="${pageContext.request.contextPath}/JS/cartmodal.js"></script>

<!-- 로그인 모달 -->
<div id="goodsBuyModal" class="login-modal-overlay">
	<div class="login-modal">
		<h2>상품을 바로 구매하시겠습니까?</h2>
		<div class="modal-buttons">
			<button type="button" class="cancel-btn" onclick="goToBuy()">구매하기</button>
			<button type="button" class="confirm-btn" onclick="closeGoodsBuyModal()">쇼핑 계속하기</button>
		</div>
	</div>
</div>

<script>
	function closeGoodsBuyModal() {
	
		document.getElementById("goodsBuyModal").style.display = "none";
	}
	
</script>
