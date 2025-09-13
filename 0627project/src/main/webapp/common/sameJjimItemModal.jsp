<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/CSS/loginmodal.css">
<script src="${pageContext.request.contextPath}/JS/cartmodal.js"></script>
	
<!-- 로그인 모달 -->
<div id="sameJjimItemModal" class="login-modal-overlay">
	<div class="login-modal">
		<h2>이미 같은 상품이 찜 목록에 있습니다. 찜 목록으로 이동하시겠습니까?</h2>
		<div class="modal-buttons">
			<button type="button" class="cancel-btn" onclick="goToJjim()">찜 목록으로 이동</button>
			<button type="button" class="confirm-btn" onclick="closeJjim22Modal()">쇼핑 계속하기</button>
		</div>
	</div>
</div>
	
<script>
	function closeJjim22Modal() {
		document.getElementById("sameJjimItemModal").style.display = "none";
		
	}
	function goToJjim() {
		document.getElementById("sameJjimItemModal").style.display = "none";
		window.location.href = contextPath + "/wishlist.do";
	}
	
</script>
