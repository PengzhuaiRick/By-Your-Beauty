//
//  UNIMypointRequest.m
//  Uni
//  预约界面请求
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMypointRequest.h"
#import "UNIShopModel.h"

@implementation UNIMypointRequest

-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
   // NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    
    //获取可预约时间
        if ([param2 isEqualToString:API_URL_GetFreeTime]) {
            if (code == 0) {
                NSArray* array = [self safeObject:dic ForKey:@"result"];
                _regetFreeTime(array,tips,nil);
            }else
                _regetFreeTime(nil,tips,nil);
        }
        //确认预约接口
        if ([param2 isEqualToString:API_URL_SetAppoint]) {
            if (code == 0) {
                NSString* order = [self safeObject:dic ForKey:@"order"];
                _resetAppoint(order,tips,nil);
            }else
                _resetAppoint(nil,tips,nil);
        }
        
        //获取店铺列表信息接口
        if ([param2 isEqualToString:API_URL_GetShopListInfo]) {
            if (code == 0) {
                NSMutableArray* arr = [NSMutableArray array];
                NSArray* array = [self safeObject:dic ForKey:@"result"];
                for (NSDictionary* dic in array) {
                    UNIShopModel* model = [[UNIShopModel alloc]initWithDic:dic];
                    [arr addObject:model];
                }
                _rqshopList(arr,tips,nil);
            }else
                 _rqshopList(nil,tips,nil);
        }
        //获取服务信息
        if ([param2 isEqualToString:API_URL_GetProjectModel]) {
            if (code == 0) {
                NSDictionary* result = [self safeObject:dic ForKey:@"result"];
                UNIMyProjectModel* model = [[UNIMyProjectModel alloc]initWithDic:result];
                _rqservice(model,tips,nil);
            }else
                _rqservice(nil,tips,nil);
        }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
   // NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    //获取可预约时间
        if ([param2 isEqualToString:API_URL_GetFreeTime]) {
             _regetFreeTime(nil,nil,err);
        }
        
       // 确认预约接口
        if ([param2 isEqualToString:API_URL_SetAppoint]) {
            _resetAppoint(nil,nil,err);
        }
        //获取店铺列表信息接口
        if ([param2 isEqualToString:API_URL_GetShopListInfo]) {
                _rqshopList(nil,nil,err);
        }
        //获取店铺列表信息接口
        if ([param2 isEqualToString:API_URL_GetProjectModel]) {
           _rqservice(nil,nil,err);
        }
}
@end
