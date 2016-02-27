//
//  UNIShopListController.m
//  Uni
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIShopListController.h"
#import "UNIMypointRequest.h"
#import <MJRefresh/MJRefresh.h>

@interface UNIShopListController ()<UITableViewDataSource,UITableViewDelegate>{
    int pageNum;
    int pageSize;
}
@property(nonatomic,strong)NSMutableArray* myData;
@property(nonatomic,strong) UITableView* tableView;
@end

@implementation UNIShopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupSelf];
    [self setupParams];
    [self startRequest];
    
}
-(void)startRequest{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UNIMypointRequest* rq = [[UNIMypointRequest alloc]init];
        rq.rqshopList=^(NSArray* arr,NSString* tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (er) {
                    [YIToast showText:NETWORKINGPEOBLEM];
                    return ;
                }
                if (self->pageNum==0)
                    [self.myData removeAllObjects];
                
                [self.myData addObjectsFromArray:arr];
                [self setupTableView];
            });
        };
        [rq postWithSerCode:@[API_PARAM_UNI,API_URL_GetShopListInfo] params:@{@"size":@(20),@"page":@(self->pageNum)}];
        });
}
-(void)setupNavigation{
    self.title = @"店铺列表";
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupSelf{
    self.view.backgroundColor =[UIColor colorWithHexString:kMainBackGroundColor];
    
}
#pragma mark 设置参数
-(void)setupParams{
    _myData = [NSMutableArray array];
    pageNum = 0;
    pageSize = 20;
    
}
#pragma mark 初始化TableView
-(void)setupTableView{
    if (self.tableView)
        [self.tableView reloadData];
    
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight-64) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    self.tableView = tab;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->pageNum =0;
        self->pageSize =(int)self.myData.count;
        [self startRequest];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ++self->pageNum;
        self->pageSize =(int)self.myData.count+20;
        [self startRequest];
    }];


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*70/320;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"CellName";
    UNIShopListCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell)
        cell = [[UNIShopListCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth*70/320) reuseIdentifier:name];
    
    [cell setupCellContent:_myData[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate UNIShopListControllerDelegateMethod:_myData[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
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
