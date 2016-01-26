//
//  UNIMyRewardModel.m
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyRewardModel.h"

@implementation UNIMyRewardModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.goods = [self safeObject:dic ForKey:@"goods"];
    self.rewardNum = [[self safeObject:dic ForKey:@"rewardNum"]intValue];
    self.price = [[self safeObject:dic ForKey:@"price"] intValue];
}
@end
