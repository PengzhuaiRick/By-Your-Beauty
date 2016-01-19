//
//  AppDelegate.m
//  Uni
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "UNIContainController.h"
#import "YILocationManager.h"
#import "APService.h"
#import "AccountManager.h"
#import "UNIShopManage.h"
#import "UNIAppDeleRequest.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "UNILocateNotifiDetail.h"
#import "UIAlertView+Blocks.h"
#import <AlipaySDK/AlipaySDK.h>//支付宝
//#import "WXApi.h"//微信
#import "WXApiManager.h"

#import "BaiduMobStat.h"//百度统计

@interface AppDelegate (){
    UIImageView* imag;
    __block UIBackgroundTaskIdentifier background_task;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    AFNetworkReachabilityManager * mangaer = [AFNetworkReachabilityManager sharedManager];
    [mangaer startMonitoring];
    [mangaer setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"AFNetworkReachabilityStatus  %ld",(long)status);
        if (status<0) {
            [YIToast showText:@"网络异常，请检查网络"];
            return ;
        }
    }];
   // [self rqCurrentVersion];
    
    //[self rqWelcomeImage];
    [self judgeFirstTime];
    //[self locateStart:launchOptions];
    //[self setupJPush:launchOptions];
    [self.window makeKeyAndVisible];
    [self replaceWelcomeImage:@""];
    [self setupNavigationStyle];
    //[NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    [self setupWeChat];
    
    //[self startBaiduMobStat];//百度统计
    return YES;

}
#pragma mark 设置微信支付
-(void)setupWeChat{
   [WXApi registerApp:WECHATAPPID withDescription:@"Uni To WeChat"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}

#pragma mark 设置导航栏样式
-(void)setupNavigationStyle{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    //设置返回按钮颜色
    [bar setTintColor:[UIColor blackColor]];
    
    //设置导航栏标题字体颜色
    
//    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
//    [barAttrs setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
//    [barAttrs setObject:[UIFont systemFontOfSize:16*1.2] forKey:NSFontAttributeName];
//    [bar setTitleTextAttributes:barAttrs];
    
    //
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionaryWithDictionary:barAttrs];
//    [itemAttrs setObject:[UIFont systemFontOfSize:KMainScreenWidth*14/320] forKey:NSFontAttributeName];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateHighlighted];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateDisabled];
}
-(void)judgeFirstTime{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* first = [user valueForKey:FIRSTINSTALL];
    if (first.length>0){
        AccountManager* manager = [[AccountManager alloc]init];
        if (manager.userId.intValue>0)
       [self setupViewController];
        else
            [self setupLoginController];
    }
    else{
        [user setValue:CURRENTVERSION forKey:FIRSTINSTALL];
        [user synchronize];
        [self setupGuideController];
    }
    
    
}
#pragma mark 开始引导页
-(void)setupGuideController{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
    UIViewController* welcome = [st instantiateViewControllerWithIdentifier:@"UNWelcomeController"];
    self.window.rootViewController = welcome;
}

#pragma mark 开始主界面
-(void)setupViewController{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController* vc = [st instantiateViewControllerWithIdentifier:@"ViewController"];
    UNIContainController* tc = [st instantiateViewControllerWithIdentifier:@"UNIContainController"];
    vc.tv = tc;
    self.window.rootViewController = vc ;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController.view.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
            self.window.rootViewController.view.alpha = 1;
    }];
    
}

#pragma mark 开始登陆界面
-(void)setupLoginController{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
    UIViewController* vc = [st instantiateViewControllerWithIdentifier:@"LoginController"];
    self.window.rootViewController = vc;
}

-(void)locateStart:(NSDictionary *)launchOptions{
    
   // if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey])
        [[YILocationManager sharedInstance] startUpdateUserLoaction];
}

#pragma mark 请求当前版本信息
-(void)rqCurrentVersion{
    UNIAppDeleRequest* model = [[UNIAppDeleRequest alloc]init];
    [model postWithoutUserIdSerCode:@[API_PARAM_UNI,
                             API_URL_CheckVersion]
                    params:@{@"type":@(2)}];
    model.reqheckVersion=^(NSString* version,
                           NSString* url,
                           NSString* desc,
                           NSString*tips,
                           int type,
                           NSError* er){
        if (er==nil) {
            NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
            float curVersinNum = curVersion.floatValue;
            float versionNum = version.floatValue;
            
            if (versionNum <= curVersinNum)
                return ;
            dispatch_async(dispatch_get_main_queue(), ^{
#ifdef IS_IOS9_OR_LATER
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:desc preferredStyle:UIAlertControllerStyleAlert];
                if (type == 1) {
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                }
               
                UIAlertAction *checkAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
                }];
                [alertController addAction:checkAction];
                
                
                [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
#else
                
                NSString* cancelTitle =@"取消";
                if (type == 1)
                    cancelTitle=nil;
                
                [UIAlertView showWithTitle:@"更新提示" message:desc style:UIAlertViewStyleDefault cancelButtonTitle:cancelTitle otherButtonTitles:@[@"更新"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex>0)
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
                }];
#endif

            });
            
        }else{
            
        }
    };
}

#pragma mark 请求欢迎页面图片
-(void)rqWelcomeImage{
    UNIAppDeleRequest* model = [[UNIAppDeleRequest alloc]init];
    [model postWithoutUserIdSerCode:@[API_PARAM_UNI,
                             API_URL_Welcome]
                    params:@{@"type":@(2)}];
    model.rqwelcomeBlock=^(NSString* url,
                           NSString* tips,
                           NSError* er){
        if (er==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
              //  [self replaceWelcomeImage:url];
            });
            
        }else{
            
        }
    };

}


