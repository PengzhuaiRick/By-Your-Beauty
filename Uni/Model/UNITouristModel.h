//
//  UNITouristModel.h
//  Uni
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@interface UNITouristModel : UNIBaseModel
@property(nonatomic,copy)NSString* logoUrl;  //活动微信分享图片
@property(nonatomic,copy)NSString* shareDetail;  //活动分享详情
@property(nonatomic,copy)NSString* shareTitle;  //活动分享标头
@property(nonatomic,copy)NSString* shareUrl;  //活动分享URL
@property(nonatomic,copy)NSString* activityUrl; //活动URL;
@property(nonatomic,assign)int isWeixinAuth; //1 授权  0 不授权;
-(id)initWithDic:(NSDictionary*)dic;
@end
