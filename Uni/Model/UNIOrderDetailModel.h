//
//  UNIOrderDetailModel.h
//  Uni
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIBaseModel.h"
@interface UNIOrderDetailGoods : UNIBaseModel
@property(nonatomic,assign)float price;
@property(nonatomic,assign)float return_money;
@property(nonatomic,copy)NSString* goodLogoUrl;
@property(nonatomic,copy)NSString* goodName;         //项目名称
@property(nonatomic,copy)NSString* specifications;       //规格
@property(nonatomic,copy)NSString* couponName;       //优惠券名称
@property(nonatomic,assign)int goodId;
@property(nonatomic,assign)int goodsType;
@property(nonatomic,assign)int isProject;
@property(nonatomic,assign)int num;
@property(nonatomic,assign)int projectId;
-(id)initWithDic:(NSDictionary*)dic;
@end


@interface UNIOrderDetailModel : UNIBaseModel
@property(nonatomic,copy)NSString* ordertext;
@property(nonatomic,copy)NSString* deliveryType;
@property(nonatomic,copy)NSString* paytext;
@property(nonatomic,assign)float endPrice;
@property(nonatomic,assign)float totalPrice;
@property(nonatomic,assign)float totalReturn;
@property(nonatomic,assign)int paytype;
@property(nonatomic,assign)int status;  // 1支付完成，2还没有支付
@property(nonatomic,strong)NSArray* goods; 
-(id)initWithDic:(NSDictionary*)dic;
@end
