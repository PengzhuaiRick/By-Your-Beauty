//
//  UNITouristModel.m
//  Uni
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNITouristModel.h"

@implementation UNITouristModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
    self.shareDetail = [self safeObject:dic ForKey:@"shareDetail"];
    self.shareTitle = [self safeObject:dic ForKey:@"shareTitle"];
    self.shareUrl = [self safeObject:dic ForKey:@"shareUrl"];
    self.activityUrl = [self safeObject:dic ForKey:@"activityUrl"];
    self.isWeixinAuth = [[self safeObject:dic ForKey:@"isWeixinAuth"] intValue];
}
@end
