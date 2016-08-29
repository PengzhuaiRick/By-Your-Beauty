//
//  UNIOrderRequest.h
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIOrderListModel.h"
#import "UNIOrderDetailModel.h"
/**
 * 我的奖励—约满奖励Bloack
 *
 *  @param arr  UNIOrderListModel 对象数组
 *  @param tips 反馈信息
 *  @param err  错误信息
 */
typedef void(^MyOrderListBlock)(NSArray* arr,NSString* tips,NSError* err);

/**
 *  订单详情
 *
 *  @param arr  UNIOrderDetailModel 对象
 *  @param tips 反馈信息
 *  @param err  错误信息
 */
typedef void(^CartOrderDetail)(UNIOrderDetailModel* arr,NSString* tips,NSError* err);


@interface UNIOrderRequest : BaseRequest

@property(nonatomic,copy)MyOrderListBlock myOrderListBlock;

@property(nonatomic,copy)CartOrderDetail cartOrderDetail;
@end
