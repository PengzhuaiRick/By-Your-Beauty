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
//    self.view.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
//    NSLog(@"NSStringFromCGRect(self.view.frame)  %@",NSStringFromCGRect(self.view.frame));
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
    float cellH = KMainScreenWidth* 60 /320;
    float rest = KMainScreenWidth* 16/320+ KMainScreenWidth* 10/320 + 16;
    
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
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoRewardListController)];
                 [cell.RewordAndIntimeView addGestureRecognizer:tap];
            }
            
            [cell setupCell:appointArr];
        }
        else if (inTimeArr.count>0){
            if (!cell){
                cell = [[UNIRewordAndIntimeCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:name andNum:inTimeNum andType:2];
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoRewardListController)];
                [cell.RewordAndIntimeView addGestureRecognizer:tap];
            }
            [cell setupCell:inTimeArr];
        }

    }
    if (indexPath.row == 1) {
        if (inTimeArr.count>0){
            if (!cell){
                cell = [[UNIRewordAndIntimeCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:name andNum:inTimeNum andType:2];
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoRewardListController)];
                [cell.RewordAndIntimeView addGestureRecognizer:tap];
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
//-(void)setupMyAppointView{
//    
//    if (appointArr.count<1)
//        return;
//    
//    
//    if (appointView){
//        [appointView startReflashTableView:appointArr];
//        return;
//    }
//    
//    float viewX = 15;
//    float viewY = 64+15;
//    float viewW =KMainScreenWidth-viewX*2;
//    float viewH = (KMainScreenHeight- 64- viewX*3)/2;
//   
//     MyRewardView * view = [[MyRewardView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH) andNum:0 andType:1];
//    [self.view addSubview:view];
//    appointView = view;
//    appointView.midTableview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self->page1 = 0;
//        [self->appointArr removeAllObjects];
//        [self startRequestMyAppoint];
//    }];
//    
//    appointView.midTableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self->page1++;
//         [self startRequestMyAppoint];
//    }];
//    
//     [appointView startReflashTableView:appointArr];
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoRewardListController)];
//    [view addGestureRecognizer:tap];
//}
//
//-(void)setupIntimeView{
//    if (inTimeArr.count<1) {
//        return;
//    }
//    
//    if (inTimeView){
//        [inTimeView startReflashTableView:inTimeArr];
//        return;
//    }
//    float viewX = 15;
//    float viewH = (KMainScreenHeight- 64- viewX*3)/2;
//    float viewY = 65+viewH+viewX*2;
//    if (appointArr.count<1)
//        viewY = 64+15;
//    
//    float viewW =KMainScreenWidth-viewX*2;
//    
//    
//    MyRewardView * view = [[MyRewardView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH) andNum:0 andType:2];
//    [self.view addSubview:view];
//    inTimeView = view;
//    
//    inTimeView.midTableview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self->page2 = 0;
//        [self startRequestIntime];
//    }];
//    
//    inTimeView.midTableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self->page2++;
//        [self startRequestIntime];
//    }];
//    [inTimeView startReflashTableView:inTimeArr];
//
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoRewardListController)];
//    [view addGestureRecognizer:tap];
//
//}

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
