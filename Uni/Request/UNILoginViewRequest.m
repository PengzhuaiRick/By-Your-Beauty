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
   // NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
     NSString* tips = [self safeObject:dic ForKey:@"tips"];
    if (code != 0) {
        if (tips.length<1) tips = @"服务器处理失败， 未知错误";
    }
   
    
    //登录验证码
    if ([param1 isEqualToString:API_URL_Verify]) {
        
        if (code ==0) {
            long server_time = [[self safeObject:dic ForKey:@"server_time"] longValue];
            NSString* phone = [self safeObject:dic ForKey:@"phone"];
            NSString* randcode = [self safeObject:dic ForKey:@"randcode"];
            NSString* name = [self safeObject:dic ForKey:@"name"];
            int sex =[[self safeObject:dic ForKey:@"sex"] intValue];
            int status =[[self safeObject:dic ForKey:@"status"] intValue];
            _rqvertifivaBlock(status,sex,name,phone,server_time,randcode,tips,nil);
        }else
            _rqvertifivaBlock(-1,-1,nil,nil,-1,nil,tips,nil);
    }
    //请求登录
    if ([param1 isEqualToString:API_URL_Login]) {
         if (code == 0 || code == 2) {
              int extra = [[self safeObject:dic ForKey:@"extra"] intValue];
             NSArray* result = [self safeObject:dic ForKey:@"result"];
             NSMutableArray* arr = [NSMutableArray array];
             for (NSDictionary* dia in result) {
                 UNILoginShopModel* model = [[UNILoginShopModel alloc]initWithDic:dia];
                 [arr addObject:model];
             }
             _rqloginBlock(extra,arr,tips,nil);
         }else
             _rqloginBlock(-1,nil,tips,nil);
    }
    //请求游客基础信息
    if ([param1 isEqualToString:API_URL_GetCustomInfo]) {
        if (code == 0) {
            int projectId = [[self safeObject:dic ForKey:@"projectId"] intValue];
            int shopId = [[self safeObject:dic ForKey:@"shopId"] intValue];
            _rqTouristBlock(shopId,projectId,tips,nil);
        }else
            _rqTouristBlock(-1,-1,tips,nil);
    }
    
    //设置游客基础信息
    if ([param1 isEqualToString:API_URL_SetCustomInfo]) {
        if (code == 0|| code == 7) {
            NSString* tel = [self safeObject:dic ForKey:@"tel"];
            _setTouristBlock(code,tel,tips,nil);
        }else
            _setTouristBlock(-1,nil,tips,nil);
    }

    //请求游客按钮显示
    if ([param1 isEqualToString:API_URL_RetCode]) {
            _rqtouristBtn(code,tips,nil);
    }
    //新用户选择店铺
    if ([param1 isEqualToString:API_URL_addUser]) {
        if (code == 0) {
            int userId = [[self safeObject:dic ForKey:@"userId"] intValue];
            int shopId = [[self safeObject:dic ForKey:@"shopId"] intValue];
            NSString* token = [self safeObject:dic ForKey:@"token"] ;
            _sAddUser(userId,shopId,token,tips,nil);
        }else
            _sAddUser(-1,-1,nil,tips,nil);
       
    }

}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    //NSString* param2 = array[1];
    
    //登录验证码
    if ([param1 isEqualToString:API_URL_Verify]) {
        _rqvertifivaBlock(-1,-1,nil,nil,-1,nil,nil,err);
    }
    //请求登录
    if ([param1 isEqualToString:API_URL_Login]) {
        _rqloginBlock(-1,nil,nil,err);
    }
    //请求游客基础信息
    if ([param1 isEqualToString:API_URL_GetCustomInfo]) {
            _rqTouristBlock(-1,-1,nil,err);
    }
    //设置游客基础信息
    if ([param1 isEqualToString:API_URL_SetCustomInfo]) {
            _setTouristBlock(-1,nil,nil,err);
    }
    
    //请求游客按钮显示
    if ([param1 isEqualToString:API_URL_RetCode]) {
        _rqtouristBtn(-1,nil,err);
    }
    
    //新用户选择店铺
    if ([param1 isEqualToString:API_URL_addUser]) {
        _sAddUser(-1,-1,nil,nil,err);
    }
}
@end
