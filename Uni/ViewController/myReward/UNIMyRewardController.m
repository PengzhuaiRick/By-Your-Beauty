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
    [self startRequestIntime];
}
-(void)setupUI{
    page1 = 0;
    page2 = 0;
}
-(void)startRequestMyAppoint{
    UNIMyRewardRequest* request = [[UNIMyRewardRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_MYRewardInfo] params:@{@"size":@(20),@"page":@(page1)}];
    request.myrewardBlock=^(NSArray* arr,int total,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->appointView.midTableview.header endRefreshing];
            [self->appointView.midTableview.footer endRefreshing];
            if (er) {
                [YIToast showText:er.localizedDescription];
                return ;
            }
            if (arr && arr.count>0) {
                [self setupMyAppointView];
                [self->appointView startReflashTableView:arr];
            }else
                [YIToast showText:tips];
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
                [YIToast showText:er.localizedDescription];
                return ;
            }
            if (arr && arr.count>0) {
                [self setupIntimeView];
                [self->inTimeView startReflashTableView:arr];
            }else
                [YIToast showText:tips];
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
-(void)setupMyAppointView{
    
    if (appointView)
        return;
    
    float viewX = 15;
    float viewY = 64+15;
    float viewW =KMainScreenWidth-viewX*2;
    float viewH = (KMainScreenHeight- 64- viewX*3)/2;
   
     MyRewardView * view = [[MyRewardView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH) andNum:0 andType:1];
    [self.view addSubview:view];
    appointView = view;
    appointView.midTableview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page1 = 0;
        [self startRequestMyAppoint];
    }];
    
    appointView.midTableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->page1++;
         [self startRequestMyAppoint];
    }];

    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoRewardListController)];
    [view addGestureRecognizer:tap];
}

-(void)setupIntimeView{
    
    if (inTimeView)
        return;
    float viewX = 15;
    float viewH = (KMainScreenHeight- 64- viewX*3)/2;
    float viewY = 65+viewH+viewX*2;
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
