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
#import "UNIAppDeleRequest.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
@interface AppDelegate (){
    UIImageView* imag;
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
    [self locateStart:launchOptions];
    [self setupJPush:launchOptions];
    [self.window makeKeyAndVisible];
    [self replaceWelcomeImage:@""];
    [self setupNavigationStyle];
    //[NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    return YES;

}

#pragma mark 设置导航栏样式
-(void)setupNavigationStyle{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    //设置返回按钮颜色
    [bar setTintColor:[UIColor whiteColor]];
    
    //设置导航栏标题字体颜色
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [barAttrs setObject:[UIFont boldSystemFontOfSize:18] forKey:NSFontAttributeName];
    [bar setTitleTextAttributes:barAttrs];
    
    //
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionaryWithDictionary:barAttrs];
    [itemAttrs setObject:[UIFont boldSystemFontOfSize:KMainScreenWidth*16/320] forKey:NSFontAttributeName];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateHighlighted];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateDisabled];
}
-(void)judgeFirstTime{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* first = [user valueForKey:FIRSTINSTALL];
    if (first.length>0){
//        AccountManager* manager = [[AccountManager alloc]init];
//        if (manager.token.length>1)
       [self setupViewController];
//        else
//            [self setupLoginController];
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
    //MainViewController* tc = [st instantiateViewControllerWithIdentifier:@"MainViewController"];
   // UINavigationController* NAV = [[UINavigationController alloc]initWithRootViewController:tc];
   // UINavigationController* NAV1 = [[UINavigationController alloc]initWithRootViewController:vc];
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
    [model postWithSerCode:@[API_PARAM_UNI,
                             API_URL_CheckVersion]
                    params:@{@"type":@(2)}];
    model.reqheckVersion=^(NSString* version,
                           NSString* url,
                           NSString* desc,
                           NSString*tips,
                           int type,
                           NSError* er){
        if (er==nil) {
            
        }else{
            
        }
    };
}

#pragma mark 请求欢迎页面图片
-(void)rqWelcomeImage{
    UNIAppDeleRequest* model = [[UNIAppDeleRequest alloc]init];
    [model postWithSerCode:@[API_PARAM_UNI,
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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //self.inBackground = YES;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    { //Check if our iOS version supports multitasking I.E iOS 4
        
        if ([[UIDevice
              currentDevice] isMultitaskingSupported])
        { //Check if device supports mulitasking
            
            UIApplication *application = [UIApplication
                                          sharedApplication]; //Get the shared application instance
            
            __block UIBackgroundTaskIdentifier background_task; //Create a task object
            
            background_task = [application beginBackgroundTaskWithExpirationHandler: ^{
                /*
                 当应用程序后台停留的时间为0时，会执行下面的操作（应用程序后台停留的时间为600s，可以通过backgroundTimeRemaining查看）
                 */
                [application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
                background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
                
                
                //System will be shutting down the app at any point in time now
            }];
            
            
            // Background tasks require you to use asyncrous tasks
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [[YILocationManager sharedInstance] startUpdateUserLoaction];
                
                
                //Perform your tasks that your application requires
                NSLog(@"time remain:%f", application.backgroundTimeRemaining);
                [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
                background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
            });
        }
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
//    if ([CLLocationManager significantLocationChangeMonitoringAvailable]){
//        YILocationManager* manager = [YILocationManager sharedInstance];
//        [manager.locationManager startUpdatingLocation];
//        [manager.locationManager stopMonitoringSignificantLocationChanges];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
     NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
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
@end
