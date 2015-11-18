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
#import "YILocationManager.h"
#import "APService.h"
#import "AccountManager.h"
#import "UNIAppDeleRequest.h"
#import "UIImageView+AFNetworking.h"
@interface AppDelegate (){
    UIImageView* imag;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
   // [self rqCurrentVersion];
    
    //[self rqWelcomeImage];
    [self judgeFirstTime];
    [self locateStart:launchOptions];
    //[self setupJPush:launchOptions];
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
    [itemAttrs setObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
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
    MainViewController* tc = [st instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController* NAV = [[UINavigationController alloc]initWithRootViewController:tc];
    UINavigationController* NAV1 = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.tv = NAV;
    self.window.rootViewController = NAV1 ;
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
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey])
        [[YILocationManager sharedInstance]startUpdateUserLoaction];
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
                [self replaceWelcomeImage:url];
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
        imag.alpha = 0;
    } completion:^(BOOL finished) {
        [imag removeFromSuperview];
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

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
@end
