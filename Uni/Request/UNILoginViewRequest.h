//
//  UNILoginViewRequest.h
//  Uni
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"

/**
 *  请求验证码Block
 *  @param sex  性别
    @param status  3为游客
    @param name 用户别名
 *  @param ph  手机号码
 *  @param llt 最近登录时间
 *  @param rc  验证码
 *  @param tip 反馈信息
 *  @param er  错误信息
 */
typedef void(^RqVertifivaBlock)( int status,int sex,NSString* name,NSString* ph,NSString* llt,NSString* rc,NSString*tip,NSError* er);


/**
 *  请求登录Block
 *  @param hasActivity 是否弹出活动界面 0：没参加过强制弹出活动页不能关闭； 1 参加过活动弹出活动页能关闭；2 不弹出活动页面
    @param activityId  活动ID
 *  @param userId 用户ID
 *  @param shopId 美容院ID
 *  @param token
 *  @param tips   反馈信息
 *  @param er     错误信息
 */
typedef void(^RqLoginBlock)(int userId,int shopId,int hasActivity,int activityId,NSString* token,NSString* tips,NSError* er);

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

@interface UNILoginViewRequest : BaseRequest


//请求验证码Block
@property(nonatomic,copy)RqVertifivaBlock rqvertifivaBlock;

//请求登录Block
@property(nonatomic,copy)RqLoginBlock rqloginBlock;

//请求游客基础信息
@property(nonatomic,copy)RqTouristBlock rqTouristBlock;

//设置游客基础信息
@property(nonatomic,copy)STouristBlock setTouristBlock;


@end
