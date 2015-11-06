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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    [self judgeFirstTime];
    //[self locateStart:launchOptions];
    [self.window makeKeyAndVisible];
    return YES;

}

-(void)judgeFirstTime{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* first = [user valueForKey:FIRSTINSTALL];
    if (first.length>0){
        [self setupViewController];
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
}


-(void)locateStart:(NSDictionary *)launchOptions{
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey])
        [[YILocationManager sharedInstance]startUpdateUserLoaction];
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

@end
