//
//  UNIShopModel.h
//  Uni
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIShopModel : UNIBaseModel
@property(nonatomic,copy)NSString* shopName;  //店铺名称
@property(nonatomic,copy)NSString* shortName;  //店铺名称
@property(nonatomic,copy)NSString* logoUrl;  //店铺logo地址
@property(nonatomic,copy)NSString* address;  //店铺地址
@property(nonatomic,copy)NSString* telphone;  //店铺电话
@property(nonatomic,assign)int shopId;   //店铺ID
@property(nonatomic,assign)double x;      //坐标X
@property(nonatomic,assign)double y;      //坐标Y

-(id)initWithDic:(NSDictionary*)dic;
@end
