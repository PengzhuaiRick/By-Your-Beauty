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
    //NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
        
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
        //客妆 商品信息接口2
        if ([param2 isEqualToString:API_URL_GetSellInfo2]) {
            if(code == 0 ){
                UNIGoodsModel * model = [[UNIGoodsModel alloc]initWithDic:dic];
                NSArray* array = @[model];
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
               // int num = [[self safeObject:dic ForKey:@"num"] intValue];
                float totalPrice = [[self safeObject:dic ForKey:@"totalPrice"] floatValue];
                _kzgoodsGetOrderBlock( totalPrice,outTradeNo,tips,nil);
            }else
                _kzgoodsGetOrderBlock(-1,nil,tips,nil);
        
    }
    

        //获取 支付宝 私钥
        if ([param2 isEqualToString:API_URL_GetAlipayConfig]) {
            if(code == 0 ){
                NSString* partner = [self safeObject:dic ForKey:@"partner"];
                NSString* key = [self safeObject:dic ForKey:@"key"];
                NSString* seller = [self safeObject:dic ForKey:@"seller"];
                NSString* ras_private_key = [self safeObject:dic ForKey:@"ras_private_key"];
                _kzalipayBlock(partner,key,seller,ras_private_key,tips,nil);
               
            }else
                _kzalipayBlock(nil,nil,nil,nil,tips,nil);
        }
        
        //获取 微信支付 私钥
        if ([param2 isEqualToString:API_URL_GetWXConfig]) {
            if(code == 0 ){
                NSString* appid = [self safeObject:dic ForKey:@"appid"];
                NSString* mchid = [self safeObject:dic ForKey:@"mchid"];
                NSString* appsecret = [self safeObject:dic ForKey:@"appsecret"];
                _kzwxpayBlock(appid,mchid,appsecret,tips,nil);
                
            }else
                _kzwxpayBlock(nil,nil,nil,tips,nil);
        }

}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
   // NSString* param1 = array[0];
    NSString* param2 = array[0];
    
        //客妆奖励接口
        if ([param2 isEqualToString:API_URL_SellReward])
            _kzrewardBlock(nil,nil,err);
        
        //客妆 商品信息接口
        if ([param2 isEqualToString:API_URL_GetSellInfo]) {
            _kzgoodsInfoBlock(nil,nil,err);
        }
         //客妆 商品信息接口2
        if ([param2 isEqualToString:API_URL_GetSellInfo2]) {
             _kzgoodsInfoBlock(nil,nil,err);
        }
    
        //获取 支付宝 私钥
        if ([param2 isEqualToString:API_URL_GetAlipayConfig])
            _kzalipayBlock(nil,nil,nil,nil,nil,err);
        
        //获取 微信支付 私钥
        if ([param2 isEqualToString:API_URL_GetWXConfig])
            _kzwxpayBlock(nil,nil,nil,nil,err);
        
        //获取 支付宝 私钥
        if ([param2 isEqualToString:API_URL_GetAlipayConfig])
            _kzgoodsGetOrderBlock(-1,nil,nil,err);

    
}

@end
