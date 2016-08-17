//
//  UNIRewardListController.m
//  Uni
//  我的奖励列表
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardListController.h"
#import "UNIRewardListCell.h"
#import "UNIRewardListView.h"
@interface UNIRewardListController ()<UIScrollViewDelegate,UNIRewardListViewDelegate>{
    //UIView* topView;
    float scrollerX;
    //float startArrowX;
   // UIView* arrowImg;
    __weak IBOutlet UIImageView *arrowImg;
    __weak IBOutlet UIView *topView;
}
//@property(nonatomic,strong)UIScrollView* myScroller;
@property(nonatomic,strong)UNIRewardListView* unGetView; //未领
@property(nonatomic,strong)UNIRewardListView* gotView; //已领
@property(nonatomic,strong)UNIRewardListView* curentView; //当前列表
@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;
@end

@implementation UNIRewardListController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"我的奖励列表"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"我的奖励列表"];
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTopView];
    [self setupTableView];
}
-(void)setupNavigation{
    self.title = @"我的奖励";
    scrollerX = 0;
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [LLARingSpinnerView RingSpinnerViewStop1];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupTopView{
    for (int i = 1; i<4; i++) {
        UIButton* bt = (UIButton*)[topView viewWithTag:i];
        bt.titleLabel.font = kWTFont(14);
    }
}
- (IBAction)topBtnAction:(UIButton*)sender {
    [self buttonLoadViewAction:sender];
}

#pragma mark 按钮改变字体颜色
-(void)btnChangeTextColor:(UIButton*)btn{
    btn.selected=YES;
    for (int i = 1; i<4; i++) {
        UIButton* bt = (UIButton*)[topView viewWithTag:i];
        if (btn!=bt) {
            bt.selected = NO;
        }
    }
   
    
}

#pragma mark 按钮加载视图
-(void)buttonLoadViewAction:(UIButton*)btn{
    [self.myScroller setContentOffset:CGPointMake(KMainScreenWidth* (btn.tag-1),
                                                  0) animated:YES];
    switch (btn.tag) {
        case 2:
                [self setupUnGetView];
    
            break;
        case 3:
                [self setupGotView];
            break;
    }
}

-(void)setupTableView{
    float sh =  _myScroller.frame.size.height;
    _myScroller.contentSize = CGSizeMake(3*KMainScreenWidth, sh);
    
    float scW = KMainScreenWidth;
    self.curentView = [[UNIRewardListView alloc]initWithFrame:CGRectMake(0, 0, scW, sh) andState:-1];
    self.curentView.delegate = self;
    [_myScroller addSubview:self.curentView];
    
}
-(void)setupUnGetView{
     if (self.unGetView)
         return;
    float unX = KMainScreenWidth;
    float unW =  self.curentView.frame.size.width;
    float unH = self.curentView.frame.size.height;
    self.unGetView = [[UNIRewardListView alloc]initWithFrame:CGRectMake(unX, 0, unW, unH) andState:0];
    self.unGetView.delegate = self;
    [self.myScroller addSubview:self.unGetView];

}
-(void)setupGotView{
    if (self.gotView)
        return;
    float unX = 2*KMainScreenWidth;
    float unW =  self.curentView.frame.size.width;
    float unH = self.curentView.frame.size.height;
    self.gotView = [[UNIRewardListView alloc]initWithFrame:CGRectMake(unX, 0, unW, unH) andState:1];
    self.gotView.delegate = self;
    [self.myScroller addSubview:self.gotView];

}

#pragma mark UNIRewardListView 代理方法
-(void)UNIRewardListViewDelegate:(id)model{
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float xx = scrollView.contentOffset.x/3;
    if (xx>-1 && xx<2*KMainScreenWidth) {
        float offsetX = xx;
        CGRect arrowR =self->arrowImg.frame;
        arrowR.origin.x = offsetX;
        self->arrowImg.frame = arrowR;
    }
  
    if(xx == KMainScreenWidth/3)
        [self setupUnGetView];
    
    if(xx == 2*KMainScreenWidth/3)
        [self setupGotView];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *颜色值转换成图片
 */

- (UIImage*) createImageWithColor: (UIColor*) color
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
