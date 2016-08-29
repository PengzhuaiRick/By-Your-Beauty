//
//  UNIOrderListModel.h
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIOrderListGoods : UNIBaseModel
@property(nonatomic,assign)float endPrice;
@property(nonatomic,assign)float price;
@property(nonatomic,assign)float return_money;
@property(nonatomic,copy)NSString* goodLogoUrl;
@property(nonatomic,copy)NSString* goodName;         //项目名称
@property(nonatomic,copy)NSString* specifications;       //规格
@property(nonatomic,assign)int goodId;
@property(nonatomic,assign)int goodsType;
@property(nonatomic,assign)int isProject;
@property(nonatomic,assign)int num;
@property(nonatomic,assign)int projectId;
-(id)initWithDic:(NSDictionary*)dic;
@end



@interface UNIOrderListModel : UNIBaseModel
@property(nonatomic,copy)NSString* orderNo;  //订单号
@property(nonatomic,assign)float totalPrice;         //价格
@property(nonatomic,copy)NSString* createtime;       //下单时间
@property(nonatomic,assign)int num;
@property(nonatomic,assign)int ifGet; // -1:全部 0:未领取 1:已领取
@property(nonatomic,assign)int isShopcartOrder; //
@property(nonatomic,strong)NSArray* goods; //UNIOrderListGoods 的对象数组

-(id)initWithDic:(NSDictionary*)dic;
@end
