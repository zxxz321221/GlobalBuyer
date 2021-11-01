function taobaoShopCartInfo(){
	var all=document.querySelectorAll("#J_cartBuy .allItemv2 .bundlev2 .itemv2 .item-cb input").length;
	var j = 0;
	var arr = new Array();
	for(i=0;i<all;i++){
	    if(document.querySelectorAll("#J_cartBuy .allItemv2 .bundlev2 .itemv2 .item-cb input")[i].checked){
	        var picture = document.querySelectorAll("#J_cartBuy .allItemv2 .bundlev2 .itemv2 .item-img img")[i].src;
	        var name = document.querySelectorAll("#J_cartBuy .allItemv2 .bundlev2 .itemv2 .item-info .title")[i].innerText;
	        var quantity = document.querySelectorAll("#J_cartBuy .allItemv2 .bundlev2 .itemv2 .item-info .edit-quantity .btn-input input")[i].value;
	        var price = document.querySelectorAll("#J_cartBuy .allItemv2 .bundlev2 .itemv2 .item-info .pay-price .price")[i].innerText.replace(/[^0-9.]/g,'');
	        var attributes = '';
	        if(document.querySelectorAll("#J_cartBuy .allItemv2 .bundlev2 .itemv2 .item-info")[i].childNodes[0].childNodes.length == 2){
		        attributes = document.querySelectorAll("#J_cartBuy .allItemv2 .bundlev2 .itemv2 .item-info")[i].childNodes[0].childNodes[1].innerText.replace(/\n/gi,"");
	        }
	        var goodLink = document.querySelectorAll("#J_cartBuy .allItemv2 .bundlev2 .itemv2 .item-img a")[i].href;
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
//    browser.taobaoShopcartInfo(callInfo);
    window.webkit.messageHandlers.browser.postMessage(callInfo);
}
