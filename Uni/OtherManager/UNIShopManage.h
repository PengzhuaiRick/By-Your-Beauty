//
//  UNIShopManage.h
//  Uni
//
//  保存店铺信息
//

#import <Foundation/Foundation.h>

@interface UNIShopManage : NSObject
@property(nonatomic,copy)NSString* shopName;  //店铺名称
@property(nonatomic,copy)NSString* shortName;  //店铺名称
@property(nonatomic,copy)NSString* logoUrl;  //店铺logo地址
@property(nonatomic,copy)NSString* address;  //店铺地址
@property(nonatomic,copy)NSString* telphone;  //店铺电话

@property(nonatomic,strong)NSNumber* x;      //坐标X
@property(nonatomic,strong)NSNumber* y;      //坐标Y


/**
 *  设置和获取店铺信息对象
 *
 *  @param shop
 */
+(void)saveShopData:(UNIShopManage*)shop;
+(UNIShopManage*)getShopData;
+(void)cleanShopinfo;
@end
