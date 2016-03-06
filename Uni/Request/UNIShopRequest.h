//
//  UNIShopRequest.h
//  Uni
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "UNIShopModel.h"

/**
 *  请求商店信息
 *
 *  @param shopName 店铺名
 *  @param logoUrl  Logo 路径
 *  @param url      二维码路径
 *  @param tips     反馈信息
 *  @param x        经度
 *  @param y        纬度
 *  @param er       错误信息
 */
typedef void(^RQShopInfoBlock)(UNIShopModel* model,NSString*tips,NSError* er);

@interface UNIShopRequest : BaseRequest

@property(nonatomic,copy) RQShopInfoBlock rwshopModelBlock;
@end
