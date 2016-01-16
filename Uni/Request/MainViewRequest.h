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
typedef void(^RQRewardBlock)(int nextRewardNum,int num,NSString*projectName ,NSString*tips,NSError* er);

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
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^RQMyProjectBlock)(NSArray* array,NSString* tips,NSError* er);



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
@end
