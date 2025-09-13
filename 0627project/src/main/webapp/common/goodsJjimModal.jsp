<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/CSS/loginmodal.css">
<script src="${pageContext.request.contextPath}/JS/cartmodal.js"></script>
	
<!-- 로그인 모달 -->
<div id="goodsJjimModal" class="login-modal-overlay">
	<div class="login-modal">
		<h2>성공적으로 찜 했습니다! 찜 목록으로 이동하겠습니까?</h2>
		<div class="modal-buttons">
			<button type="button" class="cancel-btn" onclick="goToJjim()">찜 목록으로 이동</button>
			<button type="button" class="confirm-btn" onclick="closeGoodsJjimModal()">쇼핑 계속하기</button>
		</div>
	</div>
</div>
	
<script>
	function closeGoodsJjimModal() {
	
		document.getElementById("goodsJjimModal").style.display = "none";
	}
	function goToJjim() {
		document.getElementById("goodsJjimModal").style.display = "none";
		window.location.href = contextPath + "/wishlist.do";
	}
	
</script>
