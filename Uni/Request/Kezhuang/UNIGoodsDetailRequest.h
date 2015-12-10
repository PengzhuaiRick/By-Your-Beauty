//
//  UNIGoodsDetailRequest.h
//  Uni
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
/**
 *  客妆 我的奖励
 *
 *  @param array UNIMyRewardModel.h 的对象数组
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^KZRewardBlock)(NSArray* array,NSString* tips,NSError* er);
@interface UNIGoodsDetailRequest : BaseRequest

// 客妆 我的奖励
@property(nonatomic,assign)KZRewardBlock kzrewardBlock;
@end
