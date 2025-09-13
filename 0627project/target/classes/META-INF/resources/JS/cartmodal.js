

function cartmodal() {
	
  if (!isLoggedIn) {
    document.getElementById("loginModal").style.display = "flex";
    return false;
  }
  document.getElementById("cartModal").style.display = "flex";
  return true;
}

function closecartModal() {

	document.getElementById("cartModal").style.display = "none";
	
}
	
function goToCart() {
    fetch(contextPath + "/clearCartStatusSession.jsp")
        .finally(() => {
            document.getElementById("cartModal").style.display = "none";
            window.location.href = contextPath + "/cartAll.do";
	});
}