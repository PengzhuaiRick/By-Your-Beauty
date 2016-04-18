//
//  UNIMyProjectModel.h
//  Uni
//  我的项目Model
//  Created by apple on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIMyProjectModel : UNIBaseModel
@property(nonatomic,copy)NSString* projectName;  //项目名称
@property(nonatomic,copy)NSString* logoUrl;      //logo地址
@property(nonatomic,copy)NSString* desc;         //详情
@property(nonatomic,copy)NSString* projectBeginDate;    //项目开始日期
@property(nonatomic,assign)float price;//市场价格
@property(nonatomic,assign)float shopPrice; //本店价格
@property(nonatomic,assign)int status;// 状态
@property(nonatomic,assign)int num;// 剩余数量
@property(nonatomic,assign)int costTime;//服务时长
@property(nonatomic,assign)int projectId;//项目id

@property(nonatomic,assign)BOOL select;
-(id)initWithDic:(NSDictionary*)dic;
@end
