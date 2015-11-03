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

#pragma mark 设置localLoginName方法
-(void)setLocalLoginName:(NSString *)localLoginName
{
    if (!localLoginName)localLoginName=@"";
    [self syncSetObject:localLoginName forKey:userNameDefaultKey];
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

- (void)clearAll
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:tokenDefaultKey];
    [userDefaults removeObjectForKey:userNameDefaultValue];
    [userDefaults synchronize];
    [self clear];
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

- (NSString *)stringWithKey:(NSString *)keyName

{
    NSString *string=[[NSUserDefaults standardUserDefaults] valueForKey:keyName];
    
    return string;
}


@end
