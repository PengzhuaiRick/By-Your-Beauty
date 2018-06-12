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
   // NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    if (code != 0) {
        if (tips.length<1) tips = @"服务器处理失败， 未知错误";
    }
    //获取预约详情信息
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
        
        //服务评论
        if ([param2 isEqualToString:API_URL_SetServiceAppraise]) {
            if (code == 0)
                _rqAppraise( code,tips,nil);
            else
                _rqAppraise( -1,tips,nil);
        }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
   // NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    if ([param2 isEqualToString:API_URL_GetAppointInfo])
            _reqMyAppointInfo(nil,nil,err);
        
    ////服务评论
    if ([param2 isEqualToString:API_URL_GoodsAppraise])
          _rqAppraise( -1,nil,nil);
}

@end
