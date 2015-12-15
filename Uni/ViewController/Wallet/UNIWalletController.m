//
//  UNIWalletController.m
//  Uni
//  我的钱包
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIWalletController.h"

@interface UNIWalletController ()

@end

@implementation UNIWalletController
-(void)viewWillAppear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
}
-(void)setupNavigation{
    self.title = @"我的钱包";
    [self preferredStatusBarStyle];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kMainThemeColor];
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithTitle:@"钱包明细" style:UIBarButtonItemStylePlain target:self action:@selector(navigationControllerRightBarAction:)];
    self.navigationItem.rightBarButtonItem = bar;
    
    UIBarButtonItem* left = [[UIBarButtonItem alloc]init];
    left.image = [UIImage imageNamed:@"main_btn_function"];
    left.style = UIBarButtonItemStyleDone;
    left.tintColor = [UIColor whiteColor];
    left.target = self;
    left.action=@selector(navigationControllerLeftBarAction:);
    self.navigationItem.leftBarButtonItem = left;
}
#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    float x = self.containController.view.frame.origin.x;
    [UIView animateWithDuration:0.2 animations:^{
        if (x==0)
            self.containController.view.frame =
            CGRectMake(KMainScreenWidth-100,
                       0,self.view.frame.size.width
                       ,self.view.frame.size.height);
        else
            self.containController.view.frame =
            CGRectMake(0,
                       0,self.view.frame.size.width
                       ,self.view.frame.size.height);
        
    }];
}


-(void)navigationControllerRightBarAction:(UIBarButtonItem*)bar{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UIViewController* view = [st instantiateViewControllerWithIdentifier:@"UNIWalletList"];
    [self.navigationController pushViewController:view animated:YES];
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
