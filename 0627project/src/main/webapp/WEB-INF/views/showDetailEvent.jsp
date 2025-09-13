<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" href="./resources/images/favicon3.ico" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="./resources/style/postDetail.css">
<script src="${pageContext.request.contextPath}/JS/loginmodal.js"></script>
<title>${post.title}</title>
</head>
<body class="post-detail-body">
	<jsp:include page="/common/header.jsp" />
	<script>
	  const isLoggedIn = ${sessionScope.user_seq == null ? 'false' : 'true'};
	</script>
	<jsp:include page="/common/loginmodal.jsp" />

	<!-- 상단 메뉴 버튼용 form -->
	<form id="myForm" method="post">
		<table class = "post-detail-table">
			<tr>
				<td colspan="4" class="btn-row">
					<input type="submit" value="이벤트 목록" onclick="submitTo('goEvent.do')" class="post-detail-button" />

					<c:if test="${sessionScope.user_id != null && sessionScope.user_id == post.user_id}">
						<input type="submit" value="수정하기" onclick="submitTo('goWriteEvent.do?post_id=${post.post_id}')" class="post-detail-button" />
						<input type="submit" value="삭제하기" onclick="submitTo('deleteEvent.do?post_id=${post.post_id}')" class="post-detail-button" />
					</c:if>
				</td>
			</tr>

			<tr>
				<td colspan="4" class="post-detail-card">
					<h3 style="margin: 4px 0 0 0;">[${post.category}]</h3>
					<h2 style="margin: 4px 0 0 0; color: #d63384;">${post.title}</h2>
					<div class="post-detail-comment-meta">
						<b>${post.user_id}</b> |
						<fmt:formatDate value="${post.post_date}" pattern="yy-MM-dd" />
					</div>
					<div style="margin-top: 10px;">
						<c:out value="${post.postContentsWithBr}" escapeXml="false" />
					</div>
				</td>
			</tr>
		</table>
	</form>

	<script>
		function submitTo(actionUrl) {
			const form = document.getElementById('myForm');
			form.action = actionUrl;
		}

		function showReplyForm(commentId) {
			const form = document.getElementById("replyForm-" + commentId);
			form.style.display = (form.style.display === "none") ? "table-row" : "none";
		}
		
		function editComment(commentId) {

		    const commentTextEl = document.getElementById("commentText-"+commentId);
		    const editFormEl = document.getElementById("editForm-"+commentId);
		    
		    commentTextEl.style.display = 'none';
		    editFormEl.style.display = 'block';
		}
		
		function cancelEdit(commentId) {
			document.getElementById("editForm-"+commentId).style.display = 'none';
			document.getElementById("commentText-"+commentId).style.display = 'block';
		}
	</script>

	<jsp:include page="/common/footer.jsp" />
</body>
</html>