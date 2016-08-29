//
//  UNIOrderDetailModel.h
//  Uni
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIOrderDetailModel : UNIBaseModel
@property(nonatomic,copy)NSString* ordertext;
@property(nonatomic,copy)NSString* deliveryType;
@property(nonatomic,copy)NSString* paytext;
@property(nonatomic,assign)float endPrice;
@property(nonatomic,assign)float totalPrice;
@property(nonatomic,assign)float totalReturn;
@property(nonatomic,assign)int paytype;
@property(nonatomic,assign)int status;  // 1支付完成，2还没有支付

-(id)initWithDic:(NSDictionary*)dic;
@end
