//
//  Api.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#ifndef Api_h
#define Api_h

//#define iOS_DEBUG 1

#ifdef iOS_DEBUG



#else

//登录接口
#define UserLoginApi @"http://buy.dayanghang.net/api/platform/web/customer/login"
//
#define ThirdappopenApi @"http://buy.dayanghang.net/api/platform/web/customer/Thirdappopen"

#define UserPerfectApi @"http://buy.dayanghang.net/api/platform/web/customer/perfect"

//检查用户信息接口
#define checkUserApi @"http://buy.dayanghang.net/api/platform/web/customer/check/login"
//注册接口
#define UserRegisterApi @"http://buy.dayanghang.net/api/platform/web/customer/register"
//更改用户信息接口
#define UserInfoEditApi @"http://buy.dayanghang.net/api/platform/web/customer/edit"
//新增收货地址接口
#define AddAddressApi @"http://buy.dayanghang.net/api/platform/web/customer/add/address"
//获取收货地址接口
#define GetAddressApi @"http://buy.dayanghang.net/api/platform/web/customer/addresses"
//删除收货地址接口
#define DeleteAddressApi @"http://buy.dayanghang.net/api/platform/web/customer/delete/address"
//获取编辑地址接口
#define EditAddressApi @"http://buy.dayanghang.net/api/platform/web/customer/edit/address"
//生成订单
#define CreateOrderApi @"http://buy.dayanghang.net/api/platform/web/cart/order/create"
//新增订单接口
#define InsertOrderApi @"http://buy.dayanghang.net/api/platform/web/cart/add"
//获取订单接口
#define GetOrderApi @"http://buy.dayanghang.net/api/platform/web/cart/products"
////删除购物车接口
#define DeleteShopCartApi @"http://buy.dayanghang.net/api/platform/web/cart/product/delete"
//获取打包限制
#define PickLimitApi @"http://buy.dayanghang.net/api/platform/web/cart/package/select"
//更新订单接口
//#define UpdateOrderApi @"https://buy.dayanghang.net/api/orderupdate"
//获取所有订单接口
#define AllOrderApi @"http://buy.dayanghang.net/api/platform/web/cart/orders"
//删除订单接口
#define DeleteOrderApi @"http://buy.dayanghang.net/api/platform/web/cart/order/delete"
//获取已支付订单
#define AlreadyPayApi @"http://buy.dayanghang.net/api/platform/web/cart/pay/products"
//台湾支付商品接口(全部使用统一支付接口)
//#define MomoPayApi @"https://buy.dayanghang.net/api/momopay?api_token=%@&paytype=%@&ids=%@"
//支付商品接口
#define SpgateWayPayApi @"http://buy.dayanghang.net/api/platform/web/cart/order/pay?api_id=%@&api_token=%@&secret_key=%@&payType=%@&payMethod=%@&orderId=%@&currency=%@"
//订单获取tn码接口
#define GETTNSpgateWayPayApi @"http://buy.dayanghang.net/api/platform/web/cart/order/pay"
//大陆支付运费接口(全部使用统一支付接口)
//#define TransportPayApi @"https://buy.dayanghang.net/api/transportpay?api_token=%@&paytype=%@&id=%@"
//台湾支付运费接口(全部使用统一支付接口)
//#define MomotransportPayApi @"http://buy.dayanghang.net/api/momotransportpay?api_token=%@&paytype=%@&id=%@"
//运费支付接口
#define PackagePayApi @"http://buy.dayanghang.net/api/platform/web/cart/package/pay?api_id=%@&api_token=%@&secret_key=%@&payType=%@&payMethod=%@&packageId=%@&currency=%@"
//运费获取tn码接口
#define GETTNPackagePayApi @"http://buy.dayanghang.net/api/platform/web/cart/package/pay"
//获取支付方式
#define GetPayMentListApi @"http://buy.dayanghang.net/api/platform/web/payment/list"
//解包接口
#define PackageDeleteApi @"http://buy.dayanghang.net/api/platform/web/cart/package/delete"
//包裹接口
#define PackageApi @"http://buy.dayanghang.net/api/platform/web/cart/packages"
//物流接口
//#define TrackApi @"https://buy.dayanghang.net/api/track"
//汇率接口
#define moneyTypeApi @"http://buy.dayanghang.net/api/platform/web/currency/rate"
//广告栏接口
#define  BannerApi @"http://buy.dayanghang.net/api/platform/web/advertisement/slide"
//商品接口
#define  GoodsApi @"http://buy.dayanghang.net/api/platform/web/advertisement/goods"
//微信登录接口
#define  WXLoginApi @"http://buy.dayanghang.net/api/platform/web/customer/login/weixin"

