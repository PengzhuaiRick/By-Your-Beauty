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

#import "UNIRewordAndIntimeCell.h"
@interface UNIMyRewardController ()<UITableViewDataSource,UITableViewDelegate>{
    MyRewardView* appointView;
    MyRewardView* inTimeView;
    int page1;// 约满页数
    int page2;//准时页数
    
    float cellHight;
    int apponitNum;
    int inTimeNum;
    
    NSMutableArray* appointArr;
    NSMutableArray* inTimeArr;
}
@property(nonatomic,strong)UITableView* myTableView;
@end

@implementation UNIMyRewardController

-(void)viewWillAppear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    self.myTableView.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
    [super viewWillDisappear:animated];
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

-(void)setupTableView{
    if (self.myTableView) {
        [self.myTableView reloadData];
        return;
    }
    
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    tab.delegate = self;
    tab.dataSource = self;
    tab.backgroundColor = [UIColor clearColor];
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tab];
    self.myTableView = tab;
    
    self.myTableView.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page1 = 0;
        self->page2 = 0;
        [self startRequestMyAppoint];
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num = 0;
    if (appointArr.count>0) {
        ++num;
    }if (inTimeArr.count>0) {
        ++num;
    }
    return num;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float max = (KMainScreenHeight-64)/2;
    float cellH = KMainScreenWidth* 80 /320;
    float rest = KMainScreenWidth* 30/320;
    
    cellHight = 0;
    if (indexPath.row == 0) {
        if (appointArr.count>0) {
            cellHight = cellH*appointArr.count+rest;
            if (cellHight>max)
                cellHight = max;
            
        }else if (inTimeArr.count>0) {
            cellHight = cellH*inTimeArr.count + rest;
            if (cellHight>max)
                cellHight = max;
        }
    }if (indexPath.row == 1) {
        if (inTimeArr.count>0) {
            cellHight = cellH*inTimeArr.count+rest;
            if (cellHight>max)
                cellHight = max;
        }
    }
    return cellHight;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIRewordAndIntimeCell* cell =  [tableView dequeueReusableCellWithIdentifier:name];
    if (indexPath.row == 0) {
        if (appointArr.count>0){
            if (!cell){
                cell = [[UNIRewordAndIntimeCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:name andNum:apponitNum andType:1];

            }
            
            [cell setupCell:appointArr];
        }
        else if (inTimeArr.count>0){
            if (!cell){
                cell = [[UNIRewordAndIntimeCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:name andNum:inTimeNum andType:2];

            }
            [cell setupCell:inTimeArr];
        }

    }
    if (indexPath.row == 1) {
        if (inTimeArr.count>0){
            if (!cell){
                cell = [[UNIRewordAndIntimeCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:name andNum:inTimeNum andType:2];

            }
            
                [cell setupCell:inTimeArr];
        }
    }

    return cell;
}


-(void)startRequestMyAppoint{
    UNIMyRewardRequest* request = [[UNIMyRewardRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_MYRewardInfo] params:@{@"size":@(20),@"page":@(page1)}];
    request.myrewardBlock=^(NSArray* arr,int total,NSString* tips,NSError* er){
        
        [self startRequestIntime];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            self->apponitNum = 0;
             [self->appointArr removeAllObjects];
            if (arr && arr.count>0) {
                self->apponitNum = total;
                [self->appointArr addObjectsFromArray:arr];
                //[self setupMyAppointView];
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
            [self.myTableView.header endRefreshing];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            
            self->inTimeNum = 0;
            [self->inTimeArr removeAllObjects];
            if (arr && arr.count>0) {
                self->inTimeNum = total;
                
                [self->inTimeArr addObjectsFromArray:arr];
                [self setupTableView];
               // [self setupIntimeView];
            }
//            else
//                [YIToast showText:tips];
        });
    };
}

-(void)setupNavigation{
    self.title = @"我的奖励";
    [self preferredStatusBarStyle];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
   
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gift_bar_list"] style:0 target:self action:@selector(gotoRewardListController)];
    
    
     self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
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
