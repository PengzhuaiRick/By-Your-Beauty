//
//  AccountManager.h
//  YITravelCard
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 weconex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject
//NSLog(@"");
/**
 *  本地存储用户token
 */
@property(nonatomic,strong)NSString *token;
/**
 *  设备属性参数
 */
@property(nonatomic,strong)NSString *terminalCode;
/**
 *  记住的用户 在本地存储用户名 -用于登录显示记住的用户名(其他场景请到memerInfo中获取用户名)
 */
@property(nonatomic,strong)NSString *localLoginName;

/**
 *  用户ID
 */
@property(nonatomic,strong)NSNumber* userId;
/**
 *  店铺ID
 */
@property(nonatomic,strong)NSNumber* shopId;

+ (AccountManager *)shared;

#pragma mark  静态方法

/**
 *  获取单例对象
 *
 *  @return
 */

//+ (instancetype)sharedInstance;


/**
 *  获取token和设置token的静态方法
 *
 */
+ (NSString*)token;
+ (void)setToken:(NSString*)token;


/**
 *  获取和设置userId
 *
 */
+ (NSNumber*)userId;
+ (void)setUserId:(NSNumber*)userid;


/**
 *  获取和设置店铺ID
 *
 *  @param shopId
 */
+(void)setShopId:(NSNumber *)shopId;

+(NSNumber *)shopId;


#pragma mark  动态方法

/**
 * 清除除登录名以外所保存的字段
 */
- (void)clear;

/**
 *     清楚所有保存的字段
 */
- (void)clearAll;

/**
 *  判断是否登录
 *
 *
 */
- (BOOL)isLogin;


/**
 *  获取用户的登录名（登录手机号码）
 *
 *  @return
 */
//-(NSString *)getLoginName;

@end