//苹果登录接口
#define  AppleIdLoginApi @"http://buy.dayanghang.net/api/platform/web/customer/login/apple"

//苹果登录绑定接口
#define  AppleIdBindApi @"http://buy.dayanghang.net/api/platform/web/customer/apple/bind"

//苹果登录解除绑定接口
#define  AppleIdUnBindApi @"http://buy.dayanghang.net/api/platform/web/customer/apple/unbind"

//Facebook登录接口
#define  FCLoginApi @"http://buy.dayanghang.net/api/platform/web/customer/login/facebook"
//获取各种状态商品
#define GetAllStateGoodsApi @"http://buy.dayanghang.net/api/platform/web/cart/counts"
//用户确认收货
//#define ConfirmationOfReceiptApi @"http://buy.dayanghang.net/api/platform/web/cart/package/receive"
//用户确认收货
#define ConfirmationOfReceiptApi @"http://buy.dayanghang.net/api/platform/web/cart/package/receive"

//分类标题接口
#define CategoryTitleApi @"http://buy.dayanghang.net/api/platform/web/category/signs"
//分类接口
#define CategoryApi @"http://buy.dayanghang.net/api/platform/web/category/websites"
//获取帮助中心列表
#define HelpListApi @"http://buy.dayanghang.net/api/platform/web/help/contents"
//获取帮助中心某一篇文章
#define HelpOneApi @"http://buy.dayanghang.net/api/platform/web/help/content/one"
//获取网站logo图片
#define WebLogoApi @"http://buy.dayanghang.net/img/website-logo/"
//获取公告信息
#define NoticeApi @"http://buy.dayanghang.net/api/platform/news/news"

//加入收藏夹
#define AddFavoriteApi @"http://buy.dayanghang.net/api/platform/web/cart/favorite/add"
//获取收藏夹
#define FavoriteApi @"http://buy.dayanghang.net/api/platform/web/cart/favorites"
//购物车根据商品id加入收藏
#define AddShopCartFavoriteApi @"http://buy.dayanghang.net/api/platform/web/cart/product/to/favorite"
//删除收藏夹物品
#define DeleteFavoriteApi @"http://buy.dayanghang.net/api/platform/web/cart/favorite/delete"

//首页4个馆和专题title接口
#define CountryAndSpecialApi @"http://buy.dayanghang.net/api/platform/web/advertisement/postions"
#define CountryAndSpecialDetailApi @"http://buy.dayanghang.net/api/platform/web/advertisement/items"
#define CountryWebLink @"http://buy.dayanghang.net/api/category/websites"

////计算运费（旧版）
//#define CalculatedFreightApi @"http://global.dayanghang.net/api/freight/list"
//获取国家仓库
#define WarehouseApi @"http://buy.dayanghang.net/api/platform/web/freight/storages"
//品牌搜索
#define SearchBrandApi @"http://buy.dayanghang.net/api/brand/list"
//根据品牌搜索网站
#define SearchCategoryApi @"http://buy.dayanghang.net/api/category/websites"
//计算运费正式版
#define CalculatedFreightApi @"http://buy.dayanghang.net/api/platform/web/freight/price"

//首页选择区域获取获取国家
#define RegionApi @"http://buy.dayanghang.net/api/platform/web/region"

//上传身份证
#define UploadID @"http://buy.dayanghang.net/api/platform/web/customer/upload/idcard"
//二维码扫描登陆
#define ERWEIMAAPI @"http://buy.dayanghang.net/api/platform/web/customer/auth/login"
//用户打包
#define PickApi @"http://buy.dayanghang.net/api/platform/web/cart/package/create"
//上传头像
#define UploadAvatarApi @"http://buy.dayanghang.net/api/platform/web/customer/upload/avatar"
//修改个人信息
#define editInfomationApi @"http://buy.dayanghang.net/api/platform/web/customer/edit"
//拼接下载图片
#define PictureApi @"http://buy.dayanghang.net/"
#define WebPictureApi @"http://buy.dayanghang.net"
//获取国家唯一标示
#define GetSignApi @"http://buy.dayanghang.net/api/platform/web/category/website/sign"

