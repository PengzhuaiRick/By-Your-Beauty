//
//  UNIOrderListModel.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderListModel.h"
@implementation UNIOrderListGoods
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
    
    self.endPrice = [[self safeObject:dic ForKey:@"endPrice"] floatValue];
    self.price = [[self safeObject:dic ForKey:@"price"] floatValue];
    self.return_money = [[self safeObject:dic ForKey:@"return_money"] floatValue];
    
    
    self.goodId = [[self safeObject:dic ForKey:@"goodId"]intValue];
    self.goodsType = [[self safeObject:dic ForKey:@"goodsType"]intValue];
    self.isProject = [[self safeObject:dic ForKey:@"isProject"]intValue];
    self.num = [[self safeObject:dic ForKey:@"num"]intValue];
    self.projectId = [[self safeObject:dic ForKey:@"projectId"]intValue];
    
}
@end
@implementation UNIOrderListModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.orderNo = [self safeObject:dic ForKey:@"orderNo"];
    self.totalPrice = [[self safeObject:dic ForKey:@"totalPrice"] floatValue];
    self.returnTotal = [[self safeObject:dic ForKey:@"returnTotal"] floatValue];
    self.createtime = [self safeObject:dic ForKey:@"createtime"];
    self.ifGet = [[self safeObject:dic ForKey:@"ifGet"]intValue];
    self.num = [[self safeObject:dic ForKey:@"num"]intValue];
    self.isShopcartOrder = [[self safeObject:dic ForKey:@"isShopcartOrder"]intValue];
    
    NSArray* good = [self safeObject:dic ForKey:@"goods"];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:good.count];
    for (NSDictionary* dic in good) {
        UNIOrderListGoods* model = [[UNIOrderListGoods alloc]initWithDic:dic];
        [arr addObject:model];
    }
    self.goods = arr;
}

@end
