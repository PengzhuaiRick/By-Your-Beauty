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
    UIView* topView;
    float scrollerX;
    float startArrowX;
    UIImageView* arrowImg;
}
@property(nonatomic,strong)UIScrollView* myScroller;
@property(nonatomic,strong)UNIRewardListView* unGetView; //未领
@property(nonatomic,strong)UNIRewardListView* gotView; //已领
@property(nonatomic,strong)UNIRewardListView* curentView; //当前列表
@end

@implementation UNIRewardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTopView];
    [self setupTableView];
}
-(void)setupNavigation{
    self.title = @"我的奖励";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    scrollerX = 0;
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setupTopView{
    float topH = KMainScreenWidth * 45/320;
    UIView* top = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, topH)];
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];
    topView = top;
    
    NSArray* titil = @[@"全部",@"未领取",@"已领取"];

    float btnW = KMainScreenWidth/3;
    for (int i = 0; i <titil.count; i++) {
        NSString* str = titil[i];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*btnW, 0, btnW, topH);
        btn.tag = i+1;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateSelected];
        [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateHighlighted];
        
        if (i == 0)
            btn.selected = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
            [top addSubview:btn];
        
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             [self btnChangeTextColor:x];
             [self buttonLoadViewAction:x];
        }];
    }
    
    float arrowW =KMainScreenWidth*5/320;
    float arrowH = KMainScreenWidth*4/320;
    float arrowX = (btnW-arrowW)/2;
    float arrowY = top.frame.size.height - arrowH;
    startArrowX = arrowX;
    UIImageView* arrow = [[UIImageView alloc]initWithFrame:CGRectMake(arrowX, arrowY, arrowW, arrowH)];
    arrow.image = [UIImage imageNamed:@"appoint_img_arrows"];
    [top addSubview:arrow];
    arrowImg = arrow;

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
    float tabX = 0;
    float tabY = CGRectGetMaxY(topView.frame)+10;
    float tabH = KMainScreenHeight - tabY;
    UIScrollView* scl = [[UIScrollView alloc]initWithFrame:CGRectMake(0, tabY, KMainScreenWidth, tabH)];
    scl.contentSize = CGSizeMake(KMainScreenWidth*3, tabH);
    scl.delegate = self;
    scl.pagingEnabled = YES;
    [self.view addSubview:scl];
    self.myScroller = scl;
    
    
    float scW = KMainScreenWidth;
    self.curentView = [[UNIRewardListView alloc]initWithFrame:CGRectMake(tabX, 0, scW, tabH) andState:-1];
    self.curentView.delegate = self;
    [scl addSubview:self.curentView];
    
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
    
    float xx = scrollView.contentOffset.x;
    if (xx>-1 && xx<2*KMainScreenWidth) {
        float offsetX = xx* (scrollView.frame.size.width/3) /KMainScreenWidth;
        CGRect arrowR =self->arrowImg.frame;
        arrowR.origin.x = offsetX+self->startArrowX;
        self->arrowImg.frame = arrowR;
    }

    if (xx==0) {
        int tag = 1;
        UIButton* btn = (UIButton*)[topView viewWithTag:tag];
        [self btnChangeTextColor:btn];
    }
    
    if(xx == KMainScreenWidth){
        [self setupUnGetView];
        int tag = 2;
        UIButton* btn = (UIButton*)[topView viewWithTag:tag];
        [self btnChangeTextColor:btn];

    }
    
    if(xx == 2*KMainScreenWidth){
        [self setupGotView];
       int tag = 3;
        UIButton* btn = (UIButton*)[topView viewWithTag:tag];
        [self btnChangeTextColor:btn];
    }
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
