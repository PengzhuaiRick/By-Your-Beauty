//
//  UNIMyAppointInfoRequest.m
//  Uni
//  预约详情界面
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyAppointInfoRequest.h"

@implementation UNIMyAppointInfoRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    
    //获取预约详情信息
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        if ([param2 isEqualToString:API_URL_GetAppointInfo]) {
            if (code == 0) {
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* models = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dic in result) {
                    UNIMyAppointInfoModel* model = [[UNIMyAppointInfoModel alloc]initWithDic:dic];
                    [models addObject:model];
                }
                _reqMyAppointInfo(models,tips,nil);
            }else
                _reqMyAppointInfo(nil,tips,nil);
        }
    }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    //获取预约详情信息
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        if ([param2 isEqualToString:API_URL_GetAppointInfo])
            _reqMyAppointInfo(nil,nil,err);
    }
}

@end
