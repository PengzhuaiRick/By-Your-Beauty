//
//  UNIMyRewardRequest.h
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIMyRewardModel.h"
/**
 * 我的奖励—约满奖励Bloack
 *
 *  @param arr  UNIMyRewardModel 对象数组
 *  @param num  满足次数
 *  @param tips 反馈信息
 *  @param err  错误信息
 */
typedef void(^MyRewardBlock)(NSArray* arr,int num,NSString* tips,NSError* err);

/**
 * 我的奖励--准时奖励接口
 *
 *  @param arr  UNIMyRewardModel 对象数组
    @param num  满足次数
 *  @param tips 反馈信息
 *  @param err  错误信息
 */
typedef void(^INTimeBlock)(NSArray* arr,int num,NSString* tips,NSError* err);

@interface UNIMyRewardRequest : BaseRequest

//我的奖励—约满奖励
@property(nonatomic,copy)MyRewardBlock myrewardBlock;

//我的奖励--准时奖励接口
@property(nonatomic,copy)INTimeBlock intimeBlock;
@end
