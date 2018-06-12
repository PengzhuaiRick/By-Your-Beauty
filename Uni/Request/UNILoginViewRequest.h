//
//  UNILoginViewRequest.h
//  Uni
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNILoginShopModel.h"
/**
 *  请求验证码Block
 *  @param sex  性别
    @param status  3为游客
    @param name 用户别名
 *  @param ph  手机号码
 *  @param st 服务器时间
 *  @param rc  验证码
 *  @param tip 反馈信息
 *  @param er  错误信息
 */
typedef void(^RqVertifivaBlock)( int status,int sex,NSString* name,NSString* ph,long st,NSString* rc,NSString*tip,NSError* er);


/**
 *  请求登录Block
 *  @param extra  0 没有用户，1 ，一个用户，2 ，2个以上
    @param array  用户有的店铺列表
 *  @param tips   反馈信息
 *  @param er     错误信息
 */
typedef void(^RqLoginBlock)(int extra,NSArray* array,NSString* tips,NSError* er);

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

/**
 *  请求游客按钮显示
 *  @param code
 *  @param tips      反馈信息
 *  @param er        错误信息
 */
typedef void(^RQTouristBtn)(int code,NSString* tips,NSError* er);

/**
 *  新用户选择店铺
 *  @param code
 *  @param tips      反馈信息
 *  @param er        错误信息
 */
typedef void(^SAddUser)(int userId,int shopId,NSString* token,NSString* tips,NSError* er);

@interface UNILoginViewRequest : BaseRequest


//请求验证码Block
@property(nonatomic,copy)RqVertifivaBlock rqvertifivaBlock;

//请求登录Block
@property(nonatomic,copy)RqLoginBlock rqloginBlock;

//请求游客基础信息
@property(nonatomic,copy)RqTouristBlock rqTouristBlock;

//设置游客基础信息
@property(nonatomic,copy)STouristBlock setTouristBlock;

//请求游客按钮显示
@property(nonatomic,copy)RQTouristBtn rqtouristBtn;

//新用户选择店铺
@property(nonatomic,copy)SAddUser sAddUser;
@end
