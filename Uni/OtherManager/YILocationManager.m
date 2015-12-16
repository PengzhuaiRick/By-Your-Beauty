//
//  YILocationManager.m
//  YIVasMobile
//
//  Created by apple on 15/3/28.
//  Copyright (c) 2015年 YixunInfo Inc. All rights reserved.
//

#define kUserCity  @"UserCurrentCity"
#import "YILocationManager.h"

@implementation YILocationManager

@synthesize userLocInfo;

#pragma mark -静态方法

#pragma  mark 对象单例
+ (YILocationManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    static YILocationManager *sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[YILocationManager alloc] init];
    });
    return sSharedInstance;
}


+(void)setUserCurrentCity:(NSString*)city{
    NSUserDefaults* userdef= [NSUserDefaults standardUserDefaults];
    [userdef setObject:city forKey:kUserCity];
    [userdef synchronize];
}

+(NSString *)getUserCurrentCity{
    NSString* city = [[NSUserDefaults standardUserDefaults] objectForKey:kUserCity];
    if (!city) {
        city=@"";
    }
    return city;
}

#pragma mark -动态方法

#pragma mark 开始定位
-(void)startUpdateUserLoaction{
    if ([CLLocationManager locationServicesEnabled]) {
       // Ifstop=0;
        if(!_locationManager)
        _locationManager =[[CLLocationManager alloc]init];
        _locationManager.delegate=self;
        //_locationManager.pausesLocationUpdatesAutomatically=NO;//更新是否自动暂停
        _locationManager.distanceFilter = kCLDistanceFilterNone; // 任何运动均接受，任何运动将会触发定位更新
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;// // 设置距离过滤器，超过次距离就更新一次位置
        if(IS_IOS8_OR_LATER)
             [_locationManager requestAlwaysAuthorization];
        if (IS_IOS9_OR_LATER)
        _locationManager.allowsBackgroundLocationUpdates=YES;
        
        [_locationManager startUpdatingLocation];
        //[_locationManager startMonitoringSignificantLocationChanges];
        
    }else{
        #ifdef IS_IOS8_OR_LATER
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
        #else
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
         #endif
    }
    
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark 停止定位
-(void)stopUpdatingLocation{
    [_locationManager stopUpdatingLocation];
}

#pragma mark  定位CLLocationManager  CLLocationManagerDelegate方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    [manager stopUpdatingLocation];
    CLLocation* loca=locations.lastObject;
   
    CLGeocoder* gecocoder = [[CLGeocoder alloc]init];
    [gecocoder reverseGeocodeLocation:loca completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count>0) {
            CLPlacemark* place = placemarks.lastObject;
//             NSLog(@"A = %@  B = %@ C = %@  D = %f",place.name,place.locality,place.administrativeArea,loca.altitude);
            NSString *city = place.locality;
            
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = place.administrativeArea;
                
            }
//            self->userLocInfo = [YIUserLocationMessage share];
//            self->userLocInfo.latitude =[NSString stringWithFormat:@"%f",loca.coordinate.latitude] ;
//            self->userLocInfo.longitude =[NSString stringWithFormat:@"%f",loca.coordinate.longitude] ;
//            self->userLocInfo.altitude =[NSString stringWithFormat:@"%f",loca.altitude] ;
            NSLog(@"latitude  %f,%f",loca.coordinate.latitude,loca.coordinate.longitude);
            NSString* stri = [NSString stringWithFormat:@"latitude  %f,%f",loca.coordinate.latitude,loca.coordinate.longitude];
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            if (localNotification == nil) {
                return;
            }
            //设置本地通知的触发时间（如果要立即触发，无需设置），这里设置为20妙后
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
            //设置本地通知的时区
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            //设置通知的内容
            localNotification.alertBody = stri;
            //设置通知动作按钮的标题
            localNotification.alertAction = @"查看";
            //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
//            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:LOCAL_NOTIFY_SCHEDULE_ID,@"id",[NSNumber numberWithInteger:time],@"time",[NSNumber numberWithInt:affair.aid],@"affair.aid", nil];
//            localNotification.userInfo = infoDic;
            //在规定的日期触发通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            //立即触发一个通知
            //    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
            
//            [YIToast showText:stri];

//            self.userLocInfo=self->userLocInfo;
//           // self.getLocationMessageBlock(self->userLocInfo);
//        }else if(error==nil && placemarks.count==0){;
//            self.getLocationMessageBlock(nil);
//            
       }
    }];
    //  [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:10];
   // [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];            }
        break;
        default:
        break;
    }
}

-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return YES;
            
    } return NO;
    
}
@end
