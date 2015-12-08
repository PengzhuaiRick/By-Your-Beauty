//
//  UNIRewardListModel.h
//  Uni
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIRewardListModel : UNIBaseModel
@property(nonatomic,copy)NSString* projectName;  //项目名称
@property(nonatomic,copy)NSString* time;         //时间
@property(nonatomic,copy)NSString* specifications;         //规格
@property(nonatomic,copy)NSString* logoUrl;       //logo地址
@property(nonatomic,assign)int status;// 状态；0—未领；1—已领
@property(nonatomic,assign)int num;//数量


-(id)initWithDic:(NSDictionary*)dic;
@end
