/**
 * 
 */
// 이미지 미리보기 기능
document.addEventListener('DOMContentLoaded', function () {
    const imageInput = document.getElementById('imageUpload');
    const previewContainer = document.getElementById('previewContainer');

    if (imageInput && previewContainer) {
        imageInput.addEventListener('change', function (event) {
            previewContainer.innerHTML = ''; // 기존 이미지 초기화

            const files = event.target.files;
            if (!files.length) return;

            Array.from(files).forEach(file => {
                if (!file.type.startsWith('image/')) {
                    alert('이미지 파일만 업로드할 수 있습니다.');
                    return;
                }

                const reader = new FileReader();
                reader.onload = function (e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.style.maxWidth = '150px';
                    img.style.margin = '5px';
                    img.style.border = '1px solid #ccc';
                    previewContainer.appendChild(img);
                };
                reader.readAsDataURL(file);
            });
        });
    }
});

// 전역에서 호출 가능한 폼 유효성 검사 함수
function validateForm() {
    const imageInput = document.getElementById('imageUpload');
    if (!imageInput || imageInput.files.length === 0) {
        alert('이미지를 한 장 이상 등록해 주세요.');
        return false;
    }
    return true;
}
