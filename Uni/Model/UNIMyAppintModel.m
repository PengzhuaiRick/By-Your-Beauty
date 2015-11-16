//
//  UNIMyAppintModel.m
//  Uni
//
//  Created by apple on 15/11/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyAppintModel.h"

@implementation UNIMyAppintModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.order = [self safeObject:dic ForKey:@"order"];
    self.projectName = [self safeObject:dic ForKey:@"projectName"];
    self.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
    self.time = [self safeObject:dic ForKey:@"time"];
    self.createTime = [self safeObject:dic ForKey:@"createTime"];
    self.costTime = [[self safeObject:dic ForKey:@"costTime"]intValue];
    self.status = [[self safeObject:dic ForKey:@"status"]intValue];
}
@end
