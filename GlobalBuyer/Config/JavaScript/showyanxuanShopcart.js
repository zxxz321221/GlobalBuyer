//严选购物车规则http://m.you.163.com/cart
function jdShopCartInfo(){
	var all=document.querySelectorAll(".list .item .checked").length;
	var j = 0;
	var arr = new Array();
	for(i=0;i<all;i++){
        var picture = $(".list .item .checked").eq(i).siblings(".imgWrap").find("img").attr("src"),
	        name = $(".list .item .checked").eq(i).siblings(".cnt").find(".name").text(),
	        quantity = $(".list .item .checked").eq(i).siblings(".cnt").find(".textWrap input").val(),
	        price = $(".list .item .checked").eq(i).siblings(".cnt").find(".price").text().replace(/[^0-9.]/g,''),
	        attributes = $(".list .item .checked").eq(i).siblings(".cnt").find(".spec").text();
        var data = {
        picture: picture,
        name: name,
        quantity: quantity,
        price: price,
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
