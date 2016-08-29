//
//  UNIOrderDetailModel.m
//  Uni
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderDetailModel.h"

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
    
}
@end
