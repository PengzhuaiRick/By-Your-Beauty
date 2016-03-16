//
//  UNITouristRequest.h
//  Uni
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNITouristModel.h"

/**
 *  获取活动信息
 *
 *  @param model 封装活动的信息
 *  @param tips  信息反馈
 *  @param err   错误提示
 */
typedef void(^GetTouristinfo)(UNITouristModel* model,NSString* tips,NSError* err);

/**
 *  请求游客基础信息
 *
 *  @param shopId    店铺ID
 *  @param projectId 项目ID
 *  @param tips      反馈信息
 *  @param er        错误信息
 */
typedef void(^RqTouristBlock)(int shopId,int projectId,NSString* tips,NSError* er);

/**
 *  设置游客基础信息
 *
 *  @param shopId    店铺ID
 *  @param projectId 项目ID
 *  @param tips      反馈信息
 *  @param er        错误信息
 */
typedef void(^STouristBlock)(int code,NSString* tel,NSString* tips,NSError* er);

@interface UNITouristRequest : BaseRequest

//获取活动信息 Block
@property(copy,nonatomic)GetTouristinfo getTouristinfo;

//请求游客基础信息
@property(nonatomic,copy)RqTouristBlock rqTouristBlock;

//设置游客基础信息
@property(nonatomic,copy)STouristBlock setTouristBlock;
@end
