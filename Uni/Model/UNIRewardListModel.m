//
//  UNIRewardListModel.m
//  Uni
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardListModel.h"

@implementation UNIRewardListModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.projectName = [self safeObject:dic ForKey:@"projectName"];
    self.time = [self safeObject:dic ForKey:@"time"];
    self.specifications = [self safeObject:dic ForKey:@"specifications"];
    self.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
    self.status = [[self safeObject:dic ForKey:@"status"]intValue];
    self.num = [[self safeObject:dic ForKey:@"num"]intValue];

}
@end
