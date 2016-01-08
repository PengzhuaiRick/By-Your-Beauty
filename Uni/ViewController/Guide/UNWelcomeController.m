//
//  UNWelcomeController.m
//  Uni
//  欢迎界面
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNWelcomeController.h"
#import "EAIntroView.h"
#import "AppDelegate.h"
@interface UNWelcomeController ()<EAIntroDelegate>{
    
    __weak IBOutlet UIButton *finishBtn;
}

@end

@implementation UNWelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[finishBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self intoSystem];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EAIntroDelegate

- (void)introDidFinish:(EAIntroView *)introView
{
    [self intoSystem];
}

#pragma mark 跳转到主页面

- (void)intoSystem
{
    AppDelegate* app =  [UIApplication sharedApplication].delegate;
    [app judgeFirstTime];
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
