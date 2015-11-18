//
//  UNIMyProjectModel.m
//  Uni
//  我的项目Model
//  Created by apple on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyProjectModel.h"

@implementation UNIMyProjectModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.projectName = [self safeObject:dic ForKey:@"projectName"];
    self.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
    self.price = [[self safeObject:dic ForKey:@"price"]floatValue];
    self.shopPrice = [[self safeObject:dic ForKey:@"shopPrice"]floatValue];
    self.desc = [self safeObject:dic ForKey:@"desc"];
    self.status = [[self safeObject:dic ForKey:@"status"]intValue];
    self.num = [[self safeObject:dic ForKey:@"num"]intValue];
}
@end
