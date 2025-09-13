<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>중고도서 상세 보기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/junggo_view.css">
    <script src="${pageContext.request.contextPath}/resources/js/junggo_view.js" defer></script>
</head>
<body>

   <jsp:include page="/common/header.jsp" />
   <div class = "div-body">
      <!-- 제목 영역 -->
      <div class="title-date-box">
        <div class="title-heading">${book.title}</div>
        <p>게시글 작성 날짜: 
          <fmt:formatDate value="${book.post_date}" pattern="yyyy년 MM월 dd일 (E)" />
        </p>
      </div>

<div class="book-detail-container">
     <div class="bookimage">
         <img class="slide" src="${book.image_path}" />
         <button class = id="prevBtn">이전</button>
         <button id="nextBtn">다음</button>
     </div>

     <div class="book-info-box">
       <!-- 제목 및 가격 강조 -->
       <h2>${book.title}</h2>
       <p class="price">${book.price}원</p>
   
       <!-- 기타 정보들 -->
       <p class="info-item">판매자 아이디 : ${book.user_id}</p>
       <p class="info-item">판매상태 : ${book.sale_status}</p>
       <p class="info-item">상품 상태 : ${book.content}</p>
       <p class="info-item">결제 방법 : 카카오페이</p>
       

     <!-- 버튼 영역 -->
       <div class="action-buttons">
         <form action="${pageContext.request.contextPath}/chat.do" method="get">
           <input type="hidden" name="sellerId" value="${book.user_id}" />
           <button type="submit" class="chat-btn">구매 문의 채팅</button>
         </form>
       </div>
     </div>
   </div>

<hr>

   <!-- 상품 설명 -->
   <div class="product-info-heading">상품 정보</div>
   <br>
   <p>${book.content}</p>
   
   <p>구매 문의는 채팅을 통해 이루어집니다. 상단의 구매 문의 채팅을 눌러주세요.</p>
   
   <!-- 하단 버튼 영역 -->
   <form action="${pageContext.request.contextPath}/junggo_write.do" method="get" class="bottom-buttons" style="display:inline;">
     <button type="submit" class="basic-button">글쓰기</button>
   </form>
   
   <form action="${pageContext.request.contextPath}/junggo_list.do" method="get" class="bottom-buttons" style="display:inline;">
     <button type="submit" class="basic-button">목록</button>
   </form>
 
 <!-- 교환 환불 정책 -->
    <jsp:include page="/common/exchange_info.jsp" />
   <jsp:include page="/common/footer.jsp" />

</body>
</html>
