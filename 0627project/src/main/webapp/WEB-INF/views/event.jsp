<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 게시판</title>
<link rel="icon" href="./resources/images/favicon3.ico" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="./resources/style/post-board.css" />
<script src="${pageContext.request.contextPath}/JS/loginmodal.js"></script>

<script>
  window.onload = function() {
    const content = document.querySelector('.content');
    const sidebar = document.querySelector('.sidebar');
    const layoutWrapper = document.querySelector('.layout-wrapper');

    if (content && sidebar && layoutWrapper) {
      const contentRect = content.getBoundingClientRect();
      const contentTopInDoc = contentRect.top + window.pageYOffset;

      const layoutRect = layoutWrapper.getBoundingClientRect();
      const layoutTopInDoc = layoutRect.top + window.pageYOffset;

      const relativeTop = contentTopInDoc - layoutTopInDoc;

      sidebar.style.top = relativeTop + 'px';
      sidebar.style.height = content.offsetHeight + 'px';
    }
  };

  window.addEventListener('resize', () => {
    window.onload();
  });
  window.addEventListener('scroll', () => {
    window.onload();
  });
</script>
</head>
<body>

	<jsp:include page="/common/header.jsp" />
	<jsp:include page="/common/loginmodal.jsp" />

	<c:if test="${not empty alertMessage}">
		<script>
      		alert("${alertMessage}");
    	</script>
	</c:if>

	<div class="page-wrapper">
		<h1>이벤트 게시판</h1>

		<div class="layout-wrapper">

			<!-- 사이드바 -->
			<div class="sidebar">
				<div class="sidebar-box">
					<h3>메뉴</h3>
					<a href="goPost.do">게시판</a>
					<a href="goEvent.do">이벤트 게시판</a>
					<a href="goNotification.do">공지 게시판</a>
					<a href="goQna.do">Q&A 게시판</a>
				</div>
			</div>

			<!-- main-area: top-bar + content -->
			<div class="main-area">

				<!-- top-bar -->
				<div class="top-bar">
					<c:choose>
						<c:when test="${isAdmin == 1}">
							<form action="goWriteNotification.do" method="post" onsubmit="return loginedSubmit();">
								<input type="submit" value="글쓰기" class="write-btn" />
							</form>
						</c:when>
						<c:otherwise>
							<div style="width: 100px;"></div>
						</c:otherwise>
					</c:choose>

					<div class="search-wrapper">
						<form action="searchEvent.do" method="get" class="search-form">
							<input type="text" name="keyword" id="searchInput" placeholder="검색어를 입력하세요" value="${param.keyword}" />
							<input type="submit" value="검색" id="searchBtn" />
						</form>
					</div>
				</div>

				<!-- content -->
				<div class="content">
					<table>
						<thead>
							<tr>
								<th style="width: 60px;">번호</th>
								<th>제목</th>
								<th style="width: 100px;">작성자</th>
								<th style="width: 160px;">작성일</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="posts" items="${eventPosts}">
								<c:if test="${posts.category == '이벤트'}">
									<tr>
										<td>${posts.post_id}</td>
										<td style="border-left: none;">
											<div style="display: flex; justify-content: space-between; align-items: center;">
												<div style="text-align: left;">
													<a href="showDetailEvent.do?post_id=${posts.post_id}">[${posts.category}] ${posts.title}</a>
													<c:if test="${posts.image_path == '1'}">
														<img src="./resources/images/picture.png" alt="이미지 있음" style="width: 16px; height: 16px; margin-left: 4px;" />
													</c:if>
													<c:if test="${posts.image_path == '2'}">
														<img src="./resources/images/video.png" alt="동영상 있음" style="width: 16px; height: 16px; margin-left: 4px;" />
													</c:if>
												</div>
												<c:if test="${posts.commentCount > 0}">
													<div style="text-align: right; color: gray;">(${posts.commentCount})</div>
												</c:if>
											</div>
										</td>
										<td>${posts.user_id}</td>
										<td>
											<fmt:formatDate value="${posts.post_date}" pattern="yy-MM-dd" />
										</td>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<!-- content -->
			</div>
			<!-- main-area -->

		</div>
		<!-- layout-wrapper -->
		<!-- ✅ 중앙 정렬된 페이징 버튼 -->
		<div class="button-wrapper">
			<div class="button-row">
				<!-- 이전 버튼 -->
				<form action="goEvent.do" method="get" style="display: inline;">
					<input type="hidden" name="spage" value="${currentPage - 1 < 1 ? 1 : currentPage - 1}" />
					<input type="submit" value="이전" />
				</form>

				<!-- 페이지 번호 -->
				<c:forEach begin="1" end="${totalPages}" var="i">
					<form action="goEvent.do" method="get">
						<input type="hidden" name="spage" value="${i}" />
						<input type="submit" value="${i}" class="${i == currentPage ? 'current-page' : ''}" />
					</form>
				</c:forEach>
				<!-- 다음 버튼 -->
				<form action="goEvent.do" method="get" style="display: inline;">
					<input type="hidden" name="spage" value="${currentPage + 1 > totalPages ? totalPages : currentPage + 1}" />
					<input type="submit" value="다음" />
				</form>
			</div>
		</div>
	</div>
	<!-- page-wrapper -->

	<jsp:include page="/common/footer.jsp" />
</body>
</html>