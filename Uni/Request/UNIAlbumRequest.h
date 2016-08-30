//
//  UNIAlbumRequest.h
//  Uni
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequest.h"
#import "UNIBaseModel.h"
@interface UNIAlbumModel : UNIBaseModel
@property(nonatomic,copy)NSString* imgUrl;
@property(nonatomic,copy)NSString* intro;
-(id)initWithDic:(NSDictionary*)dic;
@end



@interface UNIAlbumRequest : BaseRequest

//获取购物车列表
typedef void(^GetShopImages)(NSArray* array,NSString* msg,NSError* err);
@property(nonatomic,copy)GetShopImages getShopImages;

@end
