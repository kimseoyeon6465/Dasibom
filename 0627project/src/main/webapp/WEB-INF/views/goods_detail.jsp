<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GoodsMall</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/goods_detail.css">
</head>
<body>

	<jsp:include page="/common/header.jsp" />
	
	<jsp:include page="/common/loginmodal.jsp" />
	
	<jsp:include page="/common/goodsCartModal.jsp" />
	<jsp:include page="/common/goodsSameItemModal.jsp" />
	<jsp:include page="/common/goodsBuyModal.jsp" />
	<jsp:include page="/common/goodsNotLoginModal.jsp" />
	<jsp:include page="/common/goodsSameJjimItemModal.jsp" />
	<jsp:include page="/common/goodsJjimModal.jsp" />
	
	
	<!-- 로그인 여부 변수 -->
	<script>
	    const isLoggedIn = "${sessionScope.user_seq == null ? 'false' : 'true'}";
	    const contextPath = "${pageContext.request.contextPath}";
	</script>
	
<div class="wrapper">
    <div class="wrap">
	
       <!-- 굿즈 상세 -->
       <div class="content_top">
       
		<!-- 사진 좌우로 넘기기  -->
			<div class="goods-slider">
			    <div class="main-image-wrapper">
			        <div class="main-image">
			            <img id="mainImage" src="${pageContext.request.contextPath}${photoList[0].img_path}" alt="${goods.goods_name}">
			        </div>
			        <button class="slider-btn prev-btn" onclick="changeImage(-1)">&#10094;</button>
			        <button class="slider-btn next-btn" onclick="changeImage(1)">&#10095;</button>
			    </div>
			    <div class="thumbnail-list">
			        <c:forEach var="photo" items="${photoList}" varStatus="status">
			            <img class="thumbnail" src="${pageContext.request.contextPath}${photo.img_path}" 
			                 alt="굿즈 이미지" onclick="showImage(${status.index})">
			        </c:forEach>
			    </div>
			</div>

            <div class="ct_right_area">
                <h1>${goods.goods_name}</h1>

                <p>정가 : <fmt:formatNumber value="${goods.price}" pattern="#,### 원" /></p>

                <p>
                    판매가 :
                    <fmt:formatNumber value="${goods.price * 0.9}" pattern="#,### 원" />
                    <span class="discount-highlight">[10% 할인]</span>
                </p>

                <p>
                    적립/혜택 : 
                    <fmt:formatNumber value="${goods.price * 0.05}" pattern="#,### 원" />
                    (구매 시 5% 적립됩니다)
                </p>

                <p>배송료 3000원 (5만원 이상 구매 시 무료배송)</p>

                <!-- 주문수량 -->
                <div class="button_quantity">
                    주문수량 
                    <input id="quantityInput" type="number" value="1" min="1" style="width:50px; text-align:center;">
                    <div class="quantity_controls" style="display:inline-block;">
                        <button type="button" onclick="changeQuantity(1)">▲</button>
                        <button type="button" onclick="changeQuantity(-1)">▼</button>
                    </div>
                </div>

                <!-- 버튼 영역 -->
                <div class="button_set" style="margin-top:20px;">
                    <!-- 장바구니 -->
                    <button type="button" class="btn_cart"
						    onclick="handleGoodsCartClickAjax('${goods.goods_Id}')">장바구니</button>
                   
                    <!-- 바로구매 -->
                    <button type="submit" class="btn_buy"
						onclick="handleGoodsBuyClickAjax('${goods.goods_Id}')">바로구매</button>

					<!-- 찜 버튼 -->
					<button type="button" class="btn_wish" 
						onclick="handleGoodsJjimClickAjax('${goods.goods_Id}')">찜하기 ♥</button>
                </div>
                
                
            </div>
        </div> <!-- content_top -->
    </div> <!-- wrap -->
