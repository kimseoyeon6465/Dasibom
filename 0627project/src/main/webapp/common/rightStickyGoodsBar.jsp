<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
   .sticky-goods-bar {
       position: fixed;
       top: 160px; /* 헤더와 거리 */
       right: 40px;      /* 스코롤이랑 거리 */
       width: 120px;
       background-color: #ffeef3; /* 연한 분홍색 배경 */
       border: 1px solid #f0d9df; /* 연한 테두리 */
       box-shadow: 0 2px 8px rgba(0,0,0,0.15);
       padding: 16px 12px;
       border-radius: 12px;
       z-index: 999;
       display: flex;
       flex-direction: column;
       gap: 20px;
   }
   
   .sticky-goods-card {
       text-align: center;
   }
   
   .sticky-goods-card img {
       width: 100%;
       border-radius: 8px;
       object-fit: cover;
       box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* 살짝 입체감 */
   }
   
   .sticky-goods-card p {
       font-size: 14px;
       margin-top: 8px;
       color: #333;
       word-break: keep-all;
       margin-bottom: 4px;  /*글자, 버튼 사이 간격  */
   }
   


/* 굿즈 보러가기 버튼 */
   .goods-link-btn {
     /*   margin-top: 2px; */      /*글자, 버튼 사이 간격  */
       padding: 10px 14px;
       background-color: #fdfdfd;   /* 흰색에 가까운 아이보리색 */
       color: #ec6792;   /* 폰트색 */
       font-size: 14px;
       font-weight: 600;
       letter-spacing: 0.5px;
       border: none;
       border-radius: 10px;
       cursor: pointer;
       box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
       transition: all 0.25s ease-in-out;
       text-align: center;
   }
   
   .goods-link-btn:hover {
       background-color: #ffb6c1;
       transform: scale(1.03);
       box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
   }

</style>
</head>
   <body>
      <div class="sticky-goods-bar">
          <div class="sticky-goods-card">
              <img src="${pageContext.request.contextPath}/IMG/side1.png" alt="사이드굿즈1">
              <p>벚꽃 무드등</p>
          </div>
          <div class="sticky-goods-card">
              <img src="${pageContext.request.contextPath}/IMG/side2.png" alt="사이드굿즈2">
              <p>다시,봄 텀블러</p>
          </div>
          
          <!-- 굿즈샵 버튼 추가 -->
            <button class="goods-link-btn" onclick="location.href='${pageContext.request.contextPath}/goods_list.do'">굿즈 보러가기</button>
      </div>

   </body>
</html>