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
#import "UNIShopModel.h"
#import "UNIHttpUrlManager.h"
#import "UNITouristController.h"

@interface AppDelegate (){
    UIImageView* imag;
    __block UIBackgroundTaskIdentifier background_task;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
//    AFNetworkReachabilityManager * mangaer = [AFNetworkReachabilityManager sharedManager];
//    [mangaer startMonitoring];
//    [mangaer setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"AFNetworkReachabilityStatus  %ld",(long)status);
//        if (status<0) {
//            [YIToast showText:NETWORKINGPEOBLEM];
//            return ;
//        }
//    }];
   // [self rqWelcomeImage];
    [self rqCurrentVersion];
    [self rqAppTips];
    [self judgeFirstTime];
    [self setupJPush:launchOptions];
    //[self.window makeKeyAndVisible];
    [self setupNavigationStyle];
    [self setupWeChat];
    
    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    return YES;

}
#pragma mark 设置微信支付
-(void)setupWeChat{
   [WXApi registerApp:WECHATAPPID withDescription:@"UniToWeChat"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

#pragma mark 设置导航栏样式
-(void)setupNavigationStyle{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    //设置返回按钮颜色
    [bar setTintColor:[UIColor blackColor]];
    
    //设置导航栏标题字体颜色
    
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [barAttrs setObject:[UIFont systemFontOfSize:KMainScreenWidth>400?15:13] forKey:NSFontAttributeName];
    [bar setTitleTextAttributes:barAttrs];
    
    //
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionaryWithDictionary:barAttrs];
//    [itemAttrs setObject:[UIFont systemFontOfSize:KMainScreenWidth*14/320] forKey:NSFontAttributeName];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateHighlighted];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateDisabled];
}
-(void)judgeFirstTime{
//    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
//    NSString* first = [user valueForKey:FIRSTINSTALL];
//    if (first.length>0){
        AccountManager* manager = [[AccountManager alloc]init];
        if (manager.userId.intValue>0)
       [self setupViewController];
        else
            [self setupLoginController];
//    }
//    else{
//        [user setValue:CURRENTVERSION forKey:FIRSTINSTALL];
//        [user synchronize];
//        [self setupGuideController];
//    }
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
    UNIContainController* tc = [st instantiateViewControllerWithIdentifier:@"UNIContainController"];
    tc.edag = KMainScreenWidth*60/320;
    ViewController* vc = [st instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.tv = tc;
    self.window.rootViewController = vc ;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController.view.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
            self.window.rootViewController.view.alpha = 1;
    }];
    st=nil; tc=nil;vc=nil;
}

#pragma mark 有活动就弹出活动界面
-(void)setupActivityController:(NSArray*)hasActivity{
    UNITouristController* tourist = [[UNITouristController alloc]init];
    tourist.hasActivity = [hasActivity[0] intValue];
    tourist.activityId = [hasActivity[1] intValue];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:tourist];
    [self.window.rootViewController presentViewController:nav animated:YES completion:^{
    }];
    
    tourist = nil; 
}
#pragma mark 开始登陆界面
-(void)setupLoginController{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
    UIViewController* vc = [st instantiateViewControllerWithIdentifier:@"LoginController"];
    self.window.rootViewController = vc;
    vc=nil;
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
//            url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1077238256";
            NSString *curVersion = CURRENTVERSION;      //获取项目版本号
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
        }
    };
}

#pragma mark 获取APP提示语信息
-(void)rqAppTips{
    NSString* URL = @"http://uni.dodwow.com/uni_api/getAppTips.php";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html"]];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"rqAppTips  JSON:%@",responseObject);
        UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
        [manager initHttpUrlManager:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"rqAppTips Error:%@", error);
        
    }];

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
                [self replaceWelcomeImage:url];
                
            });
            
        }else[YIToast showText:NETWORKINGPEOBLEM];
    };

}


-(void)replaceWelcomeImage:(NSString*)url{
//    UIStoryboard* st = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
//    UIViewController* vc = [st instantiateViewControllerWithIdentifier:@"LaunchScreen"];
   imag = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    //UIImage* image = [UIImage imageNamed:@"Main_Img_Welcome"];
    [imag sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[self createImageWithColor:[UIColor blackColor]]];
    [[UIApplication sharedApplication].keyWindow addSubview:imag];
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
    [self judgeFirstTime];
    [self.window makeKeyAndVisible];
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
    NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];
    NSArray* appointArr =[userD objectForKey:@"appointArr"];
    if (appointArr.count<1) {
        return;
    }
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
    
      //[[YILocationManager sharedInstance] startUpdateUserLoaction];
        [self checkLocationNotification];
      //  NSLog(@"time remain:%f", application.backgroundTimeRemaining);
}
#pragma mark 结束后台服务
-(void)closeTheBackGroundTask{
     [[YILocationManager sharedInstance] stopUpdatingLocation];
    UIApplication *application = [UIApplication sharedApplication];
    [application endBackgroundTask: self->background_task];
    self->background_task = UIBackgroundTaskInvalid;
}

