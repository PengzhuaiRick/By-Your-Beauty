//
//  UNIMyRewardController.m
//  Uni
//  我的奖励界面
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyRewardController.h"
#import "MyRewardView.h"
#import "UNIMyRewardRequest.h"
#import "UNIRewardListController.h"
#import <MJRefresh/MJRefresh.h>
@interface UNIMyRewardController (){
    MyRewardView* appointView;
    MyRewardView* inTimeView;
    int page1;// 约满页数
    int page2;//准时页数
    
    NSMutableArray* appointArr;
    NSMutableArray* inTimeArr;
}

@end

@implementation UNIMyRewardController

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
    [self setupUI];
    //[self setupMyAppointView];
   // [self setupIntimeView];
    [self startRequestMyAppoint];
    //[self startRequestIntime];
}
-(void)setupUI{
    page1 = 0;
    page2 = 0;
    
    appointArr = [NSMutableArray array ];
    inTimeArr = [NSMutableArray array ];
}
-(void)startRequestMyAppoint{
    UNIMyRewardRequest* request = [[UNIMyRewardRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_MYRewardInfo] params:@{@"size":@(20),@"page":@(page1)}];
    request.myrewardBlock=^(NSArray* arr,int total,NSString* tips,NSError* er){
        
        [self startRequestIntime];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->appointView.midTableview.header endRefreshing];
            [self->appointView.midTableview.footer endRefreshing];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (arr && arr.count>0) {
                if (self->page1 == 0)
                    [self->appointArr removeAllObjects];

                [self->appointArr addObjectsFromArray:arr];
                [self setupMyAppointView];
            }
//            else
//                [YIToast showText:tips];
        });
    };
}
-(void)startRequestIntime{
    UNIMyRewardRequest* request = [[UNIMyRewardRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_MYITRewardInfo] params:@{@"size":@(20),@"page":@(page2)}];
    request.intimeBlock=^(NSArray* arr,int total,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->inTimeView.midTableview.header endRefreshing];
            [self->inTimeView.midTableview.footer endRefreshing];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (arr && arr.count>0) {
                if (self->page2 == 0)
                    [self->inTimeArr removeAllObjects];
                
                [self->inTimeArr addObjectsFromArray:arr];
                [self setupIntimeView];
            }
//            else
//                [YIToast showText:tips];
        });
    };
}

-(void)setupNavigation{
    self.title = @"我的奖励";
    [self preferredStatusBarStyle];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kMainThemeColor];
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]init];
    bar.image = [UIImage imageNamed:@"main_btn_function"];
    bar.style = UIBarButtonItemStyleDone;
    bar.tintColor = [UIColor whiteColor];
    bar.target = self;
    bar.action=@selector(navigationControllerLeftBarAction:);
    self.navigationItem.leftBarButtonItem = bar;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
}
#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    if (self.containController.closing) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWOPEN object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWCLOSE object:nil];
    }
}
-(void)setupMyAppointView{
    
    if (appointArr.count<1)
        return;
    
    
    if (appointView){
        [appointView startReflashTableView:appointArr];
        return;
    }
    
    float viewX = 15;
    float viewY = 64+15;
    float viewW =KMainScreenWidth-viewX*2;
    float viewH = (KMainScreenHeight- 64- viewX*3)/2;
   
     MyRewardView * view = [[MyRewardView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH) andNum:0 andType:1];
    [self.view addSubview:view];
    appointView = view;
    appointView.midTableview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page1 = 0;
        [self->appointArr removeAllObjects];
        [self startRequestMyAppoint];
    }];
    
    appointView.midTableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->page1++;
         [self startRequestMyAppoint];
    }];
    
     [appointView startReflashTableView:appointArr];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoRewardListController)];
    [view addGestureRecognizer:tap];
}

-(void)setupIntimeView{
    if (inTimeArr.count<1) {
        return;
    }
    
    if (inTimeView){
        [inTimeView startReflashTableView:inTimeArr];
        return;
    }
    float viewX = 15;
    float viewH = (KMainScreenHeight- 64- viewX*3)/2;
    float viewY = 65+viewH+viewX*2;
    if (appointArr.count<1)
        viewY = 64+15;
    
    float viewW =KMainScreenWidth-viewX*2;
    
    
    MyRewardView * view = [[MyRewardView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH) andNum:0 andType:2];
    [self.view addSubview:view];
    inTimeView = view;
    
    inTimeView.midTableview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page2 = 0;
        [self startRequestIntime];
    }];
    
    inTimeView.midTableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->page2++;
        [self startRequestIntime];
    }];
    [inTimeView startReflashTableView:inTimeArr];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoRewardListController)];
    [view addGestureRecognizer:tap];

}

-(void)gotoRewardListController{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UIViewController* vc = [st instantiateViewControllerWithIdentifier:@"UNIRewardListController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
