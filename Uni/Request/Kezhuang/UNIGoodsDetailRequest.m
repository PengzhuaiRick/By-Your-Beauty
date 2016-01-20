//
//  UNIGoodsDetailRequest.m
//  Uni
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIGoodsDetailRequest.h"
#import "UNIMyRewardModel.h"
#import "UNIGoodsModel.h"
@implementation UNIGoodsDetailRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        
        //客妆 商品信息接口
        if ([param2 isEqualToString:API_URL_GetSellInfo]) {
             if(code == 0 ){
                 NSArray* result = [self safeObject:dic ForKey:@"result"];
                 NSMutableArray* array = [NSMutableArray arrayWithCapacity:result.count];
                 for (NSDictionary* dia in result) {
                     UNIGoodsModel * model = [[UNIGoodsModel alloc]initWithDic:dia];
                     [array addObject:model];
                 }
                 _kzgoodsInfoBlock(array,tips,nil);
             }else
                 _kzgoodsInfoBlock(nil,tips,nil);
        }
        
        //客妆奖励接口
        if ([param2 isEqualToString:API_URL_SellReward]) {
            if(code == 0 ){
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* array = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dia in result) {
                    UNIMyRewardModel * model = [[UNIMyRewardModel alloc]initWithDic:dia];
                    [array addObject:model];
                }
                _kzrewardBlock(array,tips,nil);
            }else
                _kzrewardBlock(nil,tips,nil);
        }
        //客妆 获取订单号
        if ([param2 isEqualToString:API_URL_GetOutTradeNo]) {//API_URL_GetOutTradeNo
            if(code == 0 ){
                NSString* outTradeNo = [self safeObject:dic ForKey:@"getOutTradeNo"];
              
                _kzgoodsGetOrderBlock(outTradeNo,tips,nil);
            }else
                _kzrewardBlock(nil,tips,nil);
        }
    }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        //客妆奖励接口
        if ([param2 isEqualToString:API_URL_SellReward])
            _kzrewardBlock(nil,nil,err);
         //客妆 商品信息接口
        if ([param2 isEqualToString:API_URL_GetSellInfo]) {
             _kzgoodsInfoBlock(nil,nil,err);
        }
    }
    
    
}

@end
