//
//  UNIShopCarRequest.h
//  Uni
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIShopCarModel.h"


//添加到购物车，修改购物车数量，减少购物车数量
typedef void(^ChangeGoodsToCart)(NSString* msg,NSError* err);

//获取购物车有多少种商品
typedef void(^GetCartGoodsCount)(int count,NSString* msg,NSError* err);

//删除购物车物品
typedef void(^DelCartGoods)(NSString* msg,NSError* err);

//是否全选
typedef void(^ChangeCartGoodsIsCheck)(NSString* msg,NSError* err);

//修改某个商品是否选中
typedef void(^CartIsCheck)(NSString* msg,NSError* err);

//获取购物车列表
typedef void(^GetCartList)(NSArray* array,NSString* msg,NSError* err);

/**
 *  获取购物车底部信息，比如是否全选，金额等
 *
 *  @param endPrice   合计金额
 *  @param isAll      1 全部选中，0 不是
 *  @param isCheckNum 选中个数
 *  @param msg        反馈信息
 *  @param err        错误报告
 */
typedef void(^GetCartBottomInfo)(float endPrice,int isAll,int isCheckNum,NSString* msg,NSError* err);

@interface UNIShopCarRequest : BaseRequest



@property(nonatomic,copy)ChangeGoodsToCart changeGoodsToCart;
@property(nonatomic,copy)GetCartGoodsCount getCartGoodsCount;
@property(nonatomic,copy)DelCartGoods delCartGoods;
@property(nonatomic,copy)ChangeCartGoodsIsCheck changeCartGoodsIsCheck;
@property(nonatomic,copy)CartIsCheck cartIsCheck;
@property(nonatomic,copy)GetCartList getCartList;
@property(nonatomic,copy)GetCartBottomInfo getCartBottomInfo;
@end
