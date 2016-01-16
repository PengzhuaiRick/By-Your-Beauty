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
@interface MainMidController ()<UINavigationControllerDelegate>
{
    int pageNum;
    int pageSize;
}
@end

@implementation MainMidController

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
   // [self setupTableviewHeader:@"我已预约"];
    //[self setupTableviewFootView];
    //[self startRequestInfo];
    
   
  //[self startRequestInfoPage];
    [self.tableView.header beginRefreshing];
}

-(void)setupNavigation{
    self.title = @"我已预约";
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
}

-(void)setupSelf{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
    view.backgroundColor =[UIColor colorWithHexString:kMainBackGroundColor];
    self.tableView.tableHeaderView =view;
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
    if (self.myData.count>=20) {
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            ++self->pageNum;
            self->pageSize =20;
            [self startRequestInfoPage];
        }];
    }else
        self.tableView.footer.hidden = YES;
    
    
    
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
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.043];
    [view addSubview:lab];
    self.tableView.tableHeaderView = view;
}

-(void)setupTableviewFootView{
    UIView* bView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.tableView.frame.size.width, 5)];
//    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  self.tableView.frame.size.width, 5)];
//    view.image =[UIImage imageNamed:@"main_img_cellF"];
//    bView.backgroundColor = [UIColor clearColor];
//    [bView addSubview:view];
    self.tableView.tableFooterView = bView;
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
    
    [cell setupCellContent:_myData[indexPath.row] andType:1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNIAppointDetail* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointDetail"];
    UNIMyAppintModel* model =_myData[indexPath.row];
    appoint.order =model.myorder;
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

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if ([toVC isKindOfClass:[UNIAppointDetail class]])
        return nil;
        MainMidMoveBackTransition *inverseTransition = [[MainMidMoveBackTransition alloc]init];
        return inverseTransition;
  
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
                    if (myAppointArr.count>0){
                        if (self->pageNum == 0)//下拉刷新
                            [self.myData removeAllObjects];
                        
                        if (myAppointArr.count<20)
                            self.tableView.footer.hidden=YES;
                        
                        [self.myData addObjectsFromArray:myAppointArr];
                        [self.tableView reloadData];
                    }
                    else
                        [YIToast showText:tips];
                }else
                    [YIToast showText:tips];
            });
        };
    });
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
