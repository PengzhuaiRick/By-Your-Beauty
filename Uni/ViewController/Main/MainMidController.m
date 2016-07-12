//
//  MainMidController.m
//  Uni
//  首页中部 我已预约列表
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMidController.h"
#import "MainMidMoveBackTransition.h"
#import "MainMidCell.h"
#import "MainViewRequest.h"
#import <MJRefresh/MJRefresh.h>
//#import "UNIAppointController.h"
#import "UNIAppointDetail.h"
#import "UNIHttpUrlManager.h"
@interface MainMidController ()
{
    UIView* noData;
}
@end

@implementation MainMidController

-(void)viewWillAppear:(BOOL)animated{
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [super viewWillDisappear:animated];
}
-(void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.myData removeAllObjects];
    self.myData = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSelf];
    [self setupNavigation];
    [self setupParams];
    [self setupMJReflash];
    [self setupNodataView];
    [self.tableView.header beginRefreshing];
}

-(void)setupNavigation{
    self.title = @"我的预约";
    // self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupSelf{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
    view.backgroundColor =[UIColor colorWithHexString:kMainBackGroundColor];
    self.view.backgroundColor =[UIColor colorWithHexString:kMainBackGroundColor];
    self.tableView.tableHeaderView =view;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    view=nil;
}
#pragma mark 设置参数
-(void)setupParams{
    _myData = [NSMutableArray array];
   //_num = (int)_myData.count;
    _pageNum = 0;
}
#pragma mark 设置刷新方法
-(void)setupMJReflash{
    
    __weak MainMidController* myself = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        myself.pageNum =0;
        [myself startRequestInfoPage];
    }];
 
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            ++myself.pageNum;
            [myself startRequestInfoPage];
        }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNodataView{
    
    UIView* nodata = [[UIView alloc]initWithFrame:CGRectMake(0,20, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    [self.tableView addSubview:nodata];
    noData = nodata;
    
    UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_img_nodata3"]];
    float imgWH = KMainScreenWidth>400?60:50,
    imgX = (nodata.frame.size.width - imgWH)/2;
    img.frame = CGRectMake(imgX, 30, imgWH, imgWH);
    [nodata addSubview:img];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+20, nodata.frame.size.width, 30)];
    lab.text = [UNIHttpUrlManager sharedInstance].APPOINT_DESC;
    
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [nodata addSubview:lab];
    
    nodata=nil;img=nil; lab=nil;
}

-(void)setupTableviewFootView{
    UIView* bView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.tableView.frame.size.width, 5)];
    self.tableView.tableFooterView = bView;
    bView=nil;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*90/320;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"CellName";
    MainMidCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell)
        cell = [[MainMidCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth*90/320) reuseIdentifier:name];
    
    [cell setupCellContent:_myData[indexPath.row] andType:1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNIAppointDetail* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointDetail"];
    UNIMyAppintModel* model =_myData[indexPath.row];
    appoint.order =model.myorder;
    appoint.shopId = model.shopId;
    [self.navigationController pushViewController:appoint animated:YES];
    appoint=nil;
    story=nil;
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)reflashTabel:(int)Num{
    [self.tableView reloadData];
}
-(void)insertTableViewData{
    [self.tableView reloadData];
}
-(void)deleteTableViewData:(int)Num{
    [self.tableView reloadData];
}

#pragma mark 开始请求我已预约项目
-(void)startRequestInfoPage{
    __weak MainMidController* myself = self;
    int page = _pageNum;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_URL_Appoint]
                          params:@{@"page":@(page),@"size":@(10)}];
        request.reappointmentBlock =^(int count,NSArray* myAppointArr,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                [myself.tableView.header endRefreshing];
                [myself.tableView.footer endRefreshing];
                if (!err) {
                    
                    if (page == 0)//下拉刷新
                        [myself.myData removeAllObjects];
                    if (myAppointArr.count<20)
                        [myself.tableView.footer endRefreshingWithNoMoreData];
                    
                    [myself.myData addObjectsFromArray:myAppointArr];
                    [myself changeUI];
                    
                }else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
    });
}

-(void)changeUI{
    noData.hidden = _myData.count>0;
    [self.tableView reloadData];
}


@end