#pragma mark 检查所有本地预约提醒通知
-(void)checkLocationNotification{
     NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (int i = 0;i<notificaitons.count;i++) {
        UILocalNotification* noti = notificaitons[i];
        NSLog(@"checkLocationNotification %d",i);
        NSDictionary* userInfo = noti.userInfo;
        if ([self determineCurrentLoggingUser:[userInfo objectForKey:@"useId"]] == NO) {
            //删除本地通知
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            continue;
        }
    }
    
    //是否存在快到预约时间的通知
    BOOL have = NO;
    NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];
    NSArray* appointArr =[userD objectForKey:@"appointArr"];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:appointArr] ;
    
    for (int i = 0;i<arr.count;i++) {
        NSDictionary* userInfo =arr[i];
        if ([self determineCurrentLoggingUser:[userInfo objectForKey:@"useId"]] == NO)
            [arr removeObject:userInfo];
        }
    if (arr.count>0) {
        have = YES;
        [self checkLocationNotification1];
    }
  /*
    for (int i = 0;i<arr.count;i++) {
        NSDictionary* userInfo =arr[i];
        
        NSDate* time =userInfo[@"time"];
        NSDate* mubiao = [NSDate dateWithTimeInterval:60*60 sinceDate:time];
        NSDate* now =[NSDate date];
        NSTimeInterval timeBetween = [now timeIntervalSinceDate:mubiao];
//        NSTimeInterval timeBetween1 = 0;
//        if (timeBetween>0) {
//            timeBetween1 = timeBetween+4*60*60;
//        }else if (timeBetween<0){
//            timeBetween1 = timeBetween-4*60*60;
//        }
        float fen = timeBetween /60;
        //判断通知时间是否已经过去  
        if (fen > 30) {
            [arr removeObject:userInfo];
            
            //到预约服务点前十五分钟 开始定位并且检查用户是否到店
        }else if (fen>=-15 && fen<30 ){
            have = YES;
            [self checkLocationNotification1];
            break;
        }
    }*/
    
    [userD setObject:arr forKey:@"appointArr"];
    [userD synchronize];
   
    if (have == NO)
        //结束后台服务
        [self closeTheBackGroundTask];
}

#pragma mark 检查所有本地预约提醒通知
-(void)checkLocationNotification1{
    __block double x1 = 0;
    YILocationManager* manager = [YILocationManager sharedInstance];
    manager.getUserLocBlock = ^(double x, double y){
        if (x1 > 0)
            return ;
        x1 = x;
        
        CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:x longitude:y];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];
                NSMutableArray* arr = [NSMutableArray arrayWithArray:[userD objectForKey:@"appointArr"]] ;
                for (int i = 0;i<arr.count;i++) {
                    NSDictionary* noti = arr[i];
                     double shopX =[[noti objectForKey:@"shopX"] doubleValue];
                    double shopY =[[noti objectForKey:@"shopY"] doubleValue];
                    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:shopX longitude:shopY];
                    double distance  = [curLocation distanceFromLocation:otherLocation];
                    if (distance<500) {
                        UNIAppDeleRequest* model = [[UNIAppDeleRequest alloc]init];
                        model.setArriveShopBlock=^(int code, NSString* tips,NSError* er){
                            // NSLog(@"用户到店 %@",tips);
                            if (code == 0 ){
                                [arr removeObject:noti];
                                [userD setObject:arr forKey:@"appointArr"];
                                [userD synchronize];
                            }
                        };
                        NSDateFormatter *formatter2 =[[NSDateFormatter alloc] init];
                        [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *arriverTime = [formatter2 stringFromDate:[NSDate date]];
                        NSString* order = [noti objectForKey:@"OrderId"];
                        [model postWithSerCode:@[API_PARAM_UNI,API_URL_ArriveShop]
                                        params:@{@"order":order,@"arriverTime":arriverTime}];
                    }
                    if (i == arr.count-1){
                        [NSThread sleepForTimeInterval:3];
                        dispatch_async(dispatch_get_main_queue(), ^{
                                //结束后台服务
                                [self closeTheBackGroundTask];
                        });
                    }
                }
            });
    };
    //开始定位
    [manager startUpdateUserLoaction];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
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
    NSDictionary* userInfo = notification.userInfo;
    if ([self determineCurrentLoggingUser:[userInfo objectForKey:@"useId"]] == NO) {
        //删除本地通知
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        return;
    }
    
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

#pragma mark 判断是否当前登录用户
-(BOOL)determineCurrentLoggingUser:(NSNumber*)userNum{
    BOOL k = NO;
    if ([[AccountManager userId].stringValue isEqualToString: userNum.stringValue])
        k=YES;
    
    return k;
}

#pragma mark 本地通知被点击事件
-(void)showLocationNotificationDetail:(UILocalNotification *)notification{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UNILocateNotifiDetail* vc = [st instantiateViewControllerWithIdentifier:@"UNILocateNotifiDetail"];
    vc.order = [notification.userInfo objectForKey:@"OrderId"];
    vc.shopId =[[notification.userInfo objectForKey:@"shopId"] intValue];
    UNIShopModel* model = [[UNIShopModel alloc]init];
    model.x =[[notification.userInfo objectForKey:@"shopX"] doubleValue];
    model.y =[[notification.userInfo objectForKey:@"shopY"] doubleValue];
    model.shopName=[notification.userInfo objectForKey:@"shopName"] ;
    model.address=[notification.userInfo objectForKey:@"shopAddress"] ;
    vc.shopModel =model;
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
            NSLog(@"ZFBresult = %@",resultDic);
            [self resultOfZFBpay:resultDic];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"ZFBresultresult = %@",resultDic);
             [self resultOfZFBpay:resultDic];
        }];
    }
    return YES;
}

#pragma mark 支付宝回调结果
-(void)resultOfZFBpay:(NSDictionary*)dic{
    int resultStatus =[[dic valueForKey:@"resultStatus"] intValue];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dealWithResultOfTheZFB" object:nil userInfo:@{@"result":@(resultStatus)}];
}

#pragma mark 设置通知
-(void)setupNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setupLoginController) name:@"setupLoginController" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setupLoginController" object:nil];
}


#pragma mark 颜色转图片
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



@end
