//
//  UNIGoodsDetailRequest.h
//  Uni
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIGoodsModel.h"
/**
 *  客妆 我的奖励
 *
 *  @param array UNIMyRewardModel.h 的对象数组
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^KZRewardBlock)(NSArray* array,NSString* tips,NSError* er);

/**
 *  客妆 商品信息
 *
 *  @param array UNIGoodsModel.h 数组对象
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^KZGoodsInfoBlock)(NSArray* array,NSString* tips,NSError* er);


@interface UNIGoodsDetailRequest : BaseRequest

// 客妆 我的奖励
@property(nonatomic,copy)KZRewardBlock kzrewardBlock;

// 客妆 商品信息
@property(nonatomic,copy)KZGoodsInfoBlock kzgoodsInfoBlock;
@end
