//
//  UNILoginShopModel.m
//  Uni
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNILoginShopModel.h"

@implementation UNILoginShopModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.address = [self safeObject:dic ForKey:@"address"];
    self.shopName = [self safeObject:dic ForKey:@"shopName"];
    self.short_name = [self safeObject:dic ForKey:@"short_name"];
    self.token = [self safeObject:dic ForKey:@"token"];
    self.userId = [[self safeObject:dic ForKey:@"userId"] intValue];
    self.shopId = [[self safeObject:dic ForKey:@"shopId"] intValue];
}
@end
