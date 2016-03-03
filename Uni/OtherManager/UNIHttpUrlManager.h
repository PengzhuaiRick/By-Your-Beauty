//
//  UNIHttpUrlManager.h
//  Uni
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNIHttpUrlManager : NSObject
@property(nonatomic,copy) NSString* APP_KZ_URL;//客妆
@property(nonatomic,copy) NSString* MY_LIBAO_SHARE_RUL;//我的礼包分享的URL
@property(nonatomic,copy) NSString* WX_GET_PREAPYID;//微信获取 PREAPYID
@property(nonatomic,copy) NSString* WX_HB_URL; ////微信红包
@property(nonatomic,copy) NSString* WX_LIBAO_URL; //我的礼包
@property(nonatomic,copy) NSString* WX_SHARE_URL; //微信分享MY_YH_URL
@property(nonatomic,copy) NSString* MY_YH_URL;

+ (UNIHttpUrlManager *)sharedInstance;
-(void)initHttpUrlManager:(NSDictionary*)dic;
@end
