<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q&A 작성</title>
<link rel="icon" href="./resources/images/favicon3.ico" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="./resources/style/write-post.css" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
</head>
<body class="write-body">
	<jsp:include page="/common/header.jsp" />

	<div class="write-content-wrapper">
		<h1 class="write-title">Q&A 작성</h1>
		<hr class="write-hr" />

		<form id="myForm" method="post">
			<div class="write-button-row">
				<input type="button" value="목록으로" onclick="location.href = 'goQna.do'" />

				<c:choose>
					<c:when test="${empty post.post_id}">
						<input type="button" id="writebtn" value="작성하기" onclick="submitTo('insertQna.do')" />
					</c:when>
					<c:otherwise>
						<input type="hidden" name="post_id" value="${post.post_id}" />
						<input type="button" id="updatebtn" value="수정하기" onclick="submitTo('updateQna.do')" />
						<input type="hidden" name="post_date" value="${post.post_date}" />
					</c:otherwise>
				</c:choose>
			</div>

			<table class="write-table">
				<tr>
					<td>
						<input type="hidden" name="category" value="이벤트" />
						<input type="text" name="title" placeholder="제목" value="${post.title}" />
						<input type="hidden" name="user_id" placeholder="작성자 이름" value="${user.user_Id}" />
					</td>
				</tr>
				<tr>
					<td>
						<textarea id="summernote">${post.post_contents}</textarea>
						<input type="hidden" id="content" name="content" />
						<input type="hidden" id="image_path" name="image_path" value="${post.image_path}" />
					</td>
				</tr>
			</table>
		</form>
	</div>

	<script>
		$('#summernote').summernote({
			height : 300,
			callbacks : {
				onImageUpload : function(files) {
					for (let i = 0; i < files.length; i++) {
						uploadImage(files[i]);
					}
				}
			}
		});

		function uploadImage(file) {
			let data = new FormData();
			data.append("file", file);

			$.ajax({
				url : '/sawon/uploadImage.do', // 서버에서 처리할 URL
				type : 'POST',
				data : data,
				processData : false,
				contentType : false,
				success : function(url) {
					if (url.startsWith('error')) {
						alert("이미지 업로드에 실패했습니다.");
					} else {
						// 서버에서 반환된 URL은 http://localhost:8080/images/파일명 형식이어야 합니다.
						let imagePath = url; // 예: http://localhost:8080/images/파일명

						// Summernote에 이미지를 삽입
						$('#summernote').summernote('insertImage', imagePath,
								function($image) {
									$image.attr('alt', '업로드된 이미지');
								});

						// 숨겨진 input에 이미지 경로를 설정
						$('#image_path').val(imagePath); // 예: http://localhost:8080/images/파일명
					}
				},
				error : function() {
					alert("이미지 업로드 중 오류가 발생했습니다.");
				}
			});
		}

		// 폼 제출 함수
		function submitTo(actionUrl) {
			const form = document.getElementById('myForm');

			// 유효성 검사
			const category = form.category.value.trim();
			const title = form.title.value.trim();
			const userId = form.user_id.value.trim();
			const contentHtml = $('#summernote').summernote('code').trim();

			if (!category)
				return alert("말머리를 선택해주세요.");
			if (!title)
				return alert("제목을 입력해주세요.");
			if (!userId)
				return alert("작성자 성명을 입력해주세요.");
			if (contentHtml === "" || contentHtml === "<p><br></p>")
				return alert("내용을 입력해주세요.");

			// 이미지/동영상 존재 여부
			const hasImage = contentHtml.toLowerCase().includes('<img');
			const hasVideo = contentHtml.toLowerCase().includes('<iframe');

			document.getElementById('image_path').value = hasVideo ? '2'
					: hasImage ? '1' : '';

			// 콘텐츠 저장
			document.getElementById('content').value = contentHtml;

			form.action = actionUrl;
			form.submit();
		}
	</script>

	<jsp:include page="/common/footer.jsp" />
</body>
</html>
