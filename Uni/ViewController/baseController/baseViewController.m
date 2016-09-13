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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithHexString:kMainNavigationColor];
}

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
-(void)showGuideView:(NSString*)className andBlock:(VCBlock)vc{
    //if (![UNIGuideView determineWhetherFirstTime:className]) {
    if (KMainScreenHeight<500)
        return;
    
        UNIGuideView* guide = [[UNIGuideView alloc]initWithClassName:className tapBlock:^(id model) {
            if (vc)
                vc(nil);
            //[guide removeFromSuperview];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:guide];
    //}
}
#pragma mark 添加右划返回手势
-(void)addPanGesture:(VCBlock)vb{
    _vCBlock = vb;
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.view addGestureRecognizer:pan];
}
-(void)panGestureRecognizerAction:(UIPanGestureRecognizer*)gs{
    CGPoint point = [gs translationInView:self.view];
    if (gs.state == UIGestureRecognizerStateEnded) {
        if (point.x>30){
            if (_vCBlock)
                self.vCBlock(nil);
        }
    }
//    if (_vCBlock) {
//        self.vCBlock(nil);
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