-(void)replaceWelcomeImage:(NSString*)url{
//    UIStoryboard* st = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
//    UIViewController* vc = [st instantiateViewControllerWithIdentifier:@"LaunchScreen"];
   imag = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    UIImage* image = [UIImage imageNamed:@"Main_Img_Welcome"];
    imag.image = image;
    [self.window addSubview:imag];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(VWIB:) userInfo:nil repeats:NO];
//    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [img setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"Main_Img_Welcome"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//        
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        
//    }];
    
}

-(void)VWIB:(UIImageView*)IMG{
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self->imag.alpha = 0;
    } completion:^(BOOL finished) {
        [self->imag removeFromSuperview];
    }];
    
}

#pragma mark 配置JP推送
-(void)setupJPush:(NSDictionary *)launchOptions{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|
                                             UIRemoteNotificationTypeSound|
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}
//后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //获取当前所有的本地通知
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!notificaitons || notificaitons.count <= 0) 
        return;

    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    { //Check if our iOS version supports multitasking I.E iOS 4
        
        if ([[UIDevice currentDevice] isMultitaskingSupported])
        { //Check if device supports mulitasking
    
                 [self backgroundHandler];

            
        }
    }

}

#pragma mark 申请后台任务
-(void)backgroundHandler{
    UIApplication *application = [UIApplication sharedApplication];
    
   // __block UIBackgroundTaskIdentifier background_task;
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^(void){
        /*
         当应用程序后台停留的时间为0时，会执行下面的操作（应用程序后台停留的时间为600s，可以通过backgroundTimeRemaining查看）
         */
        [self backgroundHandler];
        [application endBackgroundTask: self->background_task];
        self->background_task = UIBackgroundTaskInvalid;
       // [self backgroundHandler];
    }];
    
       [[YILocationManager sharedInstance] startUpdateUserLoaction];
       // [self checkLocationNotification];
        NSLog(@"time remain:%f", application.backgroundTimeRemaining);

}

-(void)checkLocationNotification{
    
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification* noti in notificaitons) {
        NSLog(@"checkLocationNotification %@",noti.fireDate);
        
        NSDate* mubiao = [NSDate dateWithTimeInterval:60*60 sinceDate:noti.fireDate];
        
        NSTimeInterval timeBetween = [[NSDate date] timeIntervalSinceDate:mubiao];
        float fen = timeBetween /60;
        //判断通知时间是否已经过去  
        if (fen > 30) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            
            //到预约服务点前十五分钟 开始定位并且检查用户是否到店
        }else if (fen>=-15  &&  fen<30 ){
            UNIShopManage* manage = [UNIShopManage getShopData];
            double shopX = manage.x.doubleValue;
            double shopY = manage.y.doubleValue;
             CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:shopX longitude:shopY];
            YILocationManager* manager = [YILocationManager sharedInstance];
            
            manager.getUserLocBlock = ^(double x, double y){
                
                CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:x longitude:y];
                double distance  = [curLocation distanceFromLocation:otherLocation];
                if (distance<300) {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        UNIAppDeleRequest* model = [[UNIAppDeleRequest alloc]init];
                        model.setArriveShopBlock=^(int code, NSString* tips,NSError* er){
                            NSLog(@"用户到店 %@",tips);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (code == 0) {
                                    [[YILocationManager sharedInstance] stopUpdatingLocation];
                                    [[UIApplication sharedApplication] cancelLocalNotification:noti];
                                    
                                    //结束后台服务
                                    UIApplication *application = [UIApplication sharedApplication];
                                    [application endBackgroundTask: self->background_task];
                                    self->background_task = UIBackgroundTaskInvalid;

                                }
                            });
                        };
                        NSDateFormatter *formatter2 =[[NSDateFormatter alloc] init];
                        [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *arriverTime = [formatter2 stringFromDate:[NSDate date]];
                        NSString* order = [noti.userInfo objectForKey:@"OrderId"];
                        [model postWithSerCode:@[API_PARAM_UNI,API_URL_ArriveShop]
                                        params:@{@"order":order,@"arriverTime":arriverTime}];
                    });
                    
                }
                else [[YILocationManager sharedInstance] stopUpdatingLocation];
            };
            
            //开始定位
            [manager startUpdateUserLoaction];
            
        }
    }
}

-(void)checkUserToShip{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application endBackgroundTask: background_task];
    background_task = UIBackgroundTaskInvalid;

    [self checkLocationNotification];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
   // [application cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    // NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    NSLog(@"收到通知:%@", userInfo);
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
     NSLog(@"收到通知:%@", userInfo);
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
#ifdef IS_IOS9_OR_LATER
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您预约的项目时间还有一小时" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *checkAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showLocationNotificationDetail:notification];
    }];
    [alertController addAction:checkAction];

    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
#else
    
    [UIAlertView showWithTitle:@"提示" message:@"您预约的项目时间还有一小时" style:UIAlertViewStyleDefault cancelButtonTitle:@"取消" otherButtonTitles:@[@"查看"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex>0)
            [self showLocationNotificationDetail:notification];
        
    }];
#endif

    
}

-(void)showLocationNotificationDetail:(UILocalNotification *)notification{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UNILocateNotifiDetail* vc = [st instantiateViewControllerWithIdentifier:@"UNILocateNotifiDetail"];
    vc.order = [notification.userInfo objectForKey:@"OrderId"];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
    //删除本地通知
     [[UIApplication sharedApplication] cancelLocalNotification:notification];
}


#pragma mark 支付宝协议接口
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
   [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

/**
 *  初始化百度统计SDK
 */
- (void)startBaiduMobStat {
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.shortAppVersion  = CURRENTVERSION;
    statTracker.enableDebugOn = YES;
    
    [statTracker startWithAppId:BAIDUSTATAPPKEY];
}
@end
