<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
<link rel="icon" href="./resources/images/favicon3.ico" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="./resources/style/post-board.css" />
<script src="${pageContext.request.contextPath}/JS/loginmodal.js"></script>
<!-- update -->
<script>
	window.onload = function() {
		const content = document.querySelector('.content');
		const sidebar = document.querySelector('.sidebar');

		if (content && sidebar) {
			const contentRect = content.getBoundingClientRect();
			const contentTopInDoc = contentRect.top + window.pageYOffset;
			sidebar.style.top = contentTopInDoc + 'px';
		}
	};

	function alignSidebarTop() {
		const content = document.querySelector('.content');
		const sidebar = document.querySelector('.sidebar');

		if (content && sidebar) {
			const contentRect = content.getBoundingClientRect();
			const contentTopInDoc = contentRect.top + window.pageYOffset;
			sidebar.style.top = contentTopInDoc + 'px';
		}
	}

	window.onload = alignSidebarTop;
	window.addEventListener('resize', alignSidebarTop);
	window.addEventListener('scroll', alignSidebarTop);
</script>
</head>
<body>
	<jsp:include page="/common/header.jsp" />
	<script>
		const isLoggedIn = ${sessionScope.user_seq == null ? 'false' : 'true'};
	</script>
	<jsp:include page="/common/loginmodal.jsp" />

	<c:if test="${not empty alertMessage}">
		<script>
			alert("${alertMessage}");
		</script>
	</c:if>

	<div class="page-wrapper">

		<!-- 1. 맨 위 게시판 제목 -->
		<h1>Q&A 게시판</h1>

		<!-- 2. 사이드바 + top-bar + content 영역을 묶는 큰 레이아웃 -->
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

			<!-- 사이드바 옆 전체 영역: top-bar + content -->
			<div class="main-area">
				<!-- 상단 글쓰기 + 검색 -->
				<div class="top-bar">
					<form action="goWriteQna.do" method="post" onsubmit="return loginedSubmit();">
						<input type="submit" value="글쓰기" class="write-btn" />
					</form>
					<form action="searchQna.do" method="get" class="search-form">
						<input type="text" name="keyword" id="searchInput" placeholder="검색어를 입력하세요" value="${param.keyword}" />
						<input type="submit" value="검색" id="searchBtn" />
					</form>
				</div>

				<!-- 게시판 콘텐츠 -->
				<div class="content">
					<!-- 게시글 테이블 및 페이징 여기 삽입 -->
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
							<c:forEach var="posts" items="${qnaPosts}">
								<c:if test="${posts.category == 'Q&A'}">
									<tr>
										<td>${posts.post_id}</td>
										<td style="border-left: none;">
											<div style="display: flex; justify-content: space-between; align-items: center;">
												<div style="text-align: left;">
													<a href="showDetailQna.do?post_id=${posts.post_id}">[${posts.category}] ${posts.title}</a>
													<c:if test="${posts.image_path == '1' or posts.image_path != null}">
														<img src="./resources/images/picture.png" alt="이미지 있음" />
													</c:if>
													<c:if test="${posts.image_path == '2'}">
														<img src="./resources/images/video.png" alt="동영상 있음" />
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
				<!-- content 끝 -->
			</div>
			<!-- main-area 끝 -->
		</div>
		<!-- layout-wrapper 끝 -->
		<div class="button-wrapper">
			<div class="button-row">
				<form action="goQna.do" method="get">
					<input type="hidden" name="spage" value="${currentPage - 1 < 1 ? 1 : currentPage - 1}" />
					<input type="submit" value="이전" />
				</form>
				<c:forEach begin="1" end="${totalPages}" var="i">
					<form action="goQna.do" method="get">
						<input type="hidden" name="spage" value="${i}" />
						<input type="submit" value="${i}" class="${i == currentPage ? 'current-page' : ''}" />
					</form>
				</c:forEach>
				<form action="goQna.do" method="get">
					<input type="hidden" name="spage" value="${currentPage + 1 > totalPages ? totalPages : currentPage + 1}" />
					<input type="submit" value="다음" />
				</form>
			</div>
		</div>
	</div>
	<!-- page-wrapper 끝 -->

	<jsp:include page="/common/footer.jsp" />
</body>
</html>