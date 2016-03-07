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
@property(nonatomic,copy) NSString* MY_LIBAO_SHARE_URL;//我的礼包分享的URL
@property(nonatomic,copy) NSString* WX_GET_PREAPYID;//微信获取 PREAPYID
@property(nonatomic,copy) NSString* WX_HB_URL; ////女神开红包分享URL
@property(nonatomic,copy) NSString* WX_LIBAO_URL; //我的礼包
@property(nonatomic,copy) NSString* WX_SHARE_URL; //微信分享MY_YH_URL
@property(nonatomic,copy) NSString* MY_YH_URL;
@property(nonatomic,copy) NSString* APP_BWHL_SHARE_DESC;//百万好礼分享desc
@property(nonatomic,copy) NSString* APP_BWHL_SHARE_TITLE;//百万好礼分享title
@property(nonatomic,copy) NSString* APP_HB_SHARE_DESC;//红包游戏分享desc
@property(nonatomic,copy) NSString* APP_HB_SHARE_TITLE;//红包游戏分享titl
@property(nonatomic,copy) NSString* APP_BWHL_SHARE_IMG;//百万好礼分享图片
@property(nonatomic,copy) NSString* APP_HB_SHARE_IMG;//红包游戏图片
@property(nonatomic,copy) NSString* APPOINT_SUCCESS;// 预约成功
@property(nonatomic,copy) NSString* GOTOBUY;// 马上去买
@property(nonatomic,copy) NSString* IS_APPOINT;//是否马上预约
@property(nonatomic,copy) NSString* NO_CASE_TIPS;// 无现金券提示
@property(nonatomic,copy) NSString* NO_ORDER_TIPS;//无订单提示
@property(nonatomic,copy) NSString* APPOINT_DESC;//忙里忙外，也要记得体贴自己！\n马上预约，来这里休息片刻~
@property(nonatomic,copy) NSString* MORE_YH_TIPS;//更多优惠持续更新，敬请关注!
+ (UNIHttpUrlManager *)sharedInstance;
-(void)initHttpUrlManager:(NSDictionary*)dic;
@end
