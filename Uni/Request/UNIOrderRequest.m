//
//  UNIOrderRequest.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderRequest.h"

@implementation UNIOrderRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
    //NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    if (code != 0) {
        if (tips.length<1) tips = @"服务器处理失败， 未知错误";
    }
        //获取订单列表
        if ([param2 isEqualToString:API_URL_MyOrderList]) {
            if (code == 0) {
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* models = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dic in result) {
                    UNIOrderListModel* model = [[UNIOrderListModel alloc]initWithDic:dic];
                    [models addObject:model];
                }
                _myOrderListBlock(models,tips,nil);
            }
            else
                _myOrderListBlock(nil,tips,nil);
    }
    
    //获取订单列表
    if ([param2 isEqualToString:API_URL_GetMyOrder]) {
        if (code == 0) {
            NSArray* result = [self safeObject:dic ForKey:@"result"];
            NSMutableArray* models = [NSMutableArray arrayWithCapacity:result.count];
            for (NSDictionary* dic in result) {
                UNIOrderListModel* model = [[UNIOrderListModel alloc]initWithDic:dic];
                [models addObject:model];
            }
            _myOrderListBlock(models,tips,nil);
        }
        else
            _myOrderListBlock(nil,tips,nil);
    }

    
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    //NSString* param1 = array[0];
    NSString* param2 = array[0];
         //获取订单列表
    if ([param2 isEqualToString:API_URL_MyOrderList])
            _myOrderListBlock(nil,nil,err);
    
    //获取新的订单列表
    if ([param2 isEqualToString:API_URL_GetMyOrder])
        _myOrderListBlock(nil,nil,err);
}
@end
