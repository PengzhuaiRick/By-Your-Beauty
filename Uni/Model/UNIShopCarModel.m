//
//  UNIShopCarModel.m
//  Uni
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIShopCarModel.h"

@implementation UNIShopCarModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self setupShopCarModel:dic];
    }
    return self;
}
-(void)setupShopCarModel:(NSDictionary*)dic{
    self.price = [[self safeObject:dic ForKey:@"price"]floatValue];
    self.num = [[self safeObject:dic ForKey:@"num"]intValue];
    self.goodId = [[self safeObject:dic ForKey:@"goodId"]intValue];
    self.goodsType = [[self safeObject:dic ForKey:@"goodsType"]intValue];
    self.isCheck = [[self safeObject:dic ForKey:@"isCheck"]intValue];
    self.goodName = [self safeObject:dic ForKey:@"goodName"];
    self.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
}
@end
