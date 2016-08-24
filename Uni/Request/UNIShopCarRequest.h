//
//  UNIShopCarRequest.h
//  Uni
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseRequest.h"
//添加到购物车，修改购物车数量，减少购物车数量
typedef void(^ChangeGoodsToCart)(NSString* msg,NSError* err);

//获取购物车有多少种商品
typedef void(^GetCartGoodsCount)(int count,NSString* msg,NSError* err);

//删除购物车物品
typedef void(^DelCartGoods)(NSString* msg,NSError* err);
@interface UNIShopCarRequest : BaseRequest

@end
