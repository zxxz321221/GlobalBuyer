function shopCartInfo(){
	var all=document.querySelectorAll(".opt input ").length;
	var j = 0;
	var arr = new Array();
	for(i=0;i<all;i++){
	    if(document.querySelectorAll(".opt input")[i].checked){
	        var picture = document.querySelectorAll(".opt input ")[i].parentNode.parentNode.parentNode.parentNode.parentNode.firstElementChild.firstElementChild.firstElementChild.firstElementChild.src;
	        var name =document.querySelectorAll(".opt input ")[i].parentNode.parentNode.parentNode.parentNode.parentNode.firstElementChild.firstElementChild.nextElementSibling.innerText;
	        var quantity = document.querySelectorAll(".meta.meta-amount input")[i].value;
	        var price = document.querySelectorAll(".meta.meta-amount .cash")[i].innerText.replace(/[^0-9.]/g,'');
	        var attributes = document.querySelectorAll(".sku")[i].innerText;
	      
	        var goodLink =document.querySelectorAll(".opt input ")[i].parentNode.parentNode.parentNode.parentNode.parentNode.firstElementChild.firstElementChild.nextElementSibling.firstElementChild.href;
	        var data = {
	        picture: picture,
	        name: name,
	        quantity: quantity,
	        price: price,
	        goodLink: goodLink,
	        currency:'CNY',
	        attributes: attributes
	        };
	        arr[j] = data;
	        j+=1;
	    }
	}
	var callInfo = JSON.stringify(arr);
    window.webkit.messageHandlers.browser.postMessage(callInfo);
//    return callInfo;
}
