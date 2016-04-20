//
//  UNIMyPojectList.m
//  Uni
//  添加项目列表
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyPojectList.h"
#import "MainViewRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIAddProjcetCell.h"
#define CELLH KMainScreenWidth*70/320
#define MAXTABLEH KMainScreenHeight-74-60  //tableview最大高度
@interface UNIMyPojectList ()<UITableViewDataSource,UITableViewDelegate>{
    UIButton* needKnowBtn;//需知按钮
    CGRect tableRect;//
    CGRect btnRect;
    int pageNum;
    int pageSize;
    
    int seletNum;
    UILabel* numLab;
}
@end


@implementation UNIMyPojectList
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"UNIMyPojectList.h"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"UNIMyPojectList.h"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupTableView];
   // [self startRequestInfo];
    [self.myTableview.header beginRefreshing];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupData{
    self.title = @"我的项目";
    seletNum = 0;
    pageNum = 0;
    pageSize = 20;
    _myData = [NSMutableArray array];
     self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    float btnWH = KMainScreenWidth*20/320;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btnWH, btnWH)];
    lab.text=@"0";
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
    lab.backgroundColor = [UIColor colorWithHexString:kMainThemeColor];
    lab.layer.masksToBounds=YES;
    lab.layer.cornerRadius = btnWH/2;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:lab];
    numLab = lab;
}
-(void)setupTableView{
   
    tableRect =CGRectMake(0, 64+10, KMainScreenWidth,MAXTABLEH);
    _myTableview = [[UITableView alloc]initWithFrame:tableRect
                                               style:UITableViewStylePlain];

    _myTableview.delegate =self;
    _myTableview.dataSource = self;
    _myTableview.separatorStyle = 0;
    if (IOS_VERSION>8.0)
        _myTableview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:_myTableview];
    
    self.myTableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->pageNum =0;
        self->pageSize =(int)self.myData.count;
        [self startRequestInfo];
    }];
    self.myTableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            ++self->pageNum;
            self->pageSize =(int)self.myData.count+20;
            [self startRequestInfo];
        }];

    
    _myTableview.tableFooterView = [UIView new];
    
    NSString* btnT = @"选 择";
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    
    btnRect =  CGRectMake(0,KMainScreenHeight - 60,KMainScreenWidth, 60);
    btn.frame =btnRect;
    [btn setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    [btn setTitle:btnT forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth>400?20:17];
    [self.view addSubview:btn];
    needKnowBtn = btn;
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        NSMutableArray* arr = [NSMutableArray array];
        for (UNIMyProjectModel* model in self.myData) {
            if (model.select) {
                [arr addObject:model];
            }
        }
        [self.delegate UNIMyPojectListDelegateMethod:arr];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLH;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNIAddProjcetCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[UNIAddProjcetCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, CELLH) reuseIdentifier:name];
    }
    UNIMyProjectModel* model = _myData[indexPath.row];
    [cell setupCellWithData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UNIMyProjectModel* model = _myData[indexPath.row];
    UNIAddProjcetCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (model.select){
        
        _restTime +=(model.costTime* 60);
        model.select = NO;
        seletNum -- ;
        cell.handleImag.image= [UIImage imageNamed:@"addpro_btn_selelct1"];
    }
    else{
        if (self.restTime >= (model.costTime* 60)) {
            _restTime -=(model.costTime* 60);
        }else{
            [UIAlertView showWithTitle:@"提示" message:@"您添加的项目已经超出服务时间" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
            return;
        }
        model.select = YES;
        seletNum++;
        cell.handleImag.image= [UIImage imageNamed:@"addpro_btn_selelct2"];
    }
    numLab.text = [NSString stringWithFormat:@"%d",seletNum];

    
}

#pragma mark 开始请求我未预约项目
-(void)startRequestInfo{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_URL_MyProjectInfo]
                           params:@{@"page":@(self->pageNum),@"size":@(20)}];
        request1.remyProjectBlock =^(NSArray* myProjectArr,int count,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.myTableview.header endRefreshing];
                [self.myTableview.footer endRefreshing];
                if (err==nil) {
                    if (self->pageNum == 0)//下拉刷新
                        [self.myData removeAllObjects];
                    
                    if (myProjectArr.count<20)
                        [self.myTableview.footer endRefreshingWithNoMoreData];
                    
                    if (myProjectArr.count>0){
                        NSMutableArray* data = [NSMutableArray arrayWithArray:myProjectArr];
                        NSMutableArray* data1 = [NSMutableArray arrayWithArray:myProjectArr];
                        for (UNIMyProjectModel* info in self.projectIdArr) {
                            for (UNIMyProjectModel* model in data) {
                                if (model.projectId == info.projectId)
                                    [data1 removeObject:model];
                            }
                        }
                        [self.myData addObjectsFromArray:data1];
                        [self.myTableview reloadData];
                       //[self.myData addObjectsFromArray:myProjectArr];
                    }
                }else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
        
        
    });
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
