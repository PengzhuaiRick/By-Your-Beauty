//
//  UNIOrderListModel.h
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIOrderListModel : UNIBaseModel
@property(nonatomic,copy)NSString* orderCode;  //订单号
@property(nonatomic,copy)NSString* price;         //价格
@property(nonatomic,copy)NSString* projectName;         //项目名称
@property(nonatomic,copy)NSString* logoUrl;       //logo地址
@property(nonatomic,copy)NSString* specifications;       //规格
@property(nonatomic,copy)NSString* time;       //下单时间
@property(nonatomic,assign)int num;
@property(nonatomic,assign)int status; // -1:全部 0:未领取 1:已领取

-(id)initWithDic:(NSDictionary*)dic;
@end
