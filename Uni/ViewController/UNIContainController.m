//
//  UNIContainController.m
//  Uni
//  容器页面
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIContainController.h"
#import "MainViewController.h"
#import "UNIMyRewardController.h"
#import "UNIWalletController.h"
@interface UNIContainController ()
{
    UINavigationController* mainNav;
    //MainViewController* mainCtr;
    UIViewController* myRewardNav;
    UNIMyRewardController* rewardCtr;
    UNIWalletController* wallet;
}
@end

@implementation UNIContainController
-(void)viewWillAppear:(BOOL)animated{
    NSArray* array =self.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSArray* array =self.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainController];
}

//首页
-(void)setupMainController{
    [self removeController];
    if (!mainNav) {
        UIStoryboard* st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       MainViewController* mainCtr= [st instantiateViewControllerWithIdentifier:@"MainViewController"];
        mainCtr.containController = self;
        mainNav = [[UINavigationController alloc]initWithRootViewController:mainCtr];
    }
    [self.view addSubview:mainNav.view];
    [self addChildViewController:mainNav];
}

//我的奖励
-(void)setupMyController{
    [self removeController];
    if (!rewardCtr) {
        UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
        UNIMyRewardController* mainCtr= [st instantiateViewControllerWithIdentifier:@"UNIMyRewardController"];
        mainCtr.containController = self;
        rewardCtr = mainCtr;
        myRewardNav =[[UINavigationController alloc]initWithRootViewController:mainCtr];
    }
   
    [self.view addSubview:myRewardNav.view];
    [self addChildViewController:myRewardNav];
}

//我的钱包
-(void)setupWalletController{
    [self removeController];
    if (!wallet) {
        UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
        UNIWalletController* view = [st instantiateViewControllerWithIdentifier:@"UNIWalletController"];
         view.containController = self;
        wallet = view;
        myRewardNav =[[UINavigationController alloc]initWithRootViewController:view];
    }
    [self.view addSubview:myRewardNav.view];
    [self addChildViewController:myRewardNav];
  
}

-(void)removeController{
    for (UIView* vi in self.view.subviews)
        [vi removeFromSuperview];
    for (UIViewController* vc in self.childViewControllers)
        [vc removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
