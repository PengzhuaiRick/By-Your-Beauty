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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
}
-(void)setupNavigation{
    self.title = @"我的钱包";
    [self preferredStatusBarStyle];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kMainThemeColor];
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithTitle:@"钱包明细" style:UIBarButtonItemStylePlain target:self action:@selector(navigationControllerLeftBarAction:)];
    self.navigationItem.rightBarButtonItem = bar;
}

-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
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
