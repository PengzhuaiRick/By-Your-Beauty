//
//  URLconfig.h
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#ifndef URLconfig_h
#define URLconfig_h

#define NETWORKINGPEOBLEM @"请求失败,请检查网络"

// 用户id
#define LOCA_USER_ID @"locaUserId"

//TOKEN
#define LOCA_USER_TOKEN @"locaUserToken"


#define API_URL @"http://uni.dodwow.com/uni_api"
//#define API_URL @"http://192.168.0.199:8081"
//#define API_URL @"http://show.api.meiliyouni.com/uni_api"

//#define API_IMG_URL @"http://uni.dodwow.com/images"
#define API_IMG_URL [UNIUrlManager sharedInstance].img_url

// C部分 第一个参数 类型1
#define API_PARAM_UNI @"UNI"

// C部分 第一个参数 类型2
#define API_PARAM_SSMS @"SendSMS"

// C部分 第一个参数 类型3
#define API_PARAM_PAY @"PayConfig"

////登录接口：
//#define API_URL_Login @"login"

//登录接口：
#define API_URL_Login @"Customer/login"

//获取首页背景图片 和 奖励商品图片
#define API_URL_GetImgByshopIdCode @"file/getImgByshopIdCode"

//获取首页背景图片 和 奖励商品图片
#define API_URL_GetSellInfo @"getSellInfo"

//获取店铺信息接口
#define API_URL_ShopInfo @"shop/shopInfo"

//会员信息接口
#define API_URL_CustomInfo @"customInfo"

//获取已预约信息接口
#define API_URL_Appoint @"appoint/myAppoint"

//我的项目接口
#define API_URL_MyProjectInfo @"project/myProjectInfo"

//版本校验接口
#define API_URL_CheckVersion @"checkVersion"

//请求欢迎页
#define API_URL_Welcome @"index/welcome"

//短信接口
//#define API_URL_Login @"login"

//短信接口
#define API_URL_Verify @"Customer/verify"

//奖励信息接口
#define API_URL_MRInfo @"reward/rewardInfo"

//获取可选时间接口
#define API_URL_GetFreeTime @"appoint/getFreeTime"

//确认预约接口
#define API_URL_SetAppoint @"Appoint/setAppoint"

//获取预约订单详情接口
#define API_URL_GetAppointInfo @"appoint/getAppointInfo"

//获取客妆接口
#define API_URL_GetSellInfo @"getSellInfo"

//获取客妆接口2
#define API_URL_GetSellInfo2 @"SellGoods/getSellGoodsInfo"

//获取项目详情
#define API_URL_GetSellInfo3 @"Goods/getGoodsInfo"

//获取客妆列表
#define API_URL_GetSellList @"sellGoods/sellGoodsList"

//获取客妆 订单号
#define API_URL_GetOutTradeNo @"Pay/getPayInfo"

//服务评价接口
#define API_URL_SetServiceAppraise @"comment/setServiceAppraise"

//商品评价接口
#define API_URL_GoodsAppraise @"comment/SetGoodsAppaise"

//会员卡详情接口
#define API_URL_GetCardInfo @"appoint/getCardInfo"

//准时奖励信息接口
#define API_URL_ITRewardInfo @"reward/intimeReward"

//我的奖励—约满奖励接口
#define API_URL_MYRewardInfo @"reward/myRewardInfo"

//我的奖励--准时奖励接口
#define API_URL_MYITRewardInfo @"reward/myIntimeRewardInfo"

//客妆奖励接口
#define API_URL_SellReward @"reward/sellReward"

//我的奖励列表接口
#define API_URL_MYRewardList @"reward/myRewardList"

//客户到店
#define API_URL_ArriveShop @"appoint/setArriveShop"

//获取订单列表
#define API_URL_MyOrderList @"order/myOrderList"

//（废弃）支付宝 私钥之类的KEY
#define API_URL_GetAlipayConfig @"getAlipayConfig"

//（废弃）微信支付 私钥之类的KEY
#define API_URL_GetWXConfig @"getWXConfig"

//支付后 和后台验证
#define API_URL_GetOrderStatus @"Pay/getOrderStatus"

//获取法律声明文本接口
#define API_URL_GetTextInfo @"file/getTextInfo"

//获取游客基础信息接口
#define API_URL_GetCustomInfo @"User/getCustomInfo"

//设置游客基础信息接口
#define API_URL_SetCustomInfo @"User/setCustomInfo"

//获取店铺列表接口
#define API_URL_GetShopListInfo @"Shop/getShopListInfo"

//获取提示语言接口
#define API_URL_GetAppTips @"AppTips/getAppTips"

//获取用户是否参加过活动
#define API_URL_HasActivity @"Activity/hasActivity"

//获取活动分享内容
#define API_URL_ActivityShare @"Activity/activityShare"

//获取服务预约内容信息
#define API_URL_GetProjectModel @"Project/getProjectModel"

//获取游客按钮显示
#define API_URL_RetCode @"Download/retCode"

//新用户选择店铺
#define API_URL_addUser @"Customer/addUser"

//获取 UNI 办公室电话
#define API_URL_getUNIPhone @"NotLogin/getMessage"

//获取首页优惠券信息
#define API_URL_GetNewestCoupon @"SellGoods/getNewestCoupon"



//添加到购物车，修改购物车数量，减少购物车数量
#define API_URL_ChangeNumOfShopCar @"Cart/addGoodsToCart"
//获取购物车有多少种商品
#define API_URL_GetKindOfShopCar @"Cart/getCartGoodsCount"
//删除购物车物品
#define API_URL_DelCartGoods @"Cart/delCartGoods"
//是否全选
#define API_URL_ChangeCartGoodsIsCheck @"Cart/changeCartGoodsIsCheck"
//修改某个商品是否选中
#define API_URL_CartIsCheck @"Cart/cartIsCheck"
//获取购物车列表
#define API_URL_GetCartList @"Cart/getCartList"
#endif /* URLconfig_h */
