<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/loginmodal.css">
<script src="${pageContext.request.contextPath}/JS/cartmodal.js"></script>

<!-- 로그인 모달 -->
<div id="goodsCartModal" class="login-modal-overlay">
	<div class="login-modal">
		<h2>성공적으로 장바구니에 담겼습니다! 장바구니로 이동하겠습니까?</h2>
		<form action = "login.do" method="get"> 
			<div class="modal-buttons">
				<button type="button" class="cancel-btn" onclick="goToCart2()">장바구니로 이동</button>
				<button type="button" class="confirm-btn" onclick="closeGoodsCartModal()">쇼핑 계속하기</button>
			</div>
		</form>
	</div>
</div>

<script>

function closeGoodsCartModal() {

	document.getElementById("goodsCartModal").style.display = "none";
	
}
	
function goToCart2() {
	document.getElementById("goodsCartModal").style.display = "none";
	window.location.href = contextPath + "/cartAll.do";
}
</script>