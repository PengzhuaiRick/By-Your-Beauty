//
//  UNIGoodsDetailRequest.h
//  Uni
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIGoodsModel.h"
/**
 *  客妆 我的奖励
 *
 *  @param array UNIMyRewardModel.h 的对象数组
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^KZRewardBlock)(NSArray* array,NSString* tips,NSError* er);

/**
 *  客妆 商品信息
 *
 *  @param array UNIGoodsModel.h 数组对象
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^KZGoodsInfoBlock)(NSArray* array,NSString* tips,NSError* er);

/**
 *  获取项目详情
 *
 *  @param array UNIGoodsModel.h 数组对象
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^GetServiceInfoBlock)(NSArray* array,NSString* tips,NSError* er);


/**
 *  客妆 获取订单号
 *
 *  @param outTradeNo 订单号
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^KZGoodsGetOrderBlock)(NSDictionary* dictionary,NSString* tips,NSError* er);

/**
 *  获取支付宝 支付Key
 *
 *  @param partner         支付宝PID
 *  @param key
 *  @param seller          支付宝收款账号
 *  @param ras_private_key 商户私钥
 *  @param tips            反馈信息
 *  @param er              错误信息
 */
typedef void(^KZAlipayBlock)(NSString* partner ,NSString* key,NSString* seller,NSString* ras_private_key,NSString* tips,NSError* er);


/**
 *  获取微信支付 支付Key
 *
 *  @param appid     微信的APPID
 *  @param mchid     商户号ID
 *  @param appsecret 微信appsecret
 *  @param tips      反馈信息
 *  @param er        错误信息
 */
typedef void(^KZWXpayBlock)(NSString* appid ,NSString* mchid,NSString* appsecret,NSString* tips,NSError* er);

/**
    检查支付后 和后台验证
 *  code 0签名成功 203等待入账  204订单不存在
 *  @param tips      反馈信息
 *  @param er        错误信息
 */
typedef void(^CTOrderStatusBlock)(int code,NSString* tips,NSError* er);

@interface UNIGoodsDetailRequest : BaseRequest

// 客妆 我的奖励
@property(nonatomic,copy)KZRewardBlock kzrewardBlock;

// 客妆 商品信息
@property(nonatomic,copy)KZGoodsInfoBlock kzgoodsInfoBlock;

// 客妆 商品信息
@property(nonatomic,copy)GetServiceInfoBlock gserviceInfoBlock;

// 客妆 获取订单号
@property(nonatomic,copy)KZGoodsGetOrderBlock kzgoodsGetOrderBlock;

//(废弃) 获取支付宝 支付Key
@property(nonatomic,copy)KZAlipayBlock kzalipayBlock;


// (废弃) 获取微信支付  支付Key
@property(nonatomic,copy)KZWXpayBlock kzwxpayBlock;

//检查支付后 和后台验证
@property(nonatomic,copy)CTOrderStatusBlock ctorderStatusBlock;
@end
