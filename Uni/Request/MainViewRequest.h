//
//  MainViewRequest.h
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIShopManage.h"
#import "UNIMyAppintModel.h"
#import "UNIMyProjectModel.h"
#import "UNIGoodsModel.h"




/**
 *  请求版本号成功Block
 *
 *  @param version 版本号
 *  @param url     下载链接
 *  @param desc    更新内容
 *  @param tips    反馈信息
 *  @param type    更新类型;0---必须更新；1----可选更新
 *  @param er      错误信息
 */
typedef void(^RQCheckVersion)(NSString* version,NSString* url,NSString* desc,NSString*tips, int type,NSError* er);



/**
 *  请求商店信息
 *
 *  @param shopName 店铺名
 *  @param logoUrl  Logo 路径
 *  @param url      二维码路径
 *  @param tips     反馈信息
 *  @param x        经度
 *  @param y        纬度
 *  @param er       错误信息
 */
typedef void(^RQShopInfoBlock)( UNIShopManage* manager,NSString*tips,NSError* er);

/**
 *  约满奖励接口
 *
 *  @param nextRewardNum 约满次数
 *  @param num           已约次数
 *  @param tips          反馈信息
 */
typedef void(^RQRewardBlock)(int nextRewardNum,int num,int type,int goodsId,NSString*url ,NSString*projectName ,NSString* title ,NSString*tips,NSError* er);

/**
 *  请求我已预约项目
 *  @param count 服务器里一个用多少条已预约的信息
 *  @param array UNIMyAppintModel 的对象数组
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^RQAppointmentBlock)( int count,NSArray* array,NSString* tips,NSError* er);

/**
 *  请求我的项目
 *
 *  @param array UNIMyProjectModel 的对象数组
 *  @param count 活动礼包上的数字
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^RQMyProjectBlock)(NSArray* array,int count,NSString* tips,NSError* er);

/**
 *  请求首页背景图片 和 商品图片
 *
 *  @param array 两张图片的路径数组
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^RQMainBgBlock)(NSArray* array,NSString* tips,NSError* er);

/**
 *  请求首页销售商品信息
 *
 *  @param array "UNIGoodsModel"数组
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^RQSellInfoBlock)(NSArray* array,NSString* tips,NSError* er);

/**
 *  请求请求用户是否存在活动
 *
 *  @param hasActivity 0
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^RQActivity)(int hasActivity,int activityId,NSString* tips,NSError* er);

/**
 *  审核期间是否显示活动
 *  @param code
 *  @param tips      反馈信息
 *  @param er        错误信息
 */
typedef void(^RQShowAcitivityOrNot)(int code,NSString* tips,NSError* er);

/**
 *  请求APP提示信息
 *  @param code
 *  @param tips      反馈信息
 *  @param er        错误信息
 */
typedef void(^RQAppTips)(NSDictionary* dic,NSString* tips,NSError* er);

@interface MainViewRequest : BaseRequest




//请求版本号成功Block
@property(nonatomic,copy)RQCheckVersion reqheckVersion;

//请求商店信息
@property(nonatomic,copy)RQShopInfoBlock reshopInfoBlock;

//约满奖励接口
@property(nonatomic,copy)RQRewardBlock rerewardBlock;

//请求我已预约项目
@property(nonatomic,copy)RQAppointmentBlock reappointmentBlock;

//请求我的项目
@property(nonatomic,copy)RQMyProjectBlock remyProjectBlock;

// 请求首页背景图片 和 商品图片
@property(nonatomic,copy)RQMainBgBlock reMainBgBlock;

// 请求首页销售商品信息
@property(nonatomic,copy)RQSellInfoBlock resellInfoBlock;

// 请求请求用户是否存在活动
@property(nonatomic,copy)RQActivity rqactivity;

//  审核期间是否显示活动
@property(nonatomic,copy)RQShowAcitivityOrNot rqshowAcitivityOrNot;

//  请求APP提示信息
@property(nonatomic,copy)RQAppTips rqAppTips;
@end
