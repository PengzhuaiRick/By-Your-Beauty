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
 *
 *  @param ph  手机号码
 *  @param llt 最近登录时间
 *  @param rc  验证码
 *  @param tip 反馈信息
 *  @param er  错误信息
 */
typedef void(^RqVertifivaBlock)(NSString* ph,NSString* llt,NSString* rc,NSString*tip,NSError* er);


/**
 *  请求登录Block
 *
 *  @param userId 用户ID
 *  @param shopId 美容院ID
 *  @param token
 *  @param tips   反馈信息
 *  @param er     错误信息
 */
typedef void(^RqLoginBlock)(int userId,int shopId,NSString* token,NSString* tips,NSError* er);

@interface UNILoginViewRequest : BaseRequest


//请求验证码Block
@property(nonatomic,copy)RqVertifivaBlock rqvertifivaBlock;

//请求登录Block
@property(nonatomic,copy)RqLoginBlock rqloginBlock;


@end
