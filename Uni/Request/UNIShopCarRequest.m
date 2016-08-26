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
                _changeGoodsToCart(code,tips,nil);
        }else{
            if (_changeGoodsToCart)
                _changeGoodsToCart(-1,tips,nil);
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
            if (_delCartGoods)
                _delCartGoods(code,tips,nil);
        }else{
            if (_delCartGoods)
                _delCartGoods(-1,tips,nil);
        }
    }
    
    //是否全选
    if ([param2 isEqualToString:API_URL_ChangeCartGoodsIsCheck]) {
        if (code == 0) {
            if (_changeCartGoodsIsCheck)
                _changeCartGoodsIsCheck(code,tips,nil);
        }else{
            if (_changeCartGoodsIsCheck)
                _changeCartGoodsIsCheck(-1,tips,nil);
        }
        
    }
    
    //修改某个商品是否选中
    if ([param2 isEqualToString:API_URL_CartIsCheck]) {
        if (code == 0) {
            if (_cartIsCheck)
                _cartIsCheck(code,tips,nil);
        }else{
            if (_cartIsCheck)
                _cartIsCheck(-1,tips,nil);
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
                _getCartList(arr,tips,nil);
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
    
    //确认订单
    if ([param2 isEqualToString:API_URL_GetCartComfirm]) {
        if (code == 0) {
            float sumPrice = [[self safeObject:dic ForKey:@"sumPrice"] floatValue];
            NSDictionary* cartInfo = [self safeObject:dic ForKey:@"cartInfo"];
            NSArray* cartGoods = [self safeObject:cartInfo ForKey:@"cartGoods"];
            NSMutableArray* arr = [NSMutableArray arrayWithCapacity:cartGoods.count];
            for (NSDictionary* dic in cartGoods) {
                UNIShopCarModel* model = [[UNIShopCarModel alloc]initWithDic:dic];
                [arr addObject:model];
            }
            if (_getCartComfirm)
                _getCartComfirm(sumPrice,arr,tips,nil);
        }else{
            if (_getCartComfirm)
                _getCartComfirm(-1,nil,tips,nil);}
    }
    //支付调用
    if ([param2 isEqualToString:API_URL_GetNewPayInfo]) {
        if (code == 0) {
            if (_getNewPayInfo)
                _getNewPayInfo(dic,tips,nil);
        }else{
            if (_getNewPayInfo)
            _getNewPayInfo(nil,tips,nil);}
    }
    
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    // NSString* param1 = array[0];
    NSString* param2 = array[0];
    //添加到购物车，修改购物车数量，减少购物车数量
    if ([param2 isEqualToString:API_URL_ChangeNumOfShopCar]) {
        if (_changeGoodsToCart)
            _changeGoodsToCart(-1,nil,err);
    }
    //获取购物车有多少种商品
    if ([param2 isEqualToString:API_URL_GetKindOfShopCar]) {
      
    }
    
    //删除购物车物品
    if ([param2 isEqualToString:API_URL_DelCartGoods]) {
        if (_delCartGoods)
            _delCartGoods(-1,nil,err);
    }
    
    //是否全选
    if ([param2 isEqualToString:API_URL_ChangeCartGoodsIsCheck]) {
        if (_changeCartGoodsIsCheck)
            _changeCartGoodsIsCheck(-1,nil,err);
    }
    
    //修改某个商品是否选中
    if ([param2 isEqualToString:API_URL_CartIsCheck]) {
        if (_cartIsCheck)
            _cartIsCheck(-1,nil,err);
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
    
    //确认订单
    if ([param2 isEqualToString:API_URL_GetCartComfirm]) {
        if (_getCartComfirm)
             _getCartComfirm(-1,nil,nil,err);
    }

    //支付调用
    if ([param2 isEqualToString:API_URL_GetNewPayInfo]) {
        if (_getNewPayInfo)
            _getNewPayInfo(nil,nil,err);
    }
}
@end
