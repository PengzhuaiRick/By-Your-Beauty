//
//  UNITransfromX&Y.m
//  Uni
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
// 分为 地球坐标，火星坐标（iOS mapView 高德 ， 国内google ,搜搜、阿里云 都是火星坐标），百度坐标(百度地图数据主要都是四维图新提供的)
/*
火星坐标: MKMapView
地球坐标: CLLocationManager

当用到CLLocationManager 得到的数据转化为火星坐标, MKMapView不用处理


API                坐标系
百度地图API         百度坐标
腾讯搜搜地图API      火星坐标
搜狐搜狗地图API      搜狗坐标
阿里云地图API       火星坐标
图吧MapBar地图API   图吧坐标
高德MapABC地图API   火星坐标
灵图51ditu地图API   火星坐标

*/

#import "UNITransfromX&Y.h"
#import "UIActionSheet+Blocks.h"
#import "YILocationManager.h"
#import "UNIShopManage.h"
#import "BaiduMobStat.h"
@implementation UNITransfromX_Y
-(id)initWithView:(UIView*)view withEndCoor:(CLLocationCoordinate2D)endCo withAim:(NSString*)name{
    self = [super init];
    if (self) {
        _showView = view;
        _endCoor = endCo;
        _aimName = name;
        //[self setupUI];
    }
    return self;
}
-(void)setupUI{
    NSMutableArray* mapsArray = [NSMutableArray arrayWithObjects:@"苹果地图", nil];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
        [mapsArray addObject:@"百度地图"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        [mapsArray addObject:@"高德地图"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        [mapsArray addObject:@"Google地图"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]])
        [mapsArray addObject:@"腾讯地图"];
    
    [UIActionSheet showInView:_showView withTitle:@"本机地图" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:mapsArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString* mapName = [actionSheet buttonTitleAtIndex:buttonIndex];
        [self selectLocateAppMap:mapName];
    }];

}

-(void)selectLocateAppMap:(NSString*)tag{
    
    if ([tag isEqualToString:@"苹果地图"])//苹果地图
    {
        NSArray* arr = [self bd_decrypt:self.endCoor.latitude and:self.endCoor.longitude];
        CLLocationCoordinate2D endCoor =  CLLocationCoordinate2DMake([arr[0] doubleValue], [arr[1] doubleValue]);
        MKMapItem *currentAction = [MKMapItem mapItemForCurrentLocation];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
        toLocation.name =self.aimName;
        
        [MKMapItem openMapsWithItems:@[currentAction, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        return;
        
    }

    
    
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:1];
    YILocationManager* locaMan = [YILocationManager sharedInstance];
    locaMan.getUserLocBlock=^(double x,double y ){
        [LLARingSpinnerView RingSpinnerViewStop1];
        [[YILocationManager sharedInstance]stopUpdatingLocation];
        NSString *toName =self.aimName;
        
            if ([tag isEqualToString:@"百度地图"]){
                [[BaiduMobStat defaultStat]logEvent:@"btn_gps_baidu" eventLabel:@"百度导航到店按钮"];
            //百度地图
            NSArray* arr = [self bd_encrypt:x and:y];
            CLLocationCoordinate2D pt1 = CLLocationCoordinate2DMake([arr[0] doubleValue], [arr[1] doubleValue]);
            //    CLLocationCoordinate2D pt1 = CLLocationCoordinate2DMake(x, y);
            CLLocationCoordinate2D endCoor = self.endCoor;
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",
                                    pt1.latitude, pt1.longitude, endCoor.latitude, endCoor.longitude, toName]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
            
        }
        if ([tag isEqualToString:@"高德地图"]){
            [[BaiduMobStat defaultStat]logEvent:@"btn_gps_gaode" eventLabel:@"高德导航到店按钮"];
            
            NSArray* arr = [self bd_decrypt:self.endCoor.latitude and:self.endCoor.longitude];
            CLLocationCoordinate2D endCoor =  CLLocationCoordinate2DMake([arr[0] doubleValue], [arr[1] doubleValue]);
            //高德地图
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",
                                    toName, endCoor.latitude, endCoor.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }
        if ([tag isEqualToString:@"Google地图"]){
            NSArray* arr = [self bd_decrypt:self.endCoor.latitude and:self.endCoor.longitude];
            CLLocationCoordinate2D endCoor =  CLLocationCoordinate2DMake([arr[0] doubleValue], [arr[1] doubleValue]);
            //Google地图
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f¢er=%f,%f&directionsmode=transit", endCoor.latitude, endCoor.longitude, x, y]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }
        if ([tag isEqualToString:@"腾讯地图"]){
            NSArray* arr = [self bd_decrypt:self.endCoor.latitude and:self.endCoor.longitude];
            CLLocationCoordinate2D endCoor =  CLLocationCoordinate2DMake([arr[0] doubleValue], [arr[1] doubleValue]);
            //腾讯地图
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&name=%@&fromcoord=%f,%f&tocoord=%f,%f&policy=1",toName, x, y, endCoor.latitude, endCoor.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }

        
    };
    [locaMan startUpdateUserLoaction];
}

#pragma mark 百度坐标 转 火星坐标
-(NSArray*)bd_decrypt:(double)bd_lat and:(double)bd_lon{
    double x_pi = M_PI * 3000.0 / 180.0;
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    //    gg_lon = z * cos(theta);
    //    gg_lat = z * sin(theta);
    return @[@(z * sin(theta)),@(z * cos(theta))];
}

#pragma mark 火星坐标 转 百度坐标
-(NSArray*)bd_encrypt:(double)gg_lat and:(double)gg_lon
{
    double x_pi = M_PI * 3000.0 / 180.0;
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
//    bd_lon = z * cos(theta) + 0.0065;
//    bd_lat = z * sin(theta) + 0.006;
     return @[@(z * cos(theta) + 0.0065),@(z * sin(theta) + 0.006)];
}

#pragma mark 火星坐标 转 百度坐标
+(NSArray*)bd_encrypt:(double)gg_lat and:(double)gg_lon
{
    double x_pi = M_PI * 3000.0 / 180.0;
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    //    bd_lon = z * cos(theta) + 0.0065;
    //    bd_lat = z * sin(theta) + 0.006;
    return @[@(z * cos(theta) + 0.0065),@(z * sin(theta) + 0.006)];
}
#pragma mark 百度坐标 转 火星坐标
+(NSArray*)bd_decrypt:(double)bd_lat and:(double)bd_lon{
    double x_pi = M_PI * 3000.0 / 180.0;
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    //    gg_lon = z * cos(theta);
    //    gg_lat = z * sin(theta);
    return @[@(z * sin(theta)),@(z * cos(theta))];
}
@end
