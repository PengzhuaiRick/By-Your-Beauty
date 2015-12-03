//
//  UNIMyAppointInfoModel.m
//  Uni
//  预约详情项目
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyAppointInfoModel.h"

@implementation UNIMyAppointInfoModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.projectName = [self safeObject:dic ForKey:@"projectName"];
    self.order = [self safeObject:dic ForKey:@"order"];
    self.date = [self safeObject:dic ForKey:@"date"];
    self.createTime = [self safeObject:dic ForKey:@"createTime"];
    self.lastModifiedDate = [self safeObject:dic ForKey:@"lastModifiedDate"];
    self.status = [[self safeObject:dic ForKey:@"status"]intValue];
    self.projectId = [[self safeObject:dic ForKey:@"projectId"]intValue];
    self.costTime = [[self safeObject:dic ForKey:@"costTime"]intValue];
}
@end