//用户绑定微信
#define BindWeChatApi @"http://buy.dayanghang.net/api/platform/web/customer/weixin/bind"
//用户解绑微信
#define CancelBindWeChatApi @"http://buy.dayanghang.net/api/platform/web/customer/weixin/unbind"
//用户绑定facebook
#define BindFaceBookApi @"http://buy.dayanghang.net/api/platform/web/customer/facebook/bind"
//用户解绑facebook
#define CancelBindFaceBookApi @"http://buy.dayanghang.net/api/platform/web/customer/facebook/unbind"
//用户根据邮箱找回密码
#define PasswordRetrievalApi @"http://buy.dayanghang.net/api/platform/web/customer/validate/email"
//检测是否是分销商boss
#define CheckDistributorBossApi @"http://buy.dayanghang.net/api/platform/web/distributor/profit/rate"

//已发货物品查询物流
#define InquiryLogisticsApi @"http://transport.dayanghang.net/api/platform/web/packagemanagement/express/webapi/state"
//国内物流查询
#define DomesticLogisticsApi @"http://transport.dayanghang.net/api/platform/web/noticeinadvancegoods/goods/webapi/index"
//国内物流烟火照片查询
#define DomesticLogisticsImageApi @"http://transport.dayanghang.net/api/platform/web/noticeinadvancegoods/goods/webapi/package"
//获取退货退款物品
#define RefundOfReturn @"http://buy.dayanghang.net/api/platform/web/cart/pay/products/after"

//判断是否收藏
#define JudgeCollection @"http://buy.dayanghang.net/api/platform/web/cart/favorite/judge"
//获取服务费
#define GetServiceCharge @"http://buy.dayanghang.net/api/platform/web/currency/service"
//提交委托单
#define EntrustBuyApi @"http://buy.dayanghang.net/api/platform/web/entrust/buy/product"
//亚马逊分类接口
#define AmazonClassificationApi @"http://buy.dayanghang.net/api/platform/web/amazon/college" 
//亚马逊分类数据获取
#define AmazonClassificationDetailApi @"http://buy.dayanghang.net/api/platform/web/amazon/query"
//亚马逊商品详情
#define AmazonGoodsDetailApi @"http://buy.dayanghang.net/api/platform/web/amazon/product"
//亚马逊一口价计算
#define AmazonCalculationApi @"http://buy.dayanghang.net/api/platform/web/fixed/price/price"
//获取品牌库
#define BrandAToZApi @"http://buy.dayanghang.net/api/platform/web/brand/filter/search"
//@"http://buy.dayanghang.net/api/platform/web/brand/filter/list"
//一口价品牌库搜索
#define BrandSearchApi @"http://buy.dayanghang.net/api/platform/web/brand/list"
//判断网址是否已开发
#define JudgeLinkApi @"http://buy.dayanghang.net/api/platform/web/category/website/link"
//解绑极光推送唯一标示
#define UnbundlingJPushApi @"http://buy.dayanghang.net/api/platform/web/customer/jpush/unbind"

//获取用户邀请码
#define GetUserQRCodeApi @"http://buy.dayanghang.net/api/platform/web/distributor/personal/invite/code"
//获取用户利润
#define GetUserProfitApi @"http://buy.dayanghang.net/api/platform/web/distributor/personal/profit"
#define GetUserFriendApi @"http://buy.dayanghang.net/api/platform/web/distributor/personal/friend"
//获取增值服务
#define GetValueAddedServiceApi @"http://transport.dayanghang.net/api/platform/web/logisticsservice/addition/webapi/list"

//崩溃日志检测发送
#define ErrorApi @"http://buy.dayanghang.net/api/platform/web/exceptionManagement/exception/create"

//翻译接口
#define BaiDuTranslateApi @"http://api.fanyi.baidu.com/api/trans/vip/translate"

//获取短信验证码
#define VerificationCodeApi @"http://buy.dayanghang.net/api/platform/web/customer/send/verify"

//获取钱包密码修改验证码
#define WalletVerificationCodeApi @"http://buy.dayanghang.net/api/platform/web/wallet/find"

//获取钱包验证码后修改密码
#define WalletResetPWDApi @"http://buy.dayanghang.net/api/platform/web/wallet/reset"

//获取用户优惠卷
#define AllCouponsApi @"http://buy.dayanghang.net/api/platform/web/promotion/promotional/voucher"

