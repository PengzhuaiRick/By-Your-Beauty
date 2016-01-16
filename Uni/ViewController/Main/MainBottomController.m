//
//  MainBottomController.m
//  Uni
//  首页底部 我未预约项目
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainBottomController.h"
#import "MainMidMoveBackTransition.h"
#import "MainMidCell.h"
#import "MainViewRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIAppointController.h"
@interface MainBottomController ()<UINavigationControllerDelegate>
{
    int pageNum;
    int pageSize;
}
@end

@implementation MainBottomController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.delegate = nil;
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSelf];
    [self setupNavigation];
    [self setupParams];
    [self setupMJReflash];
    [self setupNotification];
}
-(void)setupSelf{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
    view.backgroundColor =[UIColor colorWithHexString:kMainBackGroundColor];
    self.tableView.tableHeaderView =view;
}


-(void)setupNavigation{
    self.title = @"我的项目";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
}
#pragma mark 设置参数
-(void)setupParams{
    _myData = [NSMutableArray array];
    
    pageNum = 0;
    pageSize = 20;
    
}
#pragma mark 设置刷新方法
-(void)setupMJReflash{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->pageNum =0;
        self->pageSize =(int)self.myData.count;
        [self startRequestInfo];
    }];
     if (_myData.count==20) {
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ++self->pageNum;
        self->pageSize =(int)self.myData.count+20;
        [self startRequestInfo];
    }];
         self.tableView.footer.hidden = YES;
     }
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTableviewHeader:(NSString*)string{
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, KMainScreenWidth*0.06)];
    view.image =[UIImage imageNamed:@"mian_img_cellH"];
    UILabel* lab = [[UILabel alloc]initWithFrame:
                    CGRectMake(10, 5,  self.tableView.frame.size.width-10, KMainScreenWidth*0.05)];
    lab.text=string;
    lab.textColor = [UIColor colorWithHexString:@"575757"];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.043];
    [view addSubview:lab];
    self.tableView.tableHeaderView = view;
}

-(void)setupTableviewFootView{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.tableView.frame.size.width, 5)];
   // view.image =[UIImage imageNamed:@"main_img_cellF"];
    self.tableView.tableFooterView = view;
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
       // cell = [[NSBundle mainBundle]loadNibNamed:@"MainMidCell" owner:self options:nil].lastObject;
        cell = [[MainMidCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth*90/320) reuseIdentifier:name];
    
    [cell setupCellContent:_myData[indexPath.row] andType:2];
    
//    cell.handleBtn.tag = indexPath.row+10;
//    [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
//    subscribeNext:^(UIButton* x) {
//        UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UNIAppointController* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointController"];
//        appoint.model =  self.myData[x.tag-10];
//        [self.navigationController pushViewController:appoint animated:YES];
//    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNIAppointController* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointController"];
    appoint.model = _myData[indexPath.row];
    [self.navigationController pushViewController:appoint animated:YES];

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


#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if ([toVC isKindOfClass:[UNIAppointController class]])
        return nil;
    MainMidMoveBackTransition *inverseTransition = [[MainMidMoveBackTransition alloc]init];
    return inverseTransition;
    
}


#pragma mark 开始请求我未预约项目
-(void)startRequestInfo{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_PARAM_UNI,API_URL_MyProjectInfo]
                           params:@{@"userId":@(1),
                                    @"token":@"abcdxxa",
                                    @"shopId":@(1),
                                    @"page":@(0),@"size":@(20)}];
        request1.remyProjectBlock =^(NSArray* myProjectArr,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.footer.hidden = YES;
                [self.tableView.header endRefreshing];
                [self.tableView.footer endRefreshing];
                if (err==nil) {
                    if (myProjectArr.count>0){
                        if (self->pageNum == 0)//下拉刷新
                            [self.myData removeAllObjects];
                        
                        [self.myData addObjectsFromArray:myProjectArr];
                        [self reflashTabel:(int)self.myData.count];
                    }
                    else
                        [YIToast showText:tips];
                }else
                    [YIToast showText:tips];
            });
        };
        
        
    });
}

#pragma mark 注册通知
-(void)setupNotification{
    //预约成功后 刷新 列表 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appointSuccessAndReflash) name:APPOINTANDREFLASH object:nil];
}

-(void)appointSuccessAndReflash{
    [self.tableView.header beginRefreshing];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:APPOINTANDREFLASH object:nil];
}

@end
