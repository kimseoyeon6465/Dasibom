<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>이벤트 리스트</title>
    
    <!-- Swiper CSS -->
	<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
    
    
    <style>
    
    .swiper-container {
	    width: 100%;
	    max-width: 1200px;
	    height: 350px;
	    margin: 20px auto;
	    border-radius: 12px;
	    overflow: hidden;
	    position: relative;  /* ⭐⭐ 이거 꼭 추가 ⭐⭐ */
	}

	.swiper-slide img {
	    width: 100%;
	    height: 100%;
	    object-fit: contain;
	}
        .event-list-title {
            font-size: 24px;
            font-weight: bold;
            margin: 30px 0 20px 20px;
        }

        .event-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr); /* 3열 그리드 */
            gap: 20px;
            padding: 0 20px 40px 20px;
        }

        .event-item {
            border: 1px solid #eee;
            padding: 10px;
            border-radius: 8px;
            text-align: center;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .event-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-5px);
        }

        .event-item img {
            width: 100%;
            height: 300px;  /* 이미지 세로 길이 늘림 */
            object-fit: cover;
            border-radius: 5px;
        }

        .event-name {
            font-size: 20px;
            font-weight: bold;
            margin: 10px 0 5px 0;
            color: #333;
        }

        .subtitle {
            font-size: 16px;
            color: #000;
        }

        .event-discount {
            color: red;
            font-weight: bold;
            margin-right: 5px;
        }
    </style>
</head>
<body>

    <jsp:include page="/common/header.jsp" />
    
	<div class="swiper-container">
	    <div class="swiper-wrapper">
	        <c:forEach var="event" items="${eventList}">
	            <div class="swiper-slide">
	                <img src="${pageContext.request.contextPath}/${event.image_path}" alt="${event.title}">
	            </div>
	        </c:forEach>
	    </div>
	
	    <!-- ⭐️ 양옆 버튼 추가 -->
	    <div class="swiper-button-prev"></div>
	    <div class="swiper-button-next"></div>
	</div>


    <div class="event-list-title">추천 이벤트</div>

    <div class="event-grid">
        <c:forEach var="event" items="${eventList}">
<%--             <div class="event-item" onclick="location.href='event_detail.do?event_Id=${event.event_Id}'"> --%>

                <div class="event-item" onclick="location.href='${pageContext.request.contextPath}/attendance.do'">
                <img src="${pageContext.request.contextPath}/${event.image_path}" alt="${event.title}">
                <div class="event-name">${event.title}</div>
					<div class="subtitle">
					    <span class="goods-discount">[이벤트] ${event.subtitle}</span>
					</div>
           		</div>
        </c:forEach>
    </div>
    
	 <%@ include file="/common/footer.jsp" %>
    
    	<!-- Swiper JS -->
		<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
		
		<script>
		    var swiper = new Swiper('.swiper-container', {
		        loop: true,
		        autoplay: {
		            delay: 2000,
		            disableOnInteraction: false
		        },
		        speed: 1000,
		        slidesPerView: 1,
		        spaceBetween: 10,
		
		        navigation: {
		            nextEl: '.swiper-button-next',
		            prevEl: '.swiper-button-prev'
		        }
		    });
		</script>


</body>
</html>
