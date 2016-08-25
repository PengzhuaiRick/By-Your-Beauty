//
//  UNIShopCarModel.h
//  Uni
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIShopCarModel : UNIBaseModel
@property(nonatomic,assign)float price; // 商品单价金额
@property(nonatomic,assign)int num; //商品数量
@property(nonatomic,assign)int goodId; //物品ID
@property(nonatomic,assign)int goodsType; //物品类型
@property(nonatomic,assign)int isCheck; // 1是选中，0没有选中
@property(nonatomic,copy)NSString* goodName;
@property(nonatomic,copy)NSString* logoUrl;

-(id)initWithDic:(NSDictionary*)dic;
@end