//兑换优惠劵
#define ExchangeCouponsApi @"http://buy.dayanghang.net/api/platform/web/promotion/exchange/coupon"

//获取优惠活动开启情况
#define CouponsStateApi @"http://buy.dayanghang.net/api/platform/web/promotion/get/recently/promotion"

//当前ip淘宝接口
#define GetIPTB @"http://ip.taobao.com/service/getIpInfo.php"

//判断当前用户是否vip
#define JudgeVipMemberApi @"http://buy.dayanghang.net/api/platform/web/vip/customer/check"

//提交web刷新过的网站
#define RefreshWebApi @"http://buy.dayanghang.net/api/platform/web/category/websites/error"

//钱包充值
#define PurseRechargeApi @"http://buy.dayanghang.net/api/platform/web/wallet/recharge?api_id=%@&api_token=%@&secret_key=%@&amount=%@&currency=%@&payMethod=%@&payType=%@"

//钱包充值支出记录查询
#define WalletRecordApi @"http://buy.dayanghang.net/api/platform/web/wallet/log"

//钱包支付
#define WalletPayApi @"http://buy.dayanghang.net/api/platform/web/wallet/pay"

//设置钱包支付密码
#define SetWalletPWDApi @"http://buy.dayanghang.net/api/platform/web/wallet/set"

//钱包退款申请
#define PurseRefundApplicationApi @"http://buy.dayanghang.net/api/platform/web/wallet/refund/application"

//个人分销提交审核
#define PersonalDataSubmissionApi @"http://buy.dayanghang.net/api/platform/web/distributor/register/personal/spreader"

//个人分销提交审核结果
#define PersonalDataSubmissionStatusApi @"http://buy.dayanghang.net/api/platform/web/distributor/personal/spreader/revoke"

//全球名站
#define GlobalFamousStationApi @"http://buy.dayanghang.net/api/platform/web/category/global/websites"

//八抓鱼商品名
#define BazhuayuGoodName @"http://buy.dayanghang.net/api/platform/web/bazhuayu/goodname"

//八抓鱼一级分类
#define BazhuayuTopClass @"http://buy.dayanghang.net/api/platform/web/bazhuayu/topclassinfo"

//八抓鱼二级分类
#define BazhuayuChildClass @"http://buy.dayanghang.net/api/platform/web/bazhuayu/childclassinfo"

//根据品牌搜索网站
#define BrandSearchWeb @"http://buy.dayanghang.net/api/platform/web/category/keyword/webapi/list"

//获取品类
#define CustomsCategoryApi @"http://buy.dayanghang.net/api/platform/web/freight/goods/webapi/list"

//提交淘宝转运包裹
#define ForwardingInformationApi @"http://buy.dayanghang.net/api/platform/web/cart/transport/webapi/create"

//获取淘宝转运包裹
#define TaobaoTransshipmentParcelApi @"http://buy.dayanghang.net/api/platform/web/cart/transport/webapi/list"

//获取快递列表
#define ExpressListApi @"http://buy.dayanghang.net/api/platform/web/freight/express/webapi/list"

//根据包裹填写物流单号
#define FillTheExpressApi @"http://buy.dayanghang.net/api/platform/web/cart/transport/webapi/number"

//获取用户淘宝打包包裹
#define UserTaobaoPakageApi @"http://buy.dayanghang.net/api/platform/web/cart/transport/webapi/package"

//用户淘宝包裹打包
#define UserTaobaoPackApi @"http://transport.dayanghang.net/api/platform/web/packagemanagement/package/webapi/merge"

//判断淘宝转运是否开启
#define JudgeTaobaoTransportApi @"http://buy.dayanghang.net/api/platform/web/cart/transport/webapi/switch"

//首页优惠信息
#define HomeDiscountApi @"http://buy.dayanghang.net/api/platform/web/advertisement/information/webapi/list"

//首页top10
#define HomeTopTenApi @"http://buy.dayanghang.net/api/platform/web/advertisement/brandinfo/webapi/list"

//首页特价商品
#define HomeSpecialOfferApi @"http://buy.dayanghang.net/api/platform/web/advertisement/goodsinfo/webapi/list"

//首页年货
#define HomeYearApi @"http://buy.dayanghang.net/api/platform/web/advertisement/subjectinfo/webapi/list"
//年货详情
#define HomeYearDetApi @"http://buy.dayanghang.net/api/platform/web/advertisement/subjectpage/webapi/list"

#endif


#endif /* Api_h */
