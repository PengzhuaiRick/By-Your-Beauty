//
//  UNIShopModel.m
//  Uni
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIShopModel.h"

@implementation UNIShopModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.shopName = [self safeObject:dic ForKey:@"shopName"];
    self.shortName = [self safeObject:dic ForKey:@"shortName"];
    self.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
    self.address = [self safeObject:dic ForKey:@"address"];
    self.telphone = [self safeObject:dic ForKey:@"telphone"];
    self.x = [[self safeObject:dic ForKey:@"latitude"]floatValue];
    self.y = [[self safeObject:dic ForKey:@"longitude"]floatValue];
    self.shopId = [[self safeObject:dic ForKey:@"shopId"]intValue];
}

@end
