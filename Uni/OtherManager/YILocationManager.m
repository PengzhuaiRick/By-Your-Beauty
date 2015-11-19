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
        Ifstop=0;
        locationManager =[[CLLocationManager alloc]init];
        locationManager.delegate=self;
        locationManager.distanceFilter = kCLDistanceFilterNone; // meters
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        //[locationManager requestAlwaysAuthorization];
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [locationManager requestWhenInUseAuthorization];
#ifdef IS_IOS8_OR_LATER
        [locationManager requestAlwaysAuthorization];
        locationManager.allowsBackgroundLocationUpdates=YES;
#endif
//        if ([CLLocationManager significantLocationChangeMonitoringAvailable])
//            [locationManager startMonitoringSignificantLocationChanges];
        
        [locationManager startMonitoringSignificantLocationChanges];
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
    [locationManager stopUpdatingLocation];
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
            self->userLocInfo = [YIUserLocationMessage share];
            self->userLocInfo.latitude =[NSString stringWithFormat:@"%f",loca.coordinate.latitude] ;
            self->userLocInfo.longitude =[NSString stringWithFormat:@"%f",loca.coordinate.longitude] ;
            self->userLocInfo.altitude =[NSString stringWithFormat:@"%f",loca.altitude] ;
          //  NSLog(@"latitude  %f,%f",loca.coordinate.latitude,loca.coordinate.longitude);
            if([self IsChinese:city]){
                if ([city hasSuffix:@"市直辖市"]) {
                    self->userLocInfo.city = [city substringToIndex:city.length-4];
                }
                self->userLocInfo.city = [city substringToIndex:place.locality.length-1];
            }
            else
                self->userLocInfo.city = city;
            
            self->userLocInfo.state =  place.country;
            self->userLocInfo.province = place.administrativeArea;
            self->userLocInfo.detailmessage = place.name;
            self.userLocInfo=self->userLocInfo;
            self.getLocationMessageBlock(self->userLocInfo);
        }else if(error==nil && placemarks.count==0){;
            self.getLocationMessageBlock(nil);
            
        }
    }];
   // [manager stopUpdatingLocation];
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
