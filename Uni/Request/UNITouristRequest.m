//
//  UNITouristRequest.m
//  Uni
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNITouristRequest.h"

@implementation UNITouristRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        if ([param2 isEqualToString:API_URL_ActivityShare]) {
            if (code==0) {
                NSDictionary* result = [self safeObject:dic ForKey:@"result"];
                UNITouristModel* model = [[UNITouristModel alloc]initWithDic:result];
                _getTouristinfo(model,tips,nil);
            }else
                _getTouristinfo(nil,tips,nil);
        }
        if ([param2 isEqualToString:API_URL_GetCustomInfo]) {
            if (code == 0) {
                int projectId = [[self safeObject:dic ForKey:@"projectId"] intValue];
                int shopId = [[self safeObject:dic ForKey:@"shopId"] intValue];
                _rqTouristBlock(shopId,projectId,tips,nil);
            }else
                _rqTouristBlock(-1,-1,tips,nil);
        }
        
        //设置游客基础信息
        if ([param2 isEqualToString:API_URL_SetCustomInfo]) {
            if (code == 0|| code == 7) {
                NSString* tel = [self safeObject:dic ForKey:@"tel"];
                 NSString* token = [self safeObject:dic ForKey:@"token"];
                int userId = [[self safeObject:dic ForKey:@"userId"] intValue];
                int shopId = [[self safeObject:dic ForKey:@"shopId"] intValue];
                _setTouristBlock(code,userId,shopId,token,tel,tips,nil);
            }else
                _setTouristBlock(-1,-1,-1,nil,nil,tips,nil);
        }

    }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        if ([param2 isEqualToString:API_URL_ActivityShare]) {
            _getTouristinfo(nil,nil,err);
        }
        
        //请求游客基础信息
        if ([param2 isEqualToString:API_URL_GetCustomInfo]) {
            _rqTouristBlock(-1,-1,nil,err);
        }
        //设置游客基础信息
        if ([param2 isEqualToString:API_URL_SetCustomInfo]) {
             _setTouristBlock(-1,-1,-1,nil,nil,nil,err);
        }
    }
    
    
}
@end
