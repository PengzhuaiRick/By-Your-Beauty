//
//  UNIMyRewardModel.h
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIMyRewardModel : UNIBaseModel
@property(nonatomic,copy)NSString* goods;  //奖励商品
@property(nonatomic,assign)int rewardNum; //奖励次数

-(id)initWithDic:(NSDictionary*)dic;
@end
