<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석체크이벤트</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/attendance.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>
	<jsp:include page="/common/header.jsp" />

	 <!--  // 로그인 여부를 정확히 판단하는 안전한 방법 -->
	<script> 
	  const isLoggedIn = "${sessionScope.user_seq == null ? 'false' : 'true'}";
	</script>
	
	<div>${sessionScope.user_seq} </div>
	
	<!-- 로그인 모달 (공통) -->
		<div id="loginModal" class="login-modal-overlay" style="display: none;">
		    <form action="${pageContext.request.contextPath}/login.do" method="get">
		        <input type="hidden" name="redirect" value="attendance.do">
		        <div class="login-modal">
		            <h2>로그인 후 이용가능합니다</h2>
		            <p>로그인 페이지로 이동하시겠습니까?</p>
		            <div class="modal-buttons">
		                <button type="button" class="cancel-btn" onclick="closeLoginModal()">취소</button>
		                <button type="submit" class="confirm-btn">확인</button>
		            </div>
		        </div>
		    </form>
		</div>

		<script>
		    function closeLoginModal() {
		        document.getElementById("loginModal").style.display = "none";
		    }
		
		    function goToLogin() {
		        const afterLogin = location.pathname + location.search;
		        window.location.href = "${pageContext.request.contextPath}/login.do?redirect=" + encodeURIComponent(afterLogin);
		    }
		</script>

<!-- 로그인 사용자 ID 변수 선언 -->
	<c:if test="${not empty sessionScope.user}">
	    <c:set var="sessionUserId" value="${sessionScope.user.user_Id}" />
	</c:if>	  
	
	
	 <!-- 구분 라인 -->	   
	    
	    
	    
	    <div class="attendance-wrapper">

    <div class="attendance-header">
        <h2>6월 출석체크</h2>
        <div class="attendance-sub">
            <span>총 ${attendanceCount}회 참여 🔥</span>
        </div>
    </div>

    <div class="attendance-calendar">
        <table>
            <thead>
                <tr>
                    <th>일</th>
                    <th>월</th>
                    <th>화</th>
                    <th>수</th>
                    <th>목</th>
                    <th>금</th>
                    <th>토</th>
                </tr>
            </thead>
            <tbody>
			    <c:forEach var="week" items="${calendar}">
			        <tr>
			            <c:forEach var="day" items="${week}">
			                <td>
			                    <c:if test="${day.day > 0}">
			                        <div class="day-circle 
									    <c:if test='${day.checked}'>
									        <c:choose>
									            <c:when test="${day.today}">
									                today-checked
									            </c:when>
									            <c:otherwise>
									                past-checked
									            </c:otherwise>
									        </c:choose>
									    </c:if>">
									    ${day.day}
									</div>
			                    </c:if>
			                </td>
			            </c:forEach>
			        </tr>
			    </c:forEach>
			</tbody>
        </table>
    </div>

    <button id="btnAttendance" class="attendance-btn">출석하기</button>

</div>
<hr><hr>	    
	    <!--  이벤트 정책 설명-->
	    <%@ include file="/common/event_info.jsp" %>	    
	    <%@ include file="/common/footer.jsp" %>


	<script>	
	
	
	 $("#btnAttendance").click(function() {
	        $.ajax({
	        	url: '${pageContext.request.contextPath}/attendance/check.do',
	            method: 'POST',
	            success: function(data) {
	            	
	            	alert(data.status)
	            	if (!isLoggedIn || isLoggedIn === "false") {
	            	    $("#loginModal").show();
	            	} else if (data.status === 'already_checked') {
	            	    alert("이미 오늘 출석하셨습니다!");
	            	} else if (data.status === 'success') {
	            	    alert(
	            	        "출석 완료! 총 " + data.totalDays + "일 출석 🎉\n\n"
	            	        + data.rewardMessage
	            	    );
	            	    location.reload();
	            	}

		            }
		        });
		    });

		</script>
	</body>
	</html>