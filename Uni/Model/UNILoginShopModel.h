//
//  UNILoginShopModel.h
//  Uni
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNILoginShopModel : UNIBaseModel
@property(nonatomic,copy)NSString* address; 
@property(nonatomic,copy)NSString* shopName;
@property(nonatomic,copy)NSString* short_name;
@property(nonatomic,copy)NSString* token;
@property(nonatomic,assign)int userId;
@property(nonatomic,assign)int shopId;
-(id)initWithDic:(NSDictionary*)dic;
@end
