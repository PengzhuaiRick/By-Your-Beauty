//
//  UNILoginViewRequest.m
//  Uni
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNILoginViewRequest.h"

@implementation UNILoginViewRequest


-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
   // NSLog(@"requestSucceed  %@",dic);
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
     NSString* tips = [self safeObject:dic ForKey:@"tips"];
    
    //登录验证码
    if ([param1 isEqualToString:API_PARAM_SSMS]&&
        [param2 isEqualToString:API_URL_Login]) {
        
        if (code ==0) {
            NSString* lastLoginTime = [self safeObject:dic ForKey:@"lastLoginTime"];
            NSString* phone = [self safeObject:dic ForKey:@"phone"];
            NSString* randcode = [self safeObject:dic ForKey:@"randcode"];
            NSString* name = [self safeObject:dic ForKey:@"name"];
            int sex =[[self safeObject:dic ForKey:@"sex"] intValue];
            int status =[[self safeObject:dic ForKey:@"status"] intValue];
            _rqvertifivaBlock(status,sex,name,phone,lastLoginTime,randcode,tips,nil);
        }else
            _rqvertifivaBlock(-1,-1,nil,nil,nil,nil,tips,nil);
    }
    //请求登录
    if ([param1 isEqualToString:API_PARAM_UNI]&&
        [param2 isEqualToString:API_URL_Login]) {
        int userId = [[self safeObject:dic ForKey:@"userId"] intValue];
        int shopId = [[self safeObject:dic ForKey:@"shopId"] intValue];
        NSString* token = [self safeObject:dic ForKey:@"token"];
        NSString* tips = [self safeObject:dic ForKey:@"tips"];
        _rqloginBlock(userId,shopId,token,tips,nil);
    }
    //请求游客基础信息
    if ([param1 isEqualToString:API_PARAM_UNI]&&
        [param2 isEqualToString:API_URL_GetCustomInfo]) {
        if (code == 0) {
            int projectId = [[self safeObject:dic ForKey:@"projectId"] intValue];
            int shopId = [[self safeObject:dic ForKey:@"shopId"] intValue];
            _rqTouristBlock(shopId,projectId,tips,nil);
        }else
            _rqTouristBlock(-1,-1,tips,nil);
    }
    
    //设置游客基础信息
    if ([param1 isEqualToString:API_PARAM_UNI]&&
        [param2 isEqualToString:API_URL_SetCustomInfo]) {
        if (code == 0|| code == 7) {
            NSString* tel = [self safeObject:dic ForKey:@"tel"];
            _setTouristBlock(code,tel,tips,nil);
        }else
            _setTouristBlock(-1,nil,tips,nil);
    }


}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    //登录验证码
    if ([param1 isEqualToString:API_PARAM_SSMS]&&
        [param2 isEqualToString:API_URL_Login]) {
        _rqvertifivaBlock(-1,-1,nil,nil,nil,nil,nil,err);
    }
    //请求登录
    if ([param1 isEqualToString:API_PARAM_UNI]&&
        [param2 isEqualToString:API_URL_Login]) {
        _rqloginBlock(-1,-1,nil,nil,err);
    }
    //请求游客基础信息
    if ([param1 isEqualToString:API_PARAM_UNI]&&
        [param2 isEqualToString:API_URL_GetCustomInfo]) {
            _rqTouristBlock(-1,-1,nil,err);
    }
    //设置游客基础信息
    if ([param1 isEqualToString:API_PARAM_UNI]&&
        [param2 isEqualToString:API_URL_SetCustomInfo]) {
            _setTouristBlock(-1,nil,nil,err);
    }

}
@end
