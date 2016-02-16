//
//  UNIGoodsModel.h
//  Uni
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNIGoodsModel : UNIBaseModel
@property(nonatomic,copy)NSString* goodsCode ;//编号
@property(nonatomic,copy)NSString* projectName;//项目名称
@property(nonatomic,copy)NSString* specifications;// 规格
@property(nonatomic,copy)NSString* effect;   //功效
@property(nonatomic,copy)NSString* place;//产地
@property(nonatomic,copy)NSString* texture;//质地
@property(nonatomic,copy)NSString* crowd;//适合人群
@property(nonatomic,copy)NSString* desc;//商品详情belong
@property(nonatomic,copy)NSString* belong;//所属品牌
@property(nonatomic,copy)NSString* url;//
@property(nonatomic,copy)NSString* imgUrl;//商品图片路径

@property(nonatomic,assign)int projectId;//项目id
@property(nonatomic,assign)int sellNum;//销售数量
@property(nonatomic,assign)int likesNum;//点赞数量
@property(nonatomic,assign)float price; //市场价格
@property(nonatomic,assign)float shopPrice; //本店价格
@property(nonatomic,assign)int type; //类型



-(id)initWithDic:(NSDictionary*)dic;
@end
