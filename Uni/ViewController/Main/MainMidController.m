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
@interface MainMidController ()
{
    int pageNum;
    int pageSize;
}
@end

@implementation MainMidController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)dealloc{
    [self.myData removeAllObjects];
    self.myData = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSelf];
    [self setupNavigation];
    [self setupParams];
    [self setupMJReflash];
    
    [self.tableView.header beginRefreshing];
}

-(void)setupNavigation{
    self.title = @"我的预约";
    // self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
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
    pageNum = 0;
    pageSize = 20;

}
#pragma mark 设置刷新方法
-(void)setupMJReflash{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->pageNum =0;
        self->pageSize =20;
        [self startRequestInfoPage];
    }];
 
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            ++self->pageNum;
            self->pageSize =20;
            [self startRequestInfoPage];
        }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)setupTableviewHeader:(NSString*)string{
//    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, KMainScreenWidth*0.06)];
//    view.image =[UIImage imageNamed:@"mian_img_cellH"];
//    UILabel* lab = [[UILabel alloc]initWithFrame:
//                    CGRectMake(10, 5,  self.tableView.frame.size.width-10, KMainScreenWidth*0.05)];
//    lab.text=string;
//    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
//    lab.font = [UIFont systemFontOfSize:KMainScreenWidth*0.043];
//    [view addSubview:lab];
//    self.tableView.tableHeaderView = view;
//}

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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_PARAM_UNI,API_URL_Appoint]
                          params:@{@"page":@(self->pageNum),@"size":@(self->pageSize)}];
        request.reappointmentBlock =^(int count,NSArray* myAppointArr,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.header endRefreshing];
                [self.tableView.footer endRefreshing];
                if (!err) {
                    
                    if (myAppointArr.count<20)
                        [self.tableView.footer setHidden:YES];
                    
                    if (myAppointArr.count>0){
                        if (self->pageNum == 0)//下拉刷新
                            [self.myData removeAllObjects];
                        
                        [self.myData addObjectsFromArray:myAppointArr];
                        [self.tableView reloadData];
                    }else{
                        if (self->pageNum == 0){//下拉刷新
                            [self.myData removeAllObjects];
                            [self.tableView reloadData];
                        }
                    }
                }else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
    });
}



@end
