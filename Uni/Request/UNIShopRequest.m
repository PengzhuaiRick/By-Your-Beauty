//
//  UNIShopRequest.m
//  Uni
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIShopRequest.h"

@implementation UNIShopRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
   // NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    if (code != 0) {
        if (tips.length<1) tips = @"服务器处理失败， 未知错误";
    }
        //获取商铺信息
        if ([param2 isEqualToString:API_URL_ShopInfo] ) {
            if (code == 0) {
                UNIShopModel* manager =[[UNIShopModel alloc]initWithDic:dic];
                _rwshopModelBlock(manager,tips,nil);
            }else
                _rwshopModelBlock(nil,tips,nil);
        }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
   // NSString* param1 = array[0];
    NSString* param2 = array[0];
        
        //商店信息
        if ([param2 isEqualToString:API_URL_ShopInfo] )
            _rwshopModelBlock(nil,nil,err);
    
    
}

@end
