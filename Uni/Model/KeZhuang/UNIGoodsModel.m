//
//  UNIGoodsModel.m
//  Uni
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIGoodsModel.h"

@implementation UNIGoodsModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.projectName = [self safeObject:dic ForKey:@"projectName"];
    self.projectId = [[self safeObject:dic ForKey:@"projectId"] intValue];
    self.likesNum = [[self safeObject:dic ForKey:@"likesNum"] intValue];
    self.sellNum = [[self safeObject:dic ForKey:@"sellNum"] intValue];
    self.type = [[self safeObject:dic ForKey:@"type"] intValue];
    self.price = [[self safeObject:dic ForKey:@"price"]floatValue];
    self.shopPrice = [[self safeObject:dic ForKey:@"shopPrice"]floatValue];
    self.reduceMoney = [[self safeObject:dic ForKey:@"reduceMoney"]floatValue];
    self.desc = [self safeObject:dic ForKey:@"desc"];
    self.goodsCode = [self safeObject:dic ForKey:@"goodsCode"];
    self.specifications = [self safeObject:dic ForKey:@"specifications"];
    self.effect = [self safeObject:dic ForKey:@"effect"];
    self.place = [self safeObject:dic ForKey:@"place"];
    self.texture = [self safeObject:dic ForKey:@"texture"];
    self.crowd = [self safeObject:dic ForKey:@"crowd"];
    self.belong = [self safeObject:dic ForKey:@"belong"];
    self.url = [self safeObject:dic ForKey:@"url"];
    self.imgUrl = [self safeObject:dic ForKey:@"imgUrl"];
}

@end
