//
//  YILocationManager.h
//  YIVasMobile
//
//  Created by apple on 15/3/28.
//  Copyright (c) 2015年 YixunInfo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "YIUserLocationMessage.h"
typedef void(^GetLocationMessageBlock)(YIUserLocationMessage *locationMsg);
typedef void(^GetUserLocateInfoBlock)(double x,double y);
@interface YILocationManager : NSObject<CLLocationManagerDelegate>
{
    //int Ifstop;
   
    
}
@property(nonatomic , strong) CLLocationManager *locationManager;

@property(nonatomic , strong)YIUserLocationMessage* userLocInfo;

@property(nonatomic , copy)GetLocationMessageBlock getLocationMessageBlock;

@property(nonatomic , copy)GetUserLocateInfoBlock getUserLocBlock;

//@property(nonatomic , copy)NSString* currentCity;//城市


#pragma mark -控制方法
/**
 *   开始定位 
 */
-(void)startUpdateUserLoaction;

/**
 *   停止定位
 */
-(void)stopUpdatingLocation;


#pragma mark -静态方法

/**
 *  获取单例对象
 *
 *  @return 返回一个YILocationManager单例对象
 */
+ (YILocationManager *)sharedInstance;



/**
 *  用户保存设置的城市的方法
 *
 *  @param city 城市
 */
+(void)setUserCurrentCity:(NSString*)city;


/**
 *  获取用户设置的城市
 *
 *  @return 返回本地存储的城市
 */
+(NSString*)getUserCurrentCity;

//判断定位城市和记录的城市是否相同

@end
