//
//  UNIOrderListModel.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderListModel.h"

@implementation UNIOrderListModel
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
    self.specifications = [self safeObject:dic ForKey:@"specifications"];
    self.orderCode = [self safeObject:dic ForKey:@"orderCode"];
    self.price = [self safeObject:dic ForKey:@"price"];
    self.time = [self safeObject:dic ForKey:@"time"];
    self.status = [[self safeObject:dic ForKey:@"status"]intValue];
    self.num = [[self safeObject:dic ForKey:@"num"]intValue];
    
}

@end
