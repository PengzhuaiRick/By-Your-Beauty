//
//  UNIRewardListController.m
//  Uni
//  我的奖励列表
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardListController.h"
#import "UNIRewardListCell.h"
#import "UNIRewardDetail.h"
#import "UNIRewardListView.h"
@interface UNIRewardListController ()<UIScrollViewDelegate,UNIRewardListViewDelegate>{
    UIView* topView;
    float scrollerX;
}
@property(nonatomic,strong)CALayer* lineLayer;
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
}

-(void)setupTopView{
    float topH = KMainScreenWidth * 40/320;
    UIView* top = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, topH)];
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];
    topView = top;
    
    NSArray* titil = @[@"全部",@"未领取",@"已领取"];
    float btnX = 10;
    float btnW = (KMainScreenWidth-btnX*2)/3;
    for (int i = 0; i <titil.count; i++) {
        NSString* str = titil[i];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX+i*btnW, 0, btnW, topH);
        btn.tag = i+1;
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:kMainTitleColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateSelected];
        if (i == 0)
            btn.selected = YES;
        if (i<titil.count-1) {
            float layX =btnX+i*btnW+btnW;
            float layH = topH*0.7;
            float layY = (topH - layH)/2;
            CALayer* lay = [CALayer layer];
            lay.backgroundColor = kMainGrayBackColor.CGColor;
            lay.frame = CGRectMake(layX, layY, 1, layH);
            [top.layer addSublayer:lay];
        }
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
            [top addSubview:btn];
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             [self lineLayerMoveAction:x];
             [self buttonRequestAction:x];
        }];
    }
    
    float layY = topH-2;
    CALayer* lay = [CALayer layer];
    lay.backgroundColor = [UIColor colorWithHexString:kMainThemeColor].CGColor;
    lay.frame = CGRectMake(btnX, layY, btnW, 1);
    [top.layer addSublayer:lay];
    self.lineLayer = lay;
}
#pragma mark 顶部红色底线滑动事件
-(void)lineLayerMoveAction:(UIButton*)btn{
    
    btn.selected=YES;
    for (int i = 1; i<4; i++) {
        UIButton* bt = (UIButton*)[topView viewWithTag:i];
        if (btn!=bt) {
            bt.selected = NO;
        }
    }
}

#pragma mark 顶部点击请求事件
-(void)buttonRequestAction:(UIButton*)btn{
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
    float tabX = 10;
    float tabY = CGRectGetMaxY(topView.frame)+tabX;
    float tabH = KMainScreenHeight - tabX - tabY;
    UIScrollView* scl = [[UIScrollView alloc]initWithFrame:CGRectMake(0, tabY, KMainScreenWidth, tabH)];
    scl.contentSize = CGSizeMake(KMainScreenWidth*3, tabH);
    scl.delegate = self;
    scl.pagingEnabled = YES;
    [self.view addSubview:scl];
    self.myScroller = scl;
    
    
    float scW = KMainScreenWidth - 2*tabX;
    self.curentView = [[UNIRewardListView alloc]initWithFrame:CGRectMake(tabX, 0, scW, tabH) andState:-1];
    self.curentView.delegate = self;
    [scl addSubview:self.curentView];
    
}
-(void)setupUnGetView{
     if (self.unGetView)
         return;
    float unX = KMainScreenWidth+10;
    float unW =  self.curentView.frame.size.width;
    float unH = self.curentView.frame.size.height;
    self.unGetView = [[UNIRewardListView alloc]initWithFrame:CGRectMake(unX, 0, unW, unH) andState:0];
    self.unGetView.delegate = self;
    [self.myScroller addSubview:self.unGetView];

}
-(void)setupGotView{
    if (self.gotView)
        return;
    float unX = 2*KMainScreenWidth+10;
    float unW =  self.curentView.frame.size.width;
    float unH = self.curentView.frame.size.height;
    self.gotView = [[UNIRewardListView alloc]initWithFrame:CGRectMake(unX, 0, unW, unH) andState:1];
    self.gotView.delegate = self;
    [self.myScroller addSubview:self.gotView];

}

#pragma mark UNIRewardListView 代理方法
-(void)UNIRewardListViewDelegate:(id)model{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UNIRewardDetail* rd = [st instantiateViewControllerWithIdentifier:@"UNIRewardDetail"];
    rd.model = model;
    [self.navigationController pushViewController:rd animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float xx = scrollView.contentOffset.x;
    if (xx<0 ||xx>2*KMainScreenWidth)
        return;
    float zx = xx-scrollerX;
    scrollerX = xx;
    CGRect layRe = self.lineLayer.frame;
    float yd = zx *layRe.size.width/KMainScreenWidth;
        self.lineLayer.frame = CGRectMake(layRe.origin.x + yd,
                                          layRe.origin.y,
                                          layRe.size.width,
                                          layRe.size.height);
    if(xx == KMainScreenWidth)
        [self setupUnGetView];
    
    if(xx == 2*KMainScreenWidth)
        [self setupGotView];
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
