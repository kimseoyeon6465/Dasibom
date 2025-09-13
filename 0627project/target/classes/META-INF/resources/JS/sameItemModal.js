function closeSameItemModal() {
	document.getElementById("sameItemModal").style.display = "none";
}

function goToCart() {
	window.location.href = contextPath + "/cartAll.do";
}

function goToAnnoBuy() {
	window.location.href = contextPath + `/guestOrderForm.do?isbn=${book.isbn}&count=` + count;
}

