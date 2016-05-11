//
//  baseViewController.m
//  Uni
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "baseViewController.h"
#import "UNIGuideView.h"
@interface baseViewController ()

@end

@implementation baseViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [LLARingSpinnerView RingSpinnerViewStop1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark 百度统计开始
-(void)BaiduStatBegin:(NSString*)text{
    [[BaiduMobStat defaultStat] pageviewStartWithName:text];
}

#pragma mark 百度统计结束
-(void)BaiduStatEnd:(NSString*)text{
    [[BaiduMobStat defaultStat] pageviewEndWithName:text];
}

#pragma mark 显示指引图片
-(void)showGuideView:(NSString*)className{
    //if (![UNIGuideView determineWhetherFirstTime:className]) {
        UNIGuideView* guide = [[UNIGuideView alloc]initWithClassName:className];
        [[UIApplication sharedApplication].keyWindow addSubview:guide];
    //}
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
