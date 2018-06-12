//
//  UNIMypointRequest.h
//  Uni
//  预约界面请求
//  Created     by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIMyProjectModel.h"
/**
 * 获取项目可预约时间
 *
 *  @param times 可预约时间组
 *  @param tips  反馈信息
 *  @param er   错误信息
 */
typedef void(^RQGetFreeTime)(NSArray* times,NSString*tips,NSError* er);

/**
 *  确定预约项目
 *
 *  @param order 预约号
 *  @param tips  反馈信息
 *  @param er   错误信息
 */
typedef void(^RQSetAppoint)(NSString* order,NSString*tips,NSError* er);

/**
 *  获取店铺列表信息
 *
 *  @param arr 店铺信息数组
 *  @param tips  反馈信息
 *  @param er   错误信息
 */
typedef void(^RQShopList)(NSArray* arr,NSString*tips,NSError* er);

/**
 *  获取服务项目内容信息
 *
 *  @param arr 服务对象信息
 *  @param tips  反馈信息
 *  @param er   错误信息
 */
typedef void(^RQService)(UNIMyProjectModel* model,NSString*tips,NSError* er);


@interface UNIMypointRequest : BaseRequest

//获取项目可预约时间
@property (copy ,nonatomic) RQGetFreeTime regetFreeTime;

//确定预约项目
@property (copy ,nonatomic) RQSetAppoint resetAppoint;

//获取店铺列表信息
@property (copy ,nonatomic) RQShopList rqshopList;

//获取服务项目内容信息
@property (copy ,nonatomic) RQService rqservice;

@end
