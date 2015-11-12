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
    NSLog(@"requestSucceed  %@",dic);
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
            _rqvertifivaBlock(phone,lastLoginTime,randcode,tips,nil);
        }else
            _rqvertifivaBlock(nil,nil,nil,tips,nil);
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
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    //登录验证码
    if ([param1 isEqualToString:API_PARAM_SSMS]&&
        [param2 isEqualToString:API_URL_Login]) {
        _rqvertifivaBlock(nil,nil,nil,nil,err);
    }
    //请求登录
    if ([param1 isEqualToString:API_PARAM_UNI]&&
        [param2 isEqualToString:API_URL_Login]) {
        _rqloginBlock(-1,-1,nil,nil,err);
    }

}
@end
