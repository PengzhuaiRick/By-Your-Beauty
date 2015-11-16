//
//  UNIMyAppintModel.h
//  Uni
//
//  Created by apple on 15/11/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNIBaseModel.h"
@interface UNIMyAppintModel : UNIBaseModel
@property(nonatomic,copy)NSString* order ;//预约号
@property(nonatomic,copy)NSString* projectName;//项目名称
@property(nonatomic,copy)NSString* logoUrl;// logo地址
@property(nonatomic,copy)NSString* time;   //预约时间
@property(nonatomic,copy)NSString* createTime;//下单时间
@property(nonatomic,assign)int costTime;//服务时长
@property(nonatomic,assign)int status; //预约状态

-(id)initWithDic:(NSDictionary*)dic;
@end
