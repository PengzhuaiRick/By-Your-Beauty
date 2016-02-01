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
#import "UNICardInfoController.h"
#import "UNIGiftController.h"
#import "UNIOrderListController.h"
#import "UNISetttingController.h"
@interface UNIContainController ()
{
    CGPoint startPoint;
    CGPoint currentPoint;
    UINavigationController* mainNav;
    //MainViewController* mainCtr;
    UIViewController* myRewardNav;
    UINavigationController* walletNav;
    UNIMyRewardController* rewardCtr;
    UNIWalletController* wallet;
    UINavigationController* card;
    UINavigationController* gift;
    UINavigationController* orderList;
    UINavigationController* set;
}


@end

@implementation UNIContainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSelf];
    [self setupNotification];
    [self setupMainController];
   }
-(void)setupSelf{
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan1:)];
    [self.view addGestureRecognizer:pan];
    self.panGes = pan;
    
    UITapGestureRecognizer* tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeTheBox)];
    [self.view addGestureRecognizer:tap];
    tap.enabled=NO;
    self.tapGes = tap;
    
    _closing = YES;
    [RACObserve(self, closing)
     subscribeNext:^(NSNumber* x) {
         if (!x.boolValue) {
             self.tapGes.enabled = YES;
             for (UIView* view in self.view.subviews)
                 view.userInteractionEnabled=NO;
         }else{
             self.tapGes.enabled = NO;
             for (UIView* view in self.view.subviews)
                 view.userInteractionEnabled=YES;
         }
     }];
}
#pragma mark 设置通知功能
-(void)setupNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeTheBox) name:CONTAITVIEWCLOSE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openTheBox) name:CONTAITVIEWOPEN object:nil];
}

-(void)handlePan1:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:[self view]];
    //UIViewController* vv = _tv.viewControllers.lastObject;
    if (pan.state == UIGestureRecognizerStateBegan) {
        startPoint = point;
        currentPoint = point;
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        if (fabs(point.x-startPoint.x)<40)
            return;
        
        float offX =self.view.frame.origin.x+(point.x-currentPoint.x);
        if (offX>-1 && offX<KMainScreenWidth-101){
            self.view.frame = CGRectMake(offX,
                                       0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
            currentPoint = point;
        }
    }
    else if(pan.state == UIGestureRecognizerStateEnded){
        float offset = currentPoint.x - startPoint.x;
        if (offset>0) {
            if (offset>80)
                [self openTheBox];
            else
                [self closeTheBox];
        }else if (offset<0 ){
            if (offset < -80)
                [self closeTheBox];
            else
                
                [self openTheBox];
        }
    }
}
-(void)closeTheBox{
    self.closing = YES;
    [UIView animateWithDuration:0.2 animations:^{
        // self.tv.view.userInteractionEnabled=YES;
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    }];
   // self.tapGes.enabled=NO;
    
}
-(void)openTheBox{
   
    [UIView animateWithDuration:0.2 animations:^{
       
        self.view.frame = CGRectMake(KMainScreenWidth-self.edag, 0, self.view.frame.size.width,self.view.frame.size.height);
    }];
    //self.tapGes.enabled=YES;
    self.closing=NO;
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
        walletNav =[[UINavigationController alloc]initWithRootViewController:view];
    }
    [self.view addSubview:walletNav.view];
    [self addChildViewController:walletNav];
}

//会员卡详情
-(void)setupCardController{
    [self removeController];
    if (!card) {
        UIStoryboard* st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UNICardInfoController* view = [st instantiateViewControllerWithIdentifier:@"UNICardInfoController"];
        view.containController = self;
        card =[[UINavigationController alloc]initWithRootViewController:view];
    }
    [self.view addSubview:card.view];
    [self addChildViewController:card];
}

//我的礼包
-(void)setupGiftController{
    [self removeController];
    if (!gift) {

        UNIGiftController* view = [[UNIGiftController alloc]init];
        view.containController = self;
        gift =[[UINavigationController alloc]initWithRootViewController:view];
    }
    [self.view addSubview:gift.view];
    [self addChildViewController:gift];

}

//订单列表
-(void)setupOrderListController{
    [self removeController];
    if (!orderList) {
        
        UNIOrderListController* view = [[UNIOrderListController alloc]init];
        view.containController = self;
        orderList =[[UINavigationController alloc]initWithRootViewController:view];
    }
    [self.view addSubview:orderList.view];
    [self addChildViewController:orderList];
    
}
//设置页面
-(void)setupSettingController{
    [self removeController];
    if (!set) {
        
        UNISetttingController* view = [[UNISetttingController alloc]init];
        view.containController = self;
        set =[[UINavigationController alloc]initWithRootViewController:view];
    }
    [self.view addSubview:set.view];
    [self addChildViewController:set];
    
}

-(void)removeController{
    for (UIView* vi in self.view.subviews)
        [vi removeFromSuperview];
    for (UIViewController* vc in self.childViewControllers)
        [vc removeFromParentViewController];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CONTAITVIEWOPEN object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CONTAITVIEWCLOSE object:nil];
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
