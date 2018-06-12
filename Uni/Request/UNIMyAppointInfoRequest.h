//
//  UNIMyAppointInfoRequest.h
//  Uni
//  预约详情界面
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIMyAppointInfoModel.h"

/**
 *  获取预约详情Block
 *
 *  @param model UNIMyAppintModel 对象
 *  @param tips  反馈信息
 *  @param er    错误信息
 */
typedef void(^RQMyAppointInfo)(NSArray* models,NSString*tips,NSError* er);

/**
 *  商品评价Block
 *  @param tips 反馈信息
 *  @param er   错误信息
 */
typedef void(^RQAppraise)(int code, NSString*tips,NSError* er);

@interface UNIMyAppointInfoRequest : BaseRequest


//获取预约详情Block
@property(nonatomic , copy) RQMyAppointInfo reqMyAppointInfo;


//商品评价Block
@property(nonatomic , copy) RQAppraise rqAppraise;
@end
