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
#import "BTKeyboardTool.h"
@interface UNIShopListController ()<UITableViewDataSource,UITableViewDelegate,KeyboardToolDelegate,UISearchBarDelegate>{
    int pageNum;
    int pageSize;
    UIView* noData;
}
@property(nonatomic,strong)NSMutableArray* myData;
@property(nonatomic,strong) UITableView* tableView;
@end

@implementation UNIShopListController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"UNIShopListController.h"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"UNIShopListController.h"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupSelf];
    [self setupSearchBar];
    [self setupParams];
    [self startRequest];
    
}
-(void)startRequest{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UNIMypointRequest* rq = [[UNIMypointRequest alloc]init];
        rq.rqshopList=^(NSArray* arr,NSString* tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.header endRefreshing];
                [self.tableView.footer endRefreshing];
                if (er) {
                    [YIToast showText:NETWORKINGPEOBLEM];
                    return ;
                }
                if (self->pageNum==0)
                    [self.myData removeAllObjects];
                if (arr.count<self->pageNum) {
                    [self.tableView.footer endRefreshingWithNoMoreData];
                }
                
                [self.myData addObjectsFromArray:arr];
                [self setupTableView];
            });
        };
        [rq postWithSerCode:@[API_URL_GetShopListInfo] params:@{@"size":@(20),@"page":@(self->pageNum)}];
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
#pragma mark 设置 searchBar
-(void)setupSearchBar{
    UISearchBar * bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
    bar.delegate =self;
    [self.navigationItem.titleView addSubview:bar];
    
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate = self;
    [tool dismissTwoBtn];
    bar.inputAccessoryView = tool;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchText  %@",searchText);
//    NSArray *array = [[NSArray alloc]initWithObjects:@"beijing",@"shanghai",@"guangzou",@"wuhan", nil];
//    NSString *string = @"ang";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",string];
//    NSLog(@"%@",[array filteredArrayUsingPredicate:pred]);
}
-(void)keyboardTool:(BTKeyboardTool *)tool buttonClick:(KeyBoardToolButtonType)type{
    [self.view endEditing:YES];
}

#pragma mark 初始化TableView
-(void)setupTableView{
    if (self.tableView){
         noData.hidden = _myData.count>0;
        [self.tableView reloadData];
        return;
    }
    
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

    [self setupNodataView];
}

-(void)setupNodataView{
    
    UIView* nodata = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height)];
   // nodata.hidden=self.allArray.count>0;
    [_tableView addSubview:nodata];
    noData = nodata;
    
    UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_img_nodata3"]];
    float imgWH = KMainScreenWidth>400?60:50,
    imgX = (nodata.frame.size.width - imgWH)/2;
    img.frame = CGRectMake(imgX, noData.frame.size.height/2 - imgWH - 10, imgWH, imgWH);
    [nodata addSubview:img];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+10, nodata.frame.size.width, 30)];
    lab.text = @"没有其他店铺可以选择哦！";
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [nodata addSubview:lab];
    
    nodata=nil;img=nil; lab=nil;
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
