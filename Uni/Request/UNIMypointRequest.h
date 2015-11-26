//
//  UNIMypointRequest.h
//  Uni
//  预约界面请求
//  Created     by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"

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

@interface UNIMypointRequest : BaseRequest

//获取项目可预约时间
@property (copy ,nonatomic) RQGetFreeTime regetFreeTime;

//确定预约项目
@property (copy ,nonatomic) RQSetAppoint resetAppoint;

@end
