//
//  UNIOrderListController.m
//  Uni
//  订单列表
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderListController.h"
#import "UNIRewardListCell.h"
#import "UNIOrderListView.h"
#import "UNIOrderDetailController.h"
@interface UNIOrderListController ()<UIScrollViewDelegate,UNIOrderListViewDelegate>{
    //UIView* topView;
    float scrollerX;
    //UIView* arrowImg;
    __weak IBOutlet UIView *topView;
    __weak IBOutlet UIImageView *arrowImg;
}
//@property(nonatomic,strong)UIScrollView* myScroller;
@property(nonatomic,strong)UNIOrderListView* unGetView; //未领
@property(nonatomic,strong)UNIOrderListView* gotView; //已领
@property(nonatomic,strong)UNIOrderListView* curentView; //当前列表
@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;

@end

@implementation UNIOrderListController

-(void)viewWillAppear:(BOOL)animated{

    [[BaiduMobStat defaultStat] pageviewStartWithName:@"我的订单"];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"我的订单"];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTopView];
    [self setupTableView];
}
-(void)setupNavigation{
    scrollerX = 0;
    self.title = @"我的订单";
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
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
    float sh = _myScroller.frame.size.height;
    _myScroller.contentSize = CGSizeMake(3*KMainScreenWidth, sh);
    
    float scW = KMainScreenWidth;
    self.curentView = [[UNIOrderListView alloc]initWithFrame:CGRectMake(0, 0, scW, sh) andState:-1];
    self.curentView.delegate = self;
    [_myScroller addSubview:self.curentView];
    
}
-(void)setupUnGetView{
    if (self.unGetView)
        return;
    float unX = KMainScreenWidth;
    float unW =  self.curentView.frame.size.width;
    float unH = self.curentView.frame.size.height;
    self.unGetView = [[UNIOrderListView alloc]initWithFrame:CGRectMake(unX, 0, unW, unH) andState:0];
    self.unGetView.delegate = self;
    [self.myScroller addSubview:self.unGetView];
    
}
-(void)setupGotView{
    if (self.gotView)
        return;
    float unX = 2*KMainScreenWidth;
    float unW =  self.curentView.frame.size.width;
    float unH = self.curentView.frame.size.height;
    self.gotView = [[UNIOrderListView alloc]initWithFrame:CGRectMake(unX, 0, unW, unH) andState:1];
    self.gotView.delegate = self;
    [self.myScroller addSubview:self.gotView];
    
}

#pragma mark UNIRewardListView 代理方法
-(void)UNIOrderListViewDelegate:(id)model{
//    UNIOrderDetailController* detail = [[UNIOrderDetailController alloc]init];
//   // detail.model = model;
//    [self.navigationController pushViewController:detail animated:YES];
    
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UIViewController* vc = [st instantiateViewControllerWithIdentifier:@"UNIOrderDetailController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float xx = scrollView.contentOffset.x/3;
    if (xx<-5){
        scrollView.panGestureRecognizer.enabled=NO;
        [self navigationControllerLeftBarAction:nil];
    }else
        scrollView.panGestureRecognizer.enabled=YES;
    
    if (xx>-1 && xx<2*KMainScreenWidth) {
        CGRect arrowR =self->arrowImg.frame;
        arrowR.origin.x = xx;
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

#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
  
    [self.navigationController popViewControllerAnimated:YES];
}

@end
