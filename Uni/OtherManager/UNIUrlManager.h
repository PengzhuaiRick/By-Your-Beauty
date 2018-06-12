//
//  UNIUrlManager.h
//  Uni
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNIUrlManager : NSObject
@property(nonatomic,copy)NSString* server_url; //动态后台接口
@property(nonatomic,copy)NSString* url;     //appStore 更新URL
@property(nonatomic,copy)NSString* detail;     //更新的信息
@property(nonatomic,copy)NSString* img_url;  //图片 和 客妆详情接口
@property(nonatomic,assign)float version;   //系统版本号
@property(nonatomic,assign)int update_type; //检查是否强制更新 1 选择更新  2 强制更新

+ (UNIUrlManager *)sharedInstance;
-(void)initUrlManager:(NSDictionary*)dic;
@end
