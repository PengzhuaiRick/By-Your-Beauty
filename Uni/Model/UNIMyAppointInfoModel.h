//
//  UNIMyAppointInfoModel.h
//  Uni
//  预约详情项目
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIMyAppointInfoModel : UNIBaseModel
@property(nonatomic,copy)NSString* projectName;  //项目名称
@property(nonatomic,copy)NSString* order;      //预约号
@property(nonatomic,copy)NSString* date;         //预约日期
@property(nonatomic,copy)NSString* createTime;         //下单时间
@property(nonatomic,copy)NSString* lastModifiedDate;         //取消时间
@property(nonatomic,copy)NSString* logoUrl;       //logo地址
@property(nonatomic,assign)int status;// 状态 0--待安排;1--待服务;2--已完成;3--已取消
@property(nonatomic,assign)int costTime;//服务时长
@property(nonatomic,assign)int projectId;//项目id
@property(nonatomic,assign)int ifIntime; //0—否;1—准时

-(id)initWithDic:(NSDictionary*)dic;
@end
