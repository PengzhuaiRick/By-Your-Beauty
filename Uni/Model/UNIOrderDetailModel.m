//
//  UNIOrderDetailModel.m
//  Uni
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderDetailModel.h"
@implementation UNIOrderDetailGoods
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.goodLogoUrl = [self safeObject:dic ForKey:@"goodLogoUrl"];
    self.goodName = [self safeObject:dic ForKey:@"goodName"];
    self.specifications = [self safeObject:dic ForKey:@"specifications"];
    self.couponName = [self safeObject:dic ForKey:@"couponName"];
    self.price = [[self safeObject:dic ForKey:@"price"] floatValue];
    self.return_money = [[self safeObject:dic ForKey:@"return_money"] floatValue];
    
    
    self.goodId = [[self safeObject:dic ForKey:@"goodId"]intValue];
    self.goodsType = [[self safeObject:dic ForKey:@"goodsType"]intValue];
    self.isProject = [[self safeObject:dic ForKey:@"isProject"]intValue];
    self.num = [[self safeObject:dic ForKey:@"num"]intValue];
    self.projectId = [[self safeObject:dic ForKey:@"projectId"]intValue];
    
}
@end
@implementation UNIOrderDetailModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.ordertext = [self safeObject:dic ForKey:@"ordertext"];
    self.deliveryType = [self safeObject:dic ForKey:@"deliveryType"];
    self.paytext = [self safeObject:dic ForKey:@"paytext"];
    
    
    self.endPrice = [[self safeObject:dic ForKey:@"endPrice"] floatValue];
    self.totalPrice = [[self safeObject:dic ForKey:@"totalPrice"] floatValue];
    self.totalReturn = [[self safeObject:dic ForKey:@"totalReturn"] floatValue];
    
    self.paytype = [[self safeObject:dic ForKey:@"paytype"]intValue];
    self.status = [[self safeObject:dic ForKey:@"status"]intValue];
    
    NSArray* detail =[self safeObject:dic ForKey:@"detail"];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:detail.count];
    for (NSDictionary* dia in detail) {
        UNIOrderDetailGoods* model = [[UNIOrderDetailGoods alloc]initWithDic:dia];
        [arr addObject:model];
    }
    self.goods = arr;
}
@end
