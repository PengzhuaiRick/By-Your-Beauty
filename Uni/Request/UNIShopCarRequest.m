//
//  UNIShopCarRequest.m
//  Uni
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIShopCarRequest.h"

@implementation UNIShopCarRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
    //NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    if (code != 0) {
        if (tips.length<1) tips = @"服务器处理失败， 未知错误";
    }
    
    //添加到购物车，修改购物车数量，减少购物车数量
    if ([param2 isEqualToString:API_URL_ChangeNumOfShopCar]) {
        if (code == 0) {
            if (_changeGoodsToCart)
                _changeGoodsToCart(tips,nil);
        }
    }
    //获取购物车有多少种商品
    if ([param2 isEqualToString:API_URL_GetKindOfShopCar]) {
        if (code == 0) {
            
        }
    }
    
    //删除购物车物品
    if ([param2 isEqualToString:API_URL_DelCartGoods]) {
        if (code == 0) {
            
        }
    }
    
    //是否全选
    if ([param2 isEqualToString:API_URL_ChangeCartGoodsIsCheck]) {
        if (code == 0) {
            
        }
    }
    
    //修改某个商品是否选中
    if ([param2 isEqualToString:API_URL_CartIsCheck]) {
        if (code == 0) {
            
        }
    }
    //获取购物车列表
    if ([param2 isEqualToString:API_URL_GetCartList]) {
        if (code == 0) {
            NSDictionary* cartInfo = [self safeObject:dic ForKey:@"cartInfo"];
            NSArray* cartGoods = [self safeObject:cartInfo ForKey:@"cartGoods"];
            NSMutableArray* arr = [NSMutableArray arrayWithCapacity:cartGoods.count];
            for (NSDictionary* dic in cartGoods) {
                UNIShopCarModel* model = [[UNIShopCarModel alloc]initWithDic:dic];
                [arr addObject:model];
            }
            if (_getCartList)
                _getCartList(array,tips,nil);
        }else{
            if (_getCartList)
                _getCartList(nil,tips,nil);}
    }
    //获取购物车底部信息，比如是否全选，金额等
    if ([param2 isEqualToString:API_URL_GetCartBottomInfo]) {
        if (code == 0) {
            float endPrice = [[self safeObject:dic ForKey:@"endPrice"]floatValue];
            int isAll = [[self safeObject:dic ForKey:@"isAll"]intValue];
            int isCheckNum = [[self safeObject:dic ForKey:@"isCheckNum"]intValue];
            if (_getCartBottomInfo)
                _getCartBottomInfo(endPrice,isAll,isCheckNum,tips,nil);
            
        }else{
            if (_getCartBottomInfo)
                _getCartBottomInfo(-1,-1,-1,tips,nil);

        }
    }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    // NSString* param1 = array[0];
    NSString* param2 = array[0];
    //添加到购物车，修改购物车数量，减少购物车数量
    if ([param2 isEqualToString:API_URL_ChangeNumOfShopCar]) {
        if (_changeGoodsToCart)
            _changeGoodsToCart(nil,err);
    }
    //获取购物车有多少种商品
    if ([param2 isEqualToString:API_URL_GetKindOfShopCar]) {
      
    }
    
    //删除购物车物品
    if ([param2 isEqualToString:API_URL_DelCartGoods]) {
     
    }
    
    //是否全选
    if ([param2 isEqualToString:API_URL_ChangeCartGoodsIsCheck]) {
        
    }
    
    //修改某个商品是否选中
    if ([param2 isEqualToString:API_URL_CartIsCheck]) {
      
    }
    //获取购物车列表
    if ([param2 isEqualToString:API_URL_GetCartList]) {
        if (_getCartList)
            _getCartList(nil,nil,err);
    }
    //获取购物车底部信息，比如是否全选，金额等
    if ([param2 isEqualToString:API_URL_GetCartBottomInfo]) {
        if (_getCartBottomInfo)
                _getCartBottomInfo(-1,-1,-1,nil,err);
        
    }


    
}
@end
