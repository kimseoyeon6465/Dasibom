<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Welcome BookMall</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/CSS/bookview.css">

</head>
<body>
	<jsp:include page="/common/header.jsp" />
	<div>${sessionScope.user_seq}${sessionScope.cartStatus}</div>

	<!--  // 로그인 여부를 정확히 판단하는 안전한 방법 -->
	<script> 
	  const isLoggedIn = "${sessionScope.user_seq == null ? 'false' : 'true'}";
	  const contextPath = "${pageContext.request.contextPath}";
	</script>

	<jsp:include page="/common/loginmodal.jsp" />
	<jsp:include page="/common/notLoginModal.jsp" />
	<jsp:include page="/common/cartmodal.jsp" />
	<jsp:include page="/common/buyModal.jsp" />
	<jsp:include page="/common/sameitemmodal.jsp" />
	<jsp:include page="/common/sameJjimItemModal.jsp" />
	<jsp:include page="/common/jjimModal.jsp" />

	<!-- 로그인 사용자 ID 변수 선언 -->
	<c:set var="sessionUserId" value="${user.user_Id}" />

	<div class="wrapper">
		<div class="wrap">

			<!-- 도서 상세 -->
			<div class="content_top">
				<img class="content_img" src="${book.image_Path}"
					alt="${book.title}">

				<div class="ct_right_area">
					<h1>
						${book.title}
						<c:if test="${averageRating > 0}">
							<span class="average-rating"> <img
								src="${pageContext.request.contextPath}/IMG/flower.png" alt="벚꽃"
								class="rating-flower-icon"> <fmt:formatNumber
									value="${averageRating}" maxFractionDigits="1" />
							</span>
						</c:if>
					</h1>

					<h3>${book.author}지음</h3>
					<p>출판사 ${book.publisher} | 장르 ${book.genre}</p>
					<p>
						출판일
						<fmt:formatDate value="${book.pub_date}" pattern="yyyy년 MM월 dd일" />
					</p>
					<p>
						정가 :
						<fmt:formatNumber value="${book.price}" pattern="#,### 원" />
					</p>
					<c:set var="discountPrice"
						value="${book.price * book.discount_price}" />
					<c:set var="salePrice" value="${book.price - discountPrice}" />
					<p>
						판매가 :
						<fmt:formatNumber value="${book.discount_price}" pattern="#,### 원" />
						<span class="discount-highlight">[<fmt:formatNumber
								value="${10}" pattern="###" />% 할인]
						</span>
					</p>

					<p>
						적립/혜택 :
						<fmt:formatNumber value="${book.price * 0.05}" pattern="#,### 원" />
					</p>
					<p>배송료 3000원 (5만원 이상 구매시 무료)</p>

					<div class="button_quantity">
						주문수량 <input id="quantityInput" type="number" value="1" min="1">
						<div class="quantity_controls">
							<button onclick="changeQuantity(1)">▲</button>
							<button onclick="changeQuantity(-1)">▼</button>
						</div>
					</div>

					<%
					java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
					String today = sdf.format(new java.util.Date());
					%>

					<!-- 장바구니 버튼 -->
					<div class="button_set">
						<button type="button" class="btn_cart"
						    onclick="handleCartClickAjax('${book.isbn}')">장바구니</button>

						<!-- 바로구매 버튼 -->
						<button type="button" class="btn_buy"
							onclick="handleBuyClickAjax('${book.isbn}')">바로구매</button>

						<!-- 찜 버튼 -->
						<button type="button" class="btn_wish" 
							onclick="handleJjimClickAjax('${book.isbn}')">찜하기 ♥</button>
					</div>
					<script>
						async function handleCartClickAjax(isbn) {
						    if (!isLoggedIn || isLoggedIn === "false") {
						        document.getElementById("loginModal").style.display = "flex";
						        return;
						    }
					
						    try {
						    	const contextPath = "${pageContext.request.contextPath}";
						    	console.log(contextPath);
						    	
						    	const count = document.getElementById("quantityInput").value;
						        const response = await fetch(`/dasibom/checkCartItem.do?isbn=${book.isbn}&count=`+count+`&image_path=${book.image_Path}`);
						        const result = await response.text(); // "empty" | "exist"
						        const cleanResult = result.trim().replace(/"/g, '');
					
						        if (cleanResult === "empty") {
						            document.getElementById("cartModal").style.display = "flex";
						        } else if (cleanResult === "exist") {
						            document.getElementById("sameItemModal").style.display = "flex";
						        }
					
						    } catch (e) {
						        console.error("장바구니 확인 실패", e);
						    }
						} 
					</script>
					
					<script>
						function handleBuyClickAjax(isbn) {
						    if (!isLoggedIn || isLoggedIn === "false") {
						        document.getElementById("notLoginModal").style.display = "flex";
						        return;
						    }
					
						    try {
						    	document.getElementById("buyModal").style.display = "flex";
					
						    } catch (e) {
						        console.error("구매 실패", e);
						    }
						} 
						
						async function goToBuy() {
							const contextPath = "${pageContext.request.contextPath}";
					    	const count = document.getElementById("quantityInput").value;
					    	alert(count + `${book.image_Path} ${book.isbn}`)
					        //const response = await fetch(`/dasibom/checkBuyItem.do?isbn=${book.isbn}&count=`+count+`&image_path=${book.image_Path}`);
						}
						
						async function goToAnnoBuy() {
							const contextPath = "${pageContext.request.contextPath}";
					    	const count = document.getElementById("quantityInput").value;
					    	window.location.href = contextPath + `/guestOrderForm.do?isbn=${book.isbn}&count=` + count;
						}
						</script>
					
					<script>
						async function handleJjimClickAjax(isbn) {
						    if (!isLoggedIn || isLoggedIn === "false") {
						        document.getElementById("loginModal").style.display = "flex";
						        return;
						    }
					
						    try {
						    	const contextPath = "${pageContext.request.contextPath}";
						    	
						    	const count = document.getElementById("quantityInput").value;
						        const response = await fetch(`/dasibom/checkJjimItem.do?isbn=${book.isbn}&count=`+count+`&image_path=${book.image_Path}`);
						        const result = await response.text();
						        const cleanResult = result.trim().replace(/"/g, '');
					
						        if (cleanResult === "empty") {
						            document.getElementById("jjimModal").style.display = "flex";
						        } else if (cleanResult === "exist") {
						            document.getElementById("sameJjimItemModal").style.display = "flex";
						        }
					
						    } catch (e) {
						        console.error("찜목록 확인 실패", e);
						    }
						} 
					</script>
				</div>
			</div>
			<!-- content_top -->
		</div>
		<!-- wrap -->

		<!-- 줄거리 + 리뷰 영역 통일된 wrapper -->
		<div class="content-section">

			<!-- 줄거리 -->
			<div class="book-summary">
				<h1>상품정보</h1>
				<p>판매량 ${book.sales }부수의 대작!</p>
				<br>
				<h2>▶줄거리</h2>
				<br>
				<p>${book.summary}</p>
			</div>

			<!-- 리뷰 작성 폼 -->
			<div class="review-write-box">
				<h3>리뷰 작성</h3>
				<form id="reviewForm" action="reviewinsert.do" method="get">
					<input type="hidden" name="isbn" value="${book.isbn}"> <input
						type="hidden" name="page" value="BookView"> <input
						type="hidden" name="user_seq" value="${sessionScope.user_seq}">

					<input type="hidden" name="ccid" value="">

					<div class="flower-rating-input" data-rate="0">
						<c:forEach begin="1" end="5" var="i">
							<img src="${pageContext.request.contextPath}/IMG/noflower.png"
								data-index="${i}" data-state="0" alt="${i}점">
						</c:forEach>
					</div>
					<input type="hidden" id="reviewScore" name="review_score" value="0">

					<div class="review-textarea-wrapper">
						<textarea name="review_text"
							placeholder="리뷰를 작성해주세요. 주제와 무관한 댓글, 악플 등의 글은 삭제될 수 있습니다"></textarea>
						<button type="submit" class="cherry-blossom-button">리뷰 등록</button>
					</div>
				</form>
			</div>

			<!-- 리뷰 목록 -->
			<div id="review-section">
				<c:forEach var="review" items="${reviewList}">


					<div class="review-box">
						<!-- 리뷰 수정용 -->
						<div id="review-content-${review.review_Id}">
							<div class="flower-display"
								id="flower-display-${review.review_Id}"
								data-rating="${review.review_score}"></div>
							<p class="review-text-display"
								id="review-text-display-${review.review_Id}">${review.review_text}</p>
						</div>


						<!-- 수정 폼 -->
						<div id="editForm-${review.review_Id}" class="review-edit-form"
							style="display: none;">
							<form action="reviewupdate.do" method="get"
								onsubmit="return confirm('리뷰를 수정하시겠습니까?');">
								<input type="hidden" name="review_Id"
									value="${review.review_Id}"> <input type="hidden"
									name="isbn" value="${book.isbn}"> <input type="hidden"
									name="review_score" id="editScore-${review.review_Id}"
									value="3">
								<!-- 별점 UI 그대로 -->
								<div class="flower-rating-input-edit"
									data-review-id="${review.review_Id}" data-rate="0"
									style="margin-bottom: 5px;">
									<c:forEach begin="1" end="5" var="i">
										<img src="${pageContext.request.contextPath}/IMG/noflower.png"
											data-index="${i}" data-state="0" alt="${i}점">
									</c:forEach>
								</div>

								<!-- 텍스트 수정 입력폼 -->
								<textarea name="review_text" rows="4" style="width: 100%"></textarea>

								<!-- 등록,취소 버튼 (같은 위치에서 보기 좋게) -->
								<div class="edit-buttons">
									<button type="button"
										onclick="hideEditForm(${review.review_Id})"
										style="background-color: #888; color: white;">취소</button>
									<button type="submit"
										style="background-color: #9988ee; color: white;">등록</button>
								</div>
							</form>
						</div>

						<!-- 작성자/날짜/ 버튼들 영역 -->
						<div class="review-header">
							<p class="review-meta">
								작성자 :
								<c:choose>
									<c:when test="${user.user_Id == review.user_Id}">${review.user_Id}(작성자)</c:when>
									<c:otherwise>${fn:substring(review.user_Id, 0, 3)}***</c:otherwise>
								</c:choose>

								<!-- | 구분자 추가 -->
								<span class="divider">|</span> <span class="review-date-display">
									<fmt:formatDate value="${review.review_date}"
										pattern="yy/MM/dd" />
								</span>
							</p>

							<div class="review-actions">
								<!-- 작성자 본인만 수정, 삭제 가능 -->
								<!-- 오류 -->
								<c:if test="${user.user_Id == review.user_Id}">

									<!-- 수정 버튼 -->
									<button type="button"
										onclick="showEditForm(${review.review_Id},
						     				'${fn:escapeXml(review.review_text)}')">수정</button>


									<!-- 리뷰 삭제 -->
									<form action="reviewdelete.do" method="get"
										onsubmit="return confirm('리뷰를 삭제하시겠습니까? 모든 댓글들이 함께 삭제됩니다');">
										<input type="hidden" name="review_Id"
											value="${review.review_Id}"> <input type="hidden"
											name="isbn" value="${book.isbn}">
										<button type="submit">삭제</button>
									</form>
								</c:if>

								<!-- 좋아요 비회원이든 회원이든 한 번만 되게-->
								<form action="reviewlike.do" method="get" class="like-form"
									data-review-id="${review.review_Id}">
									<input type="hidden" name="review_Id"
										value="${review.review_Id}"> <input type="hidden"
										name="isbn" value="${book.isbn}">
									<button type="submit" class="like-button">👍 좋아요</button>
								</form>
								<!-- 오류 -->
								<!-- 대댓글 열기 버튼 -->
								<button type="button"
									onclick="toggleReplies(${review.review_Id})">💬 댓글</button>
							</div>
						</div>

						<!-- 댓글 전체 영역 -->
						<div class="reply-container"
							id="reply-container-${review.review_Id}"
							style="display: none; margin-left: 30px; margin-top: 10px;">

							<!-- 댓글 리스트 -->
							<div class="reply-section" id="reply-${review.review_Id}">
								<c:if test="${not empty commentMap[review.review_Id]}">
									<c:forEach var="reply" items="${commentMap[review.review_Id]}">
										<div class="reply-box">
											<p class="reply-text-display">${reply.review_comment_text}</p>
											<p class="reply-meta">
												작성자 :
												<c:choose>
													<c:when test="${user.user_Id == reply.user_Id}">${reply.user_Id}(작성자)</c:when>
													<c:otherwise>${fn:substring(reply.user_Id, 0, 3)}***</c:otherwise>
												</c:choose>
												<span class="divider">|</span> <span
													class="reply-date-display"> <fmt:formatDate
														value="${reply.review_comment_date}" pattern="yy/MM/dd" />
												</span>
											</p>
										</div>
									</c:forEach>
								</c:if>
							</div>

							<!-- 댓글 입력창 -->
							<div class="reply-input-section">
								<form id="replyForm"
									action="${pageContext.request.contextPath}/comment.do?action=insert"
									method="post" onsubmit="return handleReplySubmit();">
									<input type="hidden" name="review_Id"
										value="${review.review_Id}">
									<!-- 부모 리뷰 id -->
									<input type="hidden" name="isbn" value="${book.isbn}">
									<!-- redirect 용 -->
									<textarea name="review_comment_text"
										placeholder="1000자 이내로 입력해주세요." maxlength="1000"
										style="width: 100%; height: 80px;"></textarea>
									<div style="text-align: right; margin-top: 5px;">
										<button type="button"
											onclick="hideReplyInput(${review.review_Id})"
											style="background-color: #888; color: white; border: none; padding: 5px 10px;">취소</button>
										<button type="submit"
											style="background-color: #9988ee; color: white; border: none; padding: 5px 10px;">등록</button>
									</div>
								</form>
							</div>
							<c:if test="${not empty review.image_path}">
								<div class="review-image">
									<img
										src="${pageContext.request.contextPath}${review.image_path}"
										alt="리뷰 이미지" width="150" />
								</div>
							</c:if>
						</div>
						<!-- reply-container -->
					</div>
					<!-- review-box -->
				</c:forEach>
			</div>
			<!-- review-section -->
		</div>
		<!-- content-section -->
	</div>
	<!-- wrapper -->


	<!-- 리뷰 수정 폼 -->
	
	
	
	
	<script>
function showEditForm(reviewId, reviewText, reviewScore) {
    // 숨기기
    document.getElementById('review-content-' + reviewId).style.display = 'none';

    // textarea에 기존 텍스트
    const editForm = document.getElementById('editForm-' + reviewId);
    editForm.querySelector('textarea[name="review_text"]').value = reviewText;

    // 별점 초기값
    document.getElementById('editScore-' + reviewId).value = reviewScore;

    const flowerContainer = editForm.querySelector('.flower-rating-input-edit');
    flowerContainer.dataset.rate = reviewScore;

    const flowerImages = flowerContainer.querySelectorAll('img');
    flowerImages.forEach((img, i) => {
        const fullIndex = i + 1;
        img.src = reviewScore >= fullIndex ? filled : (reviewScore >= fullIndex - 0.5 ? half : empty);

        img.onclick = (e) => {
            const rect = img.getBoundingClientRect();
            const clickX = e.clientX - rect.left;
            const isHalf = clickX < rect.width / 2;

            const currentRating = isHalf ? i + 0.5 : i + 1;
            document.getElementById('editScore-' + reviewId).value = currentRating;
            flowerContainer.dataset.rate = currentRating;

            // 다시 렌더링
            flowerImages.forEach((img2, j) => {
                const index = j + 1;
                img2.src = currentRating >= index ? filled : (currentRating >= index - 0.5 ? half : empty);
            });
        };
    });

    // 수정폼 보이기
    editForm.style.display = 'block';
}

function hideEditForm(reviewId) {
    // 원래 보여주는 부분 복원
    document.getElementById('review-content-' + reviewId).style.display = 'block';
    document.getElementById('editForm-' + reviewId).style.display = 'none';
}

</script>


	<!-- 리뷰삭제 경고창 -->
	<script>
		    function confirmDelete() {
		        return confirm('리뷰를 삭제하시겠습니까?\n모든 댓글들이 함께 삭제됩니다.');
		    }
		</script>

	<!--  벚꽃점수 랜더링 -->
	<script>
		const ctx = "${pageContext.request.contextPath}";	
		// 벚꽃 이미지 경로
		const filled = ctx + "/IMG/flower.png";
		const half = ctx + "/IMG/flower_half.png";
		const empty = ctx + "/IMG/noflower.png";
			
		function renderFlowerRating() {
		    document.querySelectorAll('.flower-display').forEach(container => {
		        const rating = parseFloat(container.dataset.rating);
		        container.innerHTML = '';
		        for (let i = 1; i <= 5; i++) {
		            const img = document.createElement('img');
		            img.src = rating >= i ? filled : (rating >= i - 0.5 ? half : empty);
		            container.appendChild(img);
	        	}
			 });
		}
			
		// 벚꽃 점수 입력 UI
		document.addEventListener('DOMContentLoaded', function() {
			  // 1. 벚꽃 별점 렌더링 먼저 실행!
		    renderFlowerRating();
			
		 // 2. 벚꽃 별점 입력 기능 등록
		    const flowerContainer = document.querySelector('.flower-rating-input');
		    
		    if (flowerContainer) {
		        const flowerImages = flowerContainer.querySelectorAll('img');
		        const scoreInput = document.getElementById('reviewScore');
		        let currentRating = 0;
		
		
		    flowerImages.forEach((img, i) => {
		        img.addEventListener('click', (e) => {
		            const index = i;
		            const rect = img.getBoundingClientRect();
		            const clickX = e.clientX - rect.left;
		            const isHalf = clickX < rect.width / 2;
		
		            currentRating = isHalf ? index + 0.5 : index + 1;
		            scoreInput.value = currentRating;
		            flowerContainer.dataset.rate = currentRating;
		
		            updateFlowerImages(currentRating);
		        });
		    });
		
		    function updateFlowerImages(rating) {
		        flowerImages.forEach((img, i) => {
		            const fullIndex = i + 1;
		            if (rating >= fullIndex) {
		                img.src = filled;
		            } else if (rating >= fullIndex - 0.5) {
		                img.src = half;
		            } else {
		                img.src = empty;
		            }
		        });
		    }
		}
	});
			
			// 댓글 토글
			function toggleReplies(cid) {
			    const container = document.getElementById('reply-container-' + cid);
			    if (!container) return;
			
			    const isHidden = (container.style.display === 'none' || container.style.display === '');
			    container.style.display = isHidden ? 'block' : 'none';
			}	
			function hideReplyInput(cid) {
			    const container = document.getElementById('reply-container-' + cid);
			    if (container) container.style.display = 'none';
			}
		
			// 리뷰 등록 로그인 확인
			function handleReviewSubmit() {
			    const isLoggedIn = "${sessionScope.user_seq == null ? 'false' : 'true'}";
			    if (isLoggedIn == 'false') {
			        document.getElementById("loginModal").style.display = "flex";
			        return false;
			    }		
			    const score = document.getElementById('reviewScore').value;
			    if (score === '0') {
			        alert('점수를 선택해주세요.');
			        return false;
			    }
			    const reviewText = document.querySelector('#reviewForm textarea[name="review_text"]').value;
			    if (reviewText.trim() === '') {
			        alert('리뷰 내용을 입력해주세요.');
			        return false;
			    }	
			    return true;
			}

			// 대댓글 (ccid) 등록 로그인 확인
			function handleReplySubmit() {
			    const isLoggedIn = "${sessionScope.user_seq == null ? 'false' : 'true'}";
			    if (isLoggedIn == 'false') {
			        document.getElementById("loginModal").style.display = "flex";
			        return false;
			    }
			
			    const replyText = this.querySelector('textarea[name="review_text"]').value;
			    if (replyText.trim() === '') {
			        alert('댓글 내용을 입력해주세요.');
			        return false;
			    }
			
			    return true;
			}
			</script>
	</div>
	<!-- wrap -->
	</div>
	<!-- wrapper -->

	<div>${sessionScope.user_seq}</div>
	<%-- 	<img height = "50px" src = "${pageContext.request.contextPath}/IMG/Logo.png"/> --%>
	<!-- 구분 라인 -->
	<hr class="section-divider">

	<!--  교환 환불 정책 -->
	<%@ include file="/common/exchange_info.jsp"%>
	<%@ include file="/common/footer.jsp"%>

	<script>
	// changeQuantity(주문수량) 함수는 전역으로 정의 (버튼에서 직접 호출)
		  function changeQuantity(amount) {
		    const input = document.getElementById("quantityInput");
		    let newValue = parseInt(input.value) + amount;
		    if (newValue < 1) newValue = 1;
		    input.value = newValue;
		    document.getElementById("paymentQuantity").value = newValue;
		    document.getElementById("cartQuantity").value = newValue;
		  }
		
		  document.addEventListener('DOMContentLoaded', function() {
		
		    // 주문수량 input 이벤트
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
		
	// 로그인 체크 (공통) // payment,cart,wish
		<!-- 로그인 여부 변수 설정-->
		const isLoggedIn = "${sessionScope.user_seq == null ? 'false' : 'true'}";
			
			// 결제 ,장바구니 , 찜하기 로그인 체크
		    function handleCartSubmit() {
			    const isLoggedIn = "${sessionScope.user_seq == null ? 'false' : 'true'}";
			    if (isLoggedIn == 'false') {
			        document.getElementById("loginModal").style.display = "flex";
			        document.querySelector('#loginModal input[name="redirect"]').value = "bookview.do?isbn=${book.isbn}";
			        return false;
			    }
			    return true;
			}
			
			function handlePaymentSubmit() {
			    const isLoggedIn = "${sessionScope.user_seq == null ? 'false' : 'true'}";
			    if (isLoggedIn == 'false') {
			        document.getElementById("loginModal").style.display = "flex";
			        document.querySelector('#loginModal input[name="redirect"]').value = "bookview.do?isbn=${book.isbn}";
			        return false;
			    }
			    return true;
			}
			
			function handleWishSubmit() {
			    const isLoggedIn = "${sessionScope.user_seq == null ? 'false' : 'true'}";
			    if (isLoggedIn == 'false') {
			        document.getElementById("loginModal").style.display = "flex";
			        document.querySelector('#loginModal input[name="redirect"]').value = "bookview.do?isbn=${book.isbn}";
			        return false;
			    }
			    return true;
			}

			// 리뷰 등록
		    const reviewForm = document.getElementById("reviewForm");
		    if (reviewForm) {
		        reviewForm.addEventListener("submit", function(e) {
		            if (isLoggedIn == 'false') {
		                e.preventDefault();
		                document.getElementById("loginModal").style.display = "flex";
		                document.querySelector('#loginModal input[name="redirect"]').value = "bookview.do?isbn=${book.isbn}";
		                return;
		            }

		            const score = document.getElementById('reviewScore').value;
		            if (score === '0') {
		                e.preventDefault();
		                alert('점수를 선택해주세요.');
		                return;
		            }

		            const reviewText = document.querySelector('#reviewForm textarea[name="review_text"]').value;
		            if (reviewText.trim() === '') {
		                e.preventDefault();
		                alert('리뷰 내용을 입력해주세요.');
		                return;
		            }
		        });
		    } 
		    	
		    // 좋아요버튼 localStorage 또는 localStorage 사용
		    const likedReviews = JSON.parse(localStorage.getItem('likedReviews') || '[]');
		
		    document.querySelectorAll('.like-form').forEach(form => {
		        const reviewId = form.dataset.reviewId;
		
		        // 이미 눌렀으면 버튼 비활성화
		        if (likedReviews.includes(reviewId)) {
		            form.querySelector('button').disabled = true;
		            form.querySelector('button').innerText = "좋아요 완료";
		        }
		
		        // submit 시 중복 체크
		        form.addEventListener('submit', function(e) {
		            if (likedReviews.includes(reviewId)) {
		                e.preventDefault();
		                alert("이미 좋아요를 누르셨습니다.");
		                return;
		            }
		            // 비회원이라도 1번 가능
		            likedReviews.push(reviewId);
		            localStorage.setItem('likedReviews', JSON.stringify(likedReviews));
		        });
		    });
		});
		</script>
</body>
</html>