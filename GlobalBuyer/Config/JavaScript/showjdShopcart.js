//京东购物车规则https://p.m.jd.com/cart/cart.action?fromnav=1
function jdShopCartInfo(){
	var all=document.querySelectorAll(".section .item .goods.selected").length;
	var j = 0;
	var arr = new Array();
	for(i=0;i<all;i++){
        var picture = document.querySelectorAll(".section .item .goods.selected")[i].getElementsByTagName("img")[0].src,
	        name = document.querySelectorAll(".section .item .goods.selected")[i].getElementsByClassName("name")[0].innerText,
	        quantity = document.querySelectorAll(".section .item .goods.selected")[i].getElementsByClassName("num")[0].value,
	        price = document.querySelectorAll(".section .item .goods.selected")[i].getElementsByClassName("price")[0].innerText.replace(/[^0-9.]/g,''),
	        attributes = document.querySelectorAll(".section .item .goods.selected")[i].getElementsByClassName("sku")[0].innerText,
	        goodLinkString = document.querySelectorAll(".section .item .goods.selected")[i].getAttribute("uuid"),
	        goodLinkOk = getCaption(goodLinkString,1),
	        goodLink = "https://item.m.jd.com/product/"+goodLinkOk+".html";
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
	var callInfo = JSON.stringify(arr);
//    browser.jdShopCartInfo(callInfo);
    window.webkit.messageHandlers.browser.postMessage(callInfo);
}

function getCaption(obj,state) {
    var index=obj.lastIndexOf("\|");
    if(state==0){
        obj=obj.substring(0,index);
    }else {
        obj=obj.substring(index+1,obj.length);
    }
    return obj;
}
