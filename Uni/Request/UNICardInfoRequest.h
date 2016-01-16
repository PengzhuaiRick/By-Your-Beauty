//
//  UNICardInfoRequest.h
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIMyAppointInfoModel.h"
/**
 *  会员卡详情Bloack
 *
 *  @param arr  UNIMyAppointInfoModel 对象数组
 *  @param tips 反馈信息
 *  @param err  错误信息
 */
typedef void(^CardInfoBlock)(NSArray* arr,NSString* tips,NSError* err);


/**
 *  准时奖励Bloack
 *
 *  @param nextRewardNum 准时次数
 *  @param num           已约次数
 *  @param tips          反馈信息
 */
typedef void(^RQRewardBlock)(int nextRewardNum,int num,NSString *projectName,NSString*tips,NSError* er);


@interface UNICardInfoRequest : BaseRequest

//会员卡详情Bloack
@property(nonatomic,copy) CardInfoBlock cardInfoBlock;

//准时奖励Bloack
@property(nonatomic,copy) RQRewardBlock rqrewardBlock;
@end