</div> <!-- wrapper -->

		<!-- 상세 설명 이미지 -->
		<div class="content-section">
		    <div class="goods-detail">
			    <h1>상품정보</h1>		
			     <!-- 펼치기 영역 감싸기 -->
       			 <div class="goods-info-content" id="goodsDetail">
					<c:forEach var="photo" items="${photoList}">
				        <img class="goods-detail-img"
				             src="${pageContext.request.contextPath}${photo.img_path}" 
				             alt="${goods.goods_name} 상세이미지">
				    </c:forEach>			
				</div>
		
			 <!-- 펼치기 버튼 -->
	        <div class="goods-info-toggle" onclick="toggleGoodsDetail()">
	            <span id="toggleDetailBtn">상품 정보 펼치기 ▼</span>
	        </div>
	</div>
		
		    <!-- 구분 라인 -->
		    <hr class="section-divider">
		
		    <!-- 교환 환불 정책 -->
		    <%@ include file="/common/exchange_info.jsp" %>
		    <%@ include file="/common/footer.jsp" %>
		</div>

	<!-- JS: 주문수량 변경, 로그인 체크 -->
	<script>
	    function changeQuantity(amount) {
	        const input = document.getElementById("quantityInput");
	        let newValue = parseInt(input.value) + amount;
	        if (newValue < 1) newValue = 1;
	        input.value = newValue;
	        document.getElementById("paymentQuantity").value = newValue;
	        document.getElementById("cartQuantity").value = newValue;
	    }
	
	    document.addEventListener('DOMContentLoaded', function() {
	        const input = document.getElementById("quantityInput");
	        if (input) {
	            input.addEventListener("input", function() {
	                let val = parseInt(this.value);
	                if (isNaN(val) || val < 1) val = 1;
	                this.value = val;
	                document.getElementById("paymentQuantity").value = val;
	                document.getElementById("cartQuantity").value = val;
	            });
	        }
	    });
	
	    function handleCartSubmit() {
	        if (isLoggedIn == 'false') {
	            document.getElementById("loginModal").style.display = "flex";
	            document.querySelector('#loginModal input[name="redirect"]').value = "goods_detail.do?goods_id=${goods.goods_Id}";
	            return false;
	        }
	        return true;
	    }
	
	    function handlePaymentSubmit() {
	        if (isLoggedIn == 'false') {
	            document.getElementById("loginModal").style.display = "flex";
	            document.querySelector('#loginModal input[name="redirect"]').value = "goods_detail.do?goods_id=${goods.goods_Id}";
	            return false;
	        }
	        return true;
	    }
	
	    function handleWishSubmit() {
	        if (isLoggedIn == 'false') {
	            document.getElementById("loginModal").style.display = "flex";
	            document.querySelector('#loginModal input[name="redirect"]').value = "goods_detail.do?goods_id=${goods.goods_Id}";
	            return false;
	        }
	        return true;
	    }
	    
	    /* 썸네일용  */
	    function changeMainImage(src) {
	        document.getElementById("mainImage").src = src;
	    }
		
		/* 사진 좌우로 넘기기 */
	    let currentIndex = 0;
	    const imageList = [
	        <c:forEach var="photo" items="${photoList}" varStatus="status">
	            "${pageContext.request.contextPath}${photo.img_path}"<c:if test="${!status.last}">,</c:if>
	        </c:forEach>
	    ];

	    function changeImage(direction) {
	        currentIndex += direction;
	        if (currentIndex < 0) currentIndex = imageList.length - 1;
	        if (currentIndex >= imageList.length) currentIndex = 0;
	        document.getElementById("mainImage").src = imageList[currentIndex];
	    }

	    function showImage(index) {
	        currentIndex = index;
	        document.getElementById("mainImage").src = imageList[currentIndex];
	    }
	    
	    
	    function toggleGoodsDetail() {
	        const detail = document.getElementById('goodsDetail');
	        const btn = document.getElementById('toggleDetailBtn');

	        detail.classList.toggle('expanded');

	        if (detail.classList.contains('expanded')) {
	            btn.textContent = '상품 정보 접기 ▲';
	        } else {
	            btn.textContent = '상품 정보 펼치기 ▼';
	        }
	    }


	    
	</script>
	<script>
						async function handleGoodsCartClickAjax(goods_Id) {
						    if (!isLoggedIn || isLoggedIn === "false") {
						        document.getElementById("loginModal").style.display = "flex";
						        return;
						    }
					
						    try {
						    	const contextPath = "${pageContext.request.contextPath}";
						    	console.log(contextPath);
						    	
						    	const count = document.getElementById("quantityInput").value;
						        const response = await fetch(`/dasibom/checkGoodsCartItem.do?goods_Id=${goods.goods_Id}&count=`+count+`&image_Path=${photoList[0].img_path}`);
						        const result = await response.text(); // "empty" | "exist"
						        const cleanResult = result.trim().replace(/"/g, '');
					
						        if (cleanResult === "empty") {
						            document.getElementById("goodsCartModal").style.display = "flex";
						        } else if (cleanResult === "exist") {
						            document.getElementById("goodsSameItemModal").style.display = "flex";
						        }
					
						    } catch (e) {
						        console.error("장바구니 확인 실패", e);
						    }
						} 
					</script>
					
					<script>
						function handleGoodsBuyClickAjax(goods_Id) {
						    if (!isLoggedIn || isLoggedIn === "false") {
						        document.getElementById("goodsNotLoginModal").style.display = "flex";
						        return;
						    }
					
						    try {
						    	document.getElementById("goodsBuyModal").style.display = "flex";
					
						    } catch (e) {
						        console.error("구매 실패", e);
						    }
						} 
						
						async function goToBuy() {
							const contextPath = "${pageContext.request.contextPath}";
					    	const count = document.getElementById("quantityInput").value;
					    	alert(count + `${photoList[0].img_path} ${goods.goods_Id}`)
					        //const response = await fetch(`/dasibom/checkBuyItem.do?isbn=${book.isbn}&count=`+count+`&image_path=${book.image_Path}`);
						}
						</script>
					
					<script>
						async function handleGoodsJjimClickAjax(goods_Id) {
						    if (!isLoggedIn || isLoggedIn === "false") {
						        document.getElementById("loginModal").style.display = "flex";
						        return;
						    }
					
						    try {
						    	const contextPath = "${pageContext.request.contextPath}";
						    	
						    	const count = document.getElementById("quantityInput").value;
						        const response = await fetch(`/dasibom/checkGoodsJjimItem.do?goods_Id=${goods.goods_Id}&count=`+count+`&image_Path=${photoList[0].img_path}`);
						        const result = await response.text();
						        const cleanResult = result.trim().replace(/"/g, '');
					
						        if (cleanResult === "empty") {
						            document.getElementById("goodsJjimModal").style.display = "flex";
						        } else if (cleanResult === "exist") {
						            document.getElementById("goodsSameJjimItemModal").style.display = "flex";
						        }
					
						    } catch (e) {
						        console.error("찜목록 확인 실패", e);
						    }
						} 
					</script>

</body>
</html>
