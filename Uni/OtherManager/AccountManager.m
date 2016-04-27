//
//  AccountManager.m
//  YITravelCard
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 weconex. All rights reserved.
//

#import "AccountManager.h"

#define tokenDefaultKey         @"tokenDefaultKey"
#define userNameDefaultKey    @"userNameDefaultKey"
#define userIdKey             @"userIdKey"
#define userShopID            @"userShopId"
#define WXUnionid            @"WXUnionid"
#define WXOpenid            @"WXOpenid"
/**
 *  用户token
 */
#define tokenDefaultValue [[NSUserDefaults standardUserDefaults] valueForKey:tokenDefaultKey]
/**
 *  用户名
 */
#define userNameDefaultValue [[NSUserDefaults standardUserDefaults] valueForKey:userNameDefaultKey]

@implementation AccountManager


+ (AccountManager *)shared
{
    static AccountManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[AccountManager alloc] init];
    });
    return _sharedManager;
}

#pragma mark 获取token的静态方法
+ (NSString*)token
{
    NSString *token = [[[self class] shared] token];
     return token;
}

#pragma mark 保存token的静态方法
+ (void)setToken:(NSString*)token {
    [[[self class] shared] setToken:token];
}


#pragma mark token 属性的getter方法
- (NSString*)token
{
    NSString *token=[self  stringWithKey:tokenDefaultKey];
    if (!token)token=@"";
    
    return token;
}

#pragma mark token 属性的setter方法
-(void)setToken:(NSString *)token
{
    if (!token)token=@"";
    [self syncSetObject:token forKey:tokenDefaultKey];
}


#pragma mark 获取localLoginName方法
- (NSString*)localLoginName
{
    NSString *localLoginName=[self  stringWithKey:userNameDefaultKey];
    if (!localLoginName)localLoginName=@"";
    
    return localLoginName;
}
+(NSString*)localLoginName{
    NSString *localLoginName = [[[self class] shared] localLoginName];
    return localLoginName;
}

#pragma mark 设置localLoginName方法
-(void)setLocalLoginName:(NSString *)localLoginName
{
    if (!localLoginName)localLoginName=@"";
    [self syncSetObject:localLoginName forKey:userNameDefaultKey];
}

+(void)setLocalLoginName:(NSString *)localLoginName{
     [[[self class] shared] setLocalLoginName:localLoginName];
}

#pragma mark 获取token的静态方法
+ (NSNumber*)userId
{
    NSNumber *userid = [[[self class] shared] userId];
    return userid;
}

#pragma mark 保存token的静态方法
+ (void)setUserId:(NSNumber*)userid{
    [[[self class] shared] setUserId:userid];
}

-(void)setUserId:(NSNumber *)userId{
    if (!userId)userId = nil;
    [self syncSetObject:userId forKey:userIdKey];
}
-(NSNumber *)userId{
    return (NSNumber*)[self stringWithKey:userIdKey];
}

+(void)setShopId:(NSNumber *)shopId{
    [[[self class] shared]setShopId:shopId];
}

+(NSNumber *)shopId{
    NSNumber* shopid = [[[self class]shared]shopId];
    return shopid;
}

-(void)setShopId:(NSNumber *)shopId{
    if (!shopId) shopId = nil;
    [self syncSetObject:shopId forKey:userShopID];
}
-(NSNumber *)shopId{
    NSNumber* shopid = [self stringWithKey:userShopID];
    if (!shopid)
        shopid=nil;
    
    return shopid;
}

+(void)setUnionid:(NSString *)unionid{
    [[[self class] shared]setUnionid:unionid];
}

+(NSString *)unionid{
    NSString* unionid = [[[self class]shared]unionid];
    return unionid;
}

-(void)setUnionid:(NSString *)unionid{
    if (!unionid) unionid = nil;
    [self syncSetObject:unionid forKey:WXUnionid];
}
-(NSString *)unionid{
    NSString *unionid = [self stringWithKey:WXUnionid];
    if (!unionid)
        unionid=nil;
    
    return unionid;
}



+(void)setOpenid:(NSString *)openid{
    [[[self class] shared]setOpenid:openid];
}

+(NSString *)openid{
    NSString* openid = [[[self class]shared]openid];
    return openid;
}

-(void)setOpenid:(NSString *)openid{
    if (!openid) openid = nil;
    [self syncSetObject:openid forKey:WXOpenid];
}
-(NSString *)openid{
    NSString *openid = [self stringWithKey:WXOpenid];
    if (!openid)
        openid=nil;
    
    return openid;
}

- (void)clear
{
//    self.memberInfo = nil;
    self.token = nil;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:tokenDefaultKey];
    [userDefaults synchronize];
}

#pragma mark  清楚所有  用户注册成功后使用

+ (void)clearAll
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:tokenDefaultKey];
   // [userDefaults removeObjectForKey:userNameDefaultValue];
    [userDefaults removeObjectForKey:userIdKey];
    [userDefaults removeObjectForKey:userShopID];
    [userDefaults removeObjectForKey:WXUnionid];
    [userDefaults removeObjectForKey:WXOpenid];
    [userDefaults removeObjectForKey:@"appointArr"];//清除提醒本地通知
    [userDefaults synchronize];
}


- (BOOL)isLogin
{
    if (tokenDefaultValue == nil || [tokenDefaultValue isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)syncSetObject:(id)value forKey:(NSString *)keyName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:value forKey:keyName];
    
    [userDefaults synchronize];
}

- (id)stringWithKey:(NSString *)keyName

{
    id string=[[NSUserDefaults standardUserDefaults] valueForKey:keyName];
    
    return string;
}


@end
