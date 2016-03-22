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

#define API_IMG_URL @"http://uni.dodwow.com/images"

// C部分 第一个参数 类型1
#define API_PARAM_UNI @"UNI"

// C部分 第一个参数 类型2
#define API_PARAM_SSMS @"SendSMS"

// C部分 第一个参数 类型3
#define API_PARAM_PAY @"PayConfig"

//登录接口：
#define API_URL_Login @"login"

//获取首页背景图片 和 奖励商品图片
#define API_URL_GetImgByshopIdCode @"getImgByshopIdCode"

//获取首页背景图片 和 奖励商品图片
#define API_URL_GetSellInfo @"getSellInfo"

//获取店铺信息接口
#define API_URL_ShopInfo @"shopInfo"

//会员信息接口
#define API_URL_CustomInfo @"customInfo"

//获取已预约信息接口
#define API_URL_Appoint @"appoint"

//我的项目接口
#define API_URL_MyProjectInfo @"myProjectInfo"

//版本校验接口
#define API_URL_CheckVersion @"checkVersion"

//请求欢迎页
#define API_URL_Welcome @"welcome"

//短信接口
#define API_URL_Login @"login"

//奖励信息接口
#define API_URL_MRInfo @"rewardInfo"

//获取可选时间接口
#define API_URL_GetFreeTime @"getFreeTime"

//确认预约接口
#define API_URL_SetAppoint @"setAppoint"

//获取预约订单详情接口
#define API_URL_GetAppointInfo @"getAppointInfo"

//获取客妆接口
#define API_URL_GetSellInfo @"getSellInfo"

//获取客妆接口2
#define API_URL_GetSellInfo2 @"getSellGoodsInfo"

//获取客妆 订单号
#define API_URL_GetOutTradeNo @"getOutTradeNo"

//服务评价接口
#define API_URL_SetServiceAppraise @"setServiceAppraise"

//商品评价接口
#define API_URL_GoodsAppraise @"setGoodsAppraise"

//会员卡详情接口
#define API_URL_GetCardInfo @"getCardInfo"

//准时奖励信息接口
#define API_URL_ITRewardInfo @"intimeRewardInfo"

//我的奖励—约满奖励接口
#define API_URL_MYRewardInfo @"myRewardInfo"

//我的奖励--准时奖励接口
#define API_URL_MYITRewardInfo @"myIntimeRewardInfo"

//客妆奖励接口
#define API_URL_SellReward @"sellReward"

//我的奖励列表接口
#define API_URL_MYRewardList @"myRewardList"

//客户到店
#define API_URL_ArriveShop @"setArriveShop"

//获取订单列表
#define API_URL_MyOrderList @"myOrderList"

//支付宝 私钥之类的KEY
#define API_URL_GetAlipayConfig @"getAlipayConfig"

//微信支付 私钥之类的KEY
#define API_URL_GetWXConfig @"getWXConfig"

//获取法律声明文本接口
#define API_URL_GetTextInfo @"getTextInfo"

//获取游客基础信息接口
#define API_URL_GetCustomInfo @"getCustomInfo"

//设置游客基础信息接口
#define API_URL_SetCustomInfo @"setCustomInfo"

//获取店铺列表接口
#define API_URL_GetShopListInfo @"getShopListInfo"

//获取提示语言接口
#define API_URL_GetAppTips @"getAppTips"

//获取用户是否参加过活动
#define API_URL_HasActivity @"hasActivity"

//获取活动分享内容
#define API_URL_ActivityShare @"activityShare"

//获取服务预约内容信息
#define API_URL_GetProjectModel @"getProjectModel"

//获取游客按钮显示
#define API_URL_RetCode @"retCode"
#endif /* URLconfig_h */
