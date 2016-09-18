//
//  MainMidController.m
//  Uni
//  首页中部 我已预约列表
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMidController.h"
#import "MainCell.h"
#import "MainViewRequest.h"
#import <MJRefresh/MJRefresh.h>
//#import "UNIAppointController.h"
#import "UNIAppointDetail.h"
#import "UNIHttpUrlManager.h"
#import "UNIGuideView.h"
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
   
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KMainScreenWidth*15/414;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenWidth*15/414)];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*81/414;;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"CellName";
    MainCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell){
        __weak MainMidController* myself = self;
        cell = [[NSBundle mainBundle]loadNibNamed:@"MainCell" owner:self options:nil].lastObject;
        [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             [myself gotoAppointDetail:(int)x.tag-1];
         }];
    }
    UNIMyAppintModel* model = _myData[indexPath.section];
    cell.mainLab.text =model.projectName;
    NSString*createTime = [model.createTime substringToIndex:16];
    cell.subLab.text =[createTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    [cell.mainImage sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    
    NSString* btnTitle = nil;
    NSString* imgName= nil;
    switch (model.status) {
        case 0:
            btnTitle = @"待确认";
            imgName = @"main_btn_cell4";
            break;
        case 1:
            btnTitle = @"待服务";
            imgName = @"main_btn_cell2";
            break;
        case 2:
            btnTitle = @"已完成";
            imgName = @"main_btn_cell1";
            break;
        case 3:
            btnTitle = @"已取消";
            imgName = @"main_btn_cell3";
            break;
    }
    cell.handleBtn.tag = indexPath.section+1;
    [cell.handleBtn setTitle:btnTitle forState:UIControlStateNormal];
    cell.handleImg.image = [UIImage imageNamed:imgName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self gotoAppointDetail:(int)indexPath.section];
//    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UNIAppointDetail* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointDetail"];
//    UNIMyAppintModel* model =_myData[indexPath.section];
//    appoint.order =model.myorder;
//    appoint.shopId = model.shopId;
//    [self.navigationController pushViewController:appoint animated:YES];
   
}
-(void)gotoAppointDetail:(int)tag{
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNIAppointDetail* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointDetail"];
    UNIMyAppintModel* model =_myData[tag];
    appoint.order =model.myorder;
    appoint.shopId = model.shopId;
    [self.navigationController pushViewController:appoint animated:YES];
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
                    if (myAppointArr.count<10)
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
    if (_myData.count>0) {
        UNIGuideView* guide = [[UNIGuideView alloc]initWithClassName:APPOINTLIST tapBlock:^(id model) {
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:guide];
    }
}


@end
