<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜리스트 목록</title>

<!-- ✅ jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link rel="stylesheet" 
	href="/dasibom/CSS/wishlist.css">

<!-- ✅ 체크된 항목을 장바구니에 추가 -->
<script>
	function addSelectedToCart() {
		const checkedItems = $("input[name='checkedItems']:checked");
		if (checkedItems.length === 0) {
			alert("추가할 책을 선택하세요.");
			return;
		}

		let completed = 0;
		const total = checkedItems.length;

		checkedItems.each(function() {
			const isbn = $(this).val();
			const imagePath = $(this).data("image");

			$.ajax({
				url : 'moveToCart.do',
				method : 'POST',
				data : {
					userId : 'user01',
					isbn : isbn,
					imagePath : imagePath
				},
				success : function() {
					completed++;
					if (completed === total) {
						if (confirm("장바구니에 추가되었습니다.\n장바구니로 이동하시겠습니까?")) {
							location.href = "cartAll.do";
						}
					}
				},
				error : function(xhr) {
					alert("에러 발생: " + xhr.status + "\n" + xhr.responseText);
				}
			});
		});
	}

	// ✅ 전체 선택 기능
	$(document).ready(function() {
		$("#selectAll").on("click", function() {
			$(".individual_checkbox").prop("checked", $(this).is(":checked"));
		});

		$(document).on("click", ".individual_checkbox", function() {
			const all = $(".individual_checkbox").length;
			const checked = $(".individual_checkbox:checked").length;
			$("#selectAll").prop("checked", all === checked);
		});
	});
</script>

</head>
<body>
	<jsp:include page="/common/header.jsp" />
	<h1>보관함</h1>
	<hr>
<!-- -------------------------update-start------------------------------ -->
	<%-- <c:if test="${empty sessionScope.user_Id}">
		<script>
			alert("로그인이 필요합니다.");
			location.href = "loginPage.jsp";
		</script>
	</c:if> --%>
<!-- -------------------------update-end------------------------------ -->

	<form id="wishlistForm" method="post">
		<input type="hidden" name="userId" value="user01" />

		<table>
			<thead>
				<tr>
					<th colspan="4" style="text-align: left; padding-left: 20px;">
						<input type="checkbox" id="selectAll" /> <label for="selectAll">전체
							선택</label>
					</th>
				</tr>
			</thead>
			
			
			
			<tbody>
			  <c:forEach var="imsi" items="${wlist}" varStatus="status">
			    <tr>
			      <td colspan="4">
			        <div class="wishlist-row">
			          
			          <!-- 체크박스 -->
			          <input type="checkbox" name="checkedItems"
			            class="individual_checkbox" value="${imsi.isbn}"
			            data-image="${imsi.image_Path}" />
			
			          <!-- 책 이미지 -->
			          <img src="${imsi.image_Path}" alt="${imsi.title}" />
			
			          <!-- 책 정보 -->
			          <div class="wishlist-info">
			            <p class="book-title">${imsi.title}</p>
			            <%-- <p class="book-author">${imsi.author}</p> --%> <%-- author 사용 안 할 거면 주석 처리 OK --%>
			          </div>
			
			          <!-- 버튼 2개를 옆으로 -->
			          <div class="wishlist-buttons">
			            <button type="button" onclick="addSelectedToCart()">장바구니</button>
			            <button type="submit" formaction="deleteWishlist.do">삭제</button>
			          </div>
			
			        </div>
			      </td>
			    </tr>
			  </c:forEach>
			  
			  
			</tbody>
			
			
<%-- 			 <tbody>
				<tr>
					<c:forEach var="imsi" items="${wlist}" varStatus="status">
						<td>
							<div class="wishlist_item">
								<input type="checkbox" name="checkedItems"
									class="individual_checkbox" value="${imsi.isbn}"
									data-image="${imsi.imagePath}" /> <img src="${imsi.imagePath}"
									alt="책 이미지" /> <span>${imsi.title}</span>
							</div>

						</td>
						<c:if test="${(status.index + 1) % 4 == 0}">
				</tr>
				<tr>
					</c:if>
					</c:forEach>
				</tr>
			</tbody> --%>
			
			
		</table>
		<!-- ✅ 페이징 UI -->
		<div style="text-align: center; margin-top: 20px;">
			<c:forEach var="i" begin="1" end="${totalPages}">
				<c:choose>
					<c:when test="${i == currentPage}">
						<strong>[${i}]</strong>
					</c:when>
					<c:otherwise>
						<a href="wishlist.do?page=${i}">[${i}]</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</div>

		<!-- ✅ 버튼 영역 -->
<!-- 	 	<br>
		<button type="button" onclick="addSelectedToCart()">장바구니에 추가</button>
		<button type="submit" formaction="deleteWishlist.do">보관함에서 삭제</button>
  -->
  
 	</form>
	<jsp:include page="/common/footer.jsp" />
</body>
</html>